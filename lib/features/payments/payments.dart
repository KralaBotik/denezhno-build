import '../../core/calendar_date.dart';
import '../../core/money/money.dart';

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
  });
  final String id;
  final String accountId;
  final Money? graceAmount;
  final CalendarDate? graceDueOn;
  final Money? minPayment;
  final CalendarDate? minDueOn;
  final bool settled;
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
}) {
  final items = <UpcomingItem>[
    for (final f in flows)
      for (final d in occurrences(f, from, to))
        UpcomingItem(
          source: UpcomingSource.flow,
          title: f.name,
          amount: f.amount,
          dueOn: d,
          direction: f.direction,
          done: doneMarks.contains((f.id!, d)),
          flowId: f.id,
        ),
    for (final c in cardFigures.values)
      if (_cardDue(c) case (final amount, final due, final minOnly)
          when from <= due && due <= to)
        UpcomingItem(
          source: UpcomingSource.cardGrace,
          title: cardNames[c.accountId] ?? '',
          amount: amount,
          dueOn: due,
          direction: FlowDirection.outflow,
          done: c.settled,
          cardFiguresId: c.id,
          isMinimumOnly: minOnly,
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
  });
  final List<PlannedFlow> flows;
  final Set<(String, CalendarDate)> doneMarks;

  /// Newest figures per credit-card account id.
  final Map<String, CardFigures> cardFigures;

  /// Credit-card account id → name (all active cards, with or without figures).
  final Map<String, String> creditCards;
}

abstract interface class PaymentsStore {
  Future<PaymentsSnapshot> payments();
  Future<void> saveFlow(PlannedFlow flow);
  Future<void> archiveFlow(String id);
  Future<void> setFlowDone(String flowId, CalendarDate dueOn, bool done);
  Future<void> saveCardFigures(CardFigures figures);
  Future<void> setCardSettled(String figuresId, bool settled);
}
