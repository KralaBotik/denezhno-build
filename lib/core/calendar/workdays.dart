import '../calendar_date.dart';

/// Working days in Russia, in two independent layers (owner decision R3):
///
/// 1. the weekly rest days — Saturday and Sunday ([isWeekend]);
/// 2. the production calendar of a year — public holidays and the days off
///    moved by the government's annual decree, plus Saturdays/Sundays made
///    working days ([RuHolidays]).
///
/// A day is working when it is not a rest day by layer 1 (unless layer 2
/// makes it working) and not a day off by layer 2.
abstract final class Workdays {
  static bool isWeekend(CalendarDate d) => d.weekday >= DateTime.saturday;

  static bool isWorking(CalendarDate d) {
    final year = RuHolidays.forYear(d.year);
    if (year.workingWeekends.contains(d.iso)) return true;
    if (isWeekend(d)) return false;
    return !year.daysOff.contains(d.iso);
  }

  /// Whether the calendar of [year] comes from the government decree (true)
  /// or is only estimated from the Labour Code (false; moved days unknown).
  static bool isOfficial(int year) => RuHolidays.official.containsKey(year);

  static CalendarDate previousWorking(CalendarDate d) {
    var x = d;
    for (var i = 0; i < 30 && !isWorking(x); i++) {
      x = x.addDays(-1);
    }
    return x;
  }

  static CalendarDate nextWorking(CalendarDate d) {
    var x = d;
    for (var i = 0; i < 30 && !isWorking(x); i++) {
      x = x.addDays(1);
    }
    return x;
  }
}

/// One year of the production calendar: weekdays that are days off, and
/// weekend days that are working days.
final class HolidayYear {
  const HolidayYear({required this.daysOff, this.workingWeekends = const {}});
  final Set<String> daysOff;
  final Set<String> workingWeekends;
}

/// Russian production calendars (five-day week).
///
/// Sources — decrees of the Government of the Russian Federation:
/// - 2025: № 1335 of 04.10.2024 (4 Jan → 2 May, 5 Jan → 31 Dec,
///   23 Feb → 8 May, 8 Mar → 13 Jun, 1 Nov → 3 Nov; Saturday 1 Nov works);
/// - 2026: № 1466 of 24.09.2025 (3 Jan → 9 Jan, 4 Jan → 31 Dec);
/// - 2027: № 1187 of 17.09.2026 (2 Jan → 5 Nov, 3 Jan → 31 Dec,
///   20 Feb → 22 Feb; Saturday 20 Feb works).
/// Plus holidays on a weekend moving to the next working day by art. 112 of
/// the Labour Code (except the January holidays).
///
/// Only weekdays are listed in [HolidayYear.daysOff] (weekends are layer 1).
abstract final class RuHolidays {
  static const official = <int, HolidayYear>{
    2025: HolidayYear(
      daysOff: {
        '2025-01-01', '2025-01-02', '2025-01-03', '2025-01-06', //
        '2025-01-07', '2025-01-08', '2025-05-01', '2025-05-02',
        '2025-05-08', '2025-05-09', '2025-06-12', '2025-06-13',
        '2025-11-03', '2025-11-04', '2025-12-31',
      },
      workingWeekends: {'2025-11-01'},
    ),
    2026: HolidayYear(
      daysOff: {
        '2026-01-01', '2026-01-02', '2026-01-05', '2026-01-06', //
        '2026-01-07', '2026-01-08', '2026-01-09', '2026-02-23',
        '2026-03-09', '2026-05-01', '2026-05-11', '2026-06-12',
        '2026-11-04', '2026-12-31',
      },
    ),
    2027: HolidayYear(
      daysOff: {
        '2027-01-01', '2027-01-04', '2027-01-05', '2027-01-06', //
        '2027-01-07', '2027-01-08', '2027-02-22', '2027-02-23',
        '2027-03-08', '2027-05-03', '2027-05-10', '2027-06-14',
        '2027-11-04', '2027-11-05', '2027-12-31',
      },
      workingWeekends: {'2027-02-20'},
    ),
  };

  /// The official year, or an estimate from the Labour Code: the fixed
  /// holidays (art. 112) and, outside January, a holiday falling on a
  /// weekend moves to the next weekday. Moves by decree are unknown.
  static HolidayYear forYear(int year) =>
      official[year] ?? _estimates.putIfAbsent(year, () => _estimate(year));

  static final _estimates = <int, HolidayYear>{};

  static HolidayYear _estimate(int year) {
    final off = <String>{};
    for (var day = 1; day <= 8; day++) {
      final d = CalendarDate(year, 1, day);
      if (!Workdays.isWeekend(d)) off.add(d.iso);
    }
    for (final (m, d) in const [
      (2, 23),
      (3, 8),
      (5, 1),
      (5, 9),
      (6, 12),
      (11, 4),
    ]) {
      var x = CalendarDate(year, m, d);
      while (Workdays.isWeekend(x) || off.contains(x.iso)) {
        x = x.addDays(1);
      }
      off.add(x.iso);
    }
    return HolidayYear(daysOff: off);
  }
}
