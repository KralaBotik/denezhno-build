import 'dart:async';

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:denezhno/ui/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart' show FakePaymentsStore;

const nb = ' ';

class _Prefs implements PreferencesStore {
  @override
  Future<AppTheme> open() async => AppTheme.system;
  @override
  Future<void> setTheme(AppTheme theme) async {}
  @override
  Future<void> close() async {}
}

/// In-memory stand-in for the UI only; ledger semantics are tested on the
/// real encrypted database in ledger_test.dart.
class FakeAccounts implements AccountsStore {
  @override
  Future<void> updateAccountDetails(
    String accountId, {
    required String name,
    Money? creditLimit,
  }) async {}

  @override
  Future<void> setIncludedInForecast(String id, bool included) async {
    final i = list.indexWhere((a) => a.id == id);
    final a = list[i];
    list[i] = AccountSummary(
      id: a.id,
      name: a.name,
      kind: a.kind,
      amount: a.amount,
      isProtected: !included,
      creditLimit: a.creditLimit,
      lastUpdatedAt: a.lastUpdatedAt,
    );
  }

  final list = <AccountSummary>[];
  final updates = <Map<String, Money>>[];
  final answers = <Map<PendingKey, bool>>[];
  bool failWrites = false;
  @override
  Future<List<AccountSummary>> accounts() async => List.of(list);
  @override
  Future<void> createAccount(NewAccount a) async {
    if (failWrites) throw StateError('synthetic');
    list.add(
      AccountSummary(
        id: 'id${list.length}',
        name: a.name,
        kind: a.kind,
        amount: a.amount,
        isProtected: a.isProtected,
        creditLimit: a.creditLimit,
        lastUpdatedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> m, {
    Map<PendingKey, bool> pending = const {},
  }) async {
    updates.add(m);
    answers.add(pending);
    var net = Money(0);
    for (var i = 0; i < list.length; i++) {
      final a = list[i];
      final v = m[a.id];
      if (v == null) continue;
      final diff = v - a.amount;
      net = net + (a.kind.isLiability ? -diff : diff);
      list[i] = AccountSummary(
        id: a.id,
        name: a.name,
        kind: a.kind,
        amount: v,
        isProtected: a.isProtected,
        creditLimit: a.creditLimit,
        lastUpdatedAt: DateTime.now(),
      );
    }
    return BalanceUpdateResult(changed: m.length, unexplained: net);
  }
}

void main() {
  Future<void> openAccounts(
    WidgetTester tester,
    FakeAccounts store, {
    FakePaymentsStore? payments,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(store),
          if (payments != null)
            paymentsStoreProvider.overrideWithValue(payments),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('tab.accounts')));
    await tester.pumpAndSettle();
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('empty state leads to adding a debit card', (tester) async {
    final store = FakeAccounts();
    await openAccounts(tester, store);
    expect(find.text('Пока нет счетов'), findsOneWidget);
    await tapKey(tester, 'accounts.addFirst');
    expect(find.byKey(const ValueKey('screen.addAccount')), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.name')),
      'Сбер',
    );
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.amount')),
      '12 345,67',
    );
    await tapKey(tester, 'addAccount.save');
    expect(store.list.single.amount, Money(1234567));
    expect(store.list.single.kind, AccountKind.debit);
    expect(find.byKey(const ValueKey('screen.accounts')), findsOneWidget);
    expect(find.text('12${nb}345,67$nb₽'), findsWidgets);
    expect(find.text('Обновить остатки'), findsOneWidget);
  });

  testWidgets('invalid input is rejected and nothing is saved', (tester) async {
    final store = FakeAccounts();
    await openAccounts(tester, store);
    await tapKey(tester, 'accounts.addFirst');
    await tapKey(tester, 'addAccount.save');
    expect(find.text('Введите название'), findsOneWidget);
    await tester.enterText(find.byKey(const ValueKey('addAccount.name')), 'X');
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.amount')),
      '12,345',
    );
    await tapKey(tester, 'addAccount.save');
    expect(find.text('Введите сумму, например 12 345,67'), findsOneWidget);
    expect(store.list, isEmpty);
  });

  testWidgets('credit card: debt and limit, savings protected by default', (
    tester,
  ) async {
    final store = FakeAccounts();
    await openAccounts(tester, store);
    await tapKey(tester, 'accounts.addFirst');
    await tapKey(tester, 'kind.creditCard');
    expect(find.text('Сколько сейчас должны банку'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.name')),
      'Альфа',
    );
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.amount')),
      '15000',
    );
    await tester.enterText(
      find.byKey(const ValueKey('addAccount.limit')),
      '100000',
    );
    await tapKey(tester, 'addAccount.save');
    expect(store.list.single.kind, AccountKind.creditCard);
    expect(store.list.single.creditLimit, Money(10000000));
    expect(find.text('Долги'), findsWidgets);

    await tapKey(tester, 'accounts.add');
    await tapKey(tester, 'kind.savings');
    final toggle = tester.widget<CupertinoSwitch>(
      find.byKey(const ValueKey('addAccount.protected')),
    );
    expect(toggle.value, true);
  });

  testWidgets('update balances: typed value, «не изменилось», banner', (
    tester,
  ) async {
    final store = FakeAccounts()
      ..list.addAll([
        AccountSummary(
          id: 'a',
          name: 'Т-Банк',
          kind: AccountKind.debit,
          amount: Money(5000000),
          isProtected: false,
        ),
        AccountSummary(
          id: 'b',
          name: 'Нал',
          kind: AccountKind.cash,
          amount: Money(300000),
          isProtected: false,
        ),
        AccountSummary(
          id: 'c',
          name: 'Сбер кредитка',
          kind: AccountKind.creditCard,
          amount: Money(0),
          isProtected: false,
        ),
      ]);
    await openAccounts(tester, store, payments: FakePaymentsStore());
    expect(find.byKey(const ValueKey('total.own')), findsOneWidget);
    await tapKey(tester, 'accounts.update');
    await tester.enterText(find.byKey(const ValueKey('balance.a')), '46 800');
    await tapKey(tester, 'unchanged.b');
    // Card left empty: it is not touched.
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates.single, {'a': Money(4680000), 'b': Money(300000)});
    expect(
      find.text('Остатки обновлены. Неучтённые расходы: 3${nb}200$nb₽'),
      findsOneWidget,
    );
  });

  testWidgets('save failure keeps the form and says nothing changed', (
    tester,
  ) async {
    final store = FakeAccounts()..failWrites = true;
    await openAccounts(tester, store);
    await tapKey(tester, 'accounts.addFirst');
    await tester.enterText(find.byKey(const ValueKey('addAccount.name')), 'X');
    await tapKey(tester, 'addAccount.save');
    expect(
      find.text('Не удалось сохранить. Данные не изменены.'),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('screen.addAccount')), findsOneWidget);
  });
  testWidgets('an account can be excluded from «можно потратить»', (
    tester,
  ) async {
    final store = FakeAccounts()
      ..list.add(
        AccountSummary(
          id: 'g',
          name: 'Общая',
          kind: AccountKind.debit,
          amount: Money(5000000),
          isProtected: false,
        ),
      );
    await openAccounts(tester, store);
    await tapKey(tester, 'account.g');
    expect(find.text('Учитывать в «можно потратить»'), findsWidgets);
    await tapKey(tester, 'account.included');
    expect(store.list.single.isProtected, true);
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('не в расчёте'), findsOneWidget);
  });

  testWidgets('update balances: a question per side of a transfer, only for '
      'the accounts being confirmed now; no default', (tester) async {
    final store = FakeAccounts()
      ..list.addAll([
        AccountSummary(
          id: 'sber',
          name: 'Сбер',
          kind: AccountKind.debit,
          amount: Money(600000),
          isProtected: false,
          lastUpdatedAt: DateTime.now(),
        ),
        AccountSummary(
          id: 'card',
          name: 'Кредитка',
          kind: AccountKind.creditCard,
          amount: Money(1100000),
          isProtected: false,
          lastUpdatedAt: DateTime.now(),
        ),
      ]);
    final payments = FakePaymentsStore()
      ..pending.addAll([
        PendingSide(
          paymentId: 'pay1',
          title: 'Погашение',
          amount: Money(400000),
          accountId: 'sber',
          paidOn: CalendarDate.today(),
          incoming: false,
        ),
        PendingSide(
          paymentId: 'pay1',
          title: 'Погашение',
          amount: Money(400000),
          accountId: 'card',
          paidOn: CalendarDate.today(),
          incoming: true,
        ),
      ]);
    await openAccounts(tester, store, payments: payments);
    await tapKey(tester, 'accounts.update');
    // Nothing is being confirmed yet: no questions.
    expect(find.byKey(const ValueKey('pending.card')), findsNothing);

    // Only the debit account: only «Банк уже списал деньги?».
    await tester.enterText(find.byKey(const ValueKey('balance.sber')), '10000');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pending.pay1.sber')), findsOneWidget);
    expect(find.byKey(const ValueKey('pending.pay1.card')), findsNothing);
    expect(find.text('«Сбер»: Банк уже списал деньги?'), findsOneWidget);
    expect(find.text('Ещё не списано'), findsOneWidget);
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates, isEmpty); // not answered: nothing written
    expect(find.text('Ответьте на каждый вопрос выше'), findsOneWidget);

    // The card is confirmed too (the bank's figure typed in): its own
    // question about the credit.
    await tester.enterText(find.byKey(const ValueKey('balance.card')), '11000');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pending.pay1.card')), findsOneWidget);
    expect(find.text('«Кредитка»: Банк уже зачислил перевод?'), findsOneWidget);
    expect(find.text('Ещё не зачислено'), findsOneWidget);
    await tapKey(tester, 'pending.pay1.sber.no');
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates, isEmpty); // the card is not answered yet
    await tapKey(tester, 'pending.pay1.card.yes');
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates.single, {
      'sber': Money(1000000),
      'card': Money(1100000),
    });
    expect(store.answers.single, {
      (paymentId: 'pay1', accountId: 'sber'): false,
      (paymentId: 'pay1', accountId: 'card'): true,
    });
  });

  testWidgets('update balances: a side on an account not confirmed now is not '
      'asked and not sent', (tester) async {
    final store = FakeAccounts()
      ..list.addAll([
        AccountSummary(
          id: 'sber',
          name: 'Сбер',
          kind: AccountKind.debit,
          amount: Money(600000),
          isProtected: false,
          lastUpdatedAt: DateTime.now(),
        ),
        AccountSummary(
          id: 'card',
          name: 'Кредитка',
          kind: AccountKind.creditCard,
          amount: Money(1100000),
          isProtected: false,
          lastUpdatedAt: DateTime.now(),
        ),
      ]);
    final payments = FakePaymentsStore()
      ..pending.add(
        PendingSide(
          paymentId: 'pay1',
          title: 'Погашение',
          amount: Money(400000),
          accountId: 'card',
          paidOn: CalendarDate.today(),
          incoming: true,
        ),
      );
    await openAccounts(tester, store, payments: payments);
    await tapKey(tester, 'accounts.update');
    await tester.enterText(find.byKey(const ValueKey('balance.sber')), '6000');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pending.card')), findsNothing);
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates.single, {'sber': Money(600000)});
    expect(store.answers.single, isEmpty);
  });

  testWidgets('«Не изменилось» is off for an account with a payment side still '
      'to come (and while that is loading); others keep the quick input', (
    tester,
  ) async {
    AccountSummary acc(String id, String name, AccountKind kind, int minor) =>
        AccountSummary(
          id: id,
          name: name,
          kind: kind,
          amount: Money(minor),
          isProtected: false,
          lastUpdatedAt: DateTime.now(),
        );
    final store = FakeAccounts()
      ..list.addAll([
        // The app's balances already contain the 4 000 transfer.
        acc('sber', 'Сбер', AccountKind.debit, 600000),
        acc('card', 'Кредитка', AccountKind.creditCard, 1100000),
        acc('cash', 'Наличные', AccountKind.cash, 50000),
      ]);
    final gate = Completer<void>();
    final payments = FakePaymentsStore()
      ..pendingGate = gate
      ..pending.addAll([
        for (final (account, incoming) in [('sber', false), ('card', true)])
          PendingSide(
            paymentId: 'pay1',
            title: 'Погашение',
            amount: Money(400000),
            accountId: account,
            paidOn: CalendarDate.today(),
            incoming: incoming,
          ),
      ]);
    await openAccounts(tester, store, payments: payments);
    await tapKey(tester, 'accounts.update');
    PillButton unchanged(String id) =>
        tester.widget<PillButton>(find.byKey(ValueKey('unchanged.$id')));
    String field(String id) => tester
        .widget<CupertinoTextField>(find.byKey(ValueKey('balance.$id')))
        .controller!
        .text;

    // Still loading: off for every account.
    for (final id in ['sber', 'card', 'cash']) {
      expect(unchanged(id).onPressed, isNull, reason: id);
    }
    gate.complete();
    await tester.pumpAndSettle();

    expect(unchanged('sber').onPressed, isNull);
    expect(unchanged('card').onPressed, isNull);
    expect(unchanged('cash').onPressed, isNotNull);
    expect(find.byKey(const ValueKey('unchanged.hint.sber')), findsOneWidget);
    expect(find.byKey(const ValueKey('unchanged.hint.card')), findsOneWidget);
    expect(find.byKey(const ValueKey('unchanged.hint.cash')), findsNothing);
    expect(find.text('Введите сумму из банка'), findsNWidgets(2));

    // Tapping it does not copy the app's 6 000 (which contains the transfer).
    await tapKey(tester, 'unchanged.sber');
    expect(field('sber'), isEmpty);
    expect(find.byKey(const ValueKey('pending.card')), findsNothing);
    // The quick input still works where nothing is pending.
    await tapKey(tester, 'unchanged.cash');
    expect(field('cash'), isNotEmpty);
    expect(find.byKey(const ValueKey('pending.card')), findsNothing);

    // The bank's figure typed in: a question only about that account.
    await tester.enterText(find.byKey(const ValueKey('balance.sber')), '10000');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('pending.pay1.sber')), findsOneWidget);
    expect(find.byKey(const ValueKey('pending.pay1.card')), findsNothing);
    await tapKey(tester, 'pending.pay1.sber.no');
    await tapKey(tester, 'updateBalances.save');
    expect(store.updates.single, {
      'sber': Money(1000000),
      'cash': Money(50000),
    });
    expect(store.answers.single, {
      (paymentId: 'pay1', accountId: 'sber'): false,
    });
  });
}
