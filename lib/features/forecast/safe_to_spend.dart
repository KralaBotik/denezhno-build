import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../accounts/accounts.dart';
import '../payments/payments.dart';

/// Why the horizon ends where it does.
enum HorizonKind { salary, monthEnd }

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

/// A credit card with a debt but no figures from the bank.
final class CardWithoutFigures extends SpendWarning {
  const CardWithoutFigures(this.name);
  final String name;
}

/// Only the minimum payment is known: paying it keeps interest running.
final class MinimumOnly extends SpendWarning {
  const MinimumOnly(this.name);
  final String name;
}

/// The bank's due date for a card has passed and the payment is not marked
/// as made: the figures are probably outdated (a new statement exists).
final class OverdueCardFigures extends SpendWarning {
  const OverdueCardFigures(this.name, this.dueOn);
  final String name;
  final CalendarDate dueOn;
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
  const Deduction(this.title, this.amount, this.dueOn);
  final String title;
  final Money amount;
  final CalendarDate dueOn;
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
}) {
  final warnings = <SpendWarning>[];

  // 1. Horizon: the next salary that has not been received yet.
  CalendarDate? salary;
  for (final f in payments.flows.where((f) => f.kind == FlowKind.salary)) {
    for (final d in occurrences(f, today, today.addDays(62))) {
      if (payments.doneMarks.contains((f.id!, d))) continue;
      if (salary == null || d < salary) salary = d;
      break;
    }
  }
  final CalendarDate horizon;
  final HorizonKind kind;
  if (salary != null) {
    horizon = salary;
    kind = HorizonKind.salary;
  } else {
    horizon = CalendarDate(
      today.year,
      today.month,
      CalendarDate.daysInMonth(today.year, today.month),
    );
    kind = HorizonKind.monthEnd;
    warnings.add(const NoSalary());
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

  // 3. Planned payments due from today up to and including the horizon day.
  final deductions = <Deduction>[];
  for (final f in payments.flows) {
    if (f.direction != FlowDirection.outflow) continue;
    for (final d in occurrences(f, today, horizon)) {
      if (payments.doneMarks.contains((f.id!, d))) continue;
      final linked = f.accountId;
      if (linked != null && remainingDebt.containsKey(linked)) {
        // The bank's figures for this card are the source of truth.
        if (payments.cardFigures.containsKey(linked)) {
          skipped.add(Deduction(f.name, f.amount, d));
          continue;
        }
        final take = capped(linked, f.amount);
        if (take.minorUnits < f.amount.minorUnits) {
          skipped.add(Deduction(f.name, f.amount - take, d));
        }
        if (take.minorUnits > 0) deductions.add(Deduction(f.name, take, d));
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
  for (final card in accounts.where((a) => a.kind == AccountKind.creditCard)) {
    final f = payments.cardFigures[card.id];
    if (f == null) {
      if (card.amount.minorUnits > 0 && !plannedFor.contains(card.id)) {
        warnings.add(CardWithoutFigures(card.name));
      }
      continue;
    }
    if (f.settled) continue;
    final (Money? due, CalendarDate? on, bool minOnly) = f.graceAmount != null
        ? (f.graceAmount, f.graceDueOn, false)
        : (f.minPayment, f.minDueOn, true);
    if (due == null || on == null || on > horizon) continue;
    if (on < today) warnings.add(OverdueCardFigures(card.name, on));
    final take = capped(card.id, due);
    if (take.minorUnits < due.minorUnits) {
      skipped.add(Deduction(card.name, due - take, on));
    }
    if (take.minorUnits == 0) continue;
    cards.add(Deduction(card.name, take, on));
    if (minOnly) warnings.add(MinimumOnly(card.name));
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
  final perDay = available.minorUnits <= 0
      ? Money(0)
      : Money.fromBigInt(
          BigInt.from(available.minorUnits) ~/
              BigInt.from(daysLeft * 100) *
              BigInt.from(100),
        );
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
    skippedAsDuplicates: skipped,
  );
}
