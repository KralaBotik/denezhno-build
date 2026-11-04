import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/controller.dart';
import '../../core/calendar_date.dart';
import 'local_reminder_scheduler.dart';
import 'payments_controller.dart';
import 'reminders.dart';

final reminderSchedulerProvider = Provider<ReminderScheduler>(
  (ref) => LocalReminderScheduler(),
);

/// `true` when reminders are allowed by iOS. While storage is open and data
/// is loaded, keeps the pending notifications in sync with «Ближайшие».
/// Never cancels reminders while storage is closed (app in background).
final remindersProvider = AsyncNotifierProvider<RemindersController, bool>(
  RemindersController.new,
);

class RemindersController extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final scheduler = ref.watch(reminderSchedulerProvider);
    final ready = ref.watch(
      appControllerProvider.select((s) => s.storage == StorageStatus.ready),
    );
    final payments = ref.watch(paymentsProvider);
    bool permitted;
    try {
      permitted = await scheduler.isPermitted();
    } on Object {
      return false;
    }
    final value = payments.value;
    if (permitted && ready && payments is AsyncData && value != null) {
      try {
        await scheduler.replaceAll(
          planReminders(
            upcomingFor(value, CalendarDate.today()),
            DateTime.now(),
          ),
        );
      } on Object {
        // Scheduling failure must not break the app; data is unaffected.
      }
    }
    return permitted;
  }

  Future<bool> enable() async {
    bool granted;
    try {
      granted = await ref.read(reminderSchedulerProvider).requestPermission();
    } on Object {
      granted = false;
    }
    if (ref.mounted) ref.invalidateSelf();
    return granted;
  }
}
