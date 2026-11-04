import 'package:drift/drift.dart';

import '../../features/payments/payments.dart';
import '../calendar_date.dart';
import '../ids.dart';
import '../money/money.dart';
import 'app_database.dart' hide CardFigures;

/// Plans (recurring payments/incomes), their «оплачено» marks and the bank's
/// credit-card figures. These are plans and reference figures, not ledger
/// history: plans are editable, card figures are appended (newest = current).
final class PaymentsRepo {
  PaymentsRepo(this.db);
  final AppDatabase db;

  Future<PaymentsSnapshot> payments() async {
    final flows =
        await (db.select(db.plannedFlows)
              ..where((f) => f.archivedAtUtc.isNull())
              ..orderBy([(f) => OrderingTerm.asc(f.createdAtUtc)]))
            .get();
    final marks = await (db.select(
      db.flowMarks,
    )..where((m) => m.status.equals('done'))).get();
    final cards =
        await (db.select(db.accounts)
              ..where(
                (a) => a.kind.equals('credit_card') & a.archivedAtUtc.isNull(),
              )
              ..orderBy([(a) => OrderingTerm.asc(a.sortOrder)]))
            .get();
    final figures = <String, CardFigures>{};
    for (final card in cards) {
      final row =
          await (db.select(db.cardFigures)
                ..where((f) => f.accountId.equals(card.id))
                ..orderBy([(f) => OrderingTerm.desc(f.recordedAtUtc)])
                ..limit(1))
              .getSingleOrNull();
      if (row != null) figures[card.id] = _figures(row);
    }
    return PaymentsSnapshot(
      flows: [for (final f in flows) ?_flow(f)],
      doneMarks: {
        for (final m in marks) (m.flowId, CalendarDate.parse(m.dueOn)),
      },
      cardFigures: figures,
      creditCards: {for (final c in cards) c.id: c.name},
    );
  }

  static PlannedFlow? _flow(PlannedFlowRow r) {
    final kind = FlowKind.fromDb(r.kind);
    if (kind == null) return null;
    final Cadence cadence = switch (r.cadence) {
      'monthly' => Monthly(r.day!),
      'weekly' => Weekly(r.day!),
      'yearly' => Yearly(r.month!, r.day!),
      _ => Once(CalendarDate.parse(r.onceOn!)),
    };
    return PlannedFlow(
      id: r.id,
      kind: kind,
      name: r.name,
      amount: Money(r.amountMinor),
      cadence: cadence,
      startsOn: CalendarDate.parse(r.startsOn),
      accountId: r.accountId,
    );
  }

  static CardFigures _figures(CardFiguresRow r) => CardFigures(
    id: r.id,
    accountId: r.accountId,
    graceAmount: r.graceAmountMinor == null ? null : Money(r.graceAmountMinor!),
    graceDueOn: r.graceDueOn == null ? null : CalendarDate.parse(r.graceDueOn!),
    minPayment: r.minPaymentMinor == null ? null : Money(r.minPaymentMinor!),
    minDueOn: r.minDueOn == null ? null : CalendarDate.parse(r.minDueOn!),
    settled: r.settledAtUtc != null,
  );

  Future<void> saveFlow(PlannedFlow flow, DateTime now) async {
    final name = flow.name.trim();
    if (name.isEmpty || name.length > 60) throw ArgumentError('Invalid name');
    if (flow.amount.minorUnits <= 0 || flow.amount.currency != Currency.rub) {
      throw ArgumentError('Invalid amount');
    }
    // Salary is planned in the income model since R3 Э3 (schema v5).
    if (flow.kind == FlowKind.salary && flow.id == null) {
      throw ArgumentError('Salary is set up in income sources');
    }
    final (cadence, day, month, onceOn) = switch (flow.cadence) {
      Monthly(:final day) => ('monthly', day, null, null),
      Weekly(:final weekday) => ('weekly', weekday, null, null),
      Yearly(:final month, :final day) => ('yearly', day, month, null),
      Once(:final date) => ('once', null, null, date.iso),
    };
    await db.transaction(() async {
      final household = await db.select(db.households).getSingle();
      if (flow.accountId != null) {
        final linked = await (db.select(
          db.accounts,
        )..where((a) => a.id.equals(flow.accountId!))).getSingleOrNull();
        if (linked == null ||
            !const {'credit_card', 'loan'}.contains(linked.kind) ||
            flow.direction != FlowDirection.outflow) {
          throw ArgumentError('Only a payment can be linked to a card or loan');
        }
      }
      final values = PlannedFlowsCompanion(
        kind: Value(flow.kind.dbValue),
        name: Value(name),
        amountMinor: Value(flow.amount.minorUnits),
        currency: const Value('RUB'),
        cadence: Value(cadence),
        day: Value(day),
        month: Value(month),
        onceOn: Value(onceOn),
        startsOn: Value(flow.startsOn.iso),
        accountId: Value(flow.accountId),
      );
      if (flow.id == null) {
        await db
            .into(db.plannedFlows)
            .insert(
              values.copyWith(
                id: Value(newUuid()),
                householdId: Value(household.id),
                createdAtUtc: Value(now.toUtc().millisecondsSinceEpoch),
              ),
            );
      } else {
        final updated =
            await (db.update(db.plannedFlows)..where(
                  (f) => f.id.equals(flow.id!) & f.archivedAtUtc.isNull(),
                ))
                .write(values);
        if (updated != 1) throw ArgumentError('Unknown plan');
      }
    });
  }

  Future<void> archiveFlow(String id, DateTime now) async {
    final updated =
        await (db.update(
          db.plannedFlows,
        )..where((f) => f.id.equals(id) & f.archivedAtUtc.isNull())).write(
          PlannedFlowsCompanion(
            archivedAtUtc: Value(now.toUtc().millisecondsSinceEpoch),
          ),
        );
    if (updated != 1) throw ArgumentError('Unknown plan');
  }

  Future<void> setFlowDone(
    String flowId,
    CalendarDate dueOn,
    bool done,
    DateTime now,
  ) => db.transaction(() async {
    final key = (db.delete(db.flowMarks)
      ..where((m) => m.flowId.equals(flowId) & m.dueOn.equals(dueOn.iso)));
    await key.go();
    if (done) {
      await db
          .into(db.flowMarks)
          .insert(
            FlowMarksCompanion.insert(
              flowId: flowId,
              dueOn: dueOn.iso,
              status: 'done',
              markedAtUtc: now.toUtc().millisecondsSinceEpoch,
            ),
          );
    }
  });

  Future<void> saveCardFigures(CardFigures f, DateTime now) async {
    for (final m in [f.graceAmount, f.minPayment]) {
      if (m != null && (m.minorUnits < 0 || m.currency != Currency.rub)) {
        throw ArgumentError('Invalid amount');
      }
    }
    if ((f.graceAmount == null) != (f.graceDueOn == null) ||
        (f.minPayment == null) != (f.minDueOn == null) ||
        (f.graceAmount == null && f.minPayment == null)) {
      throw ArgumentError('Amount and date go together');
    }
    await db.transaction(() async {
      final card = await (db.select(
        db.accounts,
      )..where((a) => a.id.equals(f.accountId))).getSingleOrNull();
      if (card == null || card.kind != 'credit_card') {
        throw ArgumentError('Not a credit card');
      }
      await db
          .into(db.cardFigures)
          .insert(
            CardFiguresCompanion.insert(
              id: newUuid(),
              accountId: f.accountId,
              graceAmountMinor: Value(f.graceAmount?.minorUnits),
              graceDueOn: Value(f.graceDueOn?.iso),
              minPaymentMinor: Value(f.minPayment?.minorUnits),
              minDueOn: Value(f.minDueOn?.iso),
              source: 'user',
              recordedAtUtc: now.toUtc().millisecondsSinceEpoch,
            ),
          );
    });
  }

  Future<void> setCardSettled(String id, bool settled, DateTime now) async {
    final updated =
        await (db.update(db.cardFigures)..where((f) => f.id.equals(id))).write(
          CardFiguresCompanion(
            settledAtUtc: Value(
              settled ? now.toUtc().millisecondsSinceEpoch : null,
            ),
          ),
        );
    if (updated != 1) throw ArgumentError('Unknown figures');
  }
}
