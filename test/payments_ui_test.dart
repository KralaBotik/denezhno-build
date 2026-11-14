import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:denezhno/ui/widgets.dart';
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
    ..._extraAccounts,
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
    Map<PendingKey, bool> pending = const {},
  }) async => BalanceUpdateResult(changed: 0, unexplained: Money(0));
}

/// Accounts a single test adds (reset after it).
var _extraAccounts = <AccountSummary>[];

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
    Map<String, ConfirmationAnswer> answers = const {},
  }) async => PaymentCheck(
    OperationPreview(
      balances: {accountId: (Money(1000000), Money(1000000) - amount)},
      inConfirmedBalance: false,
      confirmedAt: null,
      placement: SameDayPlacement.afterConfirmedBalance,
      unexplainedChange: Money(0),
      questions: List.of(questions),
    ),
    const [],
    figuresQuestion,
  );

  /// What the next preview asks (tests set them).
  final questions = <ConfirmationQuestion>[];
  FiguresQuestion? figuresQuestion;
  final paidAnswers = <(Map<String, ConfirmationAnswer>, FiguresAnswer?)>[];

  /// The next pay() fails like the store does when the data changed.
  Exception? failNextPay;
  @override
  Future<void> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required Map<String, ConfirmationAnswer> answers,
    FiguresAnswer? figuresAnswer,
    bool confirmedNotDuplicate = false,
  }) async {
    if (failNextPay case final e?) {
      failNextPay = null;
      throw e;
    }
    paidLog.add((target, amount, accountId));
    paidAnswers.add((Map.of(answers), figuresAnswer));
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
  Future<List<PendingSide>> pendingSides() async => const [];
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

  testWidgets('«Оплачено»: a question per account and its confirmation, the '
      'figures question; asked again after a newer confirmation', (
    tester,
  ) async {
    final today = CalendarDate.today();
    _extraAccounts = [
      AccountSummary(
        id: 'card1',
        name: 'Сбер кредитка',
        kind: AccountKind.creditCard,
        amount: Money(1500000),
        isProtected: false,
        lastUpdatedAt: DateTime.now(),
      ),
    ];
    addTearDown(() => _extraAccounts = []);
    final store = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'net',
          kind: FlowKind.otherPayment,
          name: 'Погашение',
          amount: Money(400000),
          cadence: Once(today.addDays(2)),
          startsOn: today,
        ),
      )
      ..questions.addAll([
        ConfirmationQuestion(
          accountId: 'sber',
          assertionId: 'a1',
          confirmedAt: DateTime(2026, 11, 9, 9),
          delta: -400000,
        ),
        ConfirmationQuestion(
          accountId: 'card1',
          assertionId: 'b1',
          confirmedAt: DateTime(2026, 11, 9, 11),
          delta: 400000,
        ),
      ])
      ..figuresQuestion = FiguresQuestion(
        figuresId: 'cf',
        due: Money(1000000),
        enteredOn: CalendarDate.parse('2026-11-08'),
      );
    await open(tester, store);
    await tapKey(tester, 'mark.net.${today.addDays(2)}');
    // Each account named with its own confirmation time.
    expect(
      find.textContaining('Остаток «Сбер» подтверждён 9 ноября, 09:00'),
      findsOneWidget,
    );
    expect(
      find.textContaining('Долг «Сбер кредитка» подтверждён 9 ноября, 11:00'),
      findsOneWidget,
    );
    expect(find.textContaining('введённая 8 ноября'), findsOneWidget);
    Future<PillButton> confirm() async {
      final button = find.byKey(const ValueKey('pay.confirm'));
      await tester.scrollUntilVisible(
        button,
        200,
        scrollable: find
            .descendant(
              of: find.byKey(const ValueKey('screen.pay')),
              matching: find.byType(Scrollable),
            )
            .first,
      );
      return tester.widget<PillButton>(button);
    }

    expect((await confirm()).onPressed, isNull); // nothing answered

    await tapKey(tester, 'confirm.sber.yes');
    // Meanwhile the debit balance is confirmed again: asked again.
    store.questions[0] = ConfirmationQuestion(
      accountId: 'sber',
      assertionId: 'a2',
      confirmedAt: DateTime(2026, 11, 9, 10),
      delta: -400000,
    );
    await tapKey(tester, 'confirm.card1.no');
    await tapKey(tester, 'pay.figures.cf.no');
    expect((await confirm()).onPressed, isNull); // «Сбер» asked again
    expect(
      find.textContaining('Остаток «Сбер» подтверждён 9 ноября, 10:00'),
      findsOneWidget,
    );
    await tapKey(tester, 'confirm.sber.yes');
    expect((await confirm()).onPressed, isNotNull);
    await tapKey(tester, 'pay.confirm');
    final (answers, figures) = store.paidAnswers.single;
    expect(
      {
        for (final e in answers.entries)
          e.key: (e.value.assertionId, e.value.included),
      },
      {'sber': ('a2', true), 'card1': ('b1', false)},
    );
    expect((figures!.figuresId, figures.included), ('cf', false));
  });

  testWidgets('«Оплачено»: newer bank figures right before saving — nothing '
      'written, the figures question is asked again', (tester) async {
    final today = CalendarDate.today();
    final store = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'net',
          kind: FlowKind.otherPayment,
          name: 'Погашение',
          amount: Money(400000),
          cadence: Once(today.addDays(2)),
          startsOn: today,
        ),
      )
      ..figuresQuestion = FiguresQuestion(
        figuresId: 'cf1',
        due: Money(1000000),
        enteredOn: CalendarDate.parse('2026-11-08'),
      );
    await open(tester, store);
    await tapKey(tester, 'mark.net.${today.addDays(2)}');
    await tapKey(tester, 'pay.figures.cf1.no');
    // The store sees a newer version (6 000, already including it).
    store
      ..failNextPay = const InvalidOperation('figures answer required')
      ..figuresQuestion = FiguresQuestion(
        figuresId: 'cf2',
        due: Money(600000),
        enteredOn: CalendarDate.parse('2026-11-08'),
      );
    await tapKey(tester, 'pay.confirm');
    expect(store.paidAnswers, isEmpty);
    expect(find.textContaining('Ничего не записано'), findsOneWidget);
    expect(find.textContaining('Сумма к оплате 6'), findsOneWidget);
    await tapKey(tester, 'pay.figures.cf2.yes');
    await tapKey(tester, 'pay.confirm');
    final (_, figures) = store.paidAnswers.single;
    expect((figures!.figuresId, figures.included), ('cf2', true));
  });

  testWidgets('«Оплачено»: the bank figures changed since the form was opened '
      '— nothing written, the screen offers to go back', (tester) async {
    final today = CalendarDate.today();
    final store = FakePayments()
      ..flows.add(
        PlannedFlow(
          id: 'net',
          kind: FlowKind.otherPayment,
          name: 'Погашение',
          amount: Money(1000000),
          cadence: Once(today.addDays(2)),
          startsOn: today,
        ),
      );
    await open(tester, store);
    await tapKey(tester, 'mark.net.${today.addDays(2)}');
    store.failNextPay = const InvalidOperation('figures changed');
    await tapKey(tester, 'pay.confirm');
    expect(store.paidAnswers, isEmpty);
    expect(
      find.textContaining('Цифры банка по этой кредитке изменились'),
      findsOneWidget,
    );
    final confirm = tester.widget<PillButton>(
      find.byKey(const ValueKey('pay.confirm')),
    );
    expect(confirm.onPressed, isNull);
    await tapKey(tester, 'pay.back');
    expect(find.byKey(const ValueKey('screen.pay')), findsNothing);
  });
}
