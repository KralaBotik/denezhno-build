import '../../core/calendar/workdays.dart';
import '../../core/calendar_date.dart';
import '../../core/money/money.dart';
import '../forecast/safe_to_spend.dart' show ForecastPeriod;
import '../operations/operations.dart' show OperationPreview, SameDayPlacement;
import '../payments/payments.dart' show Cadence, Monthly, Weekly, Yearly, Once;

/// R3 Э3: income — plan, expectation and fact kept apart (docs/r3-plan.md).

enum IncomeKind {
  salary('salary'),
  other('other');

  const IncomeKind(this.dbValue);
  final String dbValue;
  static IncomeKind fromDb(String v) =>
      values.firstWhere((k) => k.dbValue == v);
}

/// What happens to a pay date on a weekend or a holiday.
enum HolidayRule {
  /// Art. 136 of the Labour Code: paid on the eve (default).
  previousWorkday('previous_workday'),
  nextWorkday('next_workday'),
  none('none');

  const HolidayRule(this.dbValue);
  final String dbValue;
  static HolidayRule fromDb(String v) =>
      values.firstWhere((k) => k.dbValue == v);

  CalendarDate apply(CalendarDate d) => switch (this) {
    previousWorkday => Workdays.previousWorking(d),
    nextWorkday => Workdays.nextWorking(d),
    none => d,
  };
}

/// One version of one schedule line («Аванс 20-го, 40 000 ₽»).
final class SchedulePart {
  const SchedulePart({
    required this.id,
    required this.label,
    required this.amount,
    required this.cadence,
    required this.validFrom,
    this.validTo,
  });
  final String id;
  final String label;
  final Money amount;
  final Cadence cadence;
  final CalendarDate validFrom;

  /// Last date this version applies (null = still current).
  final CalendarDate? validTo;
}

final class IncomeSource {
  const IncomeSource({
    required this.id,
    required this.name,
    required this.kind,
    required this.holidayRule,
    required this.trackedFrom,
    required this.parts,
    this.accountId,
  });
  final String id;
  final String name;
  final IncomeKind kind;
  final HolidayRule holidayRule;

  /// Payments by the schedule before this date are not «waiting».
  final CalendarDate trackedFrom;

  /// All versions, current and past.
  final List<SchedulePart> parts;

  /// Default account the money comes to.
  final String? accountId;

  List<SchedulePart> get currentParts =>
      parts.where((p) => p.validTo == null).toList();
}

enum PaymentState {
  open('open'),
  received('received'),
  legacyMark('legacy_mark'),
  cancelled('cancelled');

  const PaymentState(this.dbValue);
  final String dbValue;
  static PaymentState fromDb(String v) =>
      values.firstWhere((k) => k.dbValue == v);
}

/// Money actually received for a payment (one of possibly several).
final class Receipt {
  const Receipt({
    required this.id,
    required this.entryId,
    required this.amount,
    required this.receivedOn,
    required this.cancelled,
    this.accountId,
  });
  final String id;
  final String entryId;
  final Money amount;
  final CalendarDate receivedOn;

  /// The journal entry was reversed («получение отменено»).
  final bool cancelled;
  final String? accountId;
}

/// Identifies a payment: by the schedule line and its planned date (stable
/// even before anything is written), or a one-off payment by its id.
final class PaymentKey {
  const PaymentKey({
    required this.sourceId,
    this.partId,
    required this.plannedOn,
  });
  final String sourceId;
  final String? partId;
  final CalendarDate plannedOn;
  @override
  bool operator ==(Object other) =>
      other is PaymentKey &&
      other.sourceId == sourceId &&
      other.partId == partId &&
      other.plannedOn == plannedOn;
  @override
  int get hashCode => Object.hash(sourceId, partId, plannedOn);
  @override
  String toString() => '$sourceId/$partId/${plannedOn.iso}';
}

/// One payment: by the schedule (plan), the current expectation, and what
/// actually came (receipts).
final class IncomePayment {
  const IncomePayment({
    required this.key,
    required this.sourceName,
    required this.kind,
    required this.label,
    required this.scheduledOn,
    required this.plannedAmount,
    required this.state,
    this.id,
    this.expectedOn,
    this.dateUnknown = false,
    this.expectedAmount,
    this.receipts = const [],
    this.accountId,
  });

  /// Null until something happened to it (then it is stored).
  final String? id;
  final PaymentKey key;
  final String sourceName;
  final IncomeKind kind;
  final String label;

  /// The planned date after the holiday rule (the plan never changes).
  final CalendarDate scheduledOn;
  final Money plannedAmount;

  /// Moved by the person (null = as scheduled).
  final CalendarDate? expectedOn;

  /// Delayed with no known date.
  final bool dateUnknown;
  final Money? expectedAmount;
  final PaymentState state;
  final List<Receipt> receipts;
  final String? accountId;

  CalendarDate get plannedOn => key.plannedOn;

  /// When the money is expected now; null when the date is unknown.
  CalendarDate? get dueOn => dateUnknown ? null : (expectedOn ?? scheduledOn);

  Money get expected => expectedAmount ?? plannedAmount;

  Money get received => receipts
      .where((r) => !r.cancelled)
      .fold(Money(0), (s, r) => s + r.amount);

  /// Still expected for this payment; never counted as money (И7, И12).
  Money get remaining {
    if (state != PaymentState.open) return Money(0);
    final left = expected - received;
    return left.minorUnits < 0 ? Money(0) : left;
  }

  bool get isOpen => state == PaymentState.open;

  /// Moved later than the schedule.
  bool get isDelayed =>
      isOpen &&
      (dateUnknown || (expectedOn != null && expectedOn! > scheduledOn));

  bool isOverdue(CalendarDate today) =>
      isOpen && remaining.minorUnits > 0 && dueOn != null && dueOn! < today;

  bool get isPartial =>
      isOpen && received.minorUnits > 0 && remaining.minorUnits > 0;
}

/// Everything about income the app knows, for screens and the forecast.
final class IncomeSnapshot {
  const IncomeSnapshot({required this.sources, required this.payments});
  final List<IncomeSource> sources;

  /// Stored payments (any date) and scheduled ones from each source's
  /// tracking date up to the window end, sorted by the date they are due.
  final List<IncomePayment> payments;

  bool get hasSalary =>
      sources.any((s) => s.kind == IncomeKind.salary && s.parts.isNotEmpty);
}

/// A row as stored (for [buildPayments]).
final class StoredPayment {
  const StoredPayment({
    required this.id,
    required this.sourceId,
    required this.partId,
    required this.plannedOn,
    required this.plannedAmount,
    required this.expectedOn,
    required this.dateUnknown,
    required this.expectedAmount,
    required this.state,
    required this.receipts,
  });
  final String id;
  final String sourceId;
  final String? partId;
  final CalendarDate plannedOn;
  final Money plannedAmount;
  final CalendarDate? expectedOn;
  final bool dateUnknown;
  final Money? expectedAmount;
  final PaymentState state;
  final List<Receipt> receipts;
}

/// Schedule dates of [part] within [from]..[to] (raw, before the holiday
/// rule) — the stable keys of payments.
List<CalendarDate> partDates(
  SchedulePart part,
  CalendarDate from,
  CalendarDate to,
) {
  final start = part.validFrom > from ? part.validFrom : from;
  final end = part.validTo != null && part.validTo! < to ? part.validTo! : to;
  if (start > end) return const [];
  final result = <CalendarDate>[];
  switch (part.cadence) {
    case Once(:final date):
      if (start <= date && date <= end) result.add(date);
    case Weekly(:final weekday):
      var d = start.addDays((weekday - start.weekday + 7) % 7);
      while (d <= end) {
        result.add(d);
        d = d.addDays(7);
      }
    case Monthly(:final day):
      var y = start.year, m = start.month;
      while (true) {
        final d = CalendarDate.clamped(y, m, day);
        if (d > end) break;
        if (d >= start) result.add(d);
        if (++m > 12) {
          m = 1;
          y++;
        }
      }
    case Yearly(:final month, :final day):
      for (var y = start.year; ; y++) {
        final d = CalendarDate.clamped(y, month, day);
        if (d > end) break;
        if (d >= start) result.add(d);
      }
  }
  return result;
}

/// Stored payments plus the scheduled ones not stored yet, from each
/// source's tracking date to [until]. Stored ones are kept whatever their
/// date: an open payment waits until it is resolved, however long.
List<IncomePayment> buildPayments(
  List<IncomeSource> sources,
  List<StoredPayment> stored,
  CalendarDate until,
) {
  final result = <IncomePayment>[];
  final byKey = {
    for (final s in stored)
      PaymentKey(
        sourceId: s.sourceId,
        partId: s.partId,
        plannedOn: s.plannedOn,
      ): s,
  };
  final used = <PaymentKey>{};
  for (final source in sources) {
    final parts = {for (final p in source.parts) p.id: p};
    IncomePayment make(PaymentKey key, SchedulePart? part, StoredPayment? s) {
      used.add(key);
      return IncomePayment(
        id: s?.id,
        key: key,
        sourceName: source.name,
        kind: source.kind,
        label: part?.label ?? source.name,
        scheduledOn: source.holidayRule.apply(key.plannedOn),
        plannedAmount: s?.plannedAmount ?? part!.amount,
        expectedOn: s?.expectedOn,
        dateUnknown: s?.dateUnknown ?? false,
        expectedAmount: s?.expectedAmount,
        state: s?.state ?? PaymentState.open,
        receipts: s?.receipts ?? const [],
        accountId: source.accountId,
      );
    }

    for (final part in source.parts) {
      for (final d in partDates(part, source.trackedFrom, until)) {
        final key = PaymentKey(
          sourceId: source.id,
          partId: part.id,
          plannedOn: d,
        );
        result.add(make(key, part, byKey[key]));
      }
    }
    for (final s in stored.where((s) => s.sourceId == source.id)) {
      final key = PaymentKey(
        sourceId: s.sourceId,
        partId: s.partId,
        plannedOn: s.plannedOn,
      );
      if (used.contains(key)) continue;
      result.add(make(key, parts[s.partId], s));
    }
  }
  result.sort((a, b) {
    final x = a.dueOn ?? a.scheduledOn;
    final y = b.dueOn ?? b.scheduledOn;
    return x.compareTo(y);
  });
  return result;
}

/// How a receipt closes the payment when it is less than expected.
enum ShortfallChoice {
  /// The rest comes later (date or unknown): the payment stays open.
  restLater,

  /// This is the whole payment: the expected amount becomes what came.
  wholePayment,
}

/// Storage of income (implemented by the encrypted store).
abstract interface class IncomeStore {
  Future<IncomeSnapshot> income();

  Future<String> createIncomeSource({
    required String name,
    required IncomeKind kind,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  });

  /// Changes from today on; past payments and receipts keep their plan.
  Future<void> updateIncomeSchedule(
    String sourceId, {
    required String name,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  });

  Future<void> archiveIncomeSource(String sourceId);

  Future<void> movePayment(PaymentKey key, CalendarDate to);
  Future<void> markPaymentDateUnknown(PaymentKey key);
  Future<void> setPaymentAmount(PaymentKey key, Money amount);
  Future<void> cancelPayment(PaymentKey key);
  Future<void> reopenPayment(PaymentKey key);

  Future<OperationPreview> previewReceipt(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    SameDayPlacement placement,
  });

  Future<void> receivePayment(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required SameDayPlacement placement,
    ShortfallChoice shortfall,
    CalendarDate? restOn,
  });

  Future<void> cancelReceipt(String receiptId);

  Future<ForecastPeriod> forecastPeriod();
  Future<void> setForecastPeriod(ForecastPeriod period);
}

/// A line of a schedule being saved. [id] = an existing current version.
final class PartSpec {
  const PartSpec({
    this.id,
    required this.label,
    required this.amount,
    required this.cadence,
  });
  final String? id;
  final String label;
  final Money amount;
  final Cadence cadence;
}
