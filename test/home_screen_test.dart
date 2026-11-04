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

import 'support/fakes.dart' show FakeIncomeStore, salaryIncome;

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
    FakeIncomeStore? income,
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
          incomeStoreProvider.overrideWithValue(income ?? FakeIncomeStore()),
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
      income: salaryIncome(advanceIn: 10, accountId: 'Карта'),
    );
    // 30 700 − 700 − 10 000 reserve = 20 000; 10 days → 2 000 per day.
    expect(plain(tester, 'home.available'), '20${nb}000$nb₽');
    expect(find.text('≈ 2${nb}000$nb₽ в день · 10 дн.'), findsOneWidget);
    expect(find.textContaining('Можно потратить до '), findsOneWidget);
    expect(find.text('Данные заполнены'), findsOneWidget);
    // «Как считаем» is collapsed until tapped.
    expect(find.text('Платежи до этой даты: 1'), findsNothing);
    await tester.ensureVisible(find.byKey(const ValueKey('home.breakdown')));
    await tester.pumpAndSettle();
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
    // No salary date: an explicit 14-day period, never «до зарплаты».
    expect(find.text('На 14 дней не хватает'), findsOneWidget);
    // Missing salary makes the figure preliminary, with a one-tap fix.
    expect(find.text('Предварительный расчёт'), findsOneWidget);
    expect(find.text('Укажите зарплату — дату и сумму'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('fix.salary')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.salarySchedule')), findsOneWidget);
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

  Finder byKeyPrefix(String prefix) => find.byWidgetPredicate(
    (w) =>
        w.key is ValueKey<String> &&
        (w.key! as ValueKey<String>).value.startsWith(prefix),
  );

  testWidgets('Э3: overdue advance is not counted; «Получено» is confirmed '
      'before it is written and restores the salary horizon', (tester) async {
    final today = CalendarDate.today();
    final income = salaryIncome(
      advanceIn: -3,
      salaryIn: 20,
      accountId: 'Карта',
      trackedFrom: today.addDays(-5),
    );
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 24000)],
      payments: FakePayments(),
      income: income,
    );
    // 24 000 − 10 000 reserve, the advance NOT added, 14-day period.
    expect(plain(tester, 'home.available'), '≈ 14${nb}000$nb₽');
    expect(find.text('Расчёт на 14 дней'), findsOneWidget);
    expect(byKeyPrefix('fix.salaryOverdue'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const ValueKey('salary.received')));
    await tester.tap(find.byKey(const ValueKey('salary.received')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.receive')), findsOneWidget);
    // The check is shown first; nothing is written yet.
    expect(find.byKey(const ValueKey('receive.change')), findsOneWidget);
    expect(income.stored, isEmpty);
    await tester.tap(find.byKey(const ValueKey('receive.confirm')));
    await tester.pumpAndSettle();
    expect(income.stored.values.single.receipts.single.amount, Money(4000000));
    expect(byKeyPrefix('fix.salaryOverdue'), findsNothing);
    expect(find.textContaining('Можно потратить до '), findsOneWidget);
  });

  testWidgets('Э3: partial advance — the rest stays expected, date unknown', (
    tester,
  ) async {
    final today = CalendarDate.today();
    final income = salaryIncome(
      advanceIn: -3,
      salaryIn: 20,
      accountId: 'Карта',
      trackedFrom: today.addDays(-5),
    );
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 24000)],
      payments: FakePayments(),
      income: income,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('salary.received')));
    await tester.tap(find.byKey(const ValueKey('salary.received')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('receive.amount')),
      '15000',
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('receive.less')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('receive.confirm')));
    await tester.pumpAndSettle();
    final pay = income.stored.values.single;
    expect(
      (pay.receipts.single.amount, pay.dateUnknown),
      (Money(1500000), true),
    );
    // Still waiting for 25 000 with no date: a labelled period.
    expect(byKeyPrefix('fix.salaryUnknown'), findsOneWidget);
    expect(byKeyPrefix('note.salaryPartial'), findsOneWidget);
    expect(find.text('Расчёт на 14 дней'), findsOneWidget);
  });

  testWidgets('Э3: «Не знаю когда» on one payment does not touch others', (
    tester,
  ) async {
    final today = CalendarDate.today();
    final income = salaryIncome(
      advanceIn: -3,
      salaryIn: 20,
      accountId: 'Карта',
      trackedFrom: today.addDays(-5),
    );
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 24000)],
      payments: FakePayments(),
      income: income,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('salary.details')));
    await tester.tap(find.byKey(const ValueKey('salary.details')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.incomePayment')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('payment.unknown')));
    await tester.pumpAndSettle();
    expect(income.stored.values.single.dateUnknown, true);
    expect(income.stored.keys.single.partId, 'advance');
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();
    expect(byKeyPrefix('fix.salaryUnknown'), findsOneWidget);
  });

  testWidgets('Э1: period can be changed to 7 / 30 days', (tester) async {
    await launch(
      tester,
      accounts: [acc('Карта', AccountKind.debit, 24000)],
      payments: FakePayments(),
    );
    expect(find.text('Расчёт на 14 дней'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home.period')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period.7')));
    await tester.pumpAndSettle();
    expect(find.text('Расчёт на 7 дней'), findsOneWidget);
    expect(find.text('≈ 2${nb}000$nb₽ в день · 7 дн.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home.period')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('period.30')));
    await tester.pumpAndSettle();
    expect(find.text('Расчёт на 30 дней'), findsOneWidget);
  });

  testWidgets('Э1: card without figures — debt shown, not subtracted, '
      'information scenario', (tester) async {
    final today = CalendarDate.today();
    final payments = FakePayments()
      ..flows.addAll([
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
      accounts: [
        acc('Карта', AccountKind.debit, 30000),
        acc('Кредитка Альфа', AccountKind.creditCard, 16000),
      ],
      payments: payments,
      income: salaryIncome(advanceIn: 10, accountId: 'Карта'),
    );
    // 30 000 − 700 − 10 000; the card debt is NOT subtracted.
    expect(plain(tester, 'home.available'), '≈ 19${nb}300$nb₽');
    expect(plain(tester, 'home.debts'), '16${nb}000$nb₽');
    expect(plain(tester, 'home.obligationsAmount'), '700$nb₽');
    expect(
      find.text(
        '«Кредитка Альфа»: долг 16${nb}000$nb₽, обязательный платёж '
        'неизвестен. Внесите цифры банка.',
      ),
      findsOneWidget,
    );
    final scenario = find.byKey(const ValueKey('scenario.allDebts'));
    await tester.ensureVisible(scenario);
    // 19 300 + 0 towards debts − 16 000 = 3 300; information only.
    expect(
      find.descendant(
        of: scenario,
        matching: find.text('Если погасить все долги сейчас'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: scenario,
        matching: find.textContaining('а не сумма на траты'),
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.byKey(const ValueKey('home.breakdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('home.breakdown')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('row.card.Кредитка Альфа')),
      findsOneWidget,
    );
    expect(find.text('платёж неизвестен — не вычтено'), findsOneWidget);
  });

  testWidgets('Э1: card with figures — grace subtracted, minimum is a '
      'separate scenario with an interest warning', (tester) async {
    final today = CalendarDate.today();
    final payments = FakePayments()
      ..figures['cc'] = CardFigures(
        id: 'f',
        accountId: 'cc',
        graceAmount: Money(1500000),
        graceDueOn: today.addDays(5),
        minPayment: Money(90000),
        minDueOn: today.addDays(5),
      );
    await launch(
      tester,
      accounts: [
        acc('Карта', AccountKind.debit, 50000),
        acc('cc', AccountKind.creditCard, 20000),
      ],
      payments: payments,
      income: salaryIncome(advanceIn: 10, accountId: 'Карта'),
    );
    // 50 000 − 15 000 − 10 000 = 25 000.
    expect(plain(tester, 'home.available'), '25${nb}000$nb₽');
    expect(plain(tester, 'home.obligationsAmount'), '15${nb}000$nb₽');
    final minimum = find.byKey(const ValueKey('scenario.minimum'));
    await tester.ensureVisible(minimum);
    expect(
      find.descendant(of: minimum, matching: find.textContaining('проценты')),
      findsOneWidget,
    );
  });
}
