import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/database/app_database.dart' hide CardFigures;
import 'package:denezhno/core/database/journal.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:denezhno/core/database/obligation_repo.dart';
import 'package:denezhno/core/database/payments_repo.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/answers.dart';

/// Review of build a8a02c1 (source 1375532), 2026-11-14. Each defect was
/// first reproduced on the API as it was (D1: debit 2 000 instead of
/// 6 000; D2: 2 000 to pay instead of 6 000; D3: the rent dated 10 Nov
/// instead of 7 Nov). Clean test database for every test.
CalendarDate d(String s) => CalendarDate.parse(s);
DateTime at(String day, int hour, [int minute = 0]) {
  final c = d(day);
  return DateTime(c.year, c.month, c.day, hour, minute);
}

Money rub(int r) => Money(r * 100);

final class World {
  World(this.db);
  final AppDatabase db;
  Ledger get ledger => Ledger(db);
  ObligationRepo get repo => ObligationRepo(db);
  PaymentsRepo get plans => PaymentsRepo(db);

  static Future<World> open() async => World(
    AppDatabase(
      NativeDatabase.memory(
        setup: (r) => r.execute('PRAGMA foreign_keys = ON'),
      ),
      clock: () => at('2026-11-06', 8),
    ),
  );

  Future<String> account(String name, AccountKind kind, int rubles) async {
    await ledger.createAccount(
      NewAccount(kind: kind, name: name, amount: rub(rubles)),
      at('2026-11-06', 8),
    );
    return (await ledger.accounts()).singleWhere((a) => a.name == name).id;
  }

  Future<Money> balance(String name) async =>
      (await ledger.accounts()).singleWhere((a) => a.name == name).amount;

  Future<String> plan(
    String name,
    FlowKind kind,
    int rubles,
    CalendarDate on, {
    String? linkedTo,
  }) async {
    await plans.saveFlow(
      PlannedFlow(
        id: null,
        kind: kind,
        name: name,
        amount: rub(rubles),
        cadence: Once(on),
        startsOn: d('2026-11-06'),
        accountId: linkedTo,
      ),
      at('2026-11-06', 9),
    );
    return (await plans.payments()).flows
        .singleWhere((f) => f.name == name)
        .id!;
  }

  Future<int> suspense() async =>
      (await db
              .customSelect(
                'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
                "JOIN accounts a ON a.id = p.account_id WHERE a.kind = 'suspense'",
              )
              .getSingle())
          .read<int>('s');

  /// Every historical confirmation is still exactly true.
  Future<void> expectConfirmationsHold() async {
    for (final a in await db.select(db.balanceAssertions).get()) {
      expect(
        await Journal(db).balanceAt(a.accountId, a.assertedAtUtc),
        a.amountMinor,
        reason: 'confirmation ${a.id}',
      );
    }
  }

  /// Every entry sums to zero (and has at least two lines).
  Future<void> expectBalancedEntries() async {
    final bad = await db.customSelect('''
      SELECT entry_id FROM postings GROUP BY entry_id
      HAVING SUM(amount_minor) <> 0 OR COUNT(*) < 2
    ''').get();
    expect(bad, isEmpty);
  }

  /// Category totals by operation date (non-zero days only).
  Future<Map<String, int>> byDay() async => {
    for (final r in await db.customSelect('''
      SELECT d.occurred_on AS day, SUM(p.amount_minor) AS s FROM postings p
      JOIN categories c ON c.ledger_account_id = p.account_id
      JOIN entry_details d ON d.entry_id = p.entry_id
      GROUP BY d.occurred_on HAVING SUM(p.amount_minor) <> 0
    ''').get())
      r.read<String>('day'): r.read<int>('s'),
  };

  /// Answers for [check]: per account, about its current confirmation.
  static Map<String, ConfirmationAnswer> answers(
    PaymentCheck check,
    Map<String, bool> included,
  ) => {
    for (final q in check.operation.questions)
      q.accountId: ConfirmationAnswer(
        q.assertionId,
        included: included[q.accountId]!,
      ),
  };
}

void main() {
  late World w;
  setUp(() async => w = await World.open());
  tearDown(() => w.db.close());

  group('D1: a transfer between two accounts, each with its own '
      'confirmation', () {
    late String debit;
    late String card;
    late String plan;
    PlanDate target() => PlanDate(plan, d('2026-11-07'));

    setUp(() async {
      debit = await w.account('Дебет', AccountKind.debit, 10000);
      card = await w.account('Кредитка', AccountKind.creditCard, 15000);
      plan = await w.plan(
        'Погашение',
        FlowKind.otherPayment,
        4000,
        d('2026-11-07'),
        linkedTo: card,
      );
    });

    Future<PaymentCheck> check({
      Map<String, ConfirmationAnswer> answers = const {},
    }) => w.repo.preview(
      target(),
      amount: rub(4000),
      accountId: debit,
      date: d('2026-11-07'),
      now: at('2026-11-09', 12),
      answers: answers,
    );

    Future<void> pay(Map<String, ConfirmationAnswer> answers) => w.repo.pay(
      target(),
      amount: rub(4000),
      accountId: debit,
      date: d('2026-11-07'),
      now: at('2026-11-09', 12),
      answers: answers,
    );

    test(
      'already on both: debit 6 000 at 09:00, debt 11 000 at 11:00',
      () async {
        await w.ledger.updateBalances({debit: rub(6000)}, at('2026-11-09', 9));
        await w.ledger.updateBalances({card: rub(11000)}, at('2026-11-09', 11));
        final first = await check();
        // A separate question per account, each naming its own confirmation.
        expect(
          {
            for (final q in first.operation.questions)
              q.accountId: q.confirmedAt,
          },
          {debit: at('2026-11-09', 9), card: at('2026-11-09', 11)},
        );
        final answers = World.answers(first, {debit: true, card: true});
        await expectLater(
          pay({debit: answers[debit]!}),
          throwsA(isA<InvalidOperation>()),
        ); // one account unanswered
        final shown = await check(answers: answers);
        expect(shown.operation.balances[debit], (rub(6000), rub(6000)));
        expect(shown.operation.balances[card], (rub(11000), rub(11000)));
        await pay(answers);
        expect(await w.balance('Дебет'), rub(6000));
        expect(await w.balance('Кредитка'), rub(11000));
        expect(await w.suspense(), 0);
        expect(await w.repo.pending(), isEmpty);
        await w.expectConfirmationsHold();
        await w.expectBalancedEntries();
      },
    );

    test('debit already taken (6 000), debt 15 000 not yet credited', () async {
      await w.ledger.updateBalances({debit: rub(6000)}, at('2026-11-09', 9));
      await w.ledger.updateBalances({card: rub(15000)}, at('2026-11-09', 11));
      final answers = World.answers(await check(), {debit: true, card: false});
      final shown = await check(answers: answers);
      await pay(answers);
      expect(await w.balance('Дебет'), rub(6000));
      expect(await w.balance('Кредитка'), rub(11000));
      // The preview showed exactly what was written.
      expect(shown.operation.balances[debit]!.$2, await w.balance('Дебет'));
      expect(shown.operation.balances[card]!.$2, await w.balance('Кредитка'));
      // The debit is in a balance; the credit to the card is still to come.
      final open = await w.repo.pending();
      expect([for (final p in open) (p.accountId, p.incoming)], [(card, true)]);
      await w.expectConfirmationsHold();
      await w.expectBalancedEntries();
    });

    test('the other way: debt 11 000 already credited, debit 10 000 not yet '
        'taken — the payment stays pending', () async {
      await w.ledger.updateBalances({debit: rub(10000)}, at('2026-11-09', 9));
      await w.ledger.updateBalances({card: rub(11000)}, at('2026-11-09', 11));
      final answers = World.answers(await check(), {debit: false, card: true});
      final shown = await check(answers: answers);
      await pay(answers);
      expect(await w.balance('Дебет'), rub(6000));
      expect(await w.balance('Кредитка'), rub(11000));
      expect(shown.operation.balances[debit], (rub(10000), rub(6000)));
      // The main entry is before 09:00, but the debit is still expected.
      expect((await w.repo.pending()).single.title, 'Погашение');
      await w.expectConfirmationsHold();
      await w.expectBalancedEntries();
      // The bank takes it; «уже списано» → nothing unexplained, not pending.
      await w.repo.reconcile({debit: rub(6000)}, {}, at('2026-11-10', 9));
      expect(await w.balance('Дебет'), rub(6000));
      expect(await w.suspense(), 0);
      expect(await w.repo.pending(), isEmpty);
      await w.expectConfirmationsHold();
    });

    test('a newer confirmation after the preview: asked again', () async {
      await w.ledger.updateBalances({debit: rub(6000)}, at('2026-11-09', 9));
      final stale = World.answers(await check(), {debit: true});
      // Meanwhile the debit balance is confirmed again.
      await w.ledger.updateBalances({debit: rub(6000)}, at('2026-11-09', 10));
      final again = await check(answers: stale);
      expect(again.operation.unanswered(stale).single.accountId, debit);
      await expectLater(pay(stale), throwsA(isA<InvalidOperation>()));
      await pay(World.answers(again, {debit: true}));
      expect(await w.balance('Дебет'), rub(6000));
      await w.expectConfirmationsHold();
    });

    test('cancelling keeps every confirmation and restores balances', () async {
      await w.ledger.updateBalances({debit: rub(6000)}, at('2026-11-09', 9));
      await w.ledger.updateBalances({card: rub(15000)}, at('2026-11-09', 11));
      await pay(World.answers(await check(), {debit: true, card: false}));
      final paid = (await w.plans.payments()).paid.values.single;
      await w.repo.cancel(paid.id, at('2026-11-09', 13));
      expect(await w.balance('Дебет'), rub(6000)); // as confirmed
      expect(await w.balance('Кредитка'), rub(15000));
      expect((await w.plans.payments()).paid, isEmpty);
      await w.expectConfirmationsHold();
      await w.expectBalancedEntries();
    });
  });

  group('D2: a transfer to the card and one version of the bank figures', () {
    late String debit;
    late String card;
    late CardFigures figures;

    Future<void> enterFigures(int due) async {
      await w.plans.saveCardFigures(
        CardFigures(
          id: '',
          accountId: card,
          graceAmount: rub(due),
          graceDueOn: d('2026-11-20'),
        ),
        at('2026-11-08', 10),
      );
      figures = (await w.plans.payments()).cardFigures[card]!;
    }

    setUp(() async {
      debit = await w.account('Дебет', AccountKind.debit, 30000);
      card = await w.account('Кредитка', AccountKind.creditCard, 15000);
    });

    Future<PaymentCheck> check(int rubles, CalendarDate date, DateTime now) =>
        w.repo.preview(
          CardDue(figures.id),
          amount: rub(rubles),
          accountId: debit,
          date: date,
          now: now,
        );

    Future<void> pay(
      int rubles,
      CalendarDate date,
      DateTime now, {
      bool? included,
    }) => w.repo.pay(
      CardDue(figures.id),
      amount: rub(rubles),
      accountId: debit,
      date: date,
      now: now,
      figuresAnswer: included == null
          ? null
          : FiguresAnswer(figures.id, included: included),
    );

    Future<Money?> due() async =>
        (await w.plans.payments()).cardFigures[card]!.remainingDue;

    test(
      'the bank already counted the 4 000 of 7 Nov (6 000 to pay)',
      () async {
        await enterFigures(6000);
        final c = await check(4000, d('2026-11-07'), at('2026-11-09', 10));
        expect(c.figures!.figuresId, figures.id);
        expect(c.figures!.enteredOn, d('2026-11-08'));
        await expectLater(
          pay(4000, d('2026-11-07'), at('2026-11-09', 10)),
          throwsA(isA<InvalidOperation>()),
        ); // unanswered
        await pay(4000, d('2026-11-07'), at('2026-11-09', 10), included: true);
        expect(await due(), rub(6000));
        // One rule everywhere: the forecast and the repeated-payment check.
        await pay(6000, d('2026-11-09'), at('2026-11-09', 11)); // after entry
        expect(await due(), Money(0));
        await expectLater(
          pay(1, d('2026-11-09'), at('2026-11-09', 12)),
          throwsA(isA<AlreadyPaid>()),
        );
      },
    );

    test('the bank had not counted it yet (10 000 to pay)', () async {
      await enterFigures(10000);
      await pay(4000, d('2026-11-07'), at('2026-11-09', 10), included: false);
      expect(await due(), rub(6000));
      // Purchases and refunds on the card never change what is still due.
      final cats = {
        for (final c in await w.db.select(w.db.categories).get())
          c.systemKey: c.id,
      };
      await Journal(w.db).record(
        ExpenseOp(
          accountId: card,
          categoryId: cats['cafe']!,
          amount: rub(2000),
          date: d('2026-11-09'),
        ),
        now: at('2026-11-09', 11),
      );
      await Journal(w.db).record(
        RefundOp(
          accountId: card,
          categoryId: cats['cafe']!,
          amount: rub(500),
          date: d('2026-11-09'),
        ),
        now: at('2026-11-09', 12),
      );
      expect(await due(), rub(6000));
    });

    test('cancelling the transfer removes its offset', () async {
      await enterFigures(10000);
      await pay(4000, d('2026-11-07'), at('2026-11-09', 10), included: false);
      final paid = (await w.plans.payments()).history.single;
      await w.repo.cancel(paid.id, at('2026-11-09', 11));
      expect(await due(), rub(10000));
    });

    test('«ещё не списано» keeps the offset once', () async {
      await enterFigures(10000);
      await pay(4000, d('2026-11-07'), at('2026-11-09', 10), included: false);
      final pending = await w.repo.pending();
      await w.repo.reconcile(
        {debit: rub(30000)},
        {pending.first.paymentId},
        at('2026-11-10', 9),
      );
      expect(await due(), rub(6000));
      expect(await w.balance('Дебет'), rub(26000));
      final answers = await w.db.select(w.db.figuresTransferAnswers).get();
      // The operation is not re-booked: one operation, one answer.
      expect(answers, hasLength(1));
      await w.expectConfirmationsHold();
    });
  });

  test('D3: «ещё не списано» twice keeps the rent on 7 Nov, once', () async {
    final sber = await w.account('Сбер', AccountKind.debit, 10000);
    final rent = await w.plan('Аренда', FlowKind.rent, 3000, d('2026-11-07'));
    await w.repo.pay(
      PlanDate(rent, d('2026-11-07')),
      amount: rub(3000),
      accountId: sber,
      date: d('2026-11-07'),
      now: at('2026-11-07', 12),
    );
    for (final day in ['2026-11-10', '2026-11-11']) {
      final pending = await w.repo.pending();
      expect(pending.single.paidOn, d('2026-11-07'));
      // The bank still shows 10 000.
      await w.repo.reconcile(
        {sber: rub(10000)},
        {pending.first.paymentId},
        at(day, 9),
      );
      expect(await w.balance('Сбер'), rub(7000), reason: day);
      expect(await w.byDay(), {'2026-11-07': 300000}, reason: day);
      await w.expectConfirmationsHold();
      await w.expectBalancedEntries();
    }
    // The bank takes it: 7 000, «уже списано».
    final result = await w.repo.reconcile(
      {sber: rub(7000)},
      {},
      at('2026-11-12', 9),
    );
    expect(result.unexplained, Money(0));
    expect(await w.suspense(), 0);
    expect(await w.repo.pending(), isEmpty);
    expect(await w.byDay(), {'2026-11-07': 300000});
    await w.expectConfirmationsHold();
  });

  group('Review 2', () {
    test('R1: «ещё не списано» about the debit only — two reconciliations '
        'keep debit 6 000 and debt 11 000', () async {
      final debit = await w.account('Дебет', AccountKind.debit, 10000);
      final card = await w.account('Кредитка', AccountKind.creditCard, 15000);
      final plan = await w.plan(
        'Погашение',
        FlowKind.otherPayment,
        4000,
        d('2026-11-07'),
        linkedTo: card,
      );
      // The card already credited 4 000; the debit is still pending.
      await w.ledger.updateBalances({debit: rub(10000)}, at('2026-11-09', 9));
      await w.ledger.updateBalances({card: rub(11000)}, at('2026-11-09', 11));
      final target = PlanDate(plan, d('2026-11-07'));
      final check = await w.repo.preview(
        target,
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-09', 12),
      );
      await w.repo.pay(
        target,
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-09', 12),
        answers: World.answers(check, {debit: false, card: true}),
      );
      expect(await w.balance('Дебет'), rub(6000));
      expect(await w.balance('Кредитка'), rub(11000));
      for (final day in ['2026-11-10', '2026-11-11']) {
        final pending = await w.repo.pending();
        // Both accounts confirmed; «ещё не списано» (the debit).
        await w.repo.reconcile(
          {debit: rub(10000), card: rub(11000)},
          {pending.first.paymentId},
          at(day, 9),
        );
        expect(await w.balance('Дебет'), rub(6000), reason: day);
        expect(await w.balance('Кредитка'), rub(11000), reason: day);
        await w.expectConfirmationsHold();
        await w.expectBalancedEntries();
      }
      await w.repo.reconcile({debit: rub(6000)}, {}, at('2026-11-12', 9));
      expect(await w.suspense(), 0);
      expect(await w.repo.pending(), isEmpty);
    });

    test('R2: the figures answer is about one version — a newer version '
        'before saving asks again, nothing is written', () async {
      final debit = await w.account('Дебет', AccountKind.debit, 30000);
      final card = await w.account('Кредитка', AccountKind.creditCard, 15000);
      final plan = await w.plan(
        'Погашение',
        FlowKind.otherPayment,
        4000,
        d('2026-11-07'),
        linkedTo: card,
      );
      Future<void> figures(int due, int hour) => w.plans.saveCardFigures(
        CardFigures(
          id: '',
          accountId: card,
          graceAmount: rub(due),
          graceDueOn: d('2026-11-20'),
        ),
        at('2026-11-08', hour),
      );
      await figures(10000, 10);
      final target = PlanDate(plan, d('2026-11-07'));
      final first = await w.repo.preview(
        target,
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-09', 10),
      );
      final v1 = first.figures!.figuresId;
      // Before saving, a new version: 6 000, already including the 4 000.
      await figures(6000, 12);
      final entriesBefore = await w.db.select(w.db.journalEntries).get();
      await expectLater(
        w.repo.pay(
          target,
          amount: rub(4000),
          accountId: debit,
          date: d('2026-11-07'),
          now: at('2026-11-09', 10),
          figuresAnswer: FiguresAnswer(v1, included: false),
        ),
        throwsA(isA<InvalidOperation>()),
      );
      expect(await w.db.select(w.db.journalEntries).get(), entriesBefore);
      expect(await w.db.select(w.db.obligationPayments).get(), isEmpty);
      final again = await w.repo.preview(
        target,
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-09', 10),
      );
      expect(again.figures!.figuresId, isNot(v1));
      expect(again.figures!.due, rub(6000));
      await w.repo.pay(
        target,
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-09', 10),
        figuresAnswer: FiguresAnswer(again.figures!.figuresId, included: true),
      );
      expect(
        (await w.plans.payments()).cardFigures[card]!.remainingDue,
        rub(6000),
      );
    });

    test(
      'R3: a reconciliation keeps the accounts and the kind from the journal, '
      'even after the plan was linked to another card',
      () async {
        final debit = await w.account('Дебет', AccountKind.debit, 20000);
        final cardA = await w.account(
          'Кредитка А',
          AccountKind.creditCard,
          15000,
        );
        final cardB = await w.account(
          'Кредитка Б',
          AccountKind.creditCard,
          5000,
        );
        final plan = await w.plan(
          'Погашение',
          FlowKind.otherPayment,
          4000,
          d('2026-11-07'),
          linkedTo: cardA,
        );
        await w.repo.pay(
          PlanDate(plan, d('2026-11-07')),
          amount: rub(4000),
          accountId: debit,
          date: d('2026-11-07'),
          now: at('2026-11-07', 12),
        );
        expect(await w.balance('Кредитка А'), rub(11000));
        final paidEntry = (await w.plans.payments()).paid.values.single.entryId;
        // The plan is re-linked to card Б afterwards.
        final flow = (await w.plans.payments()).flows.single;
        await w.plans.saveFlow(
          PlannedFlow(
            id: flow.id,
            kind: flow.kind,
            name: flow.name,
            amount: flow.amount,
            cadence: flow.cadence,
            startsOn: flow.startsOn,
            accountId: cardB,
          ),
          at('2026-11-08', 9),
        );
        final pending = await w.repo.pending();
        await w.repo.reconcile(
          {debit: rub(20000)},
          {pending.first.paymentId},
          at('2026-11-10', 9),
        );
        expect(await w.balance('Дебет'), rub(16000));
        expect(await w.balance('Кредитка А'), rub(11000));
        expect(await w.balance('Кредитка Б'), rub(5000));
        final live = (await w.plans.payments()).paid.values.single;
        expect(live.entryId, paidEntry); // never re-booked
        final kind = await (w.db.select(
          w.db.journalEntries,
        )..where((e) => e.id.equals(live.entryId))).getSingle();
        expect(kind.kind, 'transfer');
        await w.expectConfirmationsHold();
        await w.expectBalancedEntries();
      },
    );
  });

  group('Review 3: «Обновить остатки» asks per side of the transfer', () {
    late String debit;
    late String card;
    late String paymentId;

    setUp(() async {
      debit = await w.account('Дебет', AccountKind.debit, 10000);
      card = await w.account('Кредитка', AccountKind.creditCard, 15000);
      final plan = await w.plan(
        'Погашение',
        FlowKind.otherPayment,
        4000,
        d('2026-11-07'),
        linkedTo: card,
      );
      // No confirmation since 7 Nov: both sides are still to come.
      await w.repo.pay(
        PlanDate(plan, d('2026-11-07')),
        amount: rub(4000),
        accountId: debit,
        date: d('2026-11-07'),
        now: at('2026-11-07', 12),
      );
      paymentId = (await w.plans.payments()).paid.values.single.id;
    });

    Future<Set<(String, bool)>> open() async => {
      for (final p in await w.repo.pending()) (p.accountId, p.incoming),
    };

    PendingKey side(String account) =>
        (paymentId: paymentId, accountId: account);

    Future<Money> reconcile(
      Map<String, int> bank,
      Map<String, bool> arrived,
      DateTime now,
    ) async => (await w.repo.updateBalances(
      {for (final e in bank.entries) e.key: rub(e.value)},
      {for (final e in arrived.entries) side(e.key): e.value},
      now,
    )).unexplained;

    Future<void> expectSettled(int debitRub, int debtRub) async {
      expect(await w.balance('Дебет'), rub(debitRub));
      expect(await w.balance('Кредитка'), rub(debtRub));
      expect(await w.suspense(), 0);
      await w.expectConfirmationsHold();
      await w.expectBalancedEntries();
    }

    Future<int> transfers() async =>
        (await w.db
                .customSelect(
                  "SELECT COUNT(*) AS n FROM journal_entries e WHERE e.kind = 'transfer' "
                  'AND NOT EXISTS (SELECT 1 FROM entry_details r '
                  'WHERE r.reverses_entry_id = e.id)',
                )
                .getSingle())
            .read<int>('n');

    test('both banks still show the old figures: «ещё не списано» and «ещё '
        'не зачислено», twice — 6 000 and 11 000', () async {
      await expectSettled(6000, 11000);
      for (final day in ['2026-11-10', '2026-11-11']) {
        expect(await open(), {(debit, false), (card, true)}, reason: day);
        final unexplained = await reconcile(
          {debit: 10000, card: 15000},
          {debit: false, card: false},
          at(day, 9),
        );
        expect(unexplained, Money(0), reason: day);
        await expectSettled(6000, 11000);
      }
      expect(await open(), {(debit, false), (card, true)});
    });

    test('no default: a side on an account being confirmed must be answered; '
        'nothing is written otherwise', () async {
      final before = await w.db.select(w.db.balanceAssertions).get();
      await expectLater(
        reconcile(
          {debit: 10000, card: 15000},
          {debit: false},
          at('2026-11-10', 9),
        ),
        throwsA(isA<InvalidOperation>()),
      );
      expect(await w.db.select(w.db.balanceAssertions).get(), before);
      await expectSettled(6000, 11000);
    });

    test('the debit first, then the credit', () async {
      await reconcile(
        {debit: 10000, card: 15000},
        {debit: false, card: false},
        at('2026-11-10', 9),
      );
      // The bank took the money; the card still shows 15 000.
      expect(
        await reconcile(
          {debit: 6000, card: 15000},
          {debit: true, card: false},
          at('2026-11-11', 9),
        ),
        Money(0),
      );
      await expectSettled(6000, 11000);
      expect(await open(), {(card, true)}); // only the credit is asked now
      // Confirming only the debit again asks nothing; the card keeps its state.
      expect(
        await reconcile({debit: 6000}, {}, at('2026-11-11', 12)),
        Money(0),
      );
      expect(await open(), {(card, true)});
      await expectSettled(6000, 11000);
      // The card credits it.
      expect(
        await reconcile({card: 11000}, {card: true}, at('2026-11-12', 9)),
        Money(0),
      );
      expect(await open(), isEmpty);
      await expectSettled(6000, 11000);
      expect(await transfers(), 1);
    });

    test('the credit first, then the debit', () async {
      await reconcile(
        {debit: 10000, card: 15000},
        {debit: false, card: false},
        at('2026-11-10', 9),
      );
      // The card credited it; the debit still shows 10 000.
      expect(
        await reconcile(
          {debit: 10000, card: 11000},
          {debit: false, card: true},
          at('2026-11-11', 9),
        ),
        Money(0),
      );
      await expectSettled(6000, 11000);
      expect(await open(), {(debit, false)}); // only the debit is asked now
      expect(
        await reconcile({card: 11000}, {}, at('2026-11-11', 12)),
        Money(0),
      );
      expect(await open(), {(debit, false)});
      // Still not taken; then taken.
      expect(
        await reconcile({debit: 10000}, {debit: false}, at('2026-11-12', 9)),
        Money(0),
      );
      await expectSettled(6000, 11000);
      expect(
        await reconcile({debit: 6000}, {debit: true}, at('2026-11-13', 9)),
        Money(0),
      );
      expect(await open(), isEmpty);
      await expectSettled(6000, 11000);
      expect(await transfers(), 1);
    });

    test('Review 4: the bank figures typed in by hand (10 000 and 15 000), '
        'two «ещё не …» — 6 000 and 11 000, nothing unexplained', () async {
      final result = await w.repo.updateBalances(
        {debit: rub(10000), card: rub(15000)},
        {side(debit): false, side(card): false},
        at('2026-11-10', 9),
      );
      expect(result.unexplained, Money(0));
      await expectSettled(6000, 11000);
      // Why «Не изменилось» is off for these accounts: the app's own
      // balances (6 000 and 11 000) already contain the transfer; sent
      // with «ещё не …» they would count it twice.
      // Nothing would even warn: the debit's −4 000 and the card's +4 000
      // cancel in the total unexplained difference.
      final copied = await w.repo.updateBalances(
        {debit: rub(6000), card: rub(11000)},
        {side(debit): false, side(card): false},
        at('2026-11-11', 9),
      );
      expect(await w.balance('Дебет'), rub(2000));
      expect(await w.balance('Кредитка'), rub(7000));
      expect(copied.unexplained, Money(0));
    });

    test('an account not confirmed now keeps its side as it was', () async {
      // Only the debit is confirmed: no question about the card.
      expect(
        await reconcile({debit: 10000}, {debit: false}, at('2026-11-10', 9)),
        Money(0),
      );
      expect(await open(), {(debit, false), (card, true)});
      await expectSettled(6000, 11000);
    });

    test(
      'cancelling after «ещё не списано» removes the corrections too',
      () async {
        await reconcile(
          {debit: 10000, card: 15000},
          {debit: false, card: false},
          at('2026-11-10', 9),
        );
        await w.repo.cancel(paymentId, at('2026-11-10', 12));
        await expectSettled(10000, 15000);
        expect(await open(), isEmpty);
      },
    );
  });

  group('Review 4: a stale direct «Внёс» form (CardDue)', () {
    late String debit;
    late String card;

    setUp(() async {
      debit = await w.account('Дебет', AccountKind.debit, 30000);
      card = await w.account('Кредитка', AccountKind.creditCard, 15000);
    });

    Future<String> figures(int due, DateTime when) async {
      await w.plans.saveCardFigures(
        CardFigures(
          id: '',
          accountId: card,
          graceAmount: rub(due),
          graceDueOn: d('2026-11-20'),
        ),
        when,
      );
      return (await w.plans.payments()).cardFigures[card]!.id;
    }

    Future<List<Object>> written() async => [
      await w.db.select(w.db.journalEntries).get(),
      await w.db.select(w.db.postings).get(),
      await w.db.select(w.db.obligationPayments).get(),
      await w.db.select(w.db.figuresTransferAnswers).get(),
    ];

    for (final withQuestion in [true, false]) {
      test(
        withQuestion
            ? 'with the figures question: the old answer is refused'
            : 'without the figures question: refused all the same',
        () async {
          final v1 = await figures(10000, at('2026-11-08', 10));
          // The form is opened on 10 000. Dated 7 Nov (before the figures
          // were entered) it asks about them; dated 9 Nov it does not.
          final date = withQuestion ? d('2026-11-07') : d('2026-11-09');
          final form = await w.repo.preview(
            CardDue(v1),
            amount: rub(10000),
            accountId: debit,
            date: date,
            now: at('2026-11-09', 10),
          );
          expect(form.figures?.due, withQuestion ? rub(10000) : null);
          // Meanwhile new bank figures: 6 000.
          final v2 = await figures(6000, at('2026-11-09', 11));
          expect(v2, isNot(v1));
          final before = await written();
          await expectLater(
            w.repo.pay(
              CardDue(v1),
              amount: rub(10000),
              accountId: debit,
              date: date,
              now: at('2026-11-09', 12),
              figuresAnswer: withQuestion
                  ? FiguresAnswer(v1, included: false)
                  : null,
            ),
            throwsA(isA<FiguresChanged>()),
          );
          expect(await written(), before); // nothing at all was written
          // The old form cannot even be previewed again.
          await expectLater(
            w.repo.preview(
              CardDue(v1),
              amount: rub(10000),
              accountId: debit,
              date: date,
              now: at('2026-11-09', 12),
            ),
            throwsA(isA<FiguresChanged>()),
          );
          // Opened again: the current version, 6 000.
          final current = (await w.plans.payments()).cardFigures[card]!;
          expect(current.id, v2);
          expect(current.remainingDue, rub(6000));
          final again = await w.repo.preview(
            CardDue(v2),
            amount: current.remainingDue!,
            accountId: debit,
            date: d('2026-11-09'),
            now: at('2026-11-09', 12),
          );
          expect(again.figures?.due, rub(6000)); // entered today: asked
          expect(again.operation.balances[card], (rub(15000), rub(9000)));
        },
      );
    }
  });
}
