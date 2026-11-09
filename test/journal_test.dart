import 'dart:math';

import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/journal.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// R3 Э2: operations in the journal and the anchor rule (docs/r3-plan.md §4).
CalendarDate d(String s) => CalendarDate.parse(s);
DateTime at(String day, [int hour = 10]) {
  final c = d(day);
  return DateTime(c.year, c.month, c.day, hour);
}

Money rub(int r) => Money(r * 100);

final class Book {
  Book(this.db);
  final AppDatabase db;
  Ledger get ledger => Ledger(db);
  Journal get journal => Journal(db);
  final ids = <String, String>{};

  static Future<Book> open() async {
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (r) => r.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    final book = Book(db);
    for (final c in await db.select(db.categories).get()) {
      book.ids[c.systemKey!] = c.id;
    }
    return book;
  }

  Future<String> account(
    String name,
    AccountKind kind,
    int rubles,
    DateTime now,
  ) async {
    await ledger.createAccount(
      NewAccount(kind: kind, name: name, amount: rub(rubles)),
      now,
    );
    final id = (await ledger.accounts()).singleWhere((a) => a.name == name).id;
    ids[name] = id;
    return id;
  }

  Future<Money> balance(String name) async =>
      (await ledger.accounts()).singleWhere((a) => a.name == name).amount;

  Future<int> suspense() async {
    final row = await db
        .customSelect(
          'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
          "JOIN accounts a ON a.id = p.account_id WHERE a.kind = 'suspense'",
        )
        .getSingle();
    return row.read<int>('s');
  }

  /// И3: every confirmed balance is still true at its moment.
  Future<void> expectAnchorsHold() async {
    for (final a in await db.select(db.balanceAssertions).get()) {
      expect(
        await journal.balanceAt(a.accountId, a.assertedAtUtc),
        a.amountMinor,
        reason: 'assertion ${a.id} at ${a.assertedAtUtc}',
      );
    }
  }

  /// И1: every entry sums to zero and has two or more lines.
  Future<void> expectBalancedEntries() async {
    final bad = await db.customSelect('''
      SELECT entry_id FROM postings GROUP BY entry_id
      HAVING SUM(amount_minor) <> 0 OR COUNT(*) < 2
    ''').get();
    expect(bad, isEmpty);
  }

  /// И6: «Невыясненное» moves only by balance updates, anchor corrections,
  /// reclassification, or the reversal of an anchor correction.
  Future<void> expectSuspenseDiscipline() async {
    final rows = await db.customSelect('''
      SELECT e.kind AS kind, r.kind AS reversed
      FROM postings p
      JOIN accounts a ON a.id = p.account_id AND a.kind = 'suspense'
      JOIN journal_entries e ON e.id = p.entry_id
      LEFT JOIN entry_details dd ON dd.entry_id = e.id
      LEFT JOIN journal_entries r ON r.id = dd.reverses_entry_id
    ''').get();
    for (final r in rows) {
      final kind = r.read<String>('kind');
      if (kind == 'reversal') {
        expect(r.read<String?>('reversed'), 'anchor_correction');
      } else {
        expect({
          'balance_adjustment',
          'anchor_correction',
          'reclass',
        }, contains(kind));
      }
    }
  }
}

void main() {
  late Book b;
  setUp(() async => b = await Book.open());
  tearDown(() => b.db.close());

  test(
    '§4 example: balance confirmed, then a purchase from the day before',
    () async {
      final sber = await b.account(
        'Сбер',
        AccountKind.debit,
        10000,
        at('2026-11-01'),
      );
      // 3 Nov: the bank shows 7 000 — 3 000 unexplained.
      await b.ledger.updateBalances({sber: rub(7000)}, at('2026-11-03'));
      expect(await b.suspense(), 300000);

      // 5 Nov: «Продукты 2 500 ₽ on 2 Nov».
      final op = ExpenseOp(
        accountId: sber,
        categoryId: b.ids['groceries']!,
        amount: rub(2500),
        date: d('2026-11-02'),
      );
      final preview = await b.journal.preview(op, now: at('2026-11-05'));
      expect(preview.inConfirmedBalance, true);
      expect(preview.balances[sber], (rub(7000), rub(7000)));
      expect(preview.confirmedAt, at('2026-11-03'));
      // A confirmation after the operation's date: the screens must ask (the
      // bank may have taken it later); this internal call passes `auto`.
      expect(preview.askIncluded, true);
      expect(preview.latestConfirmation, at('2026-11-03'));
      // Nothing written by a preview.
      expect(await b.db.select(b.db.entryDetails).get(), isEmpty);

      await b.journal.record(op, now: at('2026-11-05'));
      expect(await b.balance('Сбер'), rub(7000)); // confirmed balance kept
      expect(await b.suspense(), 50000); // 500 still unexplained
      expect(await b.journal.categoryTotals(d('2026-11-01'), d('2026-11-30')), {
        b.ids['groceries']!: rub(2500),
      });
      await b.expectAnchorsHold();
      await b.expectBalancedEntries();
      await b.expectSuspenseDiscipline();
    },
  );

  test('an operation before several confirmations: corrected once, at the '
      'first one after it', () async {
    final sber = await b.account(
      'Сбер',
      AccountKind.debit,
      10000,
      at('2026-11-01'),
    );
    await b.ledger.updateBalances({sber: rub(9000)}, at('2026-11-03'));
    await b.ledger.updateBalances({sber: rub(8000)}, at('2026-11-06'));
    await b.journal.record(
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['cafe']!,
        amount: rub(400),
        date: d('2026-11-01'),
      ),
      now: at('2026-11-07'),
    );
    final corrections = await (b.db.select(
      b.db.journalEntries,
    )..where((e) => e.kind.equals('anchor_correction'))).get();
    // Created 1 Nov 10:00 with an anchor at that moment; the purchase is at
    // noon, so the first confirmation after it is 3 Nov.
    expect(
      corrections.single.occurredAtUtc,
      at('2026-11-03').toUtc().millisecondsSinceEpoch,
    );
    expect(await b.balance('Сбер'), rub(8000));
    await b.expectAnchorsHold();
  });

  test('after the last confirmation the balance changes as usual', () async {
    final sber = await b.account(
      'Сбер',
      AccountKind.debit,
      10000,
      at('2026-11-01'),
    );
    final p = await b.journal.preview(
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['transport']!,
        amount: rub(300),
        date: d('2026-11-04'),
      ),
      now: at('2026-11-04', 18),
    );
    expect(p.inConfirmedBalance, false);
    expect(p.balances[sber], (rub(10000), rub(9700)));
    await b.journal.record(
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['transport']!,
        amount: rub(300),
        date: d('2026-11-04'),
      ),
      now: at('2026-11-04', 18),
    );
    expect(await b.balance('Сбер'), rub(9700));
    expect(await b.suspense(), 0);
    await b.expectAnchorsHold();
  });

  group('same day as a balance update', () {
    test(
      'salary already in the updated balance is recognised automatically',
      () async {
        final sber = await b.account(
          'Сбер',
          AccountKind.debit,
          10000,
          at('2026-11-01'),
        );
        // The person sees the salary in the bank and updates the balance.
        await b.ledger.updateBalances({sber: rub(90000)}, at('2026-11-05', 9));
        final salary = IncomeOp(
          accountId: sber,
          categoryId: b.ids['salary']!,
          amount: rub(80000),
          date: d('2026-11-05'),
        );
        final p = await b.journal.preview(salary, now: at('2026-11-05', 20));
        expect(p.askIncluded, true);
        expect(p.placement, SameDayPlacement.inConfirmedBalance);
        expect(p.inConfirmedBalance, true);
        expect(p.balances[sber], (rub(90000), rub(90000)));
        await b.journal.record(
          salary,
          now: at('2026-11-05', 20),
          placement: p.placement,
        );
        expect(await b.balance('Сбер'), rub(90000)); // not doubled
        expect(await b.suspense(), 0); // the difference is now explained

        // A second income the same day is no longer covered: it adds.
        final extra = IncomeOp(
          accountId: sber,
          categoryId: b.ids['other_income']!,
          amount: rub(10000),
          date: d('2026-11-05'),
        );
        final p2 = await b.journal.preview(extra, now: at('2026-11-05', 21));
        expect(p2.placement, SameDayPlacement.afterConfirmedBalance);
        expect(p2.balances[sber], (rub(90000), rub(100000)));
        await b.expectAnchorsHold();
      },
    );

    test(
      'nothing unexplained that day → the money came after the update',
      () async {
        final sber = await b.account(
          'Сбер',
          AccountKind.debit,
          10000,
          at('2026-11-01'),
        );
        await b.ledger.updateBalances({sber: rub(10000)}, at('2026-11-05', 9));
        final p = await b.journal.preview(
          IncomeOp(
            accountId: sber,
            categoryId: b.ids['salary']!,
            amount: rub(80000),
            date: d('2026-11-05'),
          ),
          now: at('2026-11-05', 20),
        );
        expect(p.placement, SameDayPlacement.afterConfirmedBalance);
        expect(p.balances[sber], (rub(10000), rub(90000)));
      },
    );

    test(
      'the person can switch the placement; it is recorded as shown',
      () async {
        final sber = await b.account(
          'Сбер',
          AccountKind.debit,
          10000,
          at('2026-11-01'),
        );
        await b.ledger.updateBalances({sber: rub(90000)}, at('2026-11-05', 9));
        final op = IncomeOp(
          accountId: sber,
          categoryId: b.ids['salary']!,
          amount: rub(80000),
          date: d('2026-11-05'),
        );
        final p = await b.journal.preview(
          op,
          now: at('2026-11-05', 20),
          placement: SameDayPlacement.afterConfirmedBalance,
        );
        expect(p.balances[sber], (rub(90000), rub(170000)));
        final r = await b.journal.record(
          op,
          now: at('2026-11-05', 20),
          placement: p.placement,
        );
        expect(r.preview.balances[sber], p.balances[sber]);
        expect(await b.balance('Сбер'), rub(170000));
        await b.expectAnchorsHold();
      },
    );
  });

  group('reversal (И11)', () {
    test('cancelling an anchored operation restores everything', () async {
      final sber = await b.account(
        'Сбер',
        AccountKind.debit,
        10000,
        at('2026-11-01'),
      );
      await b.ledger.updateBalances({sber: rub(7000)}, at('2026-11-03'));
      final r = await b.journal.record(
        ExpenseOp(
          accountId: sber,
          categoryId: b.ids['groceries']!,
          amount: rub(2500),
          date: d('2026-11-02'),
        ),
        now: at('2026-11-05'),
      );
      await b.journal.reverse(r.entryId, at('2026-11-06'));
      expect(await b.balance('Сбер'), rub(7000));
      expect(await b.suspense(), 300000);
      expect(
        await b.journal.categoryTotals(d('2026-11-01'), d('2026-11-30')),
        isEmpty,
      );
      await b.expectAnchorsHold();
      await b.expectBalancedEntries();
      await b.expectSuspenseDiscipline();
      await expectLater(
        b.journal.reverse(r.entryId, at('2026-11-06')),
        throwsA(isA<InvalidOperation>()),
      );
    });

    test(
      'cancelling after a later confirmation keeps that confirmation true',
      () async {
        final sber = await b.account(
          'Сбер',
          AccountKind.debit,
          10000,
          at('2026-11-01'),
        );
        final r = await b.journal.record(
          IncomeOp(
            accountId: sber,
            categoryId: b.ids['salary']!,
            amount: rub(80000),
            date: d('2026-11-05'),
          ),
          now: at('2026-11-05', 15),
        );
        // The bank confirms 90 000 on 6 Nov (includes the salary).
        await b.ledger.updateBalances({sber: rub(90000)}, at('2026-11-06'));
        // The salary entry was a mistake: the 80 000 becomes unexplained.
        await b.journal.reverse(r.entryId, at('2026-11-07'));
        expect(await b.balance('Сбер'), rub(90000));
        expect(await b.suspense(), -8000000);
        await b.expectAnchorsHold();
      },
    );

    test('balance updates, opening balances and corrections are not '
        'cancellable as operations', () async {
      await b.account('Сбер', AccountKind.debit, 10000, at('2026-11-01'));
      final opening = await b.db.select(b.db.journalEntries).getSingle();
      await expectLater(
        b.journal.reverse(opening.id, at('2026-11-02')),
        throwsA(isA<InvalidOperation>()),
      );
    });
  });

  test('credit card: purchase grows the debt, repayment is not an expense '
      '(И13)', () async {
    final sber = await b.account(
      'Сбер',
      AccountKind.debit,
      50000,
      at('2026-11-01'),
    );
    final card = await b.account(
      'Кредитка',
      AccountKind.creditCard,
      0,
      at('2026-11-01'),
    );
    await b.journal.record(
      ExpenseOp(
        accountId: card,
        categoryId: b.ids['clothes']!,
        amount: rub(6000),
        date: d('2026-11-02'),
      ),
      now: at('2026-11-02', 15),
    );
    expect(await b.balance('Кредитка'), rub(6000)); // debt
    await b.journal.record(
      TransferOp(
        fromAccountId: sber,
        toAccountId: card,
        amount: rub(6000),
        date: d('2026-11-03'),
      ),
      now: at('2026-11-03', 15),
    );
    await b.journal.record(
      RefundOp(
        accountId: card,
        categoryId: b.ids['clothes']!,
        amount: rub(1000),
        date: d('2026-11-04'),
      ),
      now: at('2026-11-04', 15),
    );
    expect(await b.balance('Кредитка'), rub(-1000)); // overpaid by the refund
    expect(await b.balance('Сбер'), rub(44000));
    // Spending: 6 000 − 1 000 refund; the repayment is not spending.
    expect(await b.journal.categoryTotals(d('2026-11-01'), d('2026-11-30')), {
      b.ids['clothes']!: rub(5000),
    });
    await b.expectBalancedEntries();
  });

  test('invalid operations are refused and nothing is written', () async {
    final sber = await b.account(
      'Сбер',
      AccountKind.debit,
      100,
      at('2026-11-01'),
    );
    final category = (await b.db.select(b.db.categories).get()).firstWhere(
      (c) => c.systemKey == 'groceries',
    );
    final cases = <Operation>[
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['groceries']!,
        amount: rub(0),
        date: d('2026-11-01'),
      ),
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['groceries']!,
        amount: rub(1),
        date: d('2026-11-09'), // future
      ),
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['salary']!, // income category
        amount: rub(1),
        date: d('2026-11-01'),
      ),
      ExpenseOp(
        accountId: category.ledgerAccountId, // not an own account
        categoryId: b.ids['groceries']!,
        amount: rub(1),
        date: d('2026-11-01'),
      ),
      TransferOp(
        fromAccountId: sber,
        toAccountId: sber,
        amount: rub(1),
        date: d('2026-11-01'),
      ),
    ];
    for (final op in cases) {
      await expectLater(
        b.journal.record(op, now: at('2026-11-02')),
        throwsA(isA<InvalidOperation>()),
      );
    }
    expect(await b.db.select(b.db.entryDetails).get(), isEmpty);
    expect(await b.db.select(b.db.journalEntries).get(), hasLength(1));
  });

  test('the journal details are append-only (И2)', () async {
    final sber = await b.account(
      'Сбер',
      AccountKind.debit,
      100,
      at('2026-11-01'),
    );
    final r = await b.journal.record(
      ExpenseOp(
        accountId: sber,
        categoryId: b.ids['groceries']!,
        amount: rub(1),
        date: d('2026-11-01'),
      ),
      now: at('2026-11-02'),
    );
    await expectLater(
      b.db.customStatement(
        "UPDATE entry_details SET note = 'x' WHERE entry_id = ?",
        [r.entryId],
      ),
      throwsA(anything),
    );
    await expectLater(
      b.db.customStatement('DELETE FROM entry_details'),
      throwsA(anything),
    );
  });

  test('random histories keep every invariant (И1, И3, И5, И6, И11)', () async {
    final random = Random(20261104);
    for (var run = 0; run < 150; run++) {
      final book = await Book.open();
      final start = DateTime(2026, 11, 1, 8);
      var now = start;
      final accounts = [
        await book.account('A', AccountKind.debit, 10000, now),
        await book.account('B', AccountKind.cash, 2000, now),
        await book.account('C', AccountKind.creditCard, 3000, now),
      ];
      final expense = ['groceries', 'cafe', 'transport'];
      final recorded = <(String id, String category, int signed, bool live)>[];
      for (var step = 0; step < 25; step++) {
        now = now.add(Duration(hours: 1 + random.nextInt(20)));
        final today = CalendarDate.fromDateTime(now);
        final roll = random.nextInt(10);
        if (roll < 3) {
          final pick = accounts.where((_) => random.nextBool()).toList();
          if (pick.isEmpty) continue;
          await book.ledger.updateBalances({
            for (final a in pick) a: rub(random.nextInt(20000)),
          }, now);
        } else if (roll < 9 || recorded.every((r) => !r.$4)) {
          final back = random.nextInt(4);
          var date = today.addDays(-back);
          if (date < CalendarDate.fromDateTime(start)) {
            date = CalendarDate.fromDateTime(start);
          }
          final amount = rub(1 + random.nextInt(3000));
          final acc = accounts[random.nextInt(3)];
          final cat = expense[random.nextInt(3)];
          final placement = SameDayPlacement
              .values[random.nextInt(SameDayPlacement.values.length)];
          final Operation op;
          final String key;
          final int signed;
          switch (random.nextInt(4)) {
            case 0:
              op = IncomeOp(
                accountId: acc,
                categoryId: book.ids['salary']!,
                amount: amount,
                date: date,
              );
              (key, signed) = ('salary', amount.minorUnits);
            case 1:
              op = RefundOp(
                accountId: acc,
                categoryId: book.ids[cat]!,
                amount: amount,
                date: date,
              );
              (key, signed) = (cat, -amount.minorUnits);
            case 2:
              final to = accounts[(accounts.indexOf(acc) + 1) % 3];
              op = TransferOp(
                fromAccountId: acc,
                toAccountId: to,
                amount: amount,
                date: date,
              );
              (key, signed) = ('', 0);
            default:
              op = ExpenseOp(
                accountId: acc,
                categoryId: book.ids[cat]!,
                amount: amount,
                date: date,
              );
              (key, signed) = (cat, amount.minorUnits);
          }
          final r = await book.journal.record(
            op,
            now: now,
            placement: placement,
          );
          recorded.add((r.entryId, key, signed, true));
        } else {
          final live = [
            for (var i = 0; i < recorded.length; i++)
              if (recorded[i].$4) i,
          ];
          final i = live[random.nextInt(live.length)];
          await book.journal.reverse(recorded[i].$1, now);
          final r = recorded[i];
          recorded[i] = (r.$1, r.$2, r.$3, false);
        }
        await book.expectAnchorsHold();
      }
      await book.expectBalancedEntries();
      await book.expectSuspenseDiscipline();
      // И5: analytics equal the reference model.
      final want = <String, int>{};
      for (final r in recorded.where((r) => r.$4 && r.$2.isNotEmpty)) {
        want[book.ids[r.$2]!] = (want[book.ids[r.$2]!] ?? 0) + r.$3;
      }
      want.removeWhere((_, v) => v == 0);
      expect(
        await book.journal.categoryTotals(d('2026-10-01'), d('2027-01-01')),
        {for (final e in want.entries) e.key: Money(e.value)},
        reason: 'run $run',
      );
      await book.db.close();
    }
  });
}
