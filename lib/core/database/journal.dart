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
  ///
  /// [answers]: the person's answer per account, about a specific
  /// confirmation (an answer about an older confirmation does not apply).
  /// Otherwise [placement] applies to every question; `auto` is a fallback guess for
  /// internal callers only — the stores require answers.
  Future<OperationPreview> preview(
    Operation op, {
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
  }) => db.transaction(
    () async => (await _plan(op, placement, now, answers)).preview,
  );

  /// Books [op] in one transaction, exactly as [preview] shows it for the
  /// same arguments.
  Future<RecordedOperation> record(
    Operation op, {
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
  }) => db.transaction(() async {
    final plan = await _plan(op, placement, now, answers);
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

  /// «Ещё нет» at a balance update: the part of [causedBy] still to reach
  /// [accountId] ([effect], stored units) is kept out of the balance about
  /// to be confirmed at [at] — a correction against «Невыясненное» at that
  /// very moment. Call before the confirmation is written; then [release].
  Future<void> holdOut(
    String causedBy,
    String accountId,
    int effect,
    int at,
    DateTime now,
  ) => _correction(causedBy, accountId, -effect, at, now);

  /// The held-out part takes effect again right after the confirmation.
  Future<void> release(
    String causedBy,
    String accountId,
    int effect,
    int at,
    DateTime now,
  ) => _correction(causedBy, accountId, effect, at, now);

  Future<void> _correction(
    String causedBy,
    String accountId,
    int amount,
    int at,
    DateTime now,
  ) async {
    final suspense = await _suspense();
    await _write([
      _Entry(
        kind: 'anchor_correction',
        at: at,
        occurredOn: _localDate(at),
        lines: [(accountId, amount), (suspense, -amount)],
        causedBy: causedBy,
      ),
    ], now);
  }

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
    Map<String, ConfirmationAnswer> answers,
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

    // Per account: its latest balance confirmed ON OR AFTER the
    // operation's day, and the answer about THAT confirmation — was the
    // money already in it? The two sides of a transfer can be posted at
    // different times, so each account is answered separately (R3 review
    // 2026-11-14). The app never assumes on the screens.
    final questions = <ConfirmationQuestion>[];
    final latestOf = <String, int>{};
    final relevant = <int>[];
    final sameDayOnly = <String, bool>{};
    for (final a in own.keys) {
      final rows =
          await (db.select(db.balanceAssertions)
                ..where((b) => b.accountId.equals(a))
                ..orderBy([(b) => OrderingTerm.asc(b.assertedAtUtc)]))
              .get();
      final onOrAfter = [
        for (final r in rows)
          if (_localDate(r.assertedAtUtc) >= op.date) r,
      ];
      if (onOrAfter.isEmpty) continue;
      final latest = onOrAfter.last;
      relevant.addAll(onOrAfter.map((r) => r.assertedAtUtc));
      latestOf[a] = latest.assertedAtUtc;
      sameDayOnly[a] = onOrAfter.every(
        (r) => _localDate(r.assertedAtUtc) == op.date,
      );
      questions.add(
        ConfirmationQuestion(
          accountId: a,
          assertionId: latest.id,
          confirmedAt: DateTime.fromMillisecondsSinceEpoch(
            latest.assertedAtUtc,
          ),
          delta: own[a]!,
        ),
      );
    }
    final included = <String, bool>{};
    for (final q in questions) {
      final answer = answers[q.accountId];
      if (answer != null && answer.assertionId == q.assertionId) {
        included[q.accountId] = answer.included;
      } else {
        included[q.accountId] = switch (placement) {
          SameDayPlacement.inConfirmedBalance => true,
          SameDayPlacement.afterConfirmedBalance => false,
          // Internal fallback: same day → that day's unexplained
          // difference; an earlier day → in the later confirmed balance.
          SameDayPlacement.auto =>
            !sameDayOnly[q.accountId]! ||
                await _guess({q.accountId: q.delta}, op.date),
        };
      }
    }

    // The entry itself goes before every relevant confirmation; each
    // account then gets what its answer means: «уже было» — the anchor
    // rule keeps its confirmed balances; «ещё нет» — the same corrections
    // keep history, and a release right after its latest confirmation makes
    // the operation take effect from then on. The date stays the person's.
    final noon = DateTime(
      op.date.year,
      op.date.month,
      op.date.day,
      12,
    ).millisecondsSinceEpoch;
    final nowMs = now.millisecondsSinceEpoch;
    var at = noon < nowMs ? noon : nowMs;
    if (relevant.isNotEmpty) {
      final first = relevant.reduce((a, b) => a < b ? a : b);
      if (first - 1 < at) at = first - 1;
    }

    final main = _Entry(
      kind: kind,
      at: at,
      occurredOn: op.date,
      lines: lines,
      description: op.description,
    );
    final suspense = await _suspense();
    final entries = [
      main,
      ...await _anchors([main], main.id, household.id),
      for (final q in questions)
        if (included[q.accountId] == false)
          _Entry(
            kind: 'anchor_correction',
            at: latestOf[q.accountId]! + 1,
            occurredOn: _localDate(latestOf[q.accountId]!),
            lines: [(q.accountId, q.delta), (suspense, -q.delta)],
            causedBy: main.id,
          ),
    ];

    // Preview: affected own accounts now → after, and «Невыясненное».
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
    final allIn =
        questions.isNotEmpty && questions.every((q) => included[q.accountId]!);
    return _Plan(
      entries,
      OperationPreview(
        balances: balances,
        questions: questions,
        inConfirmedBalance: allIn,
        confirmedAt: allIn
            ? questions
                  .map((q) => q.confirmedAt)
                  .reduce((a, b) => a.isAfter(b) ? a : b)
            : null,
        placement: allIn
            ? SameDayPlacement.inConfirmedBalance
            : SameDayPlacement.afterConfirmedBalance,
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
