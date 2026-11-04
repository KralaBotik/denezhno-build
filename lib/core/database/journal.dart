import 'package:drift/drift.dart';

import '../../features/accounts/accounts.dart';
import '../../features/operations/operations.dart';
import '../calendar_date.dart';
import '../ids.dart';
import '../money/money.dart';
import 'app_database.dart';

/// Operations in the double-entry journal (R3 Э2), with the rule that keeps
/// confirmed balances true (docs/r3-plan.md §4, invariant И3):
///
/// A balance the person confirmed («Обновить остатки», a statement) is an
/// anchor. When an operation dated before an anchor is recorded later, the
/// money it moves was already in that confirmed balance. So in the same
/// transaction an `anchor_correction` is booked at the anchor against
/// «Невыясненное»: the confirmed balance stays exactly as confirmed, and the
/// unexplained difference shrinks instead of the money being counted twice.
///
/// Generic form, used for operations and reversals alike: for each own
/// account and each of its anchors T (in time order), c(T) = sum of this
/// command's lines on the account dated ≤ T. If c(T) ≠ 0, book −c(T) on the
/// account and +c(T) on «Невыясненное» at T.
///
/// Nothing is ever updated or deleted: corrections and cancellations are new
/// entries (reversals), linked through `entry_details`.
final class Journal {
  Journal(this.db);
  final AppDatabase db;

  static final _ownKinds = [for (final k in AccountKind.values) k.dbValue];
  static const _reversible = {'income', 'expense', 'transfer', 'refund'};

  /// What [op] will do, without writing anything.
  Future<OperationPreview> preview(
    Operation op, {
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
  }) => db.transaction(() async => (await _plan(op, placement, now)).preview);

  /// Books [op] in one transaction. Pass the placement returned by
  /// [preview] so that exactly what was shown is written.
  Future<RecordedOperation> record(
    Operation op, {
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
  }) => db.transaction(() async {
    final plan = await _plan(op, placement, now);
    await _write(plan.entries, now);
    return RecordedOperation(plan.entries.first.id, plan.preview);
  });

  /// Cancels a recorded operation (and the anchor corrections made for it)
  /// with reversal entries at the original dates. Allowed once.
  Future<String> reverse(String entryId, DateTime now) =>
      db.transaction(() async {
        final original = await (db.select(
          db.journalEntries,
        )..where((e) => e.id.equals(entryId))).getSingleOrNull();
        if (original == null || !_reversible.contains(original.kind)) {
          throw const InvalidOperation('not a reversible operation');
        }
        if (await _isReversed(entryId)) {
          throw const InvalidOperation('already cancelled');
        }
        final caused = await (db.select(
          db.entryDetails,
        )..where((d) => d.causedByEntryId.equals(entryId))).get();
        final targets = [
          original,
          for (final d in caused)
            if (!await _isReversed(d.entryId))
              await (db.select(
                db.journalEntries,
              )..where((e) => e.id.equals(d.entryId))).getSingle(),
        ];
        final entries = <_Entry>[];
        for (final t in targets) {
          final lines = await (db.select(
            db.postings,
          )..where((p) => p.entryId.equals(t.id))).get();
          final details = await (db.select(
            db.entryDetails,
          )..where((d) => d.entryId.equals(t.id))).getSingleOrNull();
          entries.add(
            _Entry(
              kind: 'reversal',
              at: t.occurredAtUtc,
              occurredOn: details == null
                  ? _localDate(t.occurredAtUtc)
                  : CalendarDate.parse(details.occurredOn),
              lines: [for (final p in lines) (p.accountId, -p.amountMinor)],
              reverses: t.id,
            ),
          );
        }
        final household = await db.select(db.households).getSingle();
        entries.addAll(await _anchors(entries, entries.first.id, household.id));
        await _write(entries, now);
        return entries.first.id;
      });

  /// Spending (expense categories, positive = spent) and income (positive =
  /// received) per category id for operations dated [from]..[to]. Only the
  /// internal category accounts count: transfers, repayments, balance
  /// updates and anchor corrections never appear here (И5).
  Future<Map<String, Money>> categoryTotals(
    CalendarDate from,
    CalendarDate to,
  ) async {
    final rows = await db
        .customSelect(
          'SELECT c.id AS id, c.direction AS dir, SUM(p.amount_minor) AS s '
          'FROM postings p '
          'JOIN categories c ON c.ledger_account_id = p.account_id '
          'JOIN entry_details d ON d.entry_id = p.entry_id '
          'WHERE d.occurred_on BETWEEN ? AND ? '
          'GROUP BY c.id, c.direction',
          variables: [Variable(from.iso), Variable(to.iso)],
          readsFrom: {db.postings, db.categories, db.entryDetails},
        )
        .get();
    return {
      for (final r in rows)
        if (r.read<int>('s') != 0)
          r.read<String>('id'): Money(
            r.read<String>('dir') == 'expense'
                ? r.read<int>('s')
                : -r.read<int>('s'),
          ),
    };
  }

  /// Stored balance (assets +, liabilities −) of [accountId] at [at].
  Future<int> balanceAt(String accountId, int at) async {
    final row = await db
        .customSelect(
          'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
          'JOIN journal_entries e ON e.id = p.entry_id '
          'WHERE p.account_id = ? AND e.occurred_at_utc <= ?',
          variables: [Variable(accountId), Variable(at)],
          readsFrom: {db.postings, db.journalEntries},
        )
        .getSingle();
    return row.read<int>('s');
  }

  // ---------------------------------------------------------------------------

  Future<bool> _isReversed(String entryId) async =>
      (await (db.select(
        db.entryDetails,
      )..where((d) => d.reversesEntryId.equals(entryId))).getSingleOrNull()) !=
      null;

  static CalendarDate _localDate(int ms) =>
      CalendarDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(ms));

  Future<AccountRow> _own(String id) async {
    final row = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (row == null ||
        row.archivedAtUtc != null ||
        !_ownKinds.contains(row.kind)) {
      throw const InvalidOperation('unknown account');
    }
    return row;
  }

  Future<CategoryRow> _category(String id, String direction) async {
    final row = await (db.select(
      db.categories,
    )..where((c) => c.id.equals(id))).getSingleOrNull();
    if (row == null ||
        row.archivedAtUtc != null ||
        row.direction != direction) {
      throw const InvalidOperation('unknown category');
    }
    return row;
  }

  Future<_Plan> _plan(
    Operation op,
    SameDayPlacement placement,
    DateTime now,
  ) async {
    if (op.amount.minorUnits <= 0 || op.amount.currency != Currency.rub) {
      throw const InvalidOperation('amount');
    }
    if (op.date > CalendarDate.fromDateTime(now)) {
      throw const InvalidOperation('date in the future');
    }
    final x = op.amount.minorUnits;
    final (String kind, List<(String, int)> lines) = switch (op) {
      IncomeOp(:final accountId, :final categoryId) => (
        'income',
        [
          ((await _own(accountId)).id, x),
          ((await _category(categoryId, 'income')).ledgerAccountId, -x),
        ],
      ),
      ExpenseOp(:final accountId, :final categoryId) => (
        'expense',
        [
          ((await _category(categoryId, 'expense')).ledgerAccountId, x),
          ((await _own(accountId)).id, -x),
        ],
      ),
      RefundOp(:final accountId, :final categoryId) => (
        'refund',
        [
          ((await _own(accountId)).id, x),
          ((await _category(categoryId, 'expense')).ledgerAccountId, -x),
        ],
      ),
      TransferOp(:final fromAccountId, :final toAccountId) => (
        'transfer',
        [
          ((await _own(toAccountId)).id, x),
          ((await _own(fromAccountId)).id, -x),
        ],
      ),
    };
    if (op is TransferOp && op.fromAccountId == op.toAccountId) {
      throw const InvalidOperation('same account');
    }
    final household = await db.select(db.households).getSingle();
    final own = {
      for (final l in lines)
        if (await _isOwn(l.$1)) l.$1: l.$2,
    };

    // Balances confirmed on the operation's own day decide its placement.
    final sameDay = <String, List<BalanceAssertionRow>>{};
    for (final a in own.keys) {
      final rows =
          await (db.select(db.balanceAssertions)
                ..where((b) => b.accountId.equals(a))
                ..orderBy([(b) => OrderingTerm.asc(b.assertedAtUtc)]))
              .get();
      final day = [
        for (final r in rows)
          if (_localDate(r.assertedAtUtc) == op.date) r,
      ];
      if (day.isNotEmpty) sameDay[a] = day;
    }
    final noon = DateTime(
      op.date.year,
      op.date.month,
      op.date.day,
      12,
    ).millisecondsSinceEpoch;
    final nowMs = now.millisecondsSinceEpoch;
    var resolved = placement;
    final int at;
    if (sameDay.isEmpty) {
      at = noon < nowMs ? noon : nowMs;
      resolved = SameDayPlacement.afterConfirmedBalance;
    } else {
      if (resolved == SameDayPlacement.auto) {
        resolved = await _guess(own, op.date)
            ? SameDayPlacement.inConfirmedBalance
            : SameDayPlacement.afterConfirmedBalance;
      }
      final last = sameDay.values
          .expand((r) => r)
          .map((r) => r.assertedAtUtc)
          .reduce((a, b) => a > b ? a : b);
      at = resolved == SameDayPlacement.inConfirmedBalance
          ? last - 1
          : last + 1;
    }

    final main = _Entry(
      kind: kind,
      at: at,
      occurredOn: op.date,
      lines: lines,
      description: op.description,
    );
    final entries = [
      main,
      ...await _anchors([main], main.id, household.id),
    ];

    // Preview: affected own accounts now → after, and «Невыясненное».
    final suspense = await _suspense();
    final balances = <String, (Money, Money)>{};
    for (final a in own.keys) {
      final row = await _own(a);
      final kindOf = AccountKind.fromDb(row.kind)!;
      final before = await _current(a);
      final delta = entries
          .expand((e) => e.lines)
          .where((l) => l.$1 == a)
          .fold(0, (s, l) => s + l.$2);
      Money facing(int stored) =>
          kindOf.isLiability ? -Money(stored) : Money(stored);
      balances[a] = (facing(before), facing(before + delta));
    }
    final anchored = entries.skip(1).toList();
    return _Plan(
      entries,
      OperationPreview(
        balances: balances,
        inConfirmedBalance: anchored.isNotEmpty,
        confirmedAt: anchored.isEmpty
            ? null
            : DateTime.fromMillisecondsSinceEpoch(anchored.first.at),
        sameDayChoice: sameDay.isNotEmpty,
        placement: resolved,
        unexplainedChange: Money(
          entries
              .expand((e) => e.lines)
              .where((l) => l.$1 == suspense)
              .fold(0, (s, l) => s + l.$2),
        ),
      ),
    );
  }

  /// Is an operation on the day of a balance update already in it? Yes when,
  /// for every affected account, that day's still-unexplained difference has
  /// the same direction and covers at least half of the operation.
  Future<bool> _guess(Map<String, int> own, CalendarDate day) async {
    for (final e in own.entries) {
      final rows = await db
          .customSelect(
            'SELECT p.amount_minor AS a, e.occurred_at_utc AS t '
            'FROM postings p JOIN journal_entries e ON e.id = p.entry_id '
            "WHERE p.account_id = ? AND e.kind IN ('balance_adjustment', "
            "'anchor_correction')",
            variables: [Variable(e.key)],
            readsFrom: {db.postings, db.journalEntries},
          )
          .get();
      final unexplained = rows
          .where((r) => _localDate(r.read<int>('t')) == day)
          .fold(0, (s, r) => s + r.read<int>('a'));
      final d = e.value;
      if (unexplained == 0 ||
          unexplained.sign != d.sign ||
          unexplained.abs() * 2 < d.abs()) {
        return false;
      }
    }
    return true;
  }

  Future<bool> _isOwn(String accountId) async {
    final row = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingle();
    return _ownKinds.contains(row.kind);
  }

  Future<String> _suspense() async => (await (db.select(
    db.accounts,
  )..where((a) => a.kind.equals('suspense'))).getSingle()).id;

  Future<int> _current(String accountId) async {
    final row = await db
        .customSelect(
          'SELECT COALESCE(SUM(amount_minor), 0) AS s FROM postings '
          'WHERE account_id = ?',
          variables: [Variable(accountId)],
          readsFrom: {db.postings},
        )
        .getSingle();
    return row.read<int>('s');
  }

  /// Anchor corrections that keep every confirmed balance true after
  /// [entries] (see the class comment).
  Future<List<_Entry>> _anchors(
    List<_Entry> entries,
    String causedBy,
    String household,
  ) async {
    final suspense = await _suspense();
    final corrections = <_Entry>[];
    final accounts = <String>{
      for (final e in entries)
        for (final l in e.lines)
          if (await _isOwn(l.$1)) l.$1,
    };
    for (final a in accounts) {
      final first = entries
          .where((e) => e.lines.any((l) => l.$1 == a))
          .map((e) => e.at)
          .reduce((x, y) => x < y ? x : y);
      final anchors =
          await (db.select(db.balanceAssertions)
                ..where(
                  (b) =>
                      b.accountId.equals(a) &
                      b.assertedAtUtc.isBiggerOrEqualValue(first),
                )
                ..orderBy([(b) => OrderingTerm.asc(b.assertedAtUtc)]))
              .get();
      for (final anchor in anchors) {
        final t = anchor.assertedAtUtc;
        final c = [...entries, ...corrections]
            .where((e) => e.at <= t)
            .expand((e) => e.lines)
            .where((l) => l.$1 == a)
            .fold(0, (s, l) => s + l.$2);
        if (c == 0) continue;
        corrections.add(
          _Entry(
            kind: 'anchor_correction',
            at: t,
            occurredOn: _localDate(t),
            lines: [(a, -c), (suspense, c)],
            causedBy: causedBy,
          ),
        );
      }
    }
    return corrections;
  }

  Future<void> _write(List<_Entry> entries, DateTime now) async {
    final household = await db.select(db.households).getSingle();
    final recorded = now.toUtc().millisecondsSinceEpoch;
    for (final e in entries) {
      final sum = e.lines.fold(BigInt.zero, (s, l) => s + BigInt.from(l.$2));
      if (sum != BigInt.zero || e.lines.length < 2) {
        throw StateError('Unbalanced entry');
      }
      await db
          .into(db.journalEntries)
          .insert(
            JournalEntriesCompanion.insert(
              id: e.id,
              householdId: household.id,
              commandId: newUuid(),
              kind: e.kind,
              source: 'user',
              occurredAtUtc: e.at,
              recordedAtUtc: recorded,
            ),
          );
      for (var i = 0; i < e.lines.length; i++) {
        await db
            .into(db.postings)
            .insert(
              PostingsCompanion.insert(
                entryId: e.id,
                lineNo: i,
                accountId: e.lines[i].$1,
                amountMinor: e.lines[i].$2,
                currency: 'RUB',
              ),
            );
      }
      await db
          .into(db.entryDetails)
          .insert(
            EntryDetailsCompanion.insert(
              entryId: e.id,
              occurredOn: e.occurredOn.iso,
              description: Value(e.description),
              reversesEntryId: Value(e.reverses),
              causedByEntryId: Value(e.causedBy),
            ),
          );
    }
  }
}

final class _Entry {
  _Entry({
    required this.kind,
    required this.at,
    required this.occurredOn,
    required this.lines,
    this.description,
    this.reverses,
    this.causedBy,
  }) : id = newUuid();
  final String id;
  final String kind;
  final int at;
  final CalendarDate occurredOn;
  final List<(String, int)> lines;
  final String? description;
  final String? reverses;
  final String? causedBy;
}

final class _Plan {
  const _Plan(this.entries, this.preview);
  final List<_Entry> entries;
  final OperationPreview preview;
}
