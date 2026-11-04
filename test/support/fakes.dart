import 'dart:typed_data';

import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/backup/backup.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';

/// In-memory stores for UI tests and screenshots. Storage semantics are
/// tested against the real encrypted database elsewhere.
class FakePrefs implements PreferencesStore {
  FakePrefs([this.theme = AppTheme.system]);
  AppTheme theme;
  @override
  Future<AppTheme> open() async => theme;
  @override
  Future<void> setTheme(AppTheme value) async => theme = value;
  @override
  Future<void> close() async {}
}

class FakeAccountsStore implements AccountsStore {
  @override
  Future<void> updateAccountDetails(
    String accountId, {
    required String name,
    Money? creditLimit,
  }) async {}

  FakeAccountsStore([List<AccountSummary>? list]) : list = list ?? [];
  final List<AccountSummary> list;
  @override
  Future<List<AccountSummary>> accounts() async => List.of(list);
  @override
  Future<void> createAccount(NewAccount a) async => list.add(
    AccountSummary(
      id: 'acc${list.length}',
      name: a.name,
      kind: a.kind,
      amount: a.amount,
      isProtected: a.isProtected,
      creditLimit: a.creditLimit,
      lastUpdatedAt: DateTime.now(),
    ),
  );
  @override
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> m) async =>
      BalanceUpdateResult(changed: m.length, unexplained: Money(0));
  @override
  Future<void> setIncludedInForecast(String id, bool included) async {}
}

class FakePaymentsStore implements PaymentsStore {
  FakePaymentsStore({
    List<PlannedFlow>? flows,
    Map<String, CardFigures>? figures,
    Map<String, String>? cards,
  }) : flows = flows ?? [],
       figures = figures ?? {},
       cards = cards ?? {};
  final List<PlannedFlow> flows;
  final Map<String, CardFigures> figures;
  final Map<String, String> cards;
  final marks = <(String, CalendarDate)>{};
  @override
  Future<PaymentsSnapshot> payments() async => PaymentsSnapshot(
    flows: List.of(flows),
    doneMarks: Set.of(marks),
    cardFigures: Map.of(figures),
    creditCards: Map.of(cards),
  );
  @override
  Future<void> saveFlow(PlannedFlow flow) async => flows.add(flow);
  @override
  Future<void> archiveFlow(String id) async =>
      flows.removeWhere((f) => f.id == id);
  @override
  Future<void> setFlowDone(String id, CalendarDate due, bool done) async =>
      done ? marks.add((id, due)) : marks.remove((id, due));
  @override
  Future<void> saveCardFigures(CardFigures f) async => figures[f.accountId] = f;
  @override
  Future<void> setCardSettled(String id, bool settled) async {}
}

class FakeHouseholdStore implements HouseholdStore {
  Money value = Money(1000000);
  @override
  Future<Money> reserve() async => value;
  @override
  Future<void> setReserve(Money reserve) async => value = reserve;
}

class FakeBackupStore implements BackupStore {
  FakeBackupStore({this.empty = false});
  bool empty;
  @override
  Future<Uint8List> exportBackup(String password) async => Uint8List(3);
  @override
  Future<bool> canRestore() async => empty;
  @override
  Future<void> restoreBackup(Uint8List file, String password) async {}
}

AccountSummary account(
  String id,
  String name,
  AccountKind kind,
  int kopecks, {
  bool protected = false,
  int? limit,
  int daysAgo = 0,
}) => AccountSummary(
  id: id,
  name: name,
  kind: kind,
  amount: Money(kopecks),
  isProtected: protected,
  creditLimit: limit == null ? null : Money(limit),
  lastUpdatedAt: DateTime.now().subtract(Duration(days: daysAgo)),
);

/// Realistic synthetic data close to the owner's first device test.
({List<AccountSummary> accounts, FakePaymentsStore payments}) sampleData({
  bool complete = true,
  bool longNames = false,
}) {
  final today = CalendarDate.today();
  final accounts = [
    account(
      'sber',
      longNames ? 'Дебетовая карта Сбера для повседневных покупок' : 'Сбер',
      AccountKind.debit,
      2873152,
    ),
    account('alfa', 'Альфа', AccountKind.debit, 20000),
    account('cash', 'Наличные', AccountKind.cash, 350000, daysAgo: 1),
    account(
      'pillow',
      'Подушка',
      AccountKind.savings,
      15000000,
      protected: true,
    ),
    account(
      'alfa-cc',
      longNames
          ? 'Кредитная карта Альфа-Банка «Год без процентов»'
          : 'Кредитка Альфа',
      AccountKind.creditCard,
      1629654,
      limit: 2000000,
    ),
  ];
  final flows = <PlannedFlow>[
    if (complete)
      PlannedFlow(
        id: 'salary',
        kind: FlowKind.salary,
        name: 'Зарплата',
        amount: Money(8000000),
        cadence: Once(today.addDays(12)),
        startsOn: today,
      ),
    PlannedFlow(
      id: 'net',
      kind: FlowKind.communication,
      name: 'Интернет',
      amount: Money(70000),
      cadence: Once(today.addDays(1)),
      startsOn: today,
    ),
    PlannedFlow(
      id: 'music',
      kind: FlowKind.subscription,
      name: 'Музыка',
      amount: Money(29900),
      cadence: Once(today.addDays(5)),
      startsOn: today,
    ),
  ];
  return (
    accounts: accounts,
    payments: FakePaymentsStore(
      flows: flows,
      cards: {'alfa-cc': accounts.last.name},
      figures: {
        if (complete)
          'alfa-cc': CardFigures(
            id: 'cf',
            accountId: 'alfa-cc',
            graceAmount: Money(1629654),
            graceDueOn: today.addDays(8),
            minPayment: Money(81483),
            minDueOn: today.addDays(8),
          ),
      },
    ),
  );
}
