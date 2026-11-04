import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
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

/// In-memory stand-in for the UI only; ledger semantics are tested on the
/// real encrypted database in ledger_test.dart.
class FakeAccounts implements AccountsStore {
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
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> m) async {
    updates.add(m);
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
  Future<void> openAccounts(WidgetTester tester, FakeAccounts store) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(_Prefs()),
          accountsStoreProvider.overrideWithValue(store),
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
    await openAccounts(tester, store);
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
    expect(find.text('Учитывать в «можно потратить»'), findsOneWidget);
    await tapKey(tester, 'account.included');
    expect(store.list.single.isProtected, true);
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();
    expect(find.textContaining('не в расчёте'), findsOneWidget);
  });
}
