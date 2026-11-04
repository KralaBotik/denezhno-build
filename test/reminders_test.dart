import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/payments/reminders.dart';
import 'package:denezhno/features/payments/reminders_controller.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'payments_ui_test.dart' show FakePayments;

CalendarDate d(String s) => CalendarDate.parse(s);

UpcomingItem item(
  String title,
  String due, {
  bool done = false,
  FlowDirection dir = FlowDirection.outflow,
  UpcomingSource source = UpcomingSource.flow,
  bool minOnly = false,
}) => UpcomingItem(
  source: source,
  title: title,
  amount: Money(123456),
  dueOn: d(due),
  direction: dir,
  done: done,
  isMinimumOnly: minOnly,
);

class _Prefs implements PreferencesStore {
  @override
  Future<AppTheme> open() async => AppTheme.system;
  @override
  Future<void> setTheme(AppTheme theme) async {}
  @override
  Future<void> close() async {}
}

class _Accounts implements AccountsStore {
  @override
  Future<void> updateAccountDetails(
    String accountId, {
    required String name,
    Money? creditLimit,
  }) async {}

  @override
  Future<void> setIncludedInForecast(String id, bool included) async {}

  @override
  Future<List<AccountSummary>> accounts() async => const [];
  @override
  Future<void> createAccount(NewAccount account) async {}
  @override
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> a) async =>
      BalanceUpdateResult(changed: 0, unexplained: Money(0));
}

class FakeScheduler implements ReminderScheduler {
  bool permitted = false;
  bool grant = true;
  List<Reminder>? scheduled;
  @override
  Future<bool> isPermitted() async => permitted;
  @override
  Future<bool> requestPermission() async => permitted = grant;
  @override
  Future<void> replaceAll(List<Reminder> r) async => scheduled = r;
}

void main() {
  test('3 days before and on the day, at 10:00, outgoing and unpaid only', () {
    final now = DateTime(2026, 11, 4, 12);
    final r = planReminders([
      item('Интернет', '2026-11-10'),
      item('Зарплата', '2026-11-10', dir: FlowDirection.inflow),
      item('Аренда', '2026-11-12', done: true),
      item('Музыка', '2026-11-05'), // 3-days-before is in the past
    ], now);
    expect(
      [for (final x in r) '${x.at} ${x.title}'],
      [
        '2026-11-05 10:00:00.000 Сегодня платёж',
        '2026-11-07 10:00:00.000 Через 3 дня платёж',
        '2026-11-10 10:00:00.000 Сегодня платёж',
      ],
    );
    expect(r.first.body, '«Музыка» — 5 ноября');
  });

  test('texts never contain amounts; card wording', () {
    final r = planReminders([
      item('Сбер', '2026-11-25', source: UpcomingSource.cardGrace),
      item(
        'Альфа',
        '2026-11-25',
        source: UpcomingSource.cardGrace,
        minOnly: true,
      ),
    ], DateTime(2026, 11, 1));
    for (final x in r) {
      expect(x.body, isNot(contains('1234')));
      expect(x.body, isNot(contains('₽')));
    }
    expect(
      r.map((x) => x.body),
      contains('«Сбер»: внести до 25 ноября, чтобы не платить проценты'),
    );
    expect(
      r.map((x) => x.body),
      contains('«Альфа»: внести до 25 ноября (минимальный платёж)'),
    );
  });

  test('capped for the iOS pending-notification limit', () {
    final items = [
      for (var i = 1; i <= 28; i++)
        item('П$i', '2026-12-${'$i'.padLeft(2, '0')}'),
      for (var i = 1; i <= 28; i++)
        item('Q$i', '2027-01-${'$i'.padLeft(2, '0')}'),
    ];
    expect(planReminders(items, DateTime(2026, 11, 1)), hasLength(60));
  });

  testWidgets('enable asks permission, then schedules from payments', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final today = CalendarDate.today();
    final scheduler = FakeScheduler();
    final payments = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'n',
          kind: FlowKind.communication,
          name: 'Интернет',
          amount: Money(70000),
          cadence: Once(today.addDays(10)),
          startsOn: today,
        ),
      );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(_Accounts()),
          paymentsStoreProvider.overrideWithValue(payments),
          reminderSchedulerProvider.overrideWithValue(scheduler),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(scheduler.scheduled, isNull); // nothing without permission
    await tester.tap(find.byKey(const ValueKey('tab.payments')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('reminders.enable')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('Суммы в уведомлениях не показываются'),
      findsOneWidget,
    );
    expect(scheduler.scheduled, hasLength(2));
    expect(scheduler.scheduled!.first.body, contains('Интернет'));
  });

  testWidgets('denied permission explains where to allow it', (tester) async {
    final scheduler = FakeScheduler()..grant = false;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(_Accounts()),
          paymentsStoreProvider.overrideWithValue(FakePayments()),
          reminderSchedulerProvider.overrideWithValue(scheduler),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab.payments')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('reminders.enable')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Уведомления запрещены'), findsOneWidget);
    expect(scheduler.scheduled, isNull);
  });
}
