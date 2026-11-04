import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:denezhno/features/payments/payments.dart';

/// R2-era test data describes salary as planned flows with «done» marks.
/// Since R3 Э3 the forecast reads salary from the income model; this turns
/// those flows into payments (tracked from the plan's start, no holiday
/// rule: exactly the dates the R2 tests expect) so the expectations stay.
List<IncomePayment> salaryPayments(PaymentsSnapshot s, CalendarDate today) => [
  for (final f in s.flows.where((f) => f.kind == FlowKind.salary))
    for (final d in occurrences(f, f.startsOn, today.addDays(62)))
      IncomePayment(
        key: PaymentKey(sourceId: f.id!, partId: f.id, plannedOn: d),
        sourceName: f.name,
        kind: IncomeKind.salary,
        label: f.name,
        scheduledOn: d,
        plannedAmount: f.amount,
        state: s.doneMarks.contains((f.id!, d))
            ? PaymentState.legacyMark
            : PaymentState.open,
      ),
];

SafeToSpend computeWithSalary({
  required List<AccountSummary> accounts,
  required PaymentsSnapshot payments,
  required Money reserve,
  required CalendarDate today,
  Money? goalsThisPeriod,
  ForecastPeriod period = defaultForecastPeriod,
}) => computeSafeToSpend(
  accounts: accounts,
  payments: payments,
  reserve: reserve,
  today: today,
  goalsThisPeriod: goalsThisPeriod,
  period: period,
  incomes: salaryPayments(payments, today),
);
