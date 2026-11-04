import '../../core/calendar_date.dart';
import 'payments.dart';

/// One local notification. Texts never contain amounts: a lock screen is
/// visible to anyone near the phone.
final class Reminder {
  const Reminder({required this.at, required this.title, required this.body});

  /// Local wall-clock time.
  final DateTime at;
  final String title;
  final String body;
}

const _months = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];
String _date(CalendarDate d) => '${d.day} ${_months[d.month - 1]}';

/// Reminders for unpaid outgoing items: 3 days before and on the due day at
/// [hour]:00 local time. Past times are skipped; at most [max] (iOS keeps
/// 64 pending notifications per app).
List<Reminder> planReminders(
  List<UpcomingItem> items,
  DateTime now, {
  int hour = 10,
  int max = 60,
}) {
  final result = <Reminder>[];
  for (final item in items) {
    if (item.done || item.direction != FlowDirection.outflow) continue;
    final card = item.source == UpcomingSource.cardGrace;
    final what = card
        ? '«${item.title}»: внести до ${_date(item.dueOn)}'
              '${item.isMinimumOnly ? ' (минимальный платёж)' : ', чтобы не платить проценты'}'
        : '«${item.title}» — ${_date(item.dueOn)}';
    for (final (offset, title) in [
      (-3, 'Через 3 дня платёж'),
      (0, 'Сегодня платёж'),
    ]) {
      final day = item.dueOn.addDays(offset);
      final at = DateTime(day.year, day.month, day.day, hour);
      if (!at.isAfter(now)) continue;
      result.add(Reminder(at: at, title: title, body: what));
    }
  }
  result.sort((a, b) => a.at.compareTo(b.at));
  return result.take(max).toList();
}

abstract interface class ReminderScheduler {
  /// Whether iOS currently allows this app to show notifications.
  Future<bool> isPermitted();

  /// Shows the system permission prompt (only once per install on iOS).
  Future<bool> requestPermission();

  /// Cancels every pending reminder and schedules [reminders].
  Future<void> replaceAll(List<Reminder> reminders);
}
