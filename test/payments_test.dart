import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarDate d(String s) => CalendarDate.parse(s);
PlannedFlow flow(Cadence c, {String start = '2026-01-01', FlowKind? kind}) =>
    PlannedFlow(
      id: 'f',
      kind: kind ?? FlowKind.subscription,
      name: 'X',
      amount: Money(100),
      cadence: c,
      startsOn: d(start),
    );

void main() {
  test('calendar date basics', () {
    expect(d('2026-02-28').addDays(1), d('2026-03-01'));
    expect(d('2028-02-28').addDays(1), d('2028-02-29'));
    expect(d('2026-12-31').addDays(1), d('2027-01-01'));
    expect(d('2026-11-02').weekday, 1);
    expect(d('2026-11-01').daysUntil(d('2026-11-25')), 24);
    expect(() => CalendarDate(2026, 2, 29), throwsArgumentError);
    expect(() => CalendarDate.parse('2026-1-1'), throwsFormatException);
    expect(d('2026-03-05').iso, '2026-03-05');
  });

  test('monthly on the 31st clamps to the month end', () {
    expect(
      occurrences(flow(const Monthly(31)), d('2026-01-01'), d('2026-04-30')),
      [d('2026-01-31'), d('2026-02-28'), d('2026-03-31'), d('2026-04-30')],
    );
    expect(
      occurrences(flow(const Monthly(30)), d('2028-02-01'), d('2028-02-29')),
      [d('2028-02-29')],
    );
  });

  test('monthly respects the window and the start date', () {
    expect(
      occurrences(
        flow(const Monthly(10), start: '2026-11-15'),
        d('2026-11-01'),
        d('2027-01-31'),
      ),
      [d('2026-12-10'), d('2027-01-10')],
    );
    expect(
      occurrences(flow(const Monthly(5)), d('2026-11-06'), d('2026-11-30')),
      isEmpty,
    );
  });

  test('weekly, yearly (29 Feb) and once', () {
    expect(
      occurrences(flow(const Weekly(5)), d('2026-11-02'), d('2026-11-20')),
      [d('2026-11-06'), d('2026-11-13'), d('2026-11-20')],
    );
    expect(
      occurrences(flow(const Yearly(2, 29)), d('2026-01-01'), d('2028-12-31')),
      [d('2026-02-28'), d('2027-02-28'), d('2028-02-29')],
    );
    expect(
      occurrences(
        flow(Once(d('2026-11-20'))),
        d('2026-11-01'),
        d('2026-11-30'),
      ),
      [d('2026-11-20')],
    );
    expect(
      occurrences(
        flow(Once(d('2026-12-20'))),
        d('2026-11-01'),
        d('2026-11-30'),
      ),
      isEmpty,
    );
  });

  test('upcoming merges plans and card figures, sorted, with marks', () {
    final salary = PlannedFlow(
      id: 's',
      kind: FlowKind.salary,
      name: 'Зарплата',
      amount: Money(8000000),
      cadence: const Monthly(10),
      startsOn: d('2026-01-01'),
    );
    final net = PlannedFlow(
      id: 'n',
      kind: FlowKind.communication,
      name: 'Интернет',
      amount: Money(70000),
      cadence: const Monthly(3),
      startsOn: d('2026-01-01'),
    );
    final items = upcoming(
      flows: [salary, net],
      doneMarks: {('n', d('2026-12-03'))},
      cardFigures: {
        'c1': CardFigures(
          id: 'cf1',
          accountId: 'c1',
          graceAmount: Money(840000),
          graceDueOn: d('2026-11-25'),
          minPayment: Money(30000),
          minDueOn: d('2026-11-25'),
        ),
        'c2': CardFigures(
          id: 'cf2',
          accountId: 'c2',
          minPayment: Money(50000),
          minDueOn: d('2026-11-20'),
        ),
      },
      cardNames: {'c1': 'Сбер', 'c2': 'Альфа'},
      from: d('2026-11-04'),
      to: d('2026-12-04'),
    );
    expect(
      [for (final i in items) '${i.dueOn} ${i.title}'],
      [
        '2026-11-10 Зарплата',
        '2026-11-20 Альфа',
        '2026-11-25 Сбер',
        '2026-12-03 Интернет',
      ],
    );
    expect(items[0].direction, FlowDirection.inflow);
    expect(items[1].isMinimumOnly, true);
    expect(items[1].amount, Money(50000));
    expect(items[2].amount, Money(840000)); // grace amount, not minimum
    expect(items[3].done, true);
  });
}
