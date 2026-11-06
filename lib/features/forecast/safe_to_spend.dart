import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../accounts/accounts.dart';
import '../income/income.dart';
import '../payments/payments.dart';

/// Why the horizon ends where it does: the next expected salary, or a period
/// chosen by the person when the salary date is unknown (none set, or the
/// last one has not arrived). A period is never presented as «до зарплаты».
enum HorizonKind { salary, period }

/// The period used when the next salary date is unknown.
sealed class ForecastPeriod {
  const ForecastPeriod();
}

/// [days] days from today (7, 14, 30).
final class PeriodDays extends ForecastPeriod {
  const PeriodDays(this.days) : assert(days > 0);
  final int days;
  @override
  bool operator ==(Object other) => other is PeriodDays && other.days == days;
  @override
  int get hashCode => days.hashCode;
}

/// Up to and including [date].
final class PeriodUntil extends ForecastPeriod {
  const PeriodUntil(this.date);
  final CalendarDate date;
  @override
  bool operator ==(Object other) => other is PeriodUntil && other.date == date;
  @override
  int get hashCode => date.hashCode;
}

/// Owner decision (R3 plan): 14 days when the salary date is unknown.
const defaultForecastPeriod = PeriodDays(14);

/// Something the person should know: the number is less certain than it
/// looks. Shown next to the figure, never hidden.
sealed class SpendWarning {
  const SpendWarning();
}

final class NoAccounts extends SpendWarning {
  const NoAccounts();
}

final class NoSalary extends SpendWarning {
  const NoSalary();
}

/// A salary payment's date has passed and it has not been received (in
/// full). It is not counted as received and the forecast does not jump to the
/// next salary; it runs for the chosen period instead. It stays until the
/// person resolves it, however long ago it was.
final class SalaryOverdue extends SpendWarning {
  const SalaryOverdue(this.payment);
  final IncomePayment payment;
  String get name => payment.label;
  CalendarDate get dueOn => payment.dueOn!;
}

/// A salary payment is delayed with no known date: the forecast runs for the
/// chosen period, labelled as such.
final class SalaryDateUnknown extends SpendWarning {
  const SalaryDateUnknown(this.payment);
  final IncomePayment payment;
}

/// The next salary payment was moved later than its schedule. The forecast
/// runs to the new date; [perDayIfOnTime] is what it would have been.
final class SalaryDelayed extends SpendWarning {
  const SalaryDelayed(this.payment, this.perDayIfOnTime);
  final IncomePayment payment;
  final Money? perDayIfOnTime;
}

/// Part of a salary payment came; the rest is still expected (not counted).
final class SalaryPartial extends SpendWarning {
  const SalaryPartial(this.payment);
  final IncomePayment payment;
}

/// A credit card with a debt but no figures from the bank.
final class CardWithoutFigures extends SpendWarning {
  const CardWithoutFigures(this.name, [this.accountId]);
  final String name;
  final String? accountId;
}

/// Only the minimum payment is known: paying it keeps interest running.
final class MinimumOnly extends SpendWarning {
  const MinimumOnly(this.name, [this.accountId]);
  final String name;
  final String? accountId;
}

/// The bank's due date for a card has passed and the payment is not marked
/// as made: the figures are probably outdated (a new statement exists).
final class OverdueCardFigures extends SpendWarning {
  const OverdueCardFigures(this.name, this.dueOn, [this.accountId]);
  final String name;
  final CalendarDate dueOn;
  final String? accountId;
}

/// A date of a recurring payment has passed and it is neither paid (by an
/// operation) nor skipped: it stays in «обязательно» until resolved.
final class PaymentOverdue extends SpendWarning {
  const PaymentOverdue(this.name, this.dueOn, this.flowId);
  final String name;
  final CalendarDate dueOn;
  final String flowId;
}

/// Balances older than [staleAfterDays].
final class StaleBalances extends SpendWarning {
  const StaleBalances(this.oldest);
  final CalendarDate oldest;
}

/// A loan/credit payment not linked to any card or loan while some cards have
/// bank figures: it may be the same money counted twice.
final class PossibleDuplicate extends SpendWarning {
  const PossibleDuplicate(this.name);
  final String name;
}

/// One subtracted obligation, for the transparent breakdown.
final class Deduction {
  const Deduction(this.title, this.amount, this.dueOn, [this.accountId]);
  final String title;
  final Money amount;
  final CalendarDate dueOn;

  /// The credit card or loan this payment repays, if any.
  final String? accountId;
}

/// Why a credit card is (or is not) part of «обязательно до …».
enum CardBasis {
  /// The bank's «без процентов» amount is due before the horizon: subtracted.
  grace,

  /// Only the minimum payment is known and due: subtracted, with a note.
  minimumOnly,

  /// No bank figures: nothing is subtracted, the payment is unknown.
  noFigures,

  /// No bank figures, but a planned payment linked to the card is counted.
  plannedPayment,

  /// The bank's due date is after the horizon.
  dueAfterHorizon,

  /// Marked as paid.
  settled,

  /// No debt on the card.
  noDebt,
}

/// One credit card in the position: the debt, the two bank figures and what
/// was subtracted. The three amounts are never mixed.
final class CardPosition {
  const CardPosition({
    required this.accountId,
    required this.name,
    required this.debt,
    required this.basis,
    required this.deducted,
    this.graceAmount,
    this.graceDueOn,
    this.minPayment,
    this.minDueOn,
  });
  final String accountId;
  final String name;

  /// Current debt (positive = owed).
  final Money debt;
  final Money? graceAmount;
  final CalendarDate? graceDueOn;
  final Money? minPayment;
  final CalendarDate? minDueOn;
  final CardBasis basis;

  /// Subtracted from «можно потратить» for this card.
  final Money deducted;
}

/// «Можно потратить до …» with every term that produced it.
///
/// available = spendable money − payments before the horizon
///             − credit-card payments before the horizon − goals − reserve
final class SafeToSpend {
  const SafeToSpend({
    required this.horizon,
    required this.horizonKind,
    required this.daysLeft,
    required this.money,
    required this.payments,
    required this.cardPayments,
    required this.goals,
    required this.reserve,
    required this.available,
    required this.perDay,
    required this.warnings,
    required this.veryStale,
    required this.totalDebt,
    required this.cards,
    required this.ifAllDebtsPaid,
    this.minimumOnlyAvailable,
    this.skippedAsDuplicates = const [],
  });
  final CalendarDate horizon;
  final HorizonKind horizonKind;

  /// Days from today until the horizon (at least 1).
  final int daysLeft;

  /// Debit cards, cash and savings not marked «не трогать».
  final Money money;
  final List<Deduction> payments;
  final List<Deduction> cardPayments;
  final Money goals;
  final Money reserve;

  /// Negative means «не хватает».
  final Money available;

  /// available / daysLeft, rounded down to whole rubles; zero if short.
  final Money perDay;
  final List<SpendWarning> warnings;

  /// Payments not subtracted because the same money is already counted
  /// (bank figures of the linked card, or nothing left to repay).
  final List<Deduction> skippedAsDuplicates;

  /// Balances are so old that the figure must be shown as unreliable.
  final bool veryStale;

  /// All known debt: credit cards and loans (positive = owed).
  final Money totalDebt;

  /// Every credit card: debt, bank figures, what was subtracted.
  final List<CardPosition> cards;

  /// Information only, never a safe amount: what would be left for the
  /// period if every known debt were repaid now (instead of the scheduled
  /// payments towards it). Negative = not enough.
  final Money ifAllDebtsPaid;

  /// Information only: «можно потратить» if credit cards were paid only the
  /// minimum before the horizon (interest will be charged). Null when no card
  /// has both a «без процентов» amount and a minimum payment.
  final Money? minimumOnlyAvailable;

  /// Payments and credit-card amounts due before the horizon.
  Money get obligationsTotal => paymentsTotal + cardPaymentsTotal;

  /// Cards with a debt whose payment is unknown (no bank figures, no plan).
  Iterable<CardPosition> get unknownCards =>
      cards.where((c) => c.basis == CardBasis.noFigures);

  Money get paymentsTotal =>
      payments.fold(Money(0), (sum, d) => sum + d.amount);
  Money get cardPaymentsTotal =>
      cardPayments.fold(Money(0), (sum, d) => sum + d.amount);
}

const staleAfterDays = 3;
const veryStaleAfterDays = 7;

/// Deterministic, exact (integer kopecks). Conservative by design:
/// expected income is not counted until it arrives; the credit limit is never
/// money; for a card the bank's grace amount is used, or the minimum when it
/// is the only figure (with a warning); unknown figures are reported, not
/// treated as zero silently.
SafeToSpend computeSafeToSpend({
  required List<AccountSummary> accounts,
  required PaymentsSnapshot payments,
  required Money reserve,
  required CalendarDate today,
  Money? goalsThisPeriod,
  ForecastPeriod period = defaultForecastPeriod,
  List<IncomePayment> incomes = const [],
  CalendarDate? horizonOverride,
}) {
  final warnings = <SpendWarning>[];

  // 1. Horizon: the next salary payment (salary or advance) still expected
  // — unless one is overdue or has no known date: then the chosen period is
  // used, labelled as a period (never a silent jump to the next salary,
  // never counted as received). Expected money is never added (И7).
  final waiting = incomes
      .where(
        (p) =>
            p.kind == IncomeKind.salary &&
            p.isOpen &&
            p.remaining.minorUnits > 0,
      )
      .toList();
  final overdue = waiting.where((p) => p.isOverdue(today)).toList()
    ..sort((a, b) => a.dueOn!.compareTo(b.dueOn!));
  final unknown = waiting.where((p) => p.dateUnknown).toList();
  IncomePayment? next;
  for (final p in waiting) {
    final due = p.dueOn;
    if (due == null || due < today) continue;
    if (next == null || due < next.dueOn!) next = p;
  }
  final CalendarDate horizon;
  final HorizonKind kind;
  if (horizonOverride != null) {
    horizon = horizonOverride;
    kind = HorizonKind.salary;
  } else if (next != null && overdue.isEmpty && unknown.isEmpty) {
    horizon = next.dueOn!;
    kind = HorizonKind.salary;
  } else {
    horizon = switch (period) {
      PeriodDays(:final days) => today.addDays(days),
      PeriodUntil(:final date) => date > today ? date : today.addDays(1),
    };
    kind = HorizonKind.period;
    if (overdue.isEmpty && unknown.isEmpty) {
      warnings.add(const NoSalary());
    } else {
      warnings
        ..addAll(overdue.map(SalaryOverdue.new))
        ..addAll(unknown.map(SalaryDateUnknown.new));
    }
  }
  for (final p in waiting.where((p) => p.isPartial)) {
    warnings.add(SalaryPartial(p));
  }
  final daysLeft = today.daysUntil(horizon) < 1 ? 1 : today.daysUntil(horizon);

  // 2. Spendable money.
  final counted = accounts
      .where((a) => !a.kind.isLiability && !a.isProtected)
      .toList();
  if (accounts.isEmpty) warnings.add(const NoAccounts());
  final money = counted.fold(Money(0), (sum, a) => sum + a.amount);

  // Current debt per card/loan (user-facing, positive = owed), used so that
  // money already repaid (and reflected in balances) is not subtracted again.
  //  - Credit card: a payment is never larger than the current debt (the
  //    bank's figure already includes interest/fees charged so far).
  //  - Loan: the balance is usually the remaining principal, while a payment
  //    also contains interest, so payments are NOT trimmed to the balance;
  //    full payments are counted until the balance is covered (conservative).
  final remainingDebt = <String, Money>{
    for (final a in accounts.where((a) => a.kind.isLiability)) a.id: a.amount,
  };
  final isLoan = {
    for (final a in accounts.where((a) => a.kind == AccountKind.loan)) a.id,
  };
  final skipped = <Deduction>[];
  Money capped(String accountId, Money amount) {
    final left = remainingDebt[accountId] ?? Money(0);
    if (left.minorUnits <= 0) return Money(0);
    final take =
        isLoan.contains(accountId) || amount.minorUnits <= left.minorUnits
        ? amount
        : left;
    remainingDebt[accountId] = left - take;
    return take;
  }

  // 3. Planned payments: every date from the plan's tracking date up to and
  // including the horizon that is not paid by an operation or skipped. A
  // date that has passed stays an obligation («просрочен») until resolved;
  // each date is counted once (R3 risk Р1).
  final deductions = <Deduction>[];
  for (final f in payments.flows) {
    if (f.direction != FlowDirection.outflow) continue;
    final tracked = payments.trackedFrom[f.id] ?? today;
    for (final d in occurrences(
      f,
      tracked < today ? tracked : today,
      horizon,
    )) {
      if (payments.doneMarks.contains((f.id!, d))) continue;
      if (d < today) warnings.add(PaymentOverdue(f.name, d, f.id!));
      final linked = f.accountId;
      if (linked != null && remainingDebt.containsKey(linked)) {
        // The bank's figures for this card are the source of truth.
        if (payments.cardFigures.containsKey(linked)) {
          skipped.add(Deduction(f.name, f.amount, d));
          continue;
        }
        final take = capped(linked, f.amount);
        if (take.minorUnits < f.amount.minorUnits) {
          skipped.add(Deduction(f.name, f.amount - take, d, linked));
        }
        if (take.minorUnits > 0) {
          deductions.add(Deduction(f.name, take, d, linked));
        }
        continue;
      }
      deductions.add(Deduction(f.name, f.amount, d));
    }
  }
  deductions.sort((a, b) => a.dueOn.compareTo(b.dueOn));

  // 4. Credit cards: the bank's figures due up to the horizon, capped by the
  // current debt.
  final cards = <Deduction>[];
  final plannedFor = {
    for (final f in payments.flows)
      if (f.accountId != null && f.direction == FlowDirection.outflow)
        f.accountId!,
  };
  final positions = <CardPosition>[];
  var minimumSaving = Money(0);
  for (final card in accounts.where((a) => a.kind == AccountKind.creditCard)) {
    final f = payments.cardFigures[card.id];
    CardPosition position(CardBasis basis, [Money? deducted]) => CardPosition(
      accountId: card.id,
      name: card.name,
      debt: card.amount,
      basis: basis,
      deducted: deducted ?? Money(0),
      graceAmount: f?.graceAmount,
      graceDueOn: f?.graceDueOn,
      minPayment: f?.minPayment,
      minDueOn: f?.minDueOn,
    );
    if (f == null) {
      if (plannedFor.contains(card.id)) {
        positions.add(position(CardBasis.plannedPayment));
      } else if (card.amount.minorUnits > 0) {
        warnings.add(CardWithoutFigures(card.name, card.id));
        positions.add(position(CardBasis.noFigures));
      } else {
        positions.add(position(CardBasis.noDebt));
      }
      continue;
    }
    if (f.settled) {
      positions.add(position(CardBasis.settled));
      continue;
    }
    final (
      Money? figure,
      CalendarDate? on,
      bool minOnly,
    ) = f.graceAmount != null
        ? (f.graceAmount, f.graceDueOn, false)
        : (f.minPayment, f.minDueOn, true);
    // Already transferred to the card for these figures (operations).
    final paidToCard = f.paid ?? Money(0);
    final Money? due = figure == null
        ? null
        : (figure - paidToCard).minorUnits < 0
        ? Money(0)
        : figure - paidToCard;
    if (due != null && due.minorUnits == 0) {
      positions.add(position(CardBasis.settled));
      continue;
    }
    if (due == null || on == null || on > horizon) {
      positions.add(position(CardBasis.dueAfterHorizon));
      continue;
    }
    if (on < today) warnings.add(OverdueCardFigures(card.name, on, card.id));
    final debtBefore = remainingDebt[card.id] ?? Money(0);
    final take = capped(card.id, due);
    if (take.minorUnits < due.minorUnits) {
      skipped.add(Deduction(card.name, due - take, on, card.id));
    }
    if (take.minorUnits == 0) {
      positions.add(position(CardBasis.noDebt));
      continue;
    }
    cards.add(Deduction(card.name, take, on, card.id));
    positions.add(
      position(minOnly ? CardBasis.minimumOnly : CardBasis.grace, take),
    );
    if (minOnly) {
      warnings.add(MinimumOnly(card.name, card.id));
    } else if (f.minPayment case final min?) {
      // «Только минимум» scenario: the minimum due before the horizon (capped
      // by the debt) instead of the «без процентов» amount.
      final minLeft = (min - paidToCard).minorUnits < 0
          ? Money(0)
          : min - paidToCard;
      final minDue = f.minDueOn != null && f.minDueOn! <= horizon
          ? (minLeft.minorUnits < debtBefore.minorUnits ? minLeft : debtBefore)
          : Money(0);
      if (take.minorUnits > minDue.minorUnits) {
        minimumSaving = minimumSaving + (take - minDue);
      }
    }
  }

  // Unlinked loan payments next to cards with bank figures: maybe counted twice.
  if (payments.cardFigures.isNotEmpty) {
    for (final f in payments.flows) {
      if (f.kind == FlowKind.loanPayment &&
          f.accountId == null &&
          occurrences(f, today, horizon).isNotEmpty) {
        warnings.add(PossibleDuplicate(f.name));
      }
    }
  }

  // 5. Freshness of the balances that were counted.
  DateTime? oldest;
  for (final a in counted) {
    final t = a.lastUpdatedAt;
    if (t != null && (oldest == null || t.isBefore(oldest))) oldest = t;
  }
  var veryStale = false;
  if (oldest != null) {
    final age = CalendarDate.fromDateTime(oldest.toLocal()).daysUntil(today);
    if (age > staleAfterDays) {
      warnings.add(StaleBalances(CalendarDate.fromDateTime(oldest.toLocal())));
    }
    veryStale = age > veryStaleAfterDays;
  }

  final goals = goalsThisPeriod ?? Money(0);
  final paymentsTotal = deductions.fold(Money(0), (s, d) => s + d.amount);
  final cardsTotal = cards.fold(Money(0), (s, d) => s + d.amount);
  final available = money - paymentsTotal - cardsTotal - goals - reserve;

  // Position (information only, does not change «можно потратить»).
  final totalDebt = accounts
      .where((a) => a.kind.isLiability && a.amount.minorUnits > 0)
      .fold(Money(0), (s, a) => s + a.amount);
  final towardsDebts = [
    ...deductions,
    ...cards,
  ].where((d) => d.accountId != null).fold(Money(0), (s, d) => s + d.amount);
  final ifAllDebtsPaid = available + towardsDebts - totalDebt;
  final perDay = available.minorUnits <= 0
      ? Money(0)
      : Money.fromBigInt(
          BigInt.from(available.minorUnits) ~/
              BigInt.from(daysLeft * 100) *
              BigInt.from(100),
        );
  // A moved salary: what «в день» would have been on the original date.
  if (horizonOverride == null &&
      kind == HorizonKind.salary &&
      next != null &&
      next.isDelayed) {
    final onTime = next.scheduledOn > today ? next.scheduledOn : null;
    final original = onTime == null
        ? null
        : computeSafeToSpend(
            accounts: accounts,
            payments: payments,
            reserve: reserve,
            today: today,
            goalsThisPeriod: goalsThisPeriod,
            incomes: incomes,
            horizonOverride: onTime,
          );
    warnings.add(SalaryDelayed(next, original?.perDay));
  }
  return SafeToSpend(
    horizon: horizon,
    horizonKind: kind,
    daysLeft: daysLeft,
    money: money,
    payments: deductions,
    cardPayments: cards,
    goals: goals,
    reserve: reserve,
    available: available,
    perDay: perDay,
    warnings: warnings,
    veryStale: veryStale,
    totalDebt: totalDebt,
    cards: positions,
    ifAllDebtsPaid: ifAllDebtsPaid,
    minimumOnlyAvailable: minimumSaving.minorUnits > 0
        ? available + minimumSaving
        : null,
    skippedAsDuplicates: skipped,
  );
}
