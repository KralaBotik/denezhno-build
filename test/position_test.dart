import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:flutter_test/flutter_test.dart';

/// R3 Э1: the financial position next to «можно потратить» (docs/r3-plan.md,
/// invariants И7, И9, И10). Exact to the kopeck.
CalendarDate d(String s) => CalendarDate.parse(s);
final today = d('2026-11-04');
Money rub(int rubles) => Money(rubles * 100);

AccountSummary acc(String id, AccountKind kind, int rubles) => AccountSummary(
  id: id,
  name: id,
  kind: kind,
  amount: rub(rubles),
  isProtected: false,
  lastUpdatedAt: DateTime(2026, 11, 4, 9),
);

PlannedFlow flow(
  String id,
  FlowKind kind,
  int rubles,
  Cadence c, {
  String? account,
  String starts = '2026-01-01',
}) => PlannedFlow(
  id: id,
  kind: kind,
  name: id,
  amount: rub(rubles),
  cadence: c,
  startsOn: d(starts),
  accountId: account,
);

PaymentsSnapshot snap({
  List<PlannedFlow> flows = const [],
  Set<(String, CalendarDate)> done = const {},
  Map<String, CardFigures> cards = const {},
}) => PaymentsSnapshot(
  flows: flows,
  doneMarks: done,
  cardFigures: cards,
  creditCards: const {},
);

SafeToSpend calc(
  List<AccountSummary> accounts,
  PaymentsSnapshot payments, {
  int reserve = 0,
  ForecastPeriod period = defaultForecastPeriod,
}) => computeSafeToSpend(
  accounts: accounts,
  payments: payments,
  reserve: rub(reserve),
  today: today,
  period: period,
);

/// И10: the identities hold for every result.
void expectIdentities(SafeToSpend r) {
  expect(
    r.available,
    r.money - r.paymentsTotal - r.cardPaymentsTotal - r.goals - r.reserve,
  );
  final towardsDebts = [
    ...r.payments,
    ...r.cardPayments,
  ].where((x) => x.accountId != null).fold(Money(0), (s, x) => s + x.amount);
  expect(r.ifAllDebtsPaid, r.available + towardsDebts - r.totalDebt);
  expect(r.obligationsTotal, r.paymentsTotal + r.cardPaymentsTotal);
  expect(r.cards.fold(Money(0), (s, c) => s + c.deducted), r.cardPaymentsTotal);
}

void main() {
  group('salary horizon (И7)', () {
    final salary = flow('ЗП', FlowKind.salary, 80000, const Monthly(1));

    test('overdue salary is not received and does not jump to next month', () {
      // Salary on the 1st, today the 4th, not marked.
      final r = calc([
        acc('Карта', AccountKind.debit, 14000),
      ], snap(flows: [salary]));
      expect(r.horizonKind, HorizonKind.period);
      expect(r.horizon, d('2026-11-18')); // 14 days, not 1 December
      expect(r.money, rub(14000)); // nothing added for the missing salary
      final w = r.warnings.whereType<SalaryOverdue>().single;
      expect((w.name, w.dueOn, w.flowId), ('ЗП', d('2026-11-01'), 'ЗП'));
      expect(r.warnings.whereType<NoSalary>(), isEmpty);
      expectIdentities(r);
    });

    test('marked as received → the next salary is the horizon', () {
      final r = calc([
        acc('Карта', AccountKind.debit, 14000),
      ], snap(flows: [salary], done: {('ЗП', d('2026-11-01'))}));
      expect(r.horizonKind, HorizonKind.salary);
      expect(r.horizon, d('2026-12-01'));
      expect(r.warnings.whereType<SalaryOverdue>(), isEmpty);
    });

    test(
      'an older unmarked month does not count when the latest is marked',
      () {
        final r = calc(
          [acc('Карта', AccountKind.debit, 100)],
          snap(
            flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(4))],
            done: {('ЗП', d('2026-11-04'))},
          ),
        );
        expect(r.warnings.whereType<SalaryOverdue>(), isEmpty);
        expect(r.horizon, d('2026-12-04'));
      },
    );

    test('salary due today is not overdue', () {
      final r = calc([
        acc('Карта', AccountKind.debit, 100),
      ], snap(flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(4))]));
      expect(r.horizonKind, HorizonKind.salary);
      expect(r.horizon, today);
    });

    test('a plan created after its last date is not overdue', () {
      final r = calc(
        [acc('Карта', AccountKind.debit, 100)],
        snap(
          flows: [
            flow(
              'ЗП',
              FlowKind.salary,
              1,
              const Monthly(1),
              starts: '2026-11-03',
            ),
          ],
        ),
      );
      expect(r.warnings.whereType<SalaryOverdue>(), isEmpty);
      expect(r.horizon, d('2026-12-01'));
    });

    test('advance overdue, salary marked: still a period, not a jump', () {
      final r = calc(
        [acc('Карта', AccountKind.debit, 100)],
        snap(
          flows: [
            flow('Аванс', FlowKind.salary, 1, const Monthly(2)),
            flow('ЗП', FlowKind.salary, 1, const Monthly(20)),
          ],
          done: {('ЗП', d('2026-10-20'))},
        ),
      );
      expect(r.horizonKind, HorizonKind.period);
      expect(r.warnings.whereType<SalaryOverdue>().single.name, 'Аванс');
    });

    test('periods: 7 / 30 days and a date', () {
      final a = [acc('Карта', AccountKind.debit, 3000)];
      expect(calc(a, snap(), period: const PeriodDays(7)).daysLeft, 7);
      expect(
        calc(a, snap(), period: const PeriodDays(30)).horizon,
        d('2026-12-04'),
      );
      final until = calc(a, snap(), period: PeriodUntil(d('2026-11-10')));
      expect((until.horizon, until.daysLeft), (d('2026-11-10'), 6));
      // A date in the past is never used: at least one day ahead.
      final past = calc(a, snap(), period: PeriodUntil(d('2026-11-01')));
      expect(past.horizon, d('2026-11-05'));
    });
  });

  test('two overdue salaries → a warning for each, earliest first', () {
    final r = calc(
      [acc('Карта', AccountKind.debit, 100)],
      snap(
        flows: [
          flow('Аванс', FlowKind.salary, 1, const Monthly(2)),
          flow('ЗП', FlowKind.salary, 1, const Monthly(20)),
        ],
      ),
    );
    expect(r.warnings.whereType<SalaryOverdue>().map((w) => w.name), [
      'ЗП',
      'Аванс',
    ]);
  });

  group('position and scenarios (И9, И10)', () {
    test('card without bank figures: debt shown, nothing subtracted', () {
      // The owner's real case: 26 931,52 ₽ and Альфа 16 296,54 ₽ without figures.
      final r = computeSafeToSpend(
        accounts: [
          AccountSummary(
            id: 'sber',
            name: 'Сбер',
            kind: AccountKind.debit,
            amount: Money(2693152),
            isProtected: false,
            lastUpdatedAt: DateTime(2026, 11, 4),
          ),
          AccountSummary(
            id: 'alfa',
            name: 'Кредитка Альфа',
            kind: AccountKind.creditCard,
            amount: Money(1629654),
            isProtected: false,
            lastUpdatedAt: DateTime(2026, 11, 4),
          ),
        ],
        payments: snap(),
        reserve: Money(0),
        today: today,
      );
      expect(r.available, Money(2693152));
      expect(r.totalDebt, Money(1629654));
      expect(r.cards.single.basis, CardBasis.noFigures);
      expect(r.cards.single.deducted, Money(0));
      expect(r.unknownCards.single.accountId, 'alfa');
      expect(r.ifAllDebtsPaid, Money(2693152 - 1629654)); // 10 634,98
      expect(r.minimumOnlyAvailable, isNull);
      expectIdentities(r);
    });

    test('card with both figures: grace subtracted, minimum is a scenario', () {
      final r = calc(
        [
          acc('Карта', AccountKind.debit, 50000),
          acc('cc', AccountKind.creditCard, 20000),
        ],
        snap(
          cards: {
            'cc': CardFigures(
              id: 'f',
              accountId: 'cc',
              graceAmount: rub(15000),
              graceDueOn: d('2026-11-10'),
              minPayment: rub(900),
              minDueOn: d('2026-11-10'),
            ),
          },
        ),
        reserve: 5000,
      );
      final c = r.cards.single;
      expect((c.basis, c.deducted), (CardBasis.grace, rub(15000)));
      expect(
        (c.debt, c.graceAmount, c.minPayment),
        (rub(20000), rub(15000), rub(900)),
      );
      expect(r.available, rub(30000)); // 50 000 − 15 000 − 5 000
      expect(r.minimumOnlyAvailable, rub(30000 + 15000 - 900));
      // All debts: 30 000 + 15 000 (already towards the card) − 20 000.
      expect(r.ifAllDebtsPaid, rub(25000));
      expectIdentities(r);
    });

    test('minimum after the horizon: whole grace amount is the saving', () {
      final r = calc(
        [
          acc('Карта', AccountKind.debit, 50000),
          acc('cc', AccountKind.creditCard, 20000),
        ],
        snap(
          cards: {
            'cc': CardFigures(
              id: 'f',
              accountId: 'cc',
              graceAmount: rub(15000),
              graceDueOn: d('2026-11-10'),
              minPayment: rub(900),
              minDueOn: d('2026-12-25'),
            ),
          },
        ),
      );
      expect(r.minimumOnlyAvailable, rub(50000));
    });

    test('only the minimum known: subtracted, no extra scenario', () {
      final r = calc(
        [
          acc('Карта', AccountKind.debit, 10000),
          acc('cc', AccountKind.creditCard, 20000),
        ],
        snap(
          cards: {
            'cc': CardFigures(
              id: 'f',
              accountId: 'cc',
              minPayment: rub(900),
              minDueOn: d('2026-11-10'),
            ),
          },
        ),
      );
      expect(r.cards.single.basis, CardBasis.minimumOnly);
      expect(r.minimumOnlyAvailable, isNull);
      expect(r.warnings.whereType<MinimumOnly>(), hasLength(1));
      expectIdentities(r);
    });

    test('loan with a linked payment and a planned card payment', () {
      final r = calc(
        [
          acc('Карта', AccountKind.debit, 100000),
          acc('loan', AccountKind.loan, 300000),
          acc('cc', AccountKind.creditCard, 4000),
        ],
        snap(
          flows: [
            flow(
              'Кредит',
              FlowKind.loanPayment,
              12000,
              const Monthly(10),
              account: 'loan',
            ),
            flow(
              'Кредитка',
              FlowKind.otherPayment,
              5000,
              const Monthly(12),
              account: 'cc',
            ),
            flow('Связь', FlowKind.communication, 500, const Monthly(6)),
          ],
        ),
      );
      // Card payment capped by its debt (4 000), loan payment not capped.
      expect(r.paymentsTotal, rub(12000 + 4000 + 500));
      expect(r.totalDebt, rub(304000));
      expect(r.cards.single.basis, CardBasis.plannedPayment);
      expect(r.unknownCards, isEmpty);
      // 83 500 + 16 000 towards debts − 304 000.
      expect(r.ifAllDebtsPaid, rub(83500 + 16000 - 304000));
      expectIdentities(r);
    });

    test('settled card and an overpaid card are not debt', () {
      final r = calc(
        [
          acc('Карта', AccountKind.debit, 1000),
          acc('cc', AccountKind.creditCard, 3000),
          acc('cc2', AccountKind.creditCard, -200), // overpaid
        ],
        snap(
          cards: {
            'cc': CardFigures(
              id: 'f',
              accountId: 'cc',
              graceAmount: rub(3000),
              graceDueOn: d('2026-11-08'),
              settled: true,
            ),
          },
        ),
      );
      expect(r.totalDebt, rub(3000));
      expect(r.cards.map((c) => c.basis), [
        CardBasis.settled,
        CardBasis.noDebt,
      ]);
      expectIdentities(r);
    });

    test('limit is never money and is not in the position (И8)', () {
      final r = calc([
        acc('Карта', AccountKind.debit, 1000),
        AccountSummary(
          id: 'cc',
          name: 'cc',
          kind: AccountKind.creditCard,
          amount: rub(0),
          isProtected: false,
          creditLimit: rub(100000),
          lastUpdatedAt: DateTime(2026, 11, 4),
        ),
      ], snap());
      expect(r.money, rub(1000));
      expect(r.ifAllDebtsPaid, rub(1000));
    });
  });
}
