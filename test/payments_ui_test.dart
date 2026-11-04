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

  @override
  Future<List<AccountSummary>> accounts() async => const [];
  @override
  Future<void> createAccount(NewAccount account) async {}
  @override
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> a) async =>
      BalanceUpdateResult(changed: 0, unexplained: Money(0));
}

/// UI stand-in; storage semantics are tested in payments_store_test.dart.
class FakePayments implements PaymentsStore {
  final flows = <PlannedFlow>[];
  final marks = <(String, CalendarDate)>{};
  final figures = <String, CardFigures>{};
  final cards = <String, String>{'card1': 'Сбер кредитка'};
  @override
  Future<PaymentsSnapshot> payments() async => PaymentsSnapshot(
    flows: List.of(flows),
    doneMarks: Set.of(marks),
    cardFigures: Map.of(figures),
    creditCards: Map.of(cards),
  );
  @override
  Future<void> saveFlow(PlannedFlow f) async {
    final i = flows.indexWhere((x) => x.id == f.id && f.id != null);
    final saved = PlannedFlow(
      id: f.id ?? 'f${flows.length}',
      kind: f.kind,
      name: f.name,
      amount: f.amount,
      cadence: f.cadence,
      startsOn: f.startsOn,
    );
    i >= 0 ? flows[i] = saved : flows.add(saved);
  }

  @override
  Future<void> archiveFlow(String id) async =>
      flows.removeWhere((f) => f.id == id);
  @override
  Future<void> setFlowDone(String id, CalendarDate due, bool done) async =>
      done ? marks.add((id, due)) : marks.remove((id, due));
  @override
  Future<void> saveCardFigures(CardFigures f) async =>
      figures[f.accountId] = CardFigures(
        id: 'cf',
        accountId: f.accountId,
        graceAmount: f.graceAmount,
        graceDueOn: f.graceDueOn,
        minPayment: f.minPayment,
        minDueOn: f.minDueOn,
      );
  @override
  Future<void> setCardSettled(String id, bool settled) async {
    final f = figures.values.single;
    figures[f.accountId] = CardFigures(
      id: f.id,
      accountId: f.accountId,
      graceAmount: f.graceAmount,
      graceDueOn: f.graceDueOn,
      minPayment: f.minPayment,
      minDueOn: f.minDueOn,
      settled: settled,
    );
  }
}

void main() {
  Future<void> open(WidgetTester tester, FakePayments store) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(_Accounts()),
          paymentsStoreProvider.overrideWithValue(store),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab.payments')));
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('add a monthly payment and an income; both show up', (
    tester,
  ) async {
    final store = FakePayments();
    await open(tester, store);
    expect(find.textContaining('Здесь появятся ближайшие'), findsOneWidget);
    await tapKey(tester, 'flow.add.outflow');
    await tester.enterText(find.byKey(const ValueKey('flow.name')), 'Интернет');
    await tester.enterText(find.byKey(const ValueKey('flow.amount')), '700');
    await tapKey(tester, 'flowKind.communication');
    await tapKey(tester, 'flow.save');
    expect(store.flows.single.kind, FlowKind.communication);
    expect(store.flows.single.amount, Money(70000));
    expect(store.flows.single.cadence, isA<Monthly>());

    await tapKey(tester, 'flow.add.inflow');
    await tester.enterText(find.byKey(const ValueKey('flow.name')), 'Зарплата');
    await tester.enterText(find.byKey(const ValueKey('flow.amount')), '80 000');
    await tapKey(tester, 'flow.save');
    expect(store.flows.last.kind, FlowKind.salary);
    expect(find.text('Интернет'), findsWidgets);
    expect(find.text('Зарплата'), findsWidgets);
    // Within 30 days each monthly plan appears in «Ближайшие».
    expect(find.text('+80${nb}000$nb₽'), findsWidgets);
  });

  testWidgets('mark an occurrence as paid and undo it', (tester) async {
    final today = CalendarDate.today();
    final store = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'net',
          kind: FlowKind.communication,
          name: 'Интернет',
          amount: Money(70000),
          cadence: Once(today.addDays(2)),
          startsOn: today,
        ),
      );
    await open(tester, store);
    final key = 'mark.net.${today.addDays(2)}';
    await tapKey(tester, key);
    expect(store.marks, {('net', today.addDays(2))});
    await tapKey(tester, key);
    expect(store.marks, isEmpty);
  });

  testWidgets('credit-card figures: enter grace amount, then settle', (
    tester,
  ) async {
    final store = FakePayments();
    await open(tester, store);
    expect(find.text('Внесите цифры из приложения банка'), findsOneWidget);
    await tapKey(tester, 'card.card1');
    await tapKey(tester, 'figures.save');
    expect(find.text('Укажите хотя бы одну сумму'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('figures.grace')), '8400');
    await tapKey(tester, 'figures.save');
    final f = store.figures['card1']!;
    expect(f.graceAmount, Money(840000));
    expect(f.graceDueOn, CalendarDate.today().addDays(20));
    expect(f.minPayment, isNull);
    expect(find.textContaining('Чтобы не платить проценты'), findsOneWidget);
    await tapKey(tester, 'mark.cf.${f.graceDueOn}');
    expect(store.figures['card1']!.settled, true);
  });

  testWidgets('edit and delete a plan', (tester) async {
    final store = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'gym',
          kind: FlowKind.subscription,
          name: 'Спортзал',
          amount: Money(300000),
          cadence: const Weekly(3),
          startsOn: CalendarDate.today(),
        ),
      );
    await open(tester, store);
    await tapKey(tester, 'flow.gym');
    expect(find.text('каждую неделю: среда'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('flow.amount')), '2500');
    await tapKey(tester, 'flow.save');
    expect(store.flows.single.amount, Money(250000));
    await tapKey(tester, 'flow.gym');
    await tapKey(tester, 'flow.delete');
    expect(store.flows, isEmpty);
  });
}
