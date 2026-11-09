import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/income_repo.dart';
import 'package:denezhno/core/database/journal.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// R3 Э3: salary and advance — plan, expectation and fact; receipts in the
/// journal without double counting (docs/r3-plan.md §10).
CalendarDate d(String s) => CalendarDate.parse(s);
DateTime at(String day, [int hour = 10]) {
  final c = d(day);
  return DateTime(c.year, c.month, c.day, hour);
}

Money rub(int r) => Money(r * 100);

final class World {
  World(this.db);
  final AppDatabase db;
  IncomeRepo get income => IncomeRepo(db);
  Ledger get ledger => Ledger(db);
  late String sber;
  late String source;

  /// Сбер 10 000 ₽ on 1 Nov; «Работа»: аванс 20-го 40 000, зарплата 5-го
  /// 60 000, tracked from 1 Nov.
  static Future<World> open() async {
    final w = World(
      AppDatabase(
        NativeDatabase.memory(
          setup: (r) => r.execute('PRAGMA foreign_keys = ON'),
        ),
      ),
    );
    await w.ledger.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'Сбер', amount: rub(10000)),
      at('2026-11-01', 9),
    );
    w.sber = (await w.ledger.accounts()).single.id;
    w.source = await w.income.createSource(
      name: 'Работа',
      kind: IncomeKind.salary,
      holidayRule: HolidayRule.previousWorkday,
      accountId: w.sber,
      parts: [
        PartSpec(
          label: 'Аванс',
          amount: rub(40000),
          cadence: const Monthly(20),
        ),
        PartSpec(
          label: 'Зарплата',
          amount: rub(60000),
          cadence: const Monthly(5),
        ),
      ],
      today: d('2026-11-01'),
      now: at('2026-11-01', 9),
    );
    return w;
  }

  Future<List<IncomePayment>> payments(String today) async =>
      (await income.snapshot(d(today))).payments;

  Future<IncomePayment> payment(
    String today,
    String label,
    String planned,
  ) async =>
      (await payments(today))
          .singleWhere((p) => p.label == label && p.plannedOn == d(planned));

  Future<Money> balance() async => (await ledger.accounts()).single.amount;

  Future<int> suspense() async {
    final r = await db
        .customSelect(
          'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
          "JOIN accounts a ON a.id = p.account_id WHERE a.kind = 'suspense'",
        )
        .getSingle();
    return r.read<int>('s');
  }

  Future<void> expectAnchorsHold() async {
    for (final a in await db.select(db.balanceAssertions).get()) {
      expect(
        await Journal(db).balanceAt(a.accountId, a.assertedAtUtc),
        a.amountMinor,
      );
    }
  }

  Future<OperationPreview> preview(
    IncomePayment p,
    int rubles,
    String date,
    String now,
  ) => income.previewReceipt(
    p.key,
    amount: rub(rubles),
    accountId: sber,
    date: d(date),
    now: at(now, 20),
  );

  Future<void> receive(
    IncomePayment p,
    int rubles,
    String date,
    String now, {
    ShortfallChoice shortfall = ShortfallChoice.restLater,
    CalendarDate? restOn,
    SameDayPlacement? placement,
  }) async {
    final shown = await preview(p, rubles, date, now);
    await income.receive(
      p.key,
      amount: rub(rubles),
      accountId: sber,
      date: d(date),
      now: at(now, 20),
      placement: placement ?? shown.placement,
      shortfall: shortfall,
      restOn: restOn,
    );
  }

  SafeToSpend forecast(List<IncomePayment> incomes, String today) =>
      computeSafeToSpend(
        accounts: const [],
        payments: const PaymentsSnapshot(
          flows: [],
          doneMarks: {},
          cardFigures: {},
          creditCards: {},
        ),
        reserve: Money(0),
        today: d(today),
        incomes: incomes,
      );
}

void main() {
  late World w;
  setUp(() async => w = await World.open());
  tearDown(() => w.db.close());

  test('two payments of one schedule, with the holiday rule', () async {
    final list = await w.payments('2026-11-01');
    expect(
      [
        for (final p in list.take(4))
          (p.label, p.plannedOn.iso, p.scheduledOn.iso, p.expected),
      ],
      [
        ('Зарплата', '2026-11-05', '2026-11-05', rub(60000)),
        ('Аванс', '2026-11-20', '2026-11-20', rub(40000)),
        // 5 Dec 2026 is Saturday → paid on Friday 4 Dec (art. 136).
        ('Зарплата', '2026-12-05', '2026-12-04', rub(60000)),
        ('Аванс', '2026-12-20', '2026-12-18', rub(40000)), // Sunday → Friday
      ],
    );
    expect(list.every((p) => p.isOpen && p.id == null), true);
  });

  test(
    'received in full: booked once; the balance and journal agree',
    () async {
      final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      final shown = await w.preview(p, 60000, '2026-11-05', '2026-11-05');
      // Confirmed before writing: nothing is stored by the preview.
      expect(await w.db.select(w.db.incomeReceipts).get(), isEmpty);
      expect(shown.balances[w.sber], (rub(10000), rub(70000)));
      await w.receive(p, 60000, '2026-11-05', '2026-11-05');
      final after = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      expect(after.state, PaymentState.received);
      expect(after.received, rub(60000));
      expect(await w.balance(), rub(70000));
      final totals = await Journal(w.db)
          .categoryTotals(d('2026-11-01'), d('2026-11-30'));
      expect(totals.values.single, rub(60000));
    },
  );

  test('partial: the rest stays expected (not money) until it comes', () async {
    final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(
      p,
      25000,
      '2026-11-05',
      '2026-11-05',
      restOn: d('2026-11-12'),
    );
    var now = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    expect(now.state, PaymentState.open);
    expect(now.received, rub(25000));
    expect(now.remaining, rub(35000));
    expect(now.dueOn, d('2026-11-12'));
    expect(now.isPartial, true);
    expect(await w.balance(), rub(35000)); // only what came

    // Forecast: horizon = the rest's date; the rest is not money (И7, И12).
    final f = w.forecast(await w.payments('2026-11-06'), '2026-11-06');
    expect(f.horizon, d('2026-11-12'));
    expect(f.warnings.whereType<SalaryPartial>(), hasLength(1));

    // Second receipt for the same payment closes it.
    await w.receive(now, 35000, '2026-11-12', '2026-11-12');
    now = await w.payment('2026-11-12', 'Зарплата', '2026-11-05');
    expect(now.state, PaymentState.received);
    expect(now.receipts, hasLength(2));
    expect(now.received + now.remaining, rub(60000));
    expect(await w.balance(), rub(70000));
  });

  test('moving one payment does not change any other month', () async {
    final p = await w.payment('2026-11-01', 'Аванс', '2026-11-20');
    await w.income.move(p.key, d('2026-11-27'), at('2026-11-18'));
    final list = await w.payments('2026-11-18');
    final nov = list.singleWhere((x) => x.plannedOn == d('2026-11-20'));
    expect(
      (nov.dueOn, nov.isDelayed, nov.plannedOn),
      (d('2026-11-27'), true, d('2026-11-20')),
    );
    final dec = list.singleWhere(
      (x) => x.label == 'Аванс' && x.plannedOn == d('2026-12-20'),
    );
    expect((dec.dueOn, dec.isDelayed), (d('2026-12-18'), false));
    // The schedule itself is untouched.
    expect(await w.db.select(w.db.incomeScheduleParts).get(), hasLength(2));
  });

  test(
    'delay with a new date: the forecast runs to it and shows the risk',
    () async {
      final salary = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      await w.receive(salary, 60000, '2026-11-05', '2026-11-05');
      await w.ledger.updateBalances({w.sber: rub(20000)}, at('2026-11-15'));
      final p = await w.payment('2026-11-15', 'Аванс', '2026-11-20');
      await w.income.move(p.key, d('2026-11-30'), at('2026-11-15'));
      final f = computeSafeToSpend(
        accounts: await w.ledger.accounts(),
        payments: const PaymentsSnapshot(
          flows: [],
          doneMarks: {},
          cardFigures: {},
          creditCards: {},
        ),
        reserve: Money(0),
        today: d('2026-11-15'),
        incomes: await w.payments('2026-11-15'),
      );
      expect(f.horizon, d('2026-11-30'));
      expect(f.horizonKind, HorizonKind.salary);
      final delayed = f.warnings.whereType<SalaryDelayed>().single;
      // 20 000 over 15 days instead of 5: 1 333 ₽ instead of 4 000 ₽ a day.
      expect(f.perDay, rub(1333));
      expect(delayed.perDayIfOnTime, rub(4000));
    },
  );

  test(
    'delay with no date: a labelled period, not a jump to next month',
    () async {
      final p = await w.payment('2026-11-01', 'Зарплата', '2026-11-05');
      await w.income.markDateUnknown(p.key, at('2026-11-05'));
      final f = w.forecast(await w.payments('2026-11-07'), '2026-11-07');
      expect(f.horizonKind, HorizonKind.period);
      expect(f.daysLeft, 14);
      expect(f.warnings.whereType<SalaryDateUnknown>(), hasLength(1));
    },
  );

  test('overdue stays until resolved, however long ago', () async {
    // Nothing done about 5 Nov; three months later it is still waiting.
    final list = await w.payments('2027-02-10');
    final old = list.singleWhere((x) => x.plannedOn == d('2026-11-05'));
    expect(old.isOverdue(d('2027-02-10')), true);
    final f = w.forecast(list, '2027-02-10');
    expect(f.horizonKind, HorizonKind.period);
    expect(
      f.warnings.whereType<SalaryOverdue>().map((x) => x.payment.plannedOn),
      contains(d('2026-11-05')),
    );
    // Cancelled («не будет») → resolved; reopen brings it back.
    await w.income.cancel(old.key, at('2027-02-10'));
    var again = (await w.payments('2027-02-10'))
        .singleWhere((x) => x.plannedOn == d('2026-11-05'));
    expect(again.state, PaymentState.cancelled);
    expect(again.isOverdue(d('2027-02-10')), false);
    await w.income.reopen(old.key, at('2027-02-10'));
    again = (await w.payments('2027-02-10'))
        .singleWhere((x) => x.plannedOn == d('2026-11-05'));
    expect(again.isOverdue(d('2027-02-10')), true);
  });

  test('early payment: received before the date', () async {
    final salary = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(salary, 60000, '2026-11-05', '2026-11-05');
    final p = await w.payment('2026-11-01', 'Аванс', '2026-11-20');
    await w.receive(p, 40000, '2026-11-17', '2026-11-17');
    final f = w.forecast(await w.payments('2026-11-17'), '2026-11-17');
    expect(f.horizon, d('2026-12-04')); // next: salary, 5 Dec → Fri 4 Dec
  });

  test('a different amount: «это вся выплата»', () async {
    final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(
      p,
      55000,
      '2026-11-05',
      '2026-11-05',
      shortfall: ShortfallChoice.wholePayment,
    );
    final now = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    expect(now.state, PaymentState.received);
    expect((now.plannedAmount, now.expected), (rub(60000), rub(55000)));
    expect(now.remaining, Money(0));
  });

  group('no double counting with balance updates', () {
    test('salary already in the balance updated that day', () async {
      // Saw the salary in the bank app, updated the balance first.
      await w.ledger.updateBalances({w.sber: rub(70000)}, at('2026-11-05', 9));
      final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      final shown = await w.preview(p, 60000, '2026-11-05', '2026-11-05');
      expect(shown.inConfirmedBalance, true);
      expect(shown.placement, SameDayPlacement.inConfirmedBalance);
      expect(shown.balances[w.sber], (rub(70000), rub(70000)));
      await w.receive(p, 60000, '2026-11-05', '2026-11-05');
      expect(await w.balance(), rub(70000)); // not 130 000
      expect(await w.suspense(), 0); // the difference is explained
      await w.expectAnchorsHold();
    });

    test(
      'received on 5 Nov, balance confirmed on 6 Nov, recorded on 7 Nov',
      () async {
        await w.ledger.updateBalances({w.sber: rub(70000)}, at('2026-11-06'));
        final p = await w.payment('2026-11-07', 'Зарплата', '2026-11-05');
        final shown = await w.preview(p, 60000, '2026-11-05', '2026-11-07');
        // Confirmed after the date: the person is asked (here: «уже были»).
        expect(shown.askIncluded, true);
        expect(shown.inConfirmedBalance, true);
        await w.receive(p, 60000, '2026-11-05', '2026-11-07');
        expect(await w.balance(), rub(70000));
        expect(await w.suspense(), 0);
        await w.expectAnchorsHold();
      },
    );

    test('a mistaken receipt is cancelled; history stays', () async {
      final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      await w.receive(p, 60000, '2026-11-05', '2026-11-05');
      final received = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
      await w.income.cancelReceipt(
        received.receipts.single.id,
        at('2026-11-06'),
      );
      final now = await w.payment('2026-11-06', 'Зарплата', '2026-11-05');
      expect(now.state, PaymentState.open);
      expect(now.receipts.single.cancelled, true);
      expect(now.received, Money(0));
      expect(await w.balance(), rub(10000));
      expect(await w.db.select(w.db.incomeReceipts).get(), hasLength(1));
      await w.expectAnchorsHold();
    });
  });

  test('schedule change: past payments and receipts keep their plan', () async {
    final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(p, 60000, '2026-11-05', '2026-11-05');
    final source = (await w.income.snapshot(d('2026-11-10'))).sources.single;
    final salary = source.currentParts.firstWhere((x) => x.label == 'Зарплата');
    final advance = source.currentParts.firstWhere((x) => x.label == 'Аванс');
    // From 10 Nov: salary 70 000 on the 7th.
    await w.income.updateSchedule(
      w.source,
      name: 'Работа',
      holidayRule: HolidayRule.previousWorkday,
      accountId: w.sber,
      parts: [
        PartSpec(
          id: advance.id,
          label: 'Аванс',
          amount: rub(40000),
          cadence: const Monthly(20),
        ),
        PartSpec(
          id: salary.id,
          label: 'Зарплата',
          amount: rub(70000),
          cadence: const Monthly(7),
        ),
      ],
      effectiveFrom: d('2026-11-10'),
      now: at('2026-11-10'),
    );
    final list = await w.payments('2026-11-10');
    final nov = list.singleWhere((x) => x.plannedOn == d('2026-11-05'));
    expect(
      (nov.state, nov.plannedAmount, nov.received),
      (PaymentState.received, rub(60000), rub(60000)),
    );
    final dec = list.singleWhere(
      (x) => x.label == 'Зарплата' && x.plannedOn.month == 12,
    );
    expect((dec.plannedOn, dec.plannedAmount), (d('2026-12-07'), rub(70000)));
    expect(list.where((x) => x.plannedOn == d('2026-12-05')), isEmpty);
    // Advance unchanged: still one version.
    final parts = await w.db.select(w.db.incomeScheduleParts).get();
    expect(parts.where((x) => x.label == 'Аванс'), hasLength(1));
    expect(parts.where((x) => x.label == 'Зарплата'), hasLength(2));
  });

  test('receipts survive archiving the source', () async {
    final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(p, 60000, '2026-11-05', '2026-11-05');
    await w.income.archiveSource(w.source, at('2026-11-06'));
    expect((await w.income.snapshot(d('2026-11-06'))).sources, isEmpty);
    expect(await w.db.select(w.db.incomeReceipts).get(), hasLength(1));
    expect(await w.balance(), rub(70000));
  });

  test('receipts are append-only', () async {
    final p = await w.payment('2026-11-05', 'Зарплата', '2026-11-05');
    await w.receive(p, 60000, '2026-11-05', '2026-11-05');
    await expectLater(
      w.db.customStatement('UPDATE income_receipts SET amount_minor = 1'),
      throwsA(anything),
    );
    await expectLater(
      w.db.customStatement('DELETE FROM income_receipts'),
      throwsA(anything),
    );
  });

  test('forecast period is stored', () async {
    expect(await w.income.period(), const PeriodDays(14));
    await w.income.setPeriod(const PeriodDays(30));
    expect(await w.income.period(), const PeriodDays(30));
    await w.income.setPeriod(PeriodUntil(d('2026-12-01')));
    expect(await w.income.period(), PeriodUntil(d('2026-12-01')));
  });
}
