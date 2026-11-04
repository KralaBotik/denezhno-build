import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'payments_ui_test.dart' show FakePayments;

const nb = ' ';

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

  _Accounts(this.list);
  final List<AccountSummary> list;
  @override
  Future<List<AccountSummary>> accounts() async => list;
  @override
  Future<void> createAccount(NewAccount account) async {}
  @override
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> a) async =>
      BalanceUpdateResult(changed: 0, unexplained: Money(0));
}

class _Household implements HouseholdStore {
  Money value = Money(1000000);
  @override
  Future<Money> reserve() async => value;
  @override
  Future<void> setReserve(Money reserve) async => value = reserve;
}

AccountSummary acc(String name, AccountKind kind, int rubles) => AccountSummary(
  id: name,
  name: name,
  kind: kind,
  amount: Money(rubles * 100),
  isProtected: false,
  lastUpdatedAt: DateTime.now(),
);

/// Plain text of a MoneyText (rich text with smaller kopecks).
String plain(WidgetTester tester, String key) => tester
    .widget<Text>(
      find.descendant(
        of: find.byKey(ValueKey(key)),
        matching: find.byType(Text),
      ),
    )
    .textSpan!
    .toPlainText();

void main() {
  Future<_Household> launch(
    WidgetTester tester, {
    required List<AccountSummary> accounts,
    required FakePayments payments,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final household = _Household();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(_Accounts(accounts)),
          paymentsStoreProvider.overrideWithValue(payments),
          householdStoreProvider.overrideWithValue(household),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    return household;
  }

  testWidgets('no accounts: explains what to add', (tester) async {
    await launch(tester, accounts: const [], payments: FakePayments());
    expect(find.text('Начните с ваших счетов'), findsOneWidget);
    expect(find.byKey(const ValueKey('home.addAccount')), findsOneWidget);
  });

  testWidgets('shows the figure, per day and the breakdown', (tester) async {
    final today = CalendarDate.today();
    final payments = FakePayments()
      ..flows.addAll([
        PlannedFlow(
          id: 'salary',
          kind: FlowKind.salary,
          name: 'Зарплата',
          amount: Money(8000000),
          cadence: Once(today.addDays(10)),
          startsOn: today,
        ),
        PlannedFlow(
          id: 'net',
          kind: FlowKind.communication,
          name: 'Интернет',
          amount: Money(70000),
          cadence: Once(today.addDays(3)),
          startsOn: today,
        ),
      ]);
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 30700)],
      payments: payments,
    );
    // 30 700 − 700 − 10 000 reserve = 20 000; 10 days → 2 000 per day.
    expect(plain(tester, 'home.available'), '20${nb}000$nb₽');
    expect(find.text('≈ 2${nb}000$nb₽ в день · 10 дн.'), findsOneWidget);
    expect(find.textContaining('Можно потратить до '), findsOneWidget);
    expect(find.text('Точный расчёт'), findsOneWidget);
    // «Как считаем» is collapsed until tapped.
    expect(find.text('Платежи до этой даты: 1'), findsNothing);
    await tester.ensureVisible(find.byKey(const ValueKey('home.breakdown')));
    await tester.tap(find.byKey(const ValueKey('home.breakdown')));
    await tester.pumpAndSettle();
    expect(find.text('Платежи до этой даты: 1'), findsOneWidget);
    expect(find.text('Резерв (не трогаем)'), findsOneWidget);
    expect(find.text('Интернет'), findsWidgets);
  });

  testWidgets('short of money and missing salary are stated plainly', (
    tester,
  ) async {
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 4000)],
      payments: FakePayments(),
    );
    expect(plain(tester, 'home.available'), '6${nb}000$nb₽');
    expect(find.text('До конца месяца не хватает'), findsOneWidget);
    // Missing salary makes the figure preliminary, with a one-tap fix.
    expect(find.text('Предварительный расчёт'), findsOneWidget);
    expect(find.text('Укажите зарплату — дату и сумму'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('fix.salary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.flowEdit')), findsOneWidget);
  });

  testWidgets('reserve is edited in Settings and changes the figure', (
    tester,
  ) async {
    final household = await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 30000)],
      payments: FakePayments(),
    );
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('reserve.edit')));
    await tester.tap(find.byKey(const ValueKey('reserve.edit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.reserve')), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('reserve.field')), '5000');
    await tester.tap(find.byKey(const ValueKey('reserve.save')));
    await tester.pumpAndSettle();
    expect(household.value, Money(500000));
    expect(find.text('5${nb}000$nb₽'), findsOneWidget); // settings row value
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();
    expect(plain(tester, 'home.available'), '≈ 25${nb}000$nb₽');
  });
}
