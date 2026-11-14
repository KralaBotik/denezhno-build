import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../operations/operations.dart'
    show ConfirmationAnswer, OperationPreview;

enum FlowDirection { outflow, inflow }

enum FlowKind {
  salary('salary', FlowDirection.inflow),
  otherIncome('other_income', FlowDirection.inflow),
  subscription('subscription', FlowDirection.outflow),
  utilities('utilities', FlowDirection.outflow),
  loanPayment('loan_payment', FlowDirection.outflow),
  rent('rent', FlowDirection.outflow),
  communication('communication', FlowDirection.outflow),
  otherPayment('other_payment', FlowDirection.outflow);

  const FlowKind(this.dbValue, this.direction);
  final String dbValue;
  final FlowDirection direction;
  static FlowKind? fromDb(String v) {
    for (final k in values) {
      if (k.dbValue == v) return k;
    }
    return null;
  }
}

/// When a plan repeats. Monthly/yearly days past the month end are clamped
/// (31 → last day of February); weekly uses ISO weekdays (1 = Monday).
sealed class Cadence {
  const Cadence();
}

final class Monthly extends Cadence {
  const Monthly(this.day) : assert(day >= 1 && day <= 31);
  final int day;
}

final class Weekly extends Cadence {
  const Weekly(this.weekday) : assert(weekday >= 1 && weekday <= 7);
  final int weekday;
}

final class Yearly extends Cadence {
  const Yearly(this.month, this.day);
  final int month;
  final int day;
}

final class Once extends Cadence {
  const Once(this.date);
  final CalendarDate date;
}

/// A recurring payment or expected income (a plan, not a fact).
final class PlannedFlow {
  const PlannedFlow({
    required this.id,
    required this.kind,
    required this.name,
    required this.amount,
    required this.cadence,
    required this.startsOn,
    this.accountId,
  });
  final String? id;
  final FlowKind kind;

  /// The credit card or loan this payment repays, if any. A payment linked to
  /// a card that has bank figures is not counted twice (the figures win).
  final String? accountId;
  final String name;

  /// Always positive; the direction comes from [kind].
  final Money amount;
  final Cadence cadence;
  final CalendarDate startsOn;
  FlowDirection get direction => kind.direction;
}

/// All due dates of [flow] within [from]..[to] (inclusive).
List<CalendarDate> occurrences(
  PlannedFlow flow,
  CalendarDate from,
  CalendarDate to,
) {
  final start = flow.startsOn > from ? flow.startsOn : from;
  if (start > to) return const [];
  final result = <CalendarDate>[];
  switch (flow.cadence) {
    case Once(:final date):
      if (start <= date && date <= to) result.add(date);
    case Weekly(:final weekday):
      var d = start.addDays((weekday - start.weekday + 7) % 7);
      while (d <= to) {
        result.add(d);
        d = d.addDays(7);
      }
    case Monthly(:final day):
      var y = start.year, m = start.month;
      while (true) {
        final d = CalendarDate.clamped(y, m, day);
        if (d > to) break;
        if (d >= start) result.add(d);
        if (++m > 12) {
          m = 1;
          y++;
        }
      }
    case Yearly(:final month, :final day):
      for (var y = start.year; ; y++) {
        final d = CalendarDate.clamped(y, month, day);
        if (d > to) break;
        if (d >= start) result.add(d);
      }
  }
  return result;
}

/// Figures from the bank app for one credit card. Either part may be absent;
/// unknown is shown as «не указано», never as zero.
final class CardFigures {
  const CardFigures({
    required this.id,
    required this.accountId,
    this.graceAmount,
    this.graceDueOn,
    this.minPayment,
    this.minDueOn,
    this.settled = false,
    this.paid,
    this.legacySettled = false,
  });
  final String id;
  final String accountId;
  final Money? graceAmount;
  final CalendarDate? graceDueOn;
  final Money? minPayment;
  final CalendarDate? minDueOn;

  /// Paid in full by transfers to the card (operations, R3 Р1).
  final bool settled;

  /// Transferred to the card for these figures so far (operations).
  final Money? paid;

  /// Marked «внёс» before R3 without an operation: does not release the
  /// obligation by itself (needs a confirmed payment).
  final bool legacySettled;

  /// What is still due for these figures: the grace amount (or the minimum)
  /// minus what was already transferred. Null when there is no figure.
  Money? get remainingDue {
    final due = graceAmount ?? minPayment;
    if (due == null) return null;
    final left = due - (paid ?? Money(0));
    return left.minorUnits < 0 ? Money(0) : left;
  }
}

/// What is being paid: one date of a plan, or a credit card's figures.
sealed class PayTarget {
  const PayTarget();
}

final class PlanDate extends PayTarget {
  const PlanDate(this.flowId, this.dueOn);
  final String flowId;
  final CalendarDate dueOn;
  @override
  bool operator ==(Object other) =>
      other is PlanDate && other.flowId == flowId && other.dueOn == dueOn;
  @override
  int get hashCode => Object.hash(flowId, dueOn);
}

final class CardDue extends PayTarget {
  const CardDue(this.figuresId);
  final String figuresId;
  @override
  bool operator ==(Object other) =>
      other is CardDue && other.figuresId == figuresId;
  @override
  int get hashCode => figuresId.hashCode;
}

/// A payment of an obligation booked as a journal operation.
final class ObligationPayment {
  const ObligationPayment({
    required this.id,
    required this.target,
    required this.entryId,
    required this.amount,
    required this.paidOn,
    required this.cancelled,
    this.accountId,
  });
  final String id;
  final PayTarget target;
  final String entryId;
  final Money amount;
  final CalendarDate paidOn;

  /// The operation was reversed («оплата отменена»).
  final bool cancelled;

  /// The account the money left.
  final String? accountId;
}

/// An operation on the same account, with the same amount, a few days
/// around: maybe this payment is already recorded.
final class SimilarOperation {
  const SimilarOperation(this.date, this.amount, this.description);
  final CalendarDate date;
  final Money amount;
  final String? description;
}

/// One payment and one of its own accounts.
typedef PendingKey = ({String paymentId, String accountId});

/// One side of a recorded payment that is not yet in a confirmed balance of
/// that account: the operation still changes it after the account's last
/// confirmation. A transfer has a side per account (the debit and the card
/// are confirmed separately); a payment for a purchase has one. At «Обновить
/// остатки» the person answers only about the accounts being confirmed now:
/// «Банк уже списал деньги?» ([incoming] false) or «Банк уже зачислил
/// перевод?» ([incoming] true). No default (R3 review 3, 2026-11-14).
final class PendingSide {
  const PendingSide({
    required this.paymentId,
    required this.title,
    required this.amount,
    required this.accountId,
    required this.paidOn,
    required this.incoming,
  });
  final String paymentId;
  final String title;
  final Money amount;
  final String accountId;
  final CalendarDate paidOn;

  /// The money comes INTO this account (a credit to the card); otherwise
  /// it leaves it.
  final bool incoming;

  PendingKey get key => (paymentId: paymentId, accountId: accountId);
}

enum UpcomingSource { flow, cardGrace }

/// One line of «Ближайшие»: a plan occurrence or a credit-card payment.
final class UpcomingItem {
  const UpcomingItem({
    required this.source,
    required this.title,
    required this.amount,
    required this.dueOn,
    required this.direction,
    required this.done,
    this.flowId,
    this.cardFiguresId,
    this.isMinimumOnly = false,
    this.overdue = false,
    this.skipped = false,
    this.legacyMarked = false,
    this.payment,
  });
  final UpcomingSource source;
  final String title;
  final Money amount;
  final CalendarDate dueOn;
  final FlowDirection direction;
  final bool done;
  final String? flowId;
  final String? cardFiguresId;

  /// The bank's grace amount is unknown; only the minimum payment is.
  final bool isMinimumOnly;

  /// The date has passed and it is not paid or skipped.
  final bool overdue;

  /// «Платежа не будет».
  final bool skipped;

  /// Marked «оплачено» before R3 without an operation: needs confirmation.
  final bool legacyMarked;

  /// The operation that paid it (for «отменить оплату»).
  final ObligationPayment? payment;

  PayTarget get target => source == UpcomingSource.flow
      ? PlanDate(flowId!, dueOn)
      : CardDue(cardFiguresId!);
}

/// Builds «Ближайшие» for [from]..[to]. Card figures contribute the grace
/// amount (to avoid interest) or, if unknown, the minimum payment.
List<UpcomingItem> upcoming({
  required List<PlannedFlow> flows,
  required Set<(String, CalendarDate)> doneMarks,
  required Map<String, CardFigures> cardFigures,
  required Map<String, String> cardNames,
  required CalendarDate from,
  required CalendarDate to,
  Map<String, CalendarDate> trackedFrom = const {},
  Map<(String, CalendarDate), ObligationPayment> paid = const {},
  Set<(String, CalendarDate)> skipped = const {},
  Set<(String, CalendarDate)> legacyMarks = const {},
}) {
  final items = <UpcomingItem>[
    for (final f in flows)
      // Payments: also every earlier date since tracking that is still
      // unresolved («просрочен»). Incomes: from [from] only.
      for (final d in occurrences(
        f,
        f.direction == FlowDirection.outflow &&
                (trackedFrom[f.id] ?? from) < from
            ? trackedFrom[f.id]!
            : from,
        to,
      ))
        if (d >= from || !doneMarks.contains((f.id!, d)))
          UpcomingItem(
            source: UpcomingSource.flow,
            title: f.name,
            amount: f.amount,
            dueOn: d,
            direction: f.direction,
            done: doneMarks.contains((f.id!, d)),
            flowId: f.id,
            overdue: d < from && !doneMarks.contains((f.id!, d)),
            skipped: skipped.contains((f.id!, d)),
            legacyMarked: legacyMarks.contains((f.id!, d)),
            payment: paid[(f.id!, d)],
          ),
    for (final c in cardFigures.values)
      if (_cardDue(c) case (final amount, final due, final minOnly)
          when (from <= due || !c.settled) && due <= to)
        UpcomingItem(
          source: UpcomingSource.cardGrace,
          title: cardNames[c.accountId] ?? '',
          amount: c.settled ? amount : (c.remainingDue ?? amount),
          dueOn: due,
          direction: FlowDirection.outflow,
          done: c.settled,
          cardFiguresId: c.id,
          isMinimumOnly: minOnly,
          overdue: due < from && !c.settled,
          legacyMarked: c.legacySettled && !c.settled,
        ),
  ];
  items.sort((a, b) {
    final byDate = a.dueOn.compareTo(b.dueOn);
    return byDate != 0 ? byDate : a.title.compareTo(b.title);
  });
  return items;
}

(Money, CalendarDate, bool)? _cardDue(CardFigures c) {
  if (c.graceAmount != null && c.graceDueOn != null) {
    return (c.graceAmount!, c.graceDueOn!, false);
  }
  if (c.minPayment != null && c.minDueOn != null) {
    return (c.minPayment!, c.minDueOn!, true);
  }
  return null;
}

/// Everything the «Платежи» screen needs, read in one go.
final class PaymentsSnapshot {
  const PaymentsSnapshot({
    required this.flows,
    required this.doneMarks,
    required this.cardFigures,
    required this.creditCards,
    this.trackedFrom = const {},
    this.paid = const {},
    this.skipped = const {},
    this.legacyMarks = const {},
    this.history = const [],
  });
  final List<PlannedFlow> flows;

  /// Dates that are no longer obligations: paid by an operation, or skipped.
  final Set<(String, CalendarDate)> doneMarks;

  /// Plan id → the first date that is an obligation (R3 Р1). Plans without
  /// an entry (old tests, fakes) are tracked from today.
  final Map<String, CalendarDate> trackedFrom;

  /// Live (not cancelled) payments of plan dates.
  final Map<(String, CalendarDate), ObligationPayment> paid;

  /// Dates explicitly skipped («платежа не будет»).
  final Set<(String, CalendarDate)> skipped;

  /// Marked «оплачено» before R3 without an operation: still obligations.
  final Set<(String, CalendarDate)> legacyMarks;

  /// Every payment, including cancelled ones.
  final List<ObligationPayment> history;

  /// Newest figures per credit-card account id.
  final Map<String, CardFigures> cardFigures;

  /// Credit-card account id → name (all active cards, with or without figures).
  final Map<String, String> creditCards;
}

abstract interface class PaymentsStore {
  Future<PaymentsSnapshot> payments();
  Future<void> saveFlow(PlannedFlow flow);
  Future<void> archiveFlow(String id);
  Future<void> saveCardFigures(CardFigures figures);

  /// «Платежа не будет» for one date of a plan (or undo it).
  Future<void> setFlowSkipped(String flowId, CalendarDate dueOn, bool skipped);

  /// What paying will do — shown before anything is written.
  Future<PaymentCheck> previewPayment(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    Map<String, ConfirmationAnswer> answers,
  });

  /// Books the payment as an operation and links it, atomically. Every
  /// confirmation question must be answered ([answers], per account and
  /// confirmation), and the figures question if it was asked.
  Future<void> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required Map<String, ConfirmationAnswer> answers,
    FiguresAnswer? figuresAnswer,
    bool confirmedNotDuplicate,
  });

  /// Reverses a payment recorded by mistake.
  Future<void> cancelObligationPayment(String paymentId);

  /// Sides of payments not yet in a confirmed balance of their account.
  Future<List<PendingSide>> pendingSides();
}

/// What paying will do, and similar operations already on the account.
final class PaymentCheck {
  const PaymentCheck(this.operation, this.similar, [this.figures]);
  final OperationPreview operation;
  final List<SimilarOperation> similar;

  /// Asked when the payment goes to a credit card whose current bank
  /// figures were entered on or after the payment's date.
  final FiguresQuestion? figures;
}

/// The person's answer to a [FiguresQuestion], bound to that version of
/// the bank figures: an answer about an older version is refused.
final class FiguresAnswer {
  const FiguresAnswer(this.figuresId, {required this.included});
  final String figuresId;

  /// The bank figure already includes this payment.
  final bool included;
}

/// «Сумма {due}, введённая {enteredOn}, уже учитывает этот платёж?» — the
/// answer is kept with the transfer and this version of the bank figures.
final class FiguresQuestion {
  const FiguresQuestion({
    required this.figuresId,
    required this.due,
    required this.enteredOn,
  });
  final String figuresId;

  /// The bank's amount to pay as entered (grace, or the minimum).
  final Money due;
  final CalendarDate enteredOn;
}
