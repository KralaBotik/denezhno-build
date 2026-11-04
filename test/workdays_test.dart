import 'package:denezhno/core/calendar/workdays.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:flutter_test/flutter_test.dart';

CalendarDate d(String s) => CalendarDate.parse(s);

void main() {
  test('weekends and the official calendars are separate layers', () {
    expect(Workdays.isWeekend(d('2026-11-07')), true); // Saturday
    expect(Workdays.isWorking(d('2026-11-06')), true); // Friday
    // Days off by decree (weekdays).
    for (final day in [
      '2026-01-09', // moved from 3 Jan (№ 1466)
      '2026-03-09', // 8 Mar on Sunday
      '2026-05-11', // 9 May on Saturday
      '2026-11-04',
      '2026-12-31', // moved from 4 Jan
      '2025-05-08', // 23 Feb moved (№ 1335)
      '2025-06-13', // 8 Mar moved
      '2027-02-22', // moved from 20 Feb (№ 1187)
      '2027-11-05', // moved from 2 Jan
    ]) {
      expect(Workdays.isWorking(d(day)), false, reason: day);
    }
    // Working weekends.
    expect(Workdays.isWorking(d('2025-11-01')), true);
    expect(Workdays.isWorking(d('2027-02-20')), true);
    expect(Workdays.isOfficial(2026), true);
    expect(Workdays.isOfficial(2028), false);
  });

  test('a year without a decree is estimated from the Labour Code', () {
    // 2028: 4 Nov is Saturday → Monday 6 Nov off; 1–8 Jan off.
    expect(Workdays.isWorking(d('2028-11-06')), false);
    expect(Workdays.isWorking(d('2028-01-05')), false);
    expect(Workdays.isWorking(d('2028-11-07')), true);
  });

  test('holiday rules for a pay date', () {
    // 5 Dec 2026 is Saturday.
    expect(HolidayRule.previousWorkday.apply(d('2026-12-05')), d('2026-12-04'));
    expect(HolidayRule.nextWorkday.apply(d('2026-12-05')), d('2026-12-07'));
    expect(HolidayRule.none.apply(d('2026-12-05')), d('2026-12-05'));
    // 10 Jan 2026 (Saturday) after the long holidays: previous working day
    // is 31 Dec 2025? No — 31 Dec 2025 is a day off too: 30 Dec.
    expect(HolidayRule.previousWorkday.apply(d('2026-01-10')), d('2025-12-30'));
    expect(HolidayRule.nextWorkday.apply(d('2026-01-03')), d('2026-01-12'));
    // A working day stays.
    expect(HolidayRule.previousWorkday.apply(d('2026-11-20')), d('2026-11-20'));
  });
}
