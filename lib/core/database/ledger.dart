import 'package:drift/drift.dart';

import '../../features/accounts/accounts.dart';
import '../ids.dart';
import '../money/money.dart';
import 'app_database.dart';

/// Double-entry writer and reader for accounts. Every write is one
/// transaction: balanced postings per currency, append-only rows, and a
/// balance assertion for each confirmed amount. Nothing here is ever updated
/// or deleted; corrections are new entries.
final class Ledger {
  Ledger(this.db);
  final AppDatabase db;

  static const _systemKinds = {'opening_equity', 'suspense'};

  Future<HouseholdRow> _household() => db.select(db.households).getSingle();

  Future<AccountRow> _systemAccount(String kind) =>
      (db.select(db.accounts)..where((a) => a.kind.equals(kind))).getSingle();

  /// Signed stored balance (assets +, liabilities −) for each account.
  Future<Map<String, int>> _balances() async {
    final rows = await db
        .customSelect(
          'SELECT account_id, SUM(amount_minor) AS total FROM postings '
          'GROUP BY account_id',
          readsFrom: {db.postings},
        )
        .get();
    return {
      for (final r in rows) r.read<String>('account_id'): r.read<int>('total'),
    };
  }

  Future<List<AccountSummary>> accounts() async {
    final rows =
        await (db.select(db.accounts)
              ..where(
                (a) => a.archivedAtUtc.isNull() & a.kind.isNotIn(_systemKinds),
              )
              ..orderBy([
                (a) => OrderingTerm.asc(a.sortOrder),
                (a) => OrderingTerm.asc(a.createdAtUtc),
              ]))
            .get();
    final balances = await _balances();
    final last = {
      for (final r
          in await db
              .customSelect(
                'SELECT account_id, MAX(asserted_at_utc) AS at '
                'FROM balance_assertions GROUP BY account_id',
                readsFrom: {db.balanceAssertions},
              )
              .get())
        r.read<String>('account_id'): r.read<int>('at'),
    };
    return [
      for (final a in rows)
        if (AccountKind.fromDb(a.kind) case final kind?)
          AccountSummary(
            id: a.id,
            name: a.name,
            kind: kind,
            amount: _userFacing(kind, balances[a.id] ?? 0),
            isProtected: a.isProtected == 1,
            creditLimit: a.creditLimitMinor == null
                ? null
                : Money(a.creditLimitMinor!),
            lastUpdatedAt: last[a.id] == null
                ? null
                : DateTime.fromMillisecondsSinceEpoch(last[a.id]!, isUtc: true),
          ),
    ];
  }

  static Money _userFacing(AccountKind kind, int stored) =>
      kind.isLiability ? -Money(stored) : Money(stored);
  static int _stored(AccountKind kind, Money amount) =>
      (kind.isLiability ? -amount : amount).minorUnits;

  Future<void> createAccount(NewAccount spec, DateTime now) async {
    final name = spec.name.trim();
    if (name.isEmpty || name.length > 60) throw ArgumentError('Invalid name');
    if (spec.amount.currency != Currency.rub) {
      throw ArgumentError('Only RUB accounts in R2');
    }
    final limit = spec.creditLimit;
    if (limit != null && (limit.minorUnits < 0 || !spec.kind.isLiability)) {
      throw ArgumentError('Invalid credit limit');
    }
    await db.transaction(() async {
      final household = await _household();
      final at = now.toUtc().millisecondsSinceEpoch;
      final maxOrder = await db
          .customSelect(
            'SELECT COALESCE(MAX(sort_order), 0) AS m FROM accounts',
            readsFrom: {db.accounts},
          )
          .getSingle();
      final id = newUuid();
      await db
          .into(db.accounts)
          .insert(
            AccountsCompanion.insert(
              id: id,
              householdId: household.id,
              kind: spec.kind.dbValue,
              name: name,
              currency: 'RUB',
              visibility: 'shared',
              isProtected: spec.kind.isLiability
                  ? 0
                  : (spec.isProtected ? 1 : 0),
              creditLimitMinor: Value(limit?.minorUnits),
              sortOrder: maxOrder.read<int>('m') + 1,
              createdAtUtc: at,
            ),
          );
      final stored = _stored(spec.kind, spec.amount);
      String? entry;
      if (stored != 0) {
        final equity = await _systemAccount('opening_equity');
        entry = await _post(
          household: household.id,
          kind: 'opening_balance',
          at: at,
          lines: [(id, stored), (equity.id, -stored)],
        );
      }
      await _assert(id, stored, at, entry);
    });
  }

  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> amounts,
    DateTime now,
  ) async {
    if (amounts.isEmpty) {
      return BalanceUpdateResult(changed: 0, unexplained: Money(0));
    }
    return db.transaction(() async {
      final household = await _household();
      final at = now.toUtc().millisecondsSinceEpoch;
      final rows = await (db.select(
        db.accounts,
      )..where((a) => a.id.isIn(amounts.keys))).get();
      if (rows.length != amounts.length) {
        throw ArgumentError('Unknown account');
      }
      final balances = await _balances();
      final lines = <(String, int)>[];
      final targets = <String, int>{};
      var net = BigInt.zero;
      for (final row in rows) {
        final kind = AccountKind.fromDb(row.kind);
        if (kind == null || row.archivedAtUtc != null) {
          throw ArgumentError('Account cannot be updated');
        }
        final target = _stored(kind, amounts[row.id]!);
        targets[row.id] = target;
        final diff = BigInt.from(target) - BigInt.from(balances[row.id] ?? 0);
        if (diff != BigInt.zero) {
          lines.add((row.id, Money.fromBigInt(diff).minorUnits));
          net += diff;
        }
      }
      String? entry;
      if (lines.isNotEmpty) {
        if (net != BigInt.zero) {
          final suspense = await _systemAccount('suspense');
          lines.add((suspense.id, Money.fromBigInt(-net).minorUnits));
        }
        entry = await _post(
          household: household.id,
          kind: 'balance_adjustment',
          at: at,
          lines: lines,
        );
      }
      for (final e in targets.entries) {
        final changed = lines.any((l) => l.$1 == e.key);
        await _assert(e.key, e.value, at, changed ? entry : null);
      }
      return BalanceUpdateResult(
        changed: lines.where((l) => targets.containsKey(l.$1)).length,
        unexplained: Money.fromBigInt(net),
      );
    });
  }

  /// Appends one balanced entry. Throws (rolling back the caller's
  /// transaction) if the lines do not sum to zero.
  Future<String> _post({
    required String household,
    required String kind,
    required int at,
    required List<(String, int)> lines,
  }) async {
    final sum = lines.fold(BigInt.zero, (s, l) => s + BigInt.from(l.$2));
    if (sum != BigInt.zero || lines.length < 2) {
      throw StateError('Unbalanced entry');
    }
    final id = newUuid();
    await db
        .into(db.journalEntries)
        .insert(
          JournalEntriesCompanion.insert(
            id: id,
            householdId: household,
            commandId: newUuid(),
            kind: kind,
            source: 'user',
            occurredAtUtc: at,
            recordedAtUtc: at,
          ),
        );
    for (var i = 0; i < lines.length; i++) {
      await db
          .into(db.postings)
          .insert(
            PostingsCompanion.insert(
              entryId: id,
              lineNo: i,
              accountId: lines[i].$1,
              amountMinor: lines[i].$2,
              currency: 'RUB',
            ),
          );
    }
    return id;
  }

  Future<void> _assert(String account, int stored, int at, String? entry) => db
      .into(db.balanceAssertions)
      .insert(
        BalanceAssertionsCompanion.insert(
          id: newUuid(),
          accountId: account,
          amountMinor: stored,
          currency: 'RUB',
          source: 'user',
          entryId: Value(entry),
          assertedAtUtc: at,
        ),
      );

  Future<Money> reserve() async => Money((await _household()).reserveMinor);

  Future<void> setReserve(Money reserve) async {
    if (reserve.minorUnits < 0 || reserve.currency != Currency.rub) {
      throw ArgumentError('Invalid reserve');
    }
    final household = await _household();
    await (db.update(db.households)..where((h) => h.id.equals(household.id)))
        .write(HouseholdsCompanion(reserveMinor: Value(reserve.minorUnits)));
  }

  Future<void> setIncludedInForecast(String id, bool included) async {
    final row = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    final kind = row == null ? null : AccountKind.fromDb(row.kind);
    if (kind == null || kind.isLiability || row!.archivedAtUtc != null) {
      throw ArgumentError('Not a money account');
    }
    await (db.update(db.accounts)..where((a) => a.id.equals(id))).write(
      AccountsCompanion(isProtected: Value(included ? 0 : 1)),
    );
  }
}
