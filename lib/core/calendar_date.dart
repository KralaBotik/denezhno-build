/// A calendar date without time or time zone: payments are due «25 ноября»,
/// not at an instant. Stored as ISO `YYYY-MM-DD`.
final class CalendarDate implements Comparable<CalendarDate> {
  CalendarDate(this.year, this.month, this.day) {
    if (month < 1 || month > 12 || day < 1 || day > daysInMonth(year, month)) {
      throw ArgumentError('Invalid date');
    }
  }
  factory CalendarDate.fromDateTime(DateTime t) =>
      CalendarDate(t.year, t.month, t.day);
  factory CalendarDate.today() => CalendarDate.fromDateTime(DateTime.now());
  factory CalendarDate.parse(String iso) {
    final m = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(iso);
    if (m == null) throw const FormatException('Not an ISO date');
    return CalendarDate(int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!));
  }

  final int year;
  final int month;
  final int day;

  static int daysInMonth(int year, int month) =>
      DateTime.utc(year, month + 1, 0).day;

  /// Day [day] of the given month, clamped: «31-го» in February is the 28/29th.
  static CalendarDate clamped(int year, int month, int day) =>
      CalendarDate(year, month, day.clamp(1, daysInMonth(year, month)));

  DateTime get _utc => DateTime.utc(year, month, day);
  CalendarDate addDays(int days) =>
      CalendarDate.fromDateTime(_utc.add(Duration(days: days)));
  int daysUntil(CalendarDate other) => other._utc.difference(_utc).inDays;

  /// ISO weekday: 1 = Monday … 7 = Sunday.
  int get weekday => _utc.weekday;

  String get iso =>
      '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}'
      '-${day.toString().padLeft(2, '0')}';

  @override
  int compareTo(CalendarDate other) => _utc.compareTo(other._utc);
  bool operator <(CalendarDate o) => compareTo(o) < 0;
  bool operator <=(CalendarDate o) => compareTo(o) <= 0;
  bool operator >(CalendarDate o) => compareTo(o) > 0;
  bool operator >=(CalendarDate o) => compareTo(o) >= 0;
  @override
  bool operator ==(Object other) =>
      other is CalendarDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;
  @override
  int get hashCode => Object.hash(year, month, day);
  @override
  String toString() => iso;
}
