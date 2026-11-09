import 'package:drift/drift.dart';

import '../../features/accounts/accounts.dart';
import '../../features/operations/operations.dart';
import '../../features/payments/payments.dart';
import '../calendar_date.dart';
import '../ids.dart';
import '../money/money.dart';
import 'app_database.dart' hide CardFigures;
import 'journal.dart';
import 'ledger.dart';

/// The same payment is already recorded (repeated tap, second device…).
final class AlreadyPaid extends InvalidOperation {
  const AlreadyPaid() : super('already paid');
}

/// An operation like this one exists; record only after the person
/// confirmed it is a different payment.
final class SimilarOperationExists extends InvalidOperation {
  const SimilarOperationExists() : super('similar operation exists');
}

/// «Оплачено» through the journal (R3 risk Р1, docs/r3-plan.md).
///
/// Paying a plan date or a credit card's figures books an operation — an
/// expense (rent, phone…) or a transfer to the card/loan it repays — and
/// links it to the obligation, in one transaction. The obligation is
/// released only by such an operation (or an explicit «пропустить»): a
/// balance update alone never releases it. The anchor rule keeps confirmed
/// balances true, so a payment already in a confirmed balance is not taken
/// twice. A second payment of the same date is refused inside the same
/// transaction; cancelling reverses the operation and keeps the history.
final class ObligationRepo {
  ObligationRepo(this.db);
  final AppDatabase db;

  static const _categoryFor = {
    'subscription': 'subscriptions',
    'utilities': 'home',
    'rent': 'home',
    'communication': 'communication',
    'loan_payment': 'other_expense',
    'other_payment': 'other_expense',
  };

  Future<String> _category(String key) async => (await (db.select(
    db.categories,
  )..where((c) => c.systemKey.equals(key))).getSingle()).id;

  /// The operation that pays [target] from [accountId].
  Future<Operation> _operation(
    PayTarget target,
    Money amount,
    String accountId,
    CalendarDate date,
  ) async {
    final from = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(accountId))).getSingleOrNull();
    final kind = from == null ? null : AccountKind.fromDb(from.kind);
    if (kind == null || kind.isLiability || from!.archivedAtUtc != null) {
      throw const InvalidOperation('pay from a money account');
    }
    switch (target) {
      case PlanDate(:final flowId):
        final f = await (db.select(
          db.plannedFlows,
        )..where((x) => x.id.equals(flowId))).getSingleOrNull();
        final category = f == null ? null : _categoryFor[f.kind];
        if (f == null || category == null) {
          throw const InvalidOperation('unknown payment');
        }
        // Repaying a card or a loan moves money between own accounts.
        if (f.accountId case final debt?) {
          return TransferOp(
            fromAccountId: accountId,
            toAccountId: debt,
            amount: amount,
            date: date,
            description: f.name,
          );
        }
        return ExpenseOp(
          accountId: accountId,
          categoryId: await _category(category),
          amount: amount,
          date: date,
          description: f.name,
        );
      case CardDue(:final figuresId):
        final f = await (db.select(
          db.cardFigures,
        )..where((x) => x.id.equals(figuresId))).getSingleOrNull();
        if (f == null) throw const InvalidOperation('unknown payment');
        final card = await (db.select(
          db.accounts,
        )..where((a) => a.id.equals(f.accountId))).getSingle();
        return TransferOp(
          fromAccountId: accountId,
          toAccountId: card.id,
          amount: amount,
          date: date,
          description: card.name,
        );
    }
  }

  /// Live payments (not cancelled) of [target].
  Future<List<ObligationPaymentRow>> _live(PayTarget target) async {
    final rows =
        await (db.select(db.obligationPayments)..where(
              (p) => switch (target) {
                PlanDate(:final flowId, :final dueOn) =>
                  p.flowId.equals(flowId) & p.dueOn.equals(dueOn.iso),
                CardDue(:final figuresId) => p.cardFiguresId.equals(figuresId),
              },
            ))
            .get();
    return [
      for (final r in rows)
        if (!await _reversed(r.entryId)) r,
    ];
  }

  Future<bool> _reversed(String entryId) async =>
      (await (db.select(
        db.entryDetails,
      )..where((d) => d.reversesEntryId.equals(entryId))).getSingleOrNull()) !=
      null;

  /// Refuses a payment that would pay [target] twice.
  Future<void> _checkOpen(PayTarget target) async {
    final live = await _live(target);
    switch (target) {
      case PlanDate(:final flowId, :final dueOn):
        if (live.isNotEmpty) throw const AlreadyPaid();
        final skipped =
            await (db.select(db.flowMarks)..where(
                  (m) =>
                      m.flowId.equals(flowId) &
                      m.dueOn.equals(dueOn.iso) &
                      m.status.equals('skipped'),
                ))
                .getSingleOrNull();
        if (skipped != null) throw const InvalidOperation('skipped');
      case CardDue(:final figuresId):
        final f = await (db.select(
          db.cardFigures,
        )..where((x) => x.id.equals(figuresId))).getSingle();
        final due = f.graceAmountMinor ?? f.minPaymentMinor ?? 0;
        if (due > 0 && await paidTowardFigures(f) >= due) {
          throw const AlreadyPaid();
        }
    }
  }

  /// What was already repaid of a card's bank figures: every transfer INTO
  /// the card (through «Внёс», a regular payment linked to the card, or any
  /// other transfer between own accounts), not cancelled, recorded after
  /// the figures were entered (earlier repayments are already in the bank's
  /// figure). Purchases, fees and refunds are not transfers and never
  /// reduce what is still due.
  Future<int> paidTowardFigures(CardFiguresRow f) async {
    final row = await db
        .customSelect(
          'SELECT COALESCE(SUM(p.amount_minor), 0) AS s FROM postings p '
          'JOIN journal_entries e ON e.id = p.entry_id '
          "WHERE p.account_id = ? AND p.amount_minor > 0 AND e.kind = 'transfer' "
          'AND e.recorded_at_utc >= ? AND NOT EXISTS (SELECT 1 FROM '
          'entry_details d WHERE d.reverses_entry_id = e.id)',
          variables: [Variable(f.accountId), Variable(f.recordedAtUtc)],
          readsFrom: {db.postings, db.journalEntries, db.entryDetails},
        )
        .getSingle();
    return row.read<int>('s');
  }

  /// Expenses and transfers out of [accountId] with the same [amount],
  /// three days around [date], not cancelled.
  Future<List<SimilarOperation>> similar(
    String accountId,
    Money amount,
    CalendarDate date,
  ) async {
    final rows = await db
        .customSelect(
          'SELECT d.occurred_on AS on_, d.description AS what, e.id AS id '
          'FROM postings p JOIN journal_entries e ON e.id = p.entry_id '
          'JOIN entry_details d ON d.entry_id = e.id '
          "WHERE p.account_id = ? AND p.amount_minor = ? AND e.kind IN "
          "('expense', 'transfer') AND d.occurred_on BETWEEN ? AND ?",
          variables: [
            Variable(accountId),
            Variable(-amount.minorUnits),
            Variable(date.addDays(-3).iso),
            Variable(date.addDays(3).iso),
          ],
          readsFrom: {db.postings, db.journalEntries, db.entryDetails},
        )
        .get();
    return [
      for (final r in rows)
        if (!await _reversed(r.read<String>('id')))
          SimilarOperation(
            CalendarDate.parse(r.read<String>('on_')),
            amount,
            r.read<String?>('what'),
          ),
    ];
  }

  Future<PaymentCheck> preview(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
  }) => db.transaction(() async {
    await _checkOpen(target);
    final op = await _operation(target, amount, accountId, date);
    return PaymentCheck(
      await Journal(db).preview(op, now: now, placement: placement),
      await similar(accountId, amount, date),
    );
  });

  /// Books the payment and links it, atomically. A same-day placement must
  /// be explicit ([SameDayPlacement.auto] is refused when a balance was
  /// confirmed that day); a similar operation must be confirmed.
  Future<String> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    required SameDayPlacement placement,
    bool confirmedNotDuplicate = false,
  }) => db.transaction(() async {
    await _checkOpen(target);
    final op = await _operation(target, amount, accountId, date);
    final journal = Journal(db);
    final shown = await journal.preview(op, now: now, placement: placement);
    if (shown.askIncluded && placement == SameDayPlacement.auto) {
      throw const InvalidOperation('same-day placement must be chosen');
    }
    if (!confirmedNotDuplicate &&
        (await similar(accountId, amount, date)).isNotEmpty) {
      throw const SimilarOperationExists();
    }
    return _book(target, op, amount, date, now, placement);
  });

  Future<String> _book(
    PayTarget target,
    Operation op,
    Money amount,
    CalendarDate paidOn,
    DateTime now,
    SameDayPlacement placement,
  ) async {
    final recorded = await Journal(db)
        .record(op, now: now, placement: placement);
    await db
        .into(db.obligationPayments)
        .insert(
          ObligationPaymentsCompanion.insert(
            id: newUuid(),
            flowId: Value(switch (target) {
              PlanDate(:final flowId) => flowId,
              CardDue() => null,
            }),
            dueOn: Value(switch (target) {
              PlanDate(:final dueOn) => dueOn.iso,
              CardDue() => null,
            }),
            cardFiguresId: Value(switch (target) {
              PlanDate() => null,
              CardDue(:final figuresId) => figuresId,
            }),
            entryId: recorded.entryId,
            amountMinor: amount.minorUnits,
            paidOn: paidOn.iso,
            createdAtUtc: now.toUtc().millisecondsSinceEpoch,
          ),
        );
    return recorded.entryId;
  }

  /// A payment marked by mistake: its operation is reversed (the date is an
  /// obligation again); the row and the history stay.
  Future<void> cancel(String paymentId, DateTime now) =>
      db.transaction(() async {
        final row = await (db.select(
          db.obligationPayments,
        )..where((p) => p.id.equals(paymentId))).getSingle();
        await Journal(db).reverse(row.entryId, now);
      });

  /// «Платежа не будет» for one date (or undo it).
  Future<void> setSkipped(
    String flowId,
    CalendarDate dueOn,
    bool skipped,
    DateTime now,
  ) => db.transaction(() async {
    if (skipped && (await _live(PlanDate(flowId, dueOn))).isNotEmpty) {
      throw const AlreadyPaid();
    }
    await (db.delete(
      db.flowMarks,
    )..where((m) => m.flowId.equals(flowId) & m.dueOn.equals(dueOn.iso))).go();
    if (skipped) {
      await db
          .into(db.flowMarks)
          .insert(
            FlowMarksCompanion.insert(
              flowId: flowId,
              dueOn: dueOn.iso,
              status: 'skipped',
              markedAtUtc: now.toUtc().millisecondsSinceEpoch,
            ),
          );
    }
  });

  /// Payments recorded after their account's last confirmed balance.
  Future<List<PendingDebit>> pending() async {
    final rows = await db
        .customSelect(
          '''
      SELECT op.id AS id, op.amount_minor AS amount, op.paid_on AS paid_on,
             e.occurred_at_utc AS at, d.description AS what,
             (SELECT p.account_id FROM postings p JOIN accounts a
                ON a.id = p.account_id
              WHERE p.entry_id = e.id AND p.amount_minor < 0
                AND a.kind IN ('debit', 'cash', 'savings', 'deposit')
              LIMIT 1) AS account
      FROM obligation_payments op
      JOIN journal_entries e ON e.id = op.entry_id
      LEFT JOIN entry_details d ON d.entry_id = e.id
      WHERE NOT EXISTS (SELECT 1 FROM entry_details r
                        WHERE r.reverses_entry_id = op.entry_id)
      ORDER BY e.occurred_at_utc
    ''',
          readsFrom: {db.obligationPayments, db.journalEntries},
        )
        .get();
    final result = <PendingDebit>[];
    for (final r in rows) {
      final account = r.read<String?>('account');
      if (account == null) continue;
      final last = await db
          .customSelect(
            'SELECT MAX(asserted_at_utc) AS t FROM balance_assertions '
            'WHERE account_id = ?',
            variables: [Variable(account)],
          )
          .getSingle();
      final t = last.read<int?>('t');
      if (t != null && r.read<int>('at') <= t) continue;
      result.add(
        PendingDebit(
          paymentId: r.read<String>('id'),
          title: r.read<String?>('what') ?? '',
          amount: Money(r.read<int>('amount')),
          accountId: account,
          paidOn: CalendarDate.parse(r.read<String>('paid_on')),
        ),
      );
    }
    return result;
  }

  /// «Обновить остатки» when some recorded payments are not yet taken by
  /// the bank ([notYetDebited], answered explicitly by the person): the
  /// bank's figure is confirmed WITHOUT them, then each such payment is
  /// booked again right after that confirmation (its first operation is
  /// reversed and the obligation stays paid). The balance in the app is the
  /// bank's figure minus what is still to be debited — never more.
  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> amounts,
    Set<String> notYetDebited,
    DateTime now,
  ) => db.transaction(() async {
    final journal = Journal(db);
    final rebook = <(PayTarget, Operation, Money, CalendarDate)>[];
    for (final id in notYetDebited) {
      final row = await (db.select(
        db.obligationPayments,
      )..where((p) => p.id.equals(id))).getSingle();
      if (await _reversed(row.entryId)) continue;
      final target = row.flowId != null
          ? PlanDate(row.flowId!, CalendarDate.parse(row.dueOn!))
          : CardDue(row.cardFiguresId!);
      final from = await db
          .customSelect(
            'SELECT p.account_id AS a FROM postings p JOIN accounts x '
            'ON x.id = p.account_id WHERE p.entry_id = ? AND p.amount_minor < 0 '
            "AND x.kind IN ('debit', 'cash', 'savings', 'deposit') LIMIT 1",
            variables: [Variable(row.entryId)],
          )
          .getSingle();
      await journal.reverse(row.entryId, now);
      final today = CalendarDate.fromDateTime(now);
      rebook.add((
        target,
        await _operation(
          target,
          Money(row.amountMinor),
          from.read<String>('a'),
          today,
        ),
        Money(row.amountMinor),
        CalendarDate.parse(row.paidOn),
      ));
    }
    final result = await Ledger(db).updateBalances(amounts, now);
    for (final (target, op, amount, paidOn) in rebook) {
      await _book(
        target,
        op,
        amount,
        paidOn,
        now,
        SameDayPlacement.afterConfirmedBalance,
      );
    }
    return result;
  });

  /// Every payment for the snapshot (with the account the money left).
  Future<List<ObligationPayment>> history() async {
    final rows = await db
        .customSelect(
          '''
      SELECT op.*,
        (SELECT 1 FROM entry_details r WHERE r.reverses_entry_id = op.entry_id)
          AS cancelled,
        (SELECT p.account_id FROM postings p JOIN accounts a ON a.id = p.account_id
          WHERE p.entry_id = op.entry_id AND p.amount_minor < 0
            AND a.kind IN ('debit', 'cash', 'savings', 'deposit') LIMIT 1)
          AS account
      FROM obligation_payments op ORDER BY op.created_at_utc
    ''',
          readsFrom: {db.obligationPayments, db.entryDetails, db.postings},
        )
        .get();
    return [
      for (final r in rows)
        ObligationPayment(
          id: r.read<String>('id'),
          target: r.read<String?>('flow_id') != null
              ? PlanDate(
                  r.read<String>('flow_id'),
                  CalendarDate.parse(r.read<String>('due_on')),
                )
              : CardDue(r.read<String>('card_figures_id')),
          entryId: r.read<String>('entry_id'),
          amount: Money(r.read<int>('amount_minor')),
          paidOn: CalendarDate.parse(r.read<String>('paid_on')),
          cancelled: r.read<int?>('cancelled') != null,
          accountId: r.read<String?>('account'),
        ),
    ];
  }
}
