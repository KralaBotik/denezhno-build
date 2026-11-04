import 'dart:io';

import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = '0404040404040404040404040404040404040404040404040404040404040404';
CalendarDate d(String s) => CalendarDate.parse(s);

void main() {
  late Directory directory;
  late LocalStore store;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('denezhno-payments-');
    final file = File('${directory.path}/denezhno.sqlite');
    store = LocalStore(() async => StorageLocation(file, _key, () async {}));
    await store.open();
  });
  tearDown(() async {
    await store.close();
    await directory.delete(recursive: true);
  });

  PlannedFlow plan(String name, Cadence cadence, {FlowKind? kind}) =>
      PlannedFlow(
        id: null,
        kind: kind ?? FlowKind.subscription,
        name: name,
        amount: Money(99900),
        cadence: cadence,
        startsOn: d('2026-11-01'),
      );

  test('plans of every cadence round-trip; edit and archive', () async {
    await store.saveFlow(plan('Музыка', const Monthly(31)));
    await store.saveFlow(plan('Спортзал', const Weekly(3)));
    await store.saveFlow(plan('Страховка', const Yearly(2, 29)));
    await store.saveFlow(
      plan('Подработка', const Monthly(10), kind: FlowKind.otherIncome),
    );
    // Salary is set up in the income model since R3 Э3.
    await expectLater(
      store.saveFlow(
        plan('Зарплата', const Monthly(10), kind: FlowKind.salary),
      ),
      throwsArgumentError,
    );
    await store.saveFlow(plan('Ремонт', Once(d('2026-12-20'))));
    var flows = (await store.payments()).flows;
    expect(
      [for (final f in flows) f.name],
      ['Музыка', 'Спортзал', 'Страховка', 'Подработка', 'Ремонт'],
    );
    expect((flows[2].cadence as Yearly).day, 29);
    expect(flows[3].direction, FlowDirection.inflow);
    expect((flows[4].cadence as Once).date, d('2026-12-20'));

    final music = flows.first;
    await store.saveFlow(
      PlannedFlow(
        id: music.id,
        kind: music.kind,
        name: 'Музыка семейная',
        amount: Money(149900),
        cadence: const Monthly(5),
        startsOn: music.startsOn,
      ),
    );
    await store.archiveFlow(flows[1].id!);
    flows = (await store.payments()).flows;
    expect(flows.first.name, 'Музыка семейная');
    expect(flows.first.amount, Money(149900));
    expect((flows.first.cadence as Monthly).day, 5);
    expect(flows.map((f) => f.name), isNot(contains('Спортзал')));
    await expectLater(store.archiveFlow(flows[1].id!), completes);
    await expectLater(store.archiveFlow('x' * 36), throwsArgumentError);
  });

  test('«оплачено» marks toggle per occurrence', () async {
    await store.saveFlow(plan('Интернет', const Monthly(3)));
    final id = (await store.payments()).flows.single.id!;
    await store.setFlowDone(id, d('2026-12-03'), true);
    await store.setFlowDone(id, d('2026-12-03'), true); // idempotent
    expect((await store.payments()).doneMarks, {(id, d('2026-12-03'))});
    await store.setFlowDone(id, d('2026-12-03'), false);
    expect((await store.payments()).doneMarks, isEmpty);
  });

  test('card figures: only for credit cards, newest wins, settle', () async {
    await store.createAccount(
      NewAccount(
        kind: AccountKind.creditCard,
        name: 'Сбер',
        amount: Money(840000),
      ),
    );
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'Дебет', amount: Money(0)),
    );
    final accounts = await store.accounts();
    final card = accounts.firstWhere((a) => a.name == 'Сбер').id;
    final debit = accounts.firstWhere((a) => a.name == 'Дебет').id;
    var snap = await store.payments();
    expect(snap.creditCards, {card: 'Сбер'});
    expect(snap.cardFigures, isEmpty);

    await store.saveCardFigures(
      CardFigures(
        id: '',
        accountId: card,
        minPayment: Money(30000),
        minDueOn: d('2026-11-25'),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 5));
    await store.saveCardFigures(
      CardFigures(
        id: '',
        accountId: card,
        graceAmount: Money(840000),
        graceDueOn: d('2026-11-25'),
        minPayment: Money(30000),
        minDueOn: d('2026-11-25'),
      ),
    );
    snap = await store.payments();
    final current = snap.cardFigures[card]!;
    expect(current.graceAmount, Money(840000));
    expect(current.settled, false);
    await store.setCardSettled(current.id, true);
    expect((await store.payments()).cardFigures[card]!.settled, true);

    await expectLater(
      store.saveCardFigures(
        CardFigures(
          id: '',
          accountId: debit,
          minPayment: Money(1),
          minDueOn: d('2026-11-25'),
        ),
      ),
      throwsArgumentError,
    );
    await expectLater(
      store.saveCardFigures(
        CardFigures(id: '', accountId: card, graceAmount: Money(1)),
      ),
      throwsArgumentError,
    );
    await expectLater(
      store.saveCardFigures(CardFigures(id: '', accountId: card)),
      throwsArgumentError,
    );
  });

  test('invalid plans are rejected', () async {
    await expectLater(
      store.saveFlow(
        PlannedFlow(
          id: null,
          kind: FlowKind.rent,
          name: 'Аренда',
          amount: Money(0),
          cadence: const Monthly(1),
          startsOn: d('2026-11-01'),
        ),
      ),
      throwsArgumentError,
    );
    await expectLater(
      store.saveFlow(plan('  ', const Monthly(1))),
      throwsArgumentError,
    );
    expect((await store.payments()).flows, isEmpty);
  });
  test('a payment can be linked only to a credit card or loan', () async {
    await store.createAccount(
      NewAccount(kind: AccountKind.creditCard, name: 'Сбер', amount: Money(1)),
    );
    await store.createAccount(
      NewAccount(kind: AccountKind.debit, name: 'Дебет', amount: Money(1)),
    );
    final accounts = await store.accounts();
    final card = accounts.firstWhere((a) => a.name == 'Сбер').id;
    final debit = accounts.firstWhere((a) => a.name == 'Дебет').id;
    PlannedFlow linked(String to, FlowKind kind) => PlannedFlow(
      id: null,
      kind: kind,
      name: 'Платёж',
      amount: Money(100),
      cadence: const Monthly(15),
      startsOn: d('2026-11-01'),
      accountId: to,
    );
    await store.saveFlow(linked(card, FlowKind.loanPayment));
    expect((await store.payments()).flows.single.accountId, card);
    await expectLater(
      store.saveFlow(linked(debit, FlowKind.loanPayment)),
      throwsArgumentError,
    );
    await expectLater(
      store.saveFlow(linked(card, FlowKind.salary)),
      throwsArgumentError,
    );
  });
}
