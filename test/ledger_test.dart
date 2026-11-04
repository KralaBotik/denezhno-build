import 'dart:io';

import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = '0303030303030303030303030303030303030303030303030303030303030303';

void main() {
  late Directory directory;
  late File file;
  late LocalStore store;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('denezhno-ledger-');
    file = File('${directory.path}/denezhno.sqlite');
    store = LocalStore(() async => StorageLocation(file, _key, () async {}));
    await store.open();
  });
  tearDown(() async {
    await store.close();
    await directory.delete(recursive: true);
  });

  Future<T> withDb<T>(Future<T> Function(AppDatabase db) action) async {
    await store.close();
    final db = AppDatabase(await encryptedConnection(file, _key));
    try {
      return await action(db);
    } finally {
      await db.close();
      await store.open();
    }
  }

  AccountSummary byName(List<AccountSummary> list, String name) =>
      list.singleWhere((a) => a.name == name);

  test(
    'fresh store has no visible accounts (system ones are hidden)',
    () async {
      expect(await store.accounts(), isEmpty);
    },
  );

  test('opening balances: money positive, debts shown positive', () async {
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'Сбер', amount: Money(1500000)),
    );
    await store.createAccount(
      NewAccount(
        kind: AccountKind.creditCard,
        name: 'Альфа кредитка',
        amount: Money(2500000),
        creditLimit: Money(10000000),
      ),
    );
    await store.createAccount(
      NewAccount(
        kind: AccountKind.savings,
        name: 'Подушка',
        amount: Money(30000000),
        isProtected: true,
      ),
    );
    await store.createAccount(
      NewAccount(kind: AccountKind.cash, name: 'Кошелёк', amount: Money(0)),
    );
    final list = await store.accounts();
    expect(
      [for (final a in list) a.name],
      ['Сбер', 'Альфа кредитка', 'Подушка', 'Кошелёк'],
    );
    expect(byName(list, 'Сбер').amount, Money(1500000));
    expect(byName(list, 'Альфа кредитка').amount, Money(2500000));
    expect(byName(list, 'Альфа кредитка').creditLimit, Money(10000000));
    expect(byName(list, 'Подушка').isProtected, true);
    expect(byName(list, 'Кошелёк').lastUpdatedAt, isNotNull);
    // Internally: the card is a liability (negative), every entry balances.
    await withDb((db) async {
      final rows = await db
          .customSelect(
            'SELECT entry_id, SUM(amount_minor) s FROM postings GROUP BY entry_id',
          )
          .get();
      expect(rows, hasLength(3)); // zero cash balance needs no entry
      for (final r in rows) {
        expect(r.read<int>('s'), 0);
      }
      final card = await db
          .customSelect(
            "SELECT SUM(p.amount_minor) s FROM postings p JOIN accounts a "
            "ON a.id = p.account_id WHERE a.name = 'Альфа кредитка'",
          )
          .getSingle();
      expect(card.read<int>('s'), -2500000);
    });
  });

  test(
    'balance update: differences go to «Невыясненное», not expenses',
    () async {
      await store.createAccount(
        NewAccount(kind: AccountKind.debit, name: 'Т', amount: Money(5000000)),
      );
      await store.createAccount(
        NewAccount(kind: AccountKind.creditCard, name: 'К', amount: Money(0)),
      );
      var list = await store.accounts();
      final t = byName(list, 'Т').id;
      final k = byName(list, 'К').id;
      // Spent 3 200 from the debit card and 1 000 on the credit card.
      final result = await store.updateBalances({
        t: Money(4680000),
        k: Money(100000),
      });
      expect(result.changed, 2);
      expect(result.unexplained, Money(-420000));
      list = await store.accounts();
      expect(byName(list, 'Т').amount, Money(4680000));
      expect(byName(list, 'К').amount, Money(100000));
      await withDb((db) async {
        final suspense = await db
            .customSelect(
              "SELECT SUM(p.amount_minor) s FROM postings p JOIN accounts a "
              "ON a.id = p.account_id WHERE a.kind = 'suspense'",
            )
            .getSingle();
        expect(suspense.read<int>('s'), 420000);
      });
    },
  );

  test('a transfer between own accounts nets out (no unexplained)', () async {
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'А', amount: Money(1000000)),
    );
    await store.createAccount(
      NewAccount(
        kind: AccountKind.creditCard,
        name: 'Б',
        amount: Money(500000),
      ),
    );
    final list = await store.accounts();
    // Paid off the card from the debit card: −5 000 money, −5 000 debt.
    final result = await store.updateBalances({
      byName(list, 'А').id: Money(500000),
      byName(list, 'Б').id: Money(0),
    });
    expect(result.changed, 2);
    expect(result.unexplained, Money(0));
    await withDb((db) async {
      final suspense = await db
          .customSelect(
            "SELECT COUNT(*) c FROM postings p JOIN accounts a "
            "ON a.id = p.account_id WHERE a.kind = 'suspense'",
          )
          .getSingle();
      expect(suspense.read<int>('c'), 0);
    });
  });

  test(
    '«не изменилось» records a confirmation without a journal entry',
    () async {
      await store.createAccount(
        NewAccount(kind: AccountKind.cash, name: 'Нал', amount: Money(70000)),
      );
      final id = (await store.accounts()).single.id;
      final entriesBefore = await withDb(
        (db) => db.select(db.journalEntries).get(),
      );
      final result = await store.updateBalances({id: Money(70000)});
      expect(result.changed, 0);
      expect(result.unexplained, Money(0));
      await withDb((db) async {
        expect(await db.select(db.journalEntries).get(), entriesBefore);
        expect(await db.select(db.balanceAssertions).get(), hasLength(2));
      });
    },
  );

  test('journal is append-only at the database level', () async {
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'X', amount: Money(100)),
    );
    await withDb((db) async {
      for (final sql in [
        'UPDATE postings SET amount_minor = 1',
        'DELETE FROM postings',
        'UPDATE journal_entries SET kind = kind',
        'DELETE FROM journal_entries',
        'DELETE FROM balance_assertions',
      ]) {
        await expectLater(
          db.customStatement(sql),
          throwsA(anything),
          reason: sql,
        );
      }
    });
  });

  test('unbalanced or invalid writes roll back completely', () async {
    await expectLater(
      store.createAccount(
        NewAccount(kind: AccountKind.debit, name: '   ', amount: Money(1)),
      ),
      throwsArgumentError,
    );
    await expectLater(
      store.createAccount(
        NewAccount(
          kind: AccountKind.debit,
          name: 'Дебет',
          amount: Money(1),
          creditLimit: Money(5),
        ),
      ),
      throwsArgumentError,
    );
    await expectLater(
      store.updateBalances({'00000000-0000-4000-8000-000000000000': Money(1)}),
      throwsArgumentError,
    );
    expect(await store.accounts(), isEmpty);
    await withDb((db) async {
      expect(await db.select(db.journalEntries).get(), isEmpty);
      expect(await Ledger(db).accounts(), isEmpty);
    });
  });

  test('closed store refuses financial operations', () async {
    await store.close();
    await expectLater(store.accounts(), throwsStateError);
    await store.open();
  });
  test('reserve: default 10 000 ₽, editable, never negative', () async {
    expect(await store.reserve(), Money(1000000));
    await store.setReserve(Money(250000));
    expect(await store.reserve(), Money(250000));
    await expectLater(store.setReserve(Money(-1)), throwsArgumentError);
    expect(await store.reserve(), Money(250000));
  });
  test('include/exclude a money account from the forecast', () async {
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'Общая', amount: Money(100)),
    );
    await store.createAccount(
      NewAccount(kind: AccountKind.creditCard, name: 'К', amount: Money(100)),
    );
    final list = await store.accounts();
    final general = list.firstWhere((a) => a.name == 'Общая');
    expect(general.isProtected, false);
    await store.setIncludedInForecast(general.id, false);
    expect(
      (await store.accounts())
          .firstWhere((a) => a.id == general.id)
          .isProtected,
      true,
    );
    await store.setIncludedInForecast(general.id, true);
    expect(
      (await store.accounts())
          .firstWhere((a) => a.id == general.id)
          .isProtected,
      false,
    );
    await expectLater(
      store.setIncludedInForecast(
        list.firstWhere((a) => a.name == 'К').id,
        false,
      ),
      throwsArgumentError,
    );
  });
}
