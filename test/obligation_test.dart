import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/database/app_database.dart' hide CardFigures;
import 'package:denezhno/core/database/journal.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:denezhno/core/database/obligation_repo.dart';
import 'package:denezhno/core/database/payments_repo.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// R3 risk Р1: «Оплачено» through the journal — the owner's scenarios
/// (docs/r3-plan.md). A payment leaves the obligations only by an operation
/// (or an explicit skip); it is taken from the balance exactly once.
CalendarDate d(String s) => CalendarDate.parse(s);
DateTime at(String day, int hour, [int minute = 0]) {
  final c = d(day);
  return DateTime(c.year, c.month, c.day, hour, minute);
}

Money rub(int r) => Money(r * 100);
const today = '2026-11-06';

final class World {
  World(this.db);
  final AppDatabase db;
  Ledger get ledger => Ledger(db);
  ObligationRepo get pay => ObligationRepo(db);
  PaymentsRepo get plans => PaymentsRepo(db);
  late String sber;
  final ids = <String, String>{};

  /// Сбер 10 000 ₽ confirmed at 08:00 on [today].
  static Future<World> open() async {
    final w = World(
      AppDatabase(
        NativeDatabase.memory(
          setup: (r) => r.execute('PRAGMA foreign_keys = ON'),
        ),
        clock: () => at(today, 8),
      ),
    );
    w.sber = await w.account('Сбер', AccountKind.debit, 10000);
    return w;
  }

  Future<String> account(String name, AccountKind kind, int rubles) async {
    await ledger.createAccount(
      NewAccount(kind: kind, name: name, amount: rub(rubles)),
      at(today, 8),
    );
    return ids[name] = (await ledger.accounts())
        .singleWhere((a) => a.name == name)
        .id;
  }

  /// A plan created at [created] (its tracking starts that day).
  Future<String> plan(
    String name,
    FlowKind kind,
    int rubles,
    Cadence cadence, {
    String created = today,
    String? linkedTo,
  }) async {
    await plans.saveFlow(
      PlannedFlow(
        id: null,
        kind: kind,
        name: name,
        amount: rub(rubles),
        cadence: cadence,
        startsOn: d(created),
        accountId: linkedTo,
      ),
      at(created, 7),
    );
    return (await plans.payments()).flows
        .singleWhere((f) => f.name == name)
        .id!;
  }

  Future<Money> balance(String name) async =>
      (await ledger.accounts()).singleWhere((a) => a.name == name).amount;

  Future<SafeToSpend> forecast([String day = today]) async =>
      computeSafeToSpend(
        accounts: await ledger.accounts(),
        payments: await plans.payments(),
        reserve: Money(0),
        today: d(day),
      );

  Future<int> suspense() async {
    final r = await db
        .customSelect(
          'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
          "JOIN accounts a ON a.id = p.account_id WHERE a.kind = 'suspense'",
        )
        .getSingle();
    return r.read<int>('s');
  }

  Future<void> expectAnchorsHold() async {
    for (final a in await db.select(db.balanceAssertions).get()) {
      expect(
        await Journal(db).balanceAt(a.accountId, a.assertedAtUtc),
        a.amountMinor,
      );
    }
  }

  Future<int> entries(String kind) async => (await (db.select(
    db.journalEntries,
  )..where((e) => e.kind.equals(kind))).get()).length;
}

void main() {
  late World w;
  setUp(() async => w = await World.open());
  tearDown(() => w.db.close());

  test('1. 10 000 ₽, rent 3 000 ₽: paid before the bank took it', () async {
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    expect((await w.forecast()).available, rub(7000)); // obligation

    final target = PlanDate(rent, d(today));
    // A balance was confirmed today (08:00): the person must answer.
    final check = await w.pay.preview(
      target,
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
    );
    expect(check.operation.askIncluded, true);
    await expectLater(
      w.pay.pay(
        target,
        amount: rub(3000),
        accountId: w.sber,
        date: d(today),
        now: at(today, 10),
        placement: SameDayPlacement.auto,
      ),
      throwsA(isA<InvalidOperation>()),
    );
    // «Списание прошло позже» that confirmation.
    await w.pay.pay(
      target,
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    expect(await w.balance('Сбер'), rub(7000));
    expect((await w.forecast()).available, rub(7000)); // not 10 000

    // 18:00: the bank still shows 10 000 — «ещё не списано».
    final pending = await w.pay.pending();
    expect(pending.single.title, 'Аренда');
    await w.pay.updateBalances(
      {w.sber: rub(10000)},
      {pending.single.paymentId},
      at(today, 18),
    );
    expect(await w.balance('Сбер'), rub(7000));
    expect((await w.forecast()).available, rub(7000));
    expect(await w.suspense(), 0);
    await w.expectAnchorsHold();

    // Next day the bank took it: «уже списано» — confirmed, no change.
    expect((await w.pay.pending()), hasLength(1));
    await w.ledger.updateBalances({w.sber: rub(7000)}, at('2026-11-07', 9));
    expect(await w.balance('Сбер'), rub(7000));
    expect(await w.suspense(), 0);
    expect(await w.pay.pending(), isEmpty);
    await w.expectAnchorsHold();
  });

  test('2. the payment is already in a confirmed balance', () async {
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    // The bank took it today; the person updates the balance tomorrow.
    await w.ledger.updateBalances({w.sber: rub(7000)}, at('2026-11-07', 9));
    expect(await w.suspense(), 300000); // 3 000 unexplained for now
    // Rent still an obligation: a balance update never releases it.
    expect((await w.forecast('2026-11-07')).payments.single.title, 'Аренда');
    final check = await w.pay.preview(
      PlanDate(rent, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at('2026-11-07', 10),
    );
    expect(check.operation.inConfirmedBalance, true);
    expect(check.operation.balances[w.sber], (rub(7000), rub(7000)));
    await w.pay.pay(
      PlanDate(rent, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at('2026-11-07', 10),
      placement: check.operation.placement,
    );
    expect(await w.balance('Сбер'), rub(7000)); // not 4 000
    expect(await w.suspense(), 0); // the difference is explained
    expect((await w.forecast('2026-11-07')).available, rub(7000));
    await w.expectAnchorsHold();
  });

  group('3. payment and balance update on the same day', () {
    test('update first (bank already took it), then «Оплачено»', () async {
      final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
      await w.ledger.updateBalances({w.sber: rub(7000)}, at(today, 12));
      // The person answers: it was already in that balance.
      await w.pay.pay(
        PlanDate(rent, d(today)),
        amount: rub(3000),
        accountId: w.sber,
        date: d(today),
        now: at(today, 13),
        placement: SameDayPlacement.inConfirmedBalance,
      );
      expect(await w.balance('Сбер'), rub(7000));
      expect(await w.suspense(), 0);
      expect((await w.forecast()).available, rub(7000));
      await w.expectAnchorsHold();
    });

    test('«Оплачено» first, then the update (bank already took it)', () async {
      final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
      await w.pay.pay(
        PlanDate(rent, d(today)),
        amount: rub(3000),
        accountId: w.sber,
        date: d(today),
        now: at(today, 12),
        placement: SameDayPlacement.afterConfirmedBalance,
      );
      expect((await w.pay.pending()), hasLength(1));
      // «Уже списано»: an ordinary confirmation.
      await w.pay.updateBalances({w.sber: rub(7000)}, {}, at(today, 13));
      expect(await w.balance('Сбер'), rub(7000));
      expect(await w.suspense(), 0);
      expect((await w.forecast()).available, rub(7000));
      expect(await w.pay.pending(), isEmpty);
      await w.expectAnchorsHold();
    });
  });

  test('4. several purchases and transfers on the payment day', () async {
    final cash = await w.account('Наличные', AccountKind.cash, 0);
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    final cats = {
      for (final c in await w.db.select(w.db.categories).get())
        c.systemKey: c.id,
    };
    final journal = Journal(w.db);
    await journal.record(
      ExpenseOp(
        accountId: w.sber,
        categoryId: cats['groceries']!,
        amount: rub(500),
        date: d(today),
      ),
      now: at(today, 9),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    await journal.record(
      TransferOp(
        fromAccountId: w.sber,
        toAccountId: cash,
        amount: rub(1000),
        date: d(today),
      ),
      now: at(today, 9, 30),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    await w.pay.pay(
      PlanDate(rent, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 11),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    // Evening: the bank shows 10 000 − 500 − 1 000 − 3 000 = 5 500.
    await w.pay.updateBalances(
      {w.sber: rub(5500), cash: rub(1000)},
      {},
      at(today, 20),
    );
    expect(await w.balance('Сбер'), rub(5500));
    expect(await w.balance('Наличные'), rub(1000));
    expect(await w.suspense(), 0); // everything explained, nothing twice
    expect(await journal.categoryTotals(d(today), d(today)), {
      cats['groceries']!: rub(500),
      cats['home']!: rub(3000),
    });
    expect((await w.forecast()).available, rub(6500));
    await w.expectAnchorsHold();
  });

  test('5. overdue unpaid rent stays an obligation, each date once', () async {
    // Monthly rent on the 1st, plan made on 1 October; nothing paid.
    final rent = await w.plan(
      'Аренда',
      FlowKind.rent,
      3000,
      const Monthly(1),
      created: '2026-10-01',
    );
    final f = await w.forecast();
    final overdue = f.warnings.whereType<PaymentOverdue>().toList();
    expect(
      [for (final o in overdue) o.dueOn],
      [d('2026-10-01'), d('2026-11-01')],
    );
    // Each date counted once (horizon 14 days: no December date yet).
    expect(
      [for (final x in f.payments) x.dueOn],
      [d('2026-10-01'), d('2026-11-01')],
    );
    expect(f.available, rub(10000 - 6000));
    // Paid one, skipped the other: no longer obligations.
    await w.pay.pay(
      PlanDate(rent, d('2026-11-01')),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    await w.pay.setSkipped(rent, d('2026-10-01'), true, at(today, 10));
    final after = await w.forecast();
    expect(after.warnings.whereType<PaymentOverdue>(), isEmpty);
    expect(after.payments, isEmpty);
    expect(after.available, rub(7000));
  });

  test('6. pressing «Оплачено» twice books it once', () async {
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    Future<void> payOnce() => w.pay.pay(
      PlanDate(rent, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    await payOnce();
    await expectLater(payOnce(), throwsA(isA<AlreadyPaid>()));
    expect(await w.entries('expense'), 1);
    expect(await w.balance('Сбер'), rub(7000));
    // Another obligation with the same amount: a similar operation needs
    // an explicit «это другая оплата».
    final other = await w.plan(
      'Стоянка',
      FlowKind.otherPayment,
      3000,
      Once(d(today)),
    );
    final check = await w.pay.preview(
      PlanDate(other, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 11),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    expect(check.similar, hasLength(1));
    await expectLater(
      w.pay.pay(
        PlanDate(other, d(today)),
        amount: rub(3000),
        accountId: w.sber,
        date: d(today),
        now: at(today, 11),
        placement: SameDayPlacement.afterConfirmedBalance,
      ),
      throwsA(isA<SimilarOperationExists>()),
    );
    await w.pay.pay(
      PlanDate(other, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 11),
      placement: SameDayPlacement.afterConfirmedBalance,
      confirmedNotDuplicate: true,
    );
    expect(await w.balance('Сбер'), rub(4000));
  });

  test('7. cancelling a payment marked by mistake', () async {
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    await w.pay.pay(
      PlanDate(rent, d(today)),
      amount: rub(3000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    final paid = (await w.plans.payments()).paid.values.single;
    await w.pay.cancel(paid.id, at(today, 11));
    final snap = await w.plans.payments();
    expect(snap.paid, isEmpty);
    expect(snap.history.single.cancelled, true); // history stays
    expect(await w.balance('Сбер'), rub(10000));
    expect((await w.forecast()).available, rub(7000)); // obligation again
    await expectLater(
      w.pay.cancel(paid.id, at(today, 12)),
      throwsA(isA<InvalidOperation>()),
    );
    await w.expectAnchorsHold();
  });

  test('8. repaying a credit card: a transfer, no double counting', () async {
    final card = await w.account('Кредитка', AccountKind.creditCard, 16000);
    // A planned card payment and the bank's figures for the same card.
    await w.plan(
      'Кредитка',
      FlowKind.otherPayment,
      15000,
      Once(d('2026-11-10')),
      linkedTo: card,
    );
    await w.plans.saveCardFigures(
      CardFigures(
        id: '',
        accountId: card,
        graceAmount: rub(15000),
        graceDueOn: d('2026-11-10'),
        minPayment: rub(800),
        minDueOn: d('2026-11-10'),
      ),
      at(today, 8, 30),
    );
    final before = await w.forecast();
    // Counted once: the bank figure; the linked plan is not added.
    expect(before.cardPaymentsTotal, rub(15000));
    expect(before.paymentsTotal, Money(0));
    expect(before.available, rub(10000 - 15000));

    // Pay part of it first, then the rest.
    final figures = (await w.plans.payments()).cardFigures[card]!;
    await w.pay.pay(
      CardDue(figures.id),
      amount: rub(5000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    var f = await w.forecast();
    expect(f.cardPaymentsTotal, rub(10000)); // 15 000 − 5 000 paid
    expect(f.money, rub(5000));
    await w.pay.pay(
      CardDue(figures.id),
      amount: rub(10000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 11),
      placement: SameDayPlacement.afterConfirmedBalance,
      confirmedNotDuplicate: true,
    );
    f = await w.forecast();
    expect(f.cardPaymentsTotal, Money(0)); // settled
    expect(f.money, Money(-500000)); // 10 000 − 15 000: taken once
    expect(await w.balance('Кредитка'), rub(1000)); // debt down
    // A transfer: no spending in the analytics.
    expect(await Journal(w.db).categoryTotals(d(today), d(today)), isEmpty);
    expect(await w.entries('transfer'), 2);
    expect(await w.entries('expense'), 0);
    await expectLater(
      w.pay.pay(
        CardDue(figures.id),
        amount: rub(1),
        accountId: w.sber,
        date: d(today),
        now: at(today, 12),
        placement: SameDayPlacement.afterConfirmedBalance,
        confirmedNotDuplicate: true,
      ),
      throwsA(isA<AlreadyPaid>()),
    );
  });

  test('a linked loan payment is a transfer, rent is an expense', () async {
    final loan = await w.account('Кредит', AccountKind.loan, 100000);
    final payment = await w.plan(
      'Кредит',
      FlowKind.loanPayment,
      2000,
      Once(d(today)),
      linkedTo: loan,
    );
    await w.pay.pay(
      PlanDate(payment, d(today)),
      amount: rub(2000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    expect(await w.balance('Кредит'), rub(98000));
    expect(await w.entries('transfer'), 1);
    expect(await w.entries('expense'), 0);
  });

  test('old «оплачено» marks without an operation do not release', () async {
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, Once(d(today)));
    await w.db
        .into(w.db.flowMarks)
        .insert(
          FlowMarksCompanion.insert(
            flowId: rent,
            dueOn: today,
            status: 'done',
            markedAtUtc: 0,
          ),
        );
    final snap = await w.plans.payments();
    expect(snap.legacyMarks, {(rent, d(today))});
    expect(snap.doneMarks, isEmpty);
    expect((await w.forecast()).available, rub(7000));
  });

  test('9. back-dated payment while the bank had not debited it yet: '
      'not silently taken as already in the later confirmation', () async {
    // Rent paid on 7 Nov (bank still pending), balance confirmed on 8 Nov
    // at 10 000, the payment recorded on 9 Nov with date 7 Nov.
    final rent = await w.plan(
      'Аренда',
      FlowKind.rent,
      3000,
      Once(d('2026-11-07')),
      created: '2026-11-07',
    );
    await w.ledger.updateBalances({w.sber: rub(10000)}, at('2026-11-08', 9));
    final target = PlanDate(rent, d('2026-11-07'));
    final check = await w.pay.preview(
      target,
      amount: rub(3000),
      accountId: w.sber,
      date: d('2026-11-07'),
      now: at('2026-11-09', 10),
    );
    // The app must ask instead of assuming «already in the balance».
    expect(check.operation.askIncluded, true);
    await expectLater(
      w.pay.pay(
        target,
        amount: rub(3000),
        accountId: w.sber,
        date: d('2026-11-07'),
        now: at('2026-11-09', 10),
        placement: SameDayPlacement.auto,
      ),
      throwsA(isA<InvalidOperation>()),
    );
    // «Нет, банк списал позже»: the balance goes down now.
    final answered = await w.pay.preview(
      target,
      amount: rub(3000),
      accountId: w.sber,
      date: d('2026-11-07'),
      now: at('2026-11-09', 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    expect(answered.operation.balances[w.sber], (rub(10000), rub(7000)));
    await w.pay.pay(
      target,
      amount: rub(3000),
      accountId: w.sber,
      date: d('2026-11-07'),
      now: at('2026-11-09', 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    expect(await w.balance('Сбер'), rub(7000));
    expect((await w.forecast('2026-11-09')).available, rub(7000));
    // The operation keeps its date (analytics), and the 8 Nov
    // confirmation stays true.
    await w.expectAnchorsHold();
    // 10 Nov: the bank finally took it — «уже списано».
    expect((await w.pay.pending()).single.title, 'Аренда');
    await w.pay.updateBalances({w.sber: rub(7000)}, {}, at('2026-11-10', 9));
    expect(await w.balance('Сбер'), rub(7000));
    expect(await w.suspense(), 0);
    expect(
      (await Journal(
        w.db,
      ).categoryTotals(d('2026-11-07'), d('2026-11-07'))).values.single,
      rub(3000),
    );
    await w.expectAnchorsHold();
  });

  test(
    '9b. the same, but the bank had already taken it (answer «да»)',
    () async {
      final rent = await w.plan(
        'Аренда',
        FlowKind.rent,
        3000,
        Once(d('2026-11-07')),
        created: '2026-11-07',
      );
      await w.ledger.updateBalances({w.sber: rub(7000)}, at('2026-11-08', 9));
      await w.pay.pay(
        PlanDate(rent, d('2026-11-07')),
        amount: rub(3000),
        accountId: w.sber,
        date: d('2026-11-07'),
        now: at('2026-11-09', 10),
        placement: SameDayPlacement.inConfirmedBalance,
      );
      expect(await w.balance('Сбер'), rub(7000));
      expect(await w.suspense(), 0);
      expect(await w.pay.pending(), isEmpty);
      await w.expectAnchorsHold();
    },
  );

  test('10. card repaid partly through the linked plan: only the rest of '
      'the bank figure is reserved; new purchases do not reduce it', () async {
    final card = await w.account('Кредитка', AccountKind.creditCard, 15000);
    await w.plans.saveCardFigures(
      CardFigures(
        id: '',
        accountId: card,
        graceAmount: rub(10000),
        graceDueOn: d('2026-11-15'),
        minPayment: rub(1000),
        minDueOn: d('2026-11-15'),
      ),
      at(today, 8, 30),
    );
    final linked = await w.plan(
      'Кредитка',
      FlowKind.otherPayment,
      4000,
      Once(d(today)),
      linkedTo: card,
    );
    expect((await w.forecast()).cardPaymentsTotal, rub(10000));
    // 4 000 through the linked regular payment (a transfer to the card).
    await w.pay.pay(
      PlanDate(linked, d(today)),
      amount: rub(4000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 10),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    var f = await w.forecast();
    expect(await w.balance('Кредитка'), rub(11000));
    expect(f.cardPaymentsTotal, rub(6000)); // 10 000 − 4 000, not 10 000
    expect(f.money, rub(6000));
    // A new purchase on the card: the debt grows, the bank's figure does
    // not, and the rest still to pay stays 6 000.
    final cats = {
      for (final c in await w.db.select(w.db.categories).get())
        c.systemKey: c.id,
    };
    await Journal(w.db).record(
      ExpenseOp(
        accountId: card,
        categoryId: cats['cafe']!,
        amount: rub(2000),
        date: d(today),
      ),
      now: at(today, 12),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    f = await w.forecast();
    expect(await w.balance('Кредитка'), rub(13000));
    expect(f.cardPaymentsTotal, rub(6000));
    // Paying the rest through «Внёс» settles the figures.
    final figures = (await w.plans.payments()).cardFigures[card]!;
    expect(figures.remainingDue, rub(6000));
    await w.pay.pay(
      CardDue(figures.id),
      amount: rub(6000),
      accountId: w.sber,
      date: d(today),
      now: at(today, 13),
      placement: SameDayPlacement.afterConfirmedBalance,
    );
    f = await w.forecast();
    expect(f.cardPaymentsTotal, Money(0));
    await expectLater(
      w.pay.pay(
        CardDue(figures.id),
        amount: rub(1),
        accountId: w.sber,
        date: d(today),
        now: at(today, 14),
        placement: SameDayPlacement.afterConfirmedBalance,
        confirmedNotDuplicate: true,
      ),
      throwsA(isA<AlreadyPaid>()),
    );
  });
}
