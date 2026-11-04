import 'dart:typed_data';

import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/backup/backup.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:denezhno/features/operations/operations.dart';
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

/// Income in memory with the same plan/expectation/fact rules as the
/// database (receipts are not booked in a journal here).
class FakeIncomeStore implements IncomeStore {
  FakeIncomeStore([List<IncomeSource>? sources]) : sources = sources ?? [];
  final List<IncomeSource> sources;
  final stored = <PaymentKey, StoredPayment>{};
  ForecastPeriod period = defaultForecastPeriod;
  var _n = 0;

  @override
  Future<IncomeSnapshot> income() async => IncomeSnapshot(
    sources: List.of(sources),
    payments: buildPayments(
      sources,
      stored.values.toList(),
      CalendarDate.today().addDays(62),
    ),
  );

  @override
  Future<String> createIncomeSource({
    required String name,
    required IncomeKind kind,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  }) async {
    final id = 'src${_n++}';
    final today = CalendarDate.today();
    sources.add(
      IncomeSource(
        id: id,
        name: name,
        kind: kind,
        holidayRule: holidayRule,
        trackedFrom: today,
        accountId: accountId,
        parts: [
          for (final p in parts)
            SchedulePart(
              id: 'part${_n++}',
              label: p.label,
              amount: p.amount,
              cadence: p.cadence,
              validFrom: today,
            ),
        ],
      ),
    );
    return id;
  }

  @override
  Future<void> updateIncomeSchedule(
    String sourceId, {
    required String name,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
  }) async {
    final i = sources.indexWhere((s) => s.id == sourceId);
    final old = sources[i];
    sources[i] = IncomeSource(
      id: old.id,
      name: name,
      kind: old.kind,
      holidayRule: holidayRule,
      trackedFrom: old.trackedFrom,
      accountId: accountId,
      parts: [
        for (final p in parts)
          SchedulePart(
            id: p.id ?? 'part${_n++}',
            label: p.label,
            amount: p.amount,
            cadence: p.cadence,
            validFrom: old.trackedFrom,
          ),
      ],
    );
  }

  @override
  Future<void> archiveIncomeSource(String sourceId) async =>
      sources.removeWhere((s) => s.id == sourceId);

  StoredPayment _row(PaymentKey key) {
    final existing = stored[key];
    if (existing != null) return existing;
    final part = sources
        .expand((s) => s.parts)
        .firstWhere((p) => p.id == key.partId);
    return StoredPayment(
      id: 'pay${_n++}',
      sourceId: key.sourceId,
      partId: key.partId,
      plannedOn: key.plannedOn,
      plannedAmount: part.amount,
      expectedOn: null,
      dateUnknown: false,
      expectedAmount: null,
      state: PaymentState.open,
      receipts: const [],
    );
  }

  void _put(
    PaymentKey key, {
    CalendarDate? Function(StoredPayment)? expectedOn,
    bool? dateUnknown,
    Money? Function(StoredPayment)? expectedAmount,
    PaymentState? state,
    List<Receipt>? receipts,
  }) {
    final r = _row(key);
    stored[key] = StoredPayment(
      id: r.id,
      sourceId: r.sourceId,
      partId: r.partId,
      plannedOn: r.plannedOn,
      plannedAmount: r.plannedAmount,
      expectedOn: expectedOn == null ? r.expectedOn : expectedOn(r),
      dateUnknown: dateUnknown ?? r.dateUnknown,
      expectedAmount: expectedAmount == null
          ? r.expectedAmount
          : expectedAmount(r),
      state: state ?? r.state,
      receipts: receipts ?? r.receipts,
    );
  }

  @override
  Future<void> movePayment(PaymentKey key, CalendarDate to) async =>
      _put(key, expectedOn: (_) => to, dateUnknown: false);
  @override
  Future<void> markPaymentDateUnknown(PaymentKey key) async =>
      _put(key, expectedOn: (_) => null, dateUnknown: true);
  @override
  Future<void> setPaymentAmount(PaymentKey key, Money amount) async =>
      _put(key, expectedAmount: (_) => amount);
  @override
  Future<void> cancelPayment(PaymentKey key) async =>
      _put(key, state: PaymentState.cancelled);
  @override
  Future<void> reopenPayment(PaymentKey key) async =>
      _put(key, state: PaymentState.open);

  final previews = <(PaymentKey, Money)>[];

  @override
  Future<OperationPreview> previewReceipt(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    SameDayPlacement placement = SameDayPlacement.auto,
  }) async {
    previews.add((key, amount));
    return OperationPreview(
      balances: {accountId: (Money(0), amount)},
      inConfirmedBalance: false,
      confirmedAt: null,
      sameDayChoice: false,
      placement: SameDayPlacement.afterConfirmedBalance,
      unexplainedChange: Money(0),
    );
  }

  @override
  Future<void> receivePayment(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required SameDayPlacement placement,
    ShortfallChoice shortfall = ShortfallChoice.restLater,
    CalendarDate? restOn,
  }) async {
    final r = _row(key);
    final receipts = [
      ...r.receipts,
      Receipt(
        id: 'rcp${_n++}',
        entryId: 'e${_n++}',
        amount: amount,
        receivedOn: date,
        cancelled: false,
        accountId: accountId,
      ),
    ];
    final total = receipts.fold(Money(0), (s, x) => s + x.amount);
    final expected = r.expectedAmount ?? r.plannedAmount;
    if (total.minorUnits >= expected.minorUnits) {
      _put(key, receipts: receipts, state: PaymentState.received);
    } else if (shortfall == ShortfallChoice.wholePayment) {
      _put(
        key,
        receipts: receipts,
        state: PaymentState.received,
        expectedAmount: (_) => total,
      );
    } else {
      _put(
        key,
        receipts: receipts,
        expectedOn: (_) => restOn,
        dateUnknown: restOn == null,
      );
    }
  }

  @override
  Future<void> cancelReceipt(String receiptId) async {
    for (final e in stored.entries.toList()) {
      if (e.value.receipts.any((r) => r.id == receiptId)) {
        _put(
          e.key,
          state: PaymentState.open,
          receipts: [
            for (final r in e.value.receipts)
              r.id == receiptId
                  ? Receipt(
                      id: r.id,
                      entryId: r.entryId,
                      amount: r.amount,
                      receivedOn: r.receivedOn,
                      cancelled: true,
                      accountId: r.accountId,
                    )
                  : r,
          ],
        );
      }
    }
  }

  @override
  Future<ForecastPeriod> forecastPeriod() async => period;
  @override
  Future<void> setForecastPeriod(ForecastPeriod p) async => period = p;
}

/// A salary source «Работа» with an advance in [advanceIn] days and the
/// salary later, as one-off dates (deterministic for tests).
FakeIncomeStore salaryIncome({
  int advanceIn = 12,
  int advance = 4000000,
  int salaryIn = 27,
  int salary = 6000000,
  String accountId = 'sber',
  CalendarDate? trackedFrom,
}) {
  final today = CalendarDate.today();
  return FakeIncomeStore([
    IncomeSource(
      id: 'work',
      name: 'Работа',
      kind: IncomeKind.salary,
      holidayRule: HolidayRule.none,
      trackedFrom: trackedFrom ?? today,
      accountId: accountId,
      parts: [
        SchedulePart(
          id: 'advance',
          label: 'Аванс',
          amount: Money(advance),
          cadence: Once(today.addDays(advanceIn)),
          validFrom: trackedFrom ?? today,
        ),
        SchedulePart(
          id: 'salary',
          label: 'Зарплата',
          amount: Money(salary),
          cadence: Once(today.addDays(salaryIn)),
          validFrom: trackedFrom ?? today,
        ),
      ],
    ),
  ]);
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
({
  List<AccountSummary> accounts,
  FakePaymentsStore payments,
  FakeIncomeStore income,
})
sampleData({bool complete = true, bool longNames = false}) {
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
    income: complete ? salaryIncome() : FakeIncomeStore(),
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
