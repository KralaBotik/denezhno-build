import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart' show FakeIncomeStore;

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
  Future<List<AccountSummary>> accounts() async => [
    AccountSummary(
      id: 'sber',
      name: 'Сбер',
      kind: AccountKind.debit,
      amount: Money(1000000),
      isProtected: false,
      lastUpdatedAt: DateTime.now(),
    ),
  ];
  @override
  Future<void> createAccount(NewAccount account) async {}
  @override
  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> a, {
    Set<String> notYetDebited = const {},
  }) async => BalanceUpdateResult(changed: 0, unexplained: Money(0));
}

/// UI stand-in; storage semantics are tested in payments_store_test.dart
/// and obligation_test.dart.
class FakePayments implements PaymentsStore {
  final flows = <PlannedFlow>[];
  final marks = <(String, CalendarDate)>{};
  final skippedDates = <(String, CalendarDate)>{};
  final figures = <String, CardFigures>{};
  final cards = <String, String>{'card1': 'Сбер кредитка'};
  final history = <ObligationPayment>[];
  final paidLog = <(PayTarget, Money, String)>[];
  final tracked = <String, CalendarDate>{};
  @override
  Future<PaymentsSnapshot> payments() async {
    final live = [
      for (final h in history)
        if (!h.cancelled) h,
    ];
    final paid = {
      for (final h in live)
        if (h.target case PlanDate(:final flowId, :final dueOn))
          (flowId, dueOn): h,
    };
    return PaymentsSnapshot(
      flows: List.of(flows),
      doneMarks: {...marks, ...paid.keys, ...skippedDates},
      cardFigures: {
        for (final e in figures.entries)
          e.key: CardFigures(
            id: e.value.id,
            accountId: e.value.accountId,
            graceAmount: e.value.graceAmount,
            graceDueOn: e.value.graceDueOn,
            minPayment: e.value.minPayment,
            minDueOn: e.value.minDueOn,
            paid: live
                .where((h) => h.target == CardDue(e.value.id))
                .fold<Money>(Money(0), (s, h) => s + h.amount),
            settled: live.any((h) => h.target == CardDue(e.value.id)),
          ),
      },
      creditCards: Map.of(cards),
      paid: paid,
      trackedFrom: Map.of(tracked),
      skipped: Set.of(skippedDates),
      history: List.of(history),
    );
  }

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
  Future<void> setFlowSkipped(String id, CalendarDate due, bool skip) async =>
      skip ? skippedDates.add((id, due)) : skippedDates.remove((id, due));
  @override
  Future<PaymentCheck> previewPayment(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    SameDayPlacement placement = SameDayPlacement.auto,
  }) async => PaymentCheck(
    OperationPreview(
      balances: {accountId: (Money(1000000), Money(1000000) - amount)},
      inConfirmedBalance: false,
      confirmedAt: null,
      sameDayChoice: false,
      placement: SameDayPlacement.afterConfirmedBalance,
      unexplainedChange: Money(0),
    ),
    const [],
  );
  @override
  Future<void> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required SameDayPlacement placement,
    bool confirmedNotDuplicate = false,
  }) async {
    paidLog.add((target, amount, accountId));
    history.add(
      ObligationPayment(
        id: 'p${history.length}',
        target: target,
        entryId: 'e${history.length}',
        amount: amount,
        paidOn: date,
        cancelled: false,
        accountId: accountId,
      ),
    );
  }

  @override
  Future<void> cancelObligationPayment(String paymentId) async {
    final i = history.indexWhere((h) => h.id == paymentId);
    final h = history[i];
    history[i] = ObligationPayment(
      id: h.id,
      target: h.target,
      entryId: h.entryId,
      amount: h.amount,
      paidOn: h.paidOn,
      cancelled: true,
      accountId: h.accountId,
    );
  }

  @override
  Future<List<PendingDebit>> pendingDebits() async => const [];
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
          incomeStoreProvider.overrideWithValue(FakeIncomeStore()),
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

    // One «Добавить доход»: it asks which kind. «Другой доход» opens the
    // general form with no salary option (salary has its own schedule).
    await tapKey(tester, 'income.add');
    expect(find.byKey(const ValueKey('incomeSheet.salary')), findsOneWidget);
    await tapKey(tester, 'incomeSheet.other');
    expect(find.byKey(const ValueKey('flow.incomeHint')), findsOneWidget);
    expect(find.byKey(const ValueKey('flowKind.salary')), findsNothing);
    await tester.enterText(
      find.byKey(const ValueKey('flow.name')),
      'Подработка',
    );
    await tester.enterText(find.byKey(const ValueKey('flow.amount')), '80 000');
    await tapKey(tester, 'flow.save');
    expect(store.flows.last.kind, FlowKind.otherIncome);
    expect(find.text('Интернет'), findsWidgets);
    expect(find.text('Подработка'), findsWidgets);
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
    // «Оплачено» opens the check first; nothing is written until confirmed.
    await tapKey(tester, key);
    expect(find.byKey(const ValueKey('screen.pay')), findsOneWidget);
    expect(find.byKey(const ValueKey('pay.change.sber')), findsOneWidget);
    expect(store.paidLog, isEmpty);
    await tapKey(tester, 'pay.confirm');
    expect(store.paidLog.single.$1, PlanDate('net', today.addDays(2)));
    expect(store.paidLog.single.$2, Money(70000));
    expect(store.paidLog.single.$3, 'sber');
    // Paid: the button shows when and offers to cancel (reversal).
    await tapKey(tester, key);
    expect(find.byKey(const ValueKey('sheet.cancelPayment')), findsOneWidget);
    await tapKey(tester, 'sheet.cancelPayment');
    await tapKey(tester, 'cancelPayment.confirm');
    expect(store.history.single.cancelled, true);
    // Unpaid again → «Платежа не будет».
    await tapKey(tester, key);
    await tapKey(tester, 'pay.skip');
    await tapKey(tester, 'pay.skipConfirm');
    expect(store.skippedDates, {('net', today.addDays(2))});
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
    // «Внёс» = a transfer from a money account to the card, after the check.
    await tapKey(tester, 'mark.cf.${f.graceDueOn}');
    expect(find.byKey(const ValueKey('screen.pay')), findsOneWidget);
    expect(find.textContaining('перевод между вашими счетами'), findsOneWidget);
    await tapKey(tester, 'pay.confirm');
    expect(store.paidLog.single.$1, const CardDue('cf'));
    expect(store.paidLog.single.$2, Money(840000));
    expect((await store.payments()).cardFigures['card1']!.settled, true);
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
