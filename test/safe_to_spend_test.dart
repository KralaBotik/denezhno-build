import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/legacy_salary.dart';

CalendarDate d(String s) => CalendarDate.parse(s);
final today = d('2026-11-04');
final fresh = DateTime(2026, 11, 4, 9);
Money rub(int rubles) => Money(rubles * 100);

AccountSummary acc(
  String id,
  AccountKind kind,
  int rubles, {
  bool protected = false,
  DateTime? updated,
}) => AccountSummary(
  id: id,
  name: id,
  kind: kind,
  amount: rub(rubles),
  isProtected: protected,
  lastUpdatedAt: updated ?? fresh,
);

PlannedFlow flow(String id, FlowKind kind, int rubles, Cadence c) =>
    PlannedFlow(
      id: id,
      kind: kind,
      name: id,
      amount: rub(rubles),
      cadence: c,
      // Salary plans in these R2 examples are set up this month, so earlier
      // months are not «not received» (overdue salary: position_test.dart).
      startsOn: kind == FlowKind.salary ? d('2026-11-01') : d('2026-01-01'),
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

void main() {
  test('reference example: salary on the 10th, payments, card, reserve', () {
    final r = computeWithSalary(
      accounts: [
        acc('Т-Банк', AccountKind.debit, 46800),
        acc('Наличные', AccountKind.cash, 3000),
        acc('Подушка', AccountKind.savings, 300000, protected: true),
        acc('Сбер кредитка', AccountKind.creditCard, 8400),
      ],
      payments: snap(
        flows: [
          flow('Зарплата', FlowKind.salary, 80000, const Monthly(10)),
          flow('Интернет', FlowKind.communication, 700, const Monthly(5)),
          flow('Аренда', FlowKind.rent, 25000, const Monthly(15)), // after
        ],
        cards: {
          'Сбер кредитка': CardFigures(
            id: 'cf',
            accountId: 'Сбер кредитка',
            graceAmount: rub(8400),
            graceDueOn: d('2026-11-08'),
            minPayment: rub(300),
            minDueOn: d('2026-11-08'),
          ),
        },
      ),
      reserve: rub(10000),
      today: today,
    );
    expect(r.horizon, d('2026-11-10'));
    expect(r.horizonKind, HorizonKind.salary);
    expect(r.daysLeft, 6);
    expect(r.money, rub(49800)); // savings «не трогать» excluded
    expect(r.payments.map((p) => p.title), ['Интернет']);
    expect(r.cardPayments.single.amount, rub(8400)); // grace, not minimum
    // 49 800 − 700 − 8 400 − 0 − 10 000 = 30 700; per day 30 700 / 6 = 5 116
    expect(r.available, rub(30700));
    expect(r.perDay, rub(5116));
    expect(r.warnings, isEmpty);
    expect(r.veryStale, false);
  });

  test('salary already received → horizon moves to the next one', () {
    final r = computeWithSalary(
      accounts: [acc('Карта', AccountKind.debit, 10000)],
      payments: snap(
        flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(4))],
        done: {('ЗП', d('2026-11-04'))},
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.horizon, d('2026-12-04'));
    expect(r.daysLeft, 30);
  });

  test('salary today and not received → one day, today counts', () {
    final r = computeWithSalary(
      accounts: [acc('Карта', AccountKind.debit, 1000)],
      payments: snap(
        flows: [
          flow('ЗП', FlowKind.salary, 1, const Monthly(4)),
          flow('Связь', FlowKind.communication, 400, const Monthly(4)),
        ],
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.daysLeft, 1);
    expect(r.available, rub(600));
    expect(r.perDay, rub(600));
  });

  test('no salary → 14 days by default (owner decision), with a warning', () {
    final r = computeWithSalary(
      accounts: [acc('Карта', AccountKind.debit, 2800)],
      payments: snap(),
      reserve: rub(0),
      today: today,
    );
    expect(r.horizon, d('2026-11-18'));
    expect(r.horizonKind, HorizonKind.period);
    expect(r.daysLeft, 14);
    expect(r.perDay, rub(200));
    expect(r.warnings.whereType<NoSalary>(), hasLength(1));
  });

  test('short of money: negative available, zero per day', () {
    final r = computeWithSalary(
      accounts: [acc('Карта', AccountKind.debit, 5000)],
      payments: snap(
        flows: [
          flow('ЗП', FlowKind.salary, 1, const Monthly(20)),
          flow('Кредит', FlowKind.loanPayment, 12000, const Monthly(15)),
        ],
      ),
      reserve: rub(10000),
      today: today,
    );
    expect(r.available, rub(-17000));
    expect(r.perDay, Money(0));
  });

  test('paid items, expected income and credit limit never count', () {
    final r = computeWithSalary(
      accounts: [
        acc('Карта', AccountKind.debit, 20000),
        acc('Кредитка', AccountKind.creditCard, 0),
      ],
      payments: snap(
        flows: [
          flow('ЗП', FlowKind.salary, 80000, const Monthly(20)),
          flow('Подработка', FlowKind.otherIncome, 15000, const Monthly(10)),
          flow('Свет', FlowKind.utilities, 3000, const Monthly(10)),
        ],
        done: {('Свет', d('2026-11-10'))},
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.payments, isEmpty);
    expect(r.available, rub(20000)); // +15 000 not counted before it arrives
  });

  test('card: minimum-only warning, missing figures warning, settled', () {
    final r = computeWithSalary(
      accounts: [
        acc('Карта', AccountKind.debit, 50000),
        acc('Альфа', AccountKind.creditCard, 20000),
        acc('ВТБ', AccountKind.creditCard, 5000),
        acc('Сбер', AccountKind.creditCard, 7000),
      ],
      payments: snap(
        flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(25))],
        cards: {
          'Альфа': CardFigures(
            id: 'a',
            accountId: 'Альфа',
            minPayment: rub(1000),
            minDueOn: d('2026-11-20'),
          ),
          'Сбер': CardFigures(
            id: 's',
            accountId: 'Сбер',
            graceAmount: rub(7000),
            graceDueOn: d('2026-11-15'),
            settled: true,
          ),
        },
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.cardPayments.single.amount, rub(1000));
    expect(r.warnings.whereType<MinimumOnly>().single.name, 'Альфа');
    expect(r.warnings.whereType<CardWithoutFigures>().single.name, 'ВТБ');
    expect(r.available, rub(49000));
  });

  test('card due after the salary is not subtracted now', () {
    final r = computeWithSalary(
      accounts: [
        acc('Карта', AccountKind.debit, 10000),
        acc('Сбер', AccountKind.creditCard, 7000),
      ],
      payments: snap(
        flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(10))],
        cards: {
          'Сбер': CardFigures(
            id: 's',
            accountId: 'Сбер',
            graceAmount: rub(7000),
            graceDueOn: d('2026-11-25'),
          ),
        },
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.cardPayments, isEmpty);
    expect(r.available, rub(10000));
  });

  test('weekly payments repeat inside the horizon; goals are subtracted', () {
    final r = computeWithSalary(
      accounts: [acc('Карта', AccountKind.debit, 30000)],
      payments: snap(
        flows: [
          flow('ЗП', FlowKind.salary, 1, const Monthly(25)),
          flow('Секция', FlowKind.otherPayment, 1500, const Weekly(6)),
        ],
      ),
      reserve: rub(5000),
      today: today,
      goalsThisPeriod: rub(10000),
    );
    // Saturdays 7, 14, 21 November.
    expect(r.payments, hasLength(3));
    expect(r.available, rub(30000 - 4500 - 10000 - 5000));
  });

  test('freshness: stale after 3 days, very stale after 7', () {
    PaymentsSnapshot s() =>
        snap(flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(25))]);
    final ok = computeWithSalary(
      accounts: [
        acc('A', AccountKind.debit, 1, updated: DateTime(2026, 11, 1, 12)),
      ],
      payments: s(),
      reserve: rub(0),
      today: today,
    );
    expect(ok.warnings, isEmpty);
    final stale = computeWithSalary(
      accounts: [
        acc('A', AccountKind.debit, 1, updated: DateTime(2026, 10, 30, 12)),
      ],
      payments: s(),
      reserve: rub(0),
      today: today,
    );
    expect(
      stale.warnings.whereType<StaleBalances>().single.oldest,
      d('2026-10-30'),
    );
    expect(stale.veryStale, false);
    final veryStale = computeWithSalary(
      accounts: [
        acc('A', AccountKind.debit, 1, updated: DateTime(2026, 10, 20, 12)),
      ],
      payments: s(),
      reserve: rub(0),
      today: today,
    );
    expect(veryStale.veryStale, true);
  });

  test('no accounts → explicit warning, zero', () {
    final r = computeWithSalary(
      accounts: const [],
      payments: snap(),
      reserve: rub(10000),
      today: today,
    );
    expect(r.warnings.whereType<NoAccounts>(), hasLength(1));
    expect(r.available, rub(-10000));
  });

  test('per day rounds down to whole rubles, exact with kopecks', () {
    final r = computeWithSalary(
      accounts: [
        AccountSummary(
          id: 'A',
          name: 'A',
          kind: AccountKind.debit,
          amount: Money(1000099), // 10 000,99 ₽
          isProtected: false,
          lastUpdatedAt: fresh,
        ),
      ],
      payments: snap(flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(7))]),
      reserve: rub(0),
      today: today,
    );
    expect(r.daysLeft, 3);
    expect(r.available, Money(1000099));
    expect(r.perDay, rub(3333)); // 3 333,66 → 3 333
  });

  group('no double counting of credit payments', () {
    PlannedFlow linked(String id, int rubles, Cadence c, String account) =>
        PlannedFlow(
          id: id,
          kind: FlowKind.loanPayment,
          name: id,
          amount: rub(rubles),
          cadence: c,
          startsOn: d('2026-01-01'),
          accountId: account,
        );
    final salary = flow('ЗП', FlowKind.salary, 1, const Monthly(25));

    test('plan linked to a card with bank figures is not subtracted again', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 50000),
          acc('Сбер', AccountKind.creditCard, 8400),
        ],
        payments: snap(
          flows: [
            salary,
            linked('Платёж Сбер', 8400, const Monthly(15), 'Сбер'),
          ],
          cards: {
            'Сбер': CardFigures(
              id: 's',
              accountId: 'Сбер',
              graceAmount: rub(8400),
              graceDueOn: d('2026-11-15'),
            ),
          },
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.payments, isEmpty);
      expect(r.cardPayments.single.amount, rub(8400));
      expect(r.skippedAsDuplicates.single.title, 'Платёж Сбер');
      expect(r.available, rub(50000 - 8400)); // once, not twice
    });

    test('card payment is capped by the current debt (already repaid)', () {
      // The person paid 8 000 of 8 400 and updated balances: debt is 400 now.
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 42000),
          acc('Сбер', AccountKind.creditCard, 400),
        ],
        payments: snap(
          flows: [salary],
          cards: {
            'Сбер': CardFigures(
              id: 's',
              accountId: 'Сбер',
              graceAmount: rub(8400),
              graceDueOn: d('2026-11-15'),
            ),
          },
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.cardPayments.single.amount, rub(400));
      expect(r.available, rub(41600));
    });

    test('fully repaid card (debt 0) subtracts nothing', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 42000),
          acc('Сбер', AccountKind.creditCard, 0),
        ],
        payments: snap(
          flows: [salary],
          cards: {
            'Сбер': CardFigures(
              id: 's',
              accountId: 'Сбер',
              graceAmount: rub(8400),
              graceDueOn: d('2026-11-15'),
            ),
          },
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.cardPayments, isEmpty);
      expect(r.available, rub(42000));
    });

    test('loan payments are not trimmed to the principal (interest)', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 50000),
          acc('Кредит', AccountKind.loan, 15000),
        ],
        payments: snap(
          flows: [salary, linked('Кредит', 10000, const Weekly(5), 'Кредит')],
        ),
        reserve: rub(0),
        today: today,
      );
      // Fridays 6, 13, 20 Nov. Principal 15 000 is covered after two full
      // payments (they also contain interest); the third is not counted.
      expect(r.paymentsTotal, rub(20000));
      expect(r.available, rub(30000));
    });

    test('card with a linked plan but no figures: plan counts, no warning', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 50000),
          acc('ВТБ', AccountKind.creditCard, 5000),
        ],
        payments: snap(
          flows: [salary, linked('ВТБ платёж', 3000, const Monthly(12), 'ВТБ')],
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.paymentsTotal, rub(3000));
      expect(r.warnings.whereType<CardWithoutFigures>(), isEmpty);
    });

    test('unlinked loan payment next to card figures is flagged', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 50000),
          acc('Сбер', AccountKind.creditCard, 8400),
        ],
        payments: snap(
          flows: [
            salary,
            flow('Кредитка', FlowKind.loanPayment, 8400, const Monthly(15)),
          ],
          cards: {
            'Сбер': CardFigures(
              id: 's',
              accountId: 'Сбер',
              graceAmount: rub(8400),
              graceDueOn: d('2026-11-15'),
            ),
          },
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.warnings.whereType<PossibleDuplicate>().single.name, 'Кредитка');
    });
  });

  test('accounts excluded from the calculation are not counted', () {
    final r = computeWithSalary(
      accounts: [
        acc('Карта', AccountKind.debit, 20000),
        acc('Общая с женой', AccountKind.debit, 50000, protected: true),
      ],
      payments: snap(
        flows: [flow('ЗП', FlowKind.salary, 1, const Monthly(25))],
      ),
      reserve: rub(0),
      today: today,
    );
    expect(r.money, rub(20000));
  });

  group('more credit scenarios', () {
    final salary = flow('ЗП', FlowKind.salary, 1, const Monthly(25));
    PlannedFlow linked(String id, int rubles, Cadence c, String account) =>
        PlannedFlow(
          id: id,
          kind: FlowKind.loanPayment,
          name: id,
          amount: rub(rubles),
          cadence: c,
          startsOn: d('2026-01-01'),
          accountId: account,
        );
    CardFigures grace(String card, int rubles, String due, {int? min}) =>
        CardFigures(
          id: card,
          accountId: card,
          graceAmount: rub(rubles),
          graceDueOn: d(due),
          minPayment: min == null ? null : rub(min),
          minDueOn: min == null ? null : d(due),
        );

    test('interest and fees charged after the statement: bank figure wins', () {
      // Debt grew to 9 100 (fee 300 + interest 400), the bank asks 8 400 to
      // keep the grace period: 8 400 is what must be paid by the date.
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 30000),
          acc('Сбер', AccountKind.creditCard, 9100),
        ],
        payments: snap(
          flows: [salary],
          cards: {'Сбер': grace('Сбер', 8400, '2026-11-15')},
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.cardPayments.single.amount, rub(8400));
      expect(r.available, rub(21600));
    });

    test('grace lost: only the minimum is known → minimum + warning', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 30000),
          acc('Альфа', AccountKind.creditCard, 52000),
        ],
        payments: snap(
          flows: [salary],
          cards: {
            'Альфа': CardFigures(
              id: 'a',
              accountId: 'Альфа',
              minPayment: rub(2600),
              minDueOn: d('2026-11-20'),
            ),
          },
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.cardPayments.single.amount, rub(2600));
      expect(r.warnings.whereType<MinimumOnly>(), hasLength(1));
    });

    test('several obligations at once, each counted once', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 100000),
          acc('Сбер', AccountKind.creditCard, 8400),
          acc('Т', AccountKind.creditCard, 12000),
          acc('Ипотека', AccountKind.loan, 3000000),
        ],
        payments: snap(
          flows: [
            salary,
            linked('Платёж Сбер', 8400, const Monthly(15), 'Сбер'), // dup
            linked('Ипотека', 38500, const Monthly(20), 'Ипотека'),
            flow('Интернет', FlowKind.communication, 700, const Monthly(5)),
          ],
          cards: {
            'Сбер': grace('Сбер', 8400, '2026-11-15'),
            'Т': grace('Т', 12000, '2026-11-18', min: 600),
          },
        ),
        reserve: rub(10000),
        today: today,
      );
      expect(r.paymentsTotal, rub(38500 + 700));
      expect(r.cardPaymentsTotal, rub(8400 + 12000));
      expect(r.skippedAsDuplicates.single.title, 'Платёж Сбер');
      expect(r.available, rub(100000 - 39200 - 20400 - 10000));
    });

    test('partial repayment entered as a new debt: only the rest is due', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 25000),
          acc('Т', AccountKind.creditCard, 5000), // paid 7 000 of 12 000
        ],
        payments: snap(
          flows: [salary],
          cards: {'Т': grace('Т', 12000, '2026-11-18')},
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.cardPayments.single.amount, rub(5000));
      expect(r.skippedAsDuplicates.single.amount, rub(7000));
      expect(r.available, rub(20000));
    });

    test(
      'partial repayment NOT yet reflected in balances: full figure counts',
      () {
        // Conservative: until the debt is updated the app cannot know.
        final r = computeWithSalary(
          accounts: [
            acc('Карта', AccountKind.debit, 18000),
            acc('Т', AccountKind.creditCard, 12000),
          ],
          payments: snap(
            flows: [salary],
            cards: {'Т': grace('Т', 12000, '2026-11-18')},
          ),
          reserve: rub(0),
          today: today,
        );
        expect(r.available, rub(6000));
      },
    );

    test('stale bank data: due date passed and not marked paid', () {
      final r = computeWithSalary(
        accounts: [
          acc('Карта', AccountKind.debit, 30000),
          acc('Сбер', AccountKind.creditCard, 8400),
        ],
        payments: snap(
          flows: [salary],
          cards: {'Сбер': grace('Сбер', 8400, '2026-10-25')},
        ),
        reserve: rub(0),
        today: today,
      );
      // Still owed (or already paid but not marked): counted, with a warning.
      expect(r.cardPayments.single.amount, rub(8400));
      final w = r.warnings.whereType<OverdueCardFigures>().single;
      expect((w.name, w.dueOn), ('Сбер', d('2026-10-25')));
    });

    test('stale balances and stale card figures together', () {
      final r = computeWithSalary(
        accounts: [
          acc(
            'Карта',
            AccountKind.debit,
            30000,
            updated: DateTime(2026, 10, 20),
          ),
          acc(
            'Сбер',
            AccountKind.creditCard,
            8400,
            updated: DateTime(2026, 10, 20),
          ),
        ],
        payments: snap(
          flows: [salary],
          cards: {'Сбер': grace('Сбер', 8400, '2026-10-25')},
        ),
        reserve: rub(0),
        today: today,
      );
      expect(r.veryStale, true);
      expect(r.warnings.whereType<StaleBalances>(), hasLength(1));
      expect(r.warnings.whereType<OverdueCardFigures>(), hasLength(1));
    });
  });
}
