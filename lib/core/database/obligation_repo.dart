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

/// The form was opened on an older version of the card's bank figures
/// (direct «Внёс», [CardDue]); newer figures were saved since. Nothing is
/// written — the payment is opened again on the current amount (R3 review
/// 4, 2026-11-14).
final class FiguresChanged extends InvalidOperation {
  const FiguresChanged() : super('figures changed');
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
        )..where((x) => x.id.equals(figuresId))).getSingleOrNull();
        if (f == null) throw const InvalidOperation('unknown payment');
        // Only the card's current figures can be paid: an older version
        // means the form is stale — checked here, inside the saving
        // transaction, whether or not the figures question is shown.
        if ((await _latestFigures(f.accountId))?.id != f.id) {
          throw const FiguresChanged();
        }
        final due = f.graceAmountMinor ?? f.minPaymentMinor ?? 0;
        if (due > 0 && await paidTowardFigures(f) >= due) {
          throw const AlreadyPaid();
        }
    }
  }

  /// What was already repaid of one version of a card's bank figures —
  /// the single rule for the forecast and for refusing a repeated payment.
  ///
  /// Counted: transfers INTO the card (not cancelled) — through «Внёс», a
  /// regular payment linked to the card, or any other transfer —
  ///  * dated after the day the figures were entered (the bank could not
  ///    have counted them), or
  ///  * dated on or before that day when the person answered that these
  ///    figures do NOT yet include it (`figures_transfer_answers`).
  /// Not counted: earlier transfers the bank already included (answered,
  /// or not asked — then the bank's figure is the truth), and purchases,
  /// fees, refunds (not transfers). When to record a transfer in the app
  /// does not matter.
  Future<int> paidTowardFigures(CardFiguresRow f) async {
    final entered = _localDate(f.recordedAtUtc).iso;
    final rows = await db
        .customSelect(
          'SELECT p.amount_minor AS a, d.occurred_on AS on_, '
          '(SELECT x.included FROM figures_transfer_answers x '
          ' WHERE x.figures_id = ? AND x.entry_id = e.id) AS answer '
          'FROM postings p JOIN journal_entries e ON e.id = p.entry_id '
          'JOIN entry_details d ON d.entry_id = e.id '
          "WHERE p.account_id = ? AND p.amount_minor > 0 AND e.kind = 'transfer' "
          'AND NOT EXISTS (SELECT 1 FROM entry_details r '
          'WHERE r.reverses_entry_id = e.id)',
          variables: [Variable(f.id), Variable(f.accountId)],
          readsFrom: {
            db.postings,
            db.journalEntries,
            db.entryDetails,
            db.figuresTransferAnswers,
          },
        )
        .get();
    var paid = 0;
    for (final r in rows) {
      final later = r.read<String>('on_').compareTo(entered) > 0;
      if (later || r.read<int?>('answer') == 0) paid += r.read<int>('a');
    }
    return paid;
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

  /// The current bank figures of the card [target] pays, if the payment's
  /// [date] is not after the day they were entered (then the bank may or may
  /// not have counted it — the person is asked).
  Future<CardFiguresRow?> _figuresToAsk(
    PayTarget target,
    CalendarDate date,
  ) async {
    CardFiguresRow? f;
    switch (target) {
      case CardDue(:final figuresId):
        f = await (db.select(
          db.cardFigures,
        )..where((x) => x.id.equals(figuresId))).getSingleOrNull();
      case PlanDate(:final flowId):
        final flow = await (db.select(
          db.plannedFlows,
        )..where((x) => x.id.equals(flowId))).getSingleOrNull();
        final card = flow?.accountId;
        if (card == null) return null;
        f = await _latestFigures(card);
    }
    if (f == null || date > _localDate(f.recordedAtUtc)) return null;
    return f;
  }

  /// The card's current bank figures (the newest version), if any.
  Future<CardFiguresRow?> _latestFigures(String card) =>
      (db.select(db.cardFigures)
            ..where((x) => x.accountId.equals(card))
            ..orderBy([(x) => OrderingTerm.desc(x.recordedAtUtc)])
            ..limit(1))
          .getSingleOrNull();

  static CalendarDate _localDate(int ms) =>
      CalendarDate.fromDateTime(DateTime.fromMillisecondsSinceEpoch(ms));

  Future<PaymentCheck> preview(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
  }) => db.transaction(() async {
    await _checkOpen(target);
    final op = await _operation(target, amount, accountId, date);
    final f = await _figuresToAsk(target, date);
    return PaymentCheck(
      await Journal(db)
          .preview(op, now: now, placement: placement, answers: answers),
      await similar(accountId, amount, date),
      f == null
          ? null
          : FiguresQuestion(
              figuresId: f.id,
              due: Money(f.graceAmountMinor ?? f.minPaymentMinor ?? 0),
              enteredOn: _localDate(f.recordedAtUtc),
            ),
    );
  });

  /// Books the payment and links it, atomically. With `auto` (the screens)
  /// every confirmation question must be answered about the CURRENT
  /// confirmation of its account — an answer given before a newer
  /// confirmation appeared is refused, the person is asked again. A
  /// figures question needs [figuresIncluded]; a similar operation must be
  /// confirmed. [placement] other than `auto` is an internal shortcut that
  /// answers every question the same way.
  Future<String> pay(
    PayTarget target, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
    FiguresAnswer? figuresAnswer,
    bool confirmedNotDuplicate = false,
  }) => db.transaction(() async {
    await _checkOpen(target);
    final op = await _operation(target, amount, accountId, date);
    final shown = await Journal(db)
        .preview(op, now: now, placement: placement, answers: answers);
    if (placement == SameDayPlacement.auto &&
        shown.unanswered(answers).isNotEmpty) {
      throw const InvalidOperation('answer required');
    }
    // The answer must be about the version asked about now: if newer bank
    // figures appeared since the preview, nothing is written and the
    // person is asked again (R3 review 2, 2026-11-14).
    final f = await _figuresToAsk(target, date);
    if (f != null && figuresAnswer?.figuresId != f.id) {
      throw const InvalidOperation('figures answer required');
    }
    if (!confirmedNotDuplicate &&
        (await similar(accountId, amount, date)).isNotEmpty) {
      throw const SimilarOperationExists();
    }
    return _book(
      target,
      op,
      amount,
      date,
      now,
      placement: placement,
      answers: answers,
      figuresAnswers: {if (f != null) f.id: figuresAnswer!.included},
    );
  });

  Future<String> _book(
    PayTarget target,
    Operation op,
    Money amount,
    CalendarDate paidOn,
    DateTime now, {
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
    Map<String, bool> figuresAnswers = const {},
  }) async {
    final recorded = await Journal(db)
        .record(op, now: now, placement: placement, answers: answers);
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
    for (final e in figuresAnswers.entries) {
      await db
          .into(db.figuresTransferAnswers)
          .insert(
            FiguresTransferAnswersCompanion.insert(
              figuresId: e.key,
              entryId: recorded.entryId,
              included: e.value ? 1 : 0,
              answeredAtUtc: now.toUtc().millisecondsSinceEpoch,
            ),
          );
    }
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

  /// Lines of the anchor corrections made for an operation (not the
  /// operation itself): (account, amount, moment).
  Future<List<(String, int, int)>> _causedLines(String entryId) async {
    final rows = await db
        .customSelect(
          'SELECT p.account_id AS a, p.amount_minor AS m, e.occurred_at_utc AS t '
          'FROM postings p JOIN journal_entries e ON e.id = p.entry_id '
          'JOIN entry_details d ON d.entry_id = e.id '
          'WHERE d.caused_by_entry_id = ?',
          variables: [Variable(entryId)],
        )
        .get();
    return [
      for (final r in rows)
        (r.read<String>('a'), r.read<int>('m'), r.read<int>('t')),
    ];
  }

  /// Sides of live payments not yet in a confirmed balance: for each own
  /// account of the operation, what the operation (with its corrections)
  /// still changes AFTER that account's last confirmation. This holds also
  /// when the operation itself is dated before that confirmation and the
  /// answer was «ещё нет». Each side is confirmed separately: the debit by
  /// the debit account's balance, the credit by the card's debt.
  Future<List<PendingSide>> pending() async => [
    for (final o in await _openSides()) o.side,
  ];

  Future<List<({PendingSide side, String entry, int effect})>>
  _openSides() async {
    final rows = await db
        .customSelect(
          'SELECT op.id AS id, op.entry_id AS entry, op.amount_minor AS amount, '
          'op.paid_on AS paid_on, d.description AS what, '
          'e.occurred_at_utc AS at '
          'FROM obligation_payments op '
          'JOIN journal_entries e ON e.id = op.entry_id '
          'LEFT JOIN entry_details d ON d.entry_id = op.entry_id '
          'WHERE NOT EXISTS (SELECT 1 FROM entry_details r '
          'WHERE r.reverses_entry_id = op.entry_id) '
          'ORDER BY op.created_at_utc',
          readsFrom: {db.obligationPayments, db.entryDetails},
        )
        .get();
    final ownKinds = {for (final k in AccountKind.values) k.dbValue};
    final result = <({PendingSide side, String entry, int effect})>[];
    for (final r in rows) {
      final entry = r.read<String>('entry');
      final mainAt = r.read<int>('at');
      final caused = await _causedLines(entry);
      final lines = await db
          .customSelect(
            'SELECT p.account_id AS a, p.amount_minor AS m, x.kind AS k '
            'FROM postings p JOIN accounts x ON x.id = p.account_id '
            'WHERE p.entry_id = ? ORDER BY p.line_no',
            variables: [Variable(entry)],
          )
          .get();
      for (final line in lines) {
        if (!ownKinds.contains(line.read<String>('k'))) continue;
        final account = line.read<String>('a');
        final last = await db
            .customSelect(
              'SELECT COALESCE(MAX(asserted_at_utc), -1) AS t '
              'FROM balance_assertions WHERE account_id = ?',
              variables: [Variable(account)],
            )
            .getSingle();
        final t = last.read<int>('t');
        var after = mainAt > t ? line.read<int>('m') : 0;
        for (final l in caused) {
          if (l.$1 == account && l.$3 > t) after += l.$2;
        }
        if (after == 0) continue;
        result.add((
          side: PendingSide(
            paymentId: r.read<String>('id'),
            title: r.read<String?>('what') ?? '',
            amount: Money(r.read<int>('amount')),
            accountId: account,
            paidOn: CalendarDate.parse(r.read<String>('paid_on')),
            incoming: after > 0,
          ),
          entry: entry,
          effect: after,
        ));
      }
    }
    return result;
  }

  /// «Обновить остатки». [pending] answers, for every not yet confirmed
  /// side on an account confirmed now, whether the bank already shows it
  /// (required — no default; `InvalidOperation('answer required')`).
  ///
  /// - «Уже списано» / «уже зачислено»: nothing to add — the bank's figure
  ///   contains the operation, which is now inside the new confirmation.
  /// - «Ещё не списано» / «ещё не зачислено»: the bank's figure is
  ///   confirmed WITHOUT what is still to come (a correction at the moment
  ///   of the confirmation, caused by the operation), and it takes effect
  ///   again right after it. The balance in the app stays the bank's figure
  ///   with the operation; nothing unexplained appears.
  /// - A side on an account not confirmed now keeps its state.
  ///
  /// The operation itself is never re-booked: its date, accounts, kind and
  /// figures answers stay as recorded; cancelling it later removes these
  /// corrections too (R3 review 3, 2026-11-14).
  Future<BalanceUpdateResult> updateBalances(
    Map<String, Money> amounts,
    Map<PendingKey, bool> pending,
    DateTime now,
  ) => db.transaction(() async {
    final notYet = <({PendingSide side, String entry, int effect})>[];
    for (final o in await _openSides()) {
      if (!amounts.containsKey(o.side.accountId)) continue;
      final arrived = pending[o.side.key];
      if (arrived == null) throw const InvalidOperation('answer required');
      if (!arrived) notYet.add(o);
    }
    final journal = Journal(db);
    final at = now.toUtc().millisecondsSinceEpoch;
    for (final o in notYet) {
      await journal.holdOut(o.entry, o.side.accountId, o.effect, at, now);
    }
    final result = await Ledger(db).updateBalances(amounts, now);
    for (final o in notYet) {
      await journal.release(o.entry, o.side.accountId, o.effect, at + 1, now);
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
