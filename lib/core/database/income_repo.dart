import 'package:drift/drift.dart';

import '../../features/forecast/safe_to_spend.dart'
    show ForecastPeriod, PeriodDays, PeriodUntil, defaultForecastPeriod;
import '../../features/income/income.dart';
import '../../features/operations/operations.dart';
import '../../features/payments/payments.dart'
    show Cadence, Monthly, Weekly, Yearly, Once;
import '../calendar_date.dart';
import '../ids.dart';
import '../money/money.dart';
import 'app_database.dart';
import 'journal.dart';

/// Income sources, their versioned schedules and payments (R3 Э3).
///
/// Receipts are booked through [Journal] (income entry + anchor rule), so a
/// salary already present in a confirmed balance is never counted twice.
/// The plan (schedule) and the expectation (moved date, «не знаю когда»,
/// amount) are editable; receipts and the journal are append-only.
final class IncomeRepo {
  IncomeRepo(this.db);
  final AppDatabase db;

  /// How far ahead scheduled payments are listed.
  static const windowDays = 62;

  Future<IncomeSnapshot> snapshot(CalendarDate today) async {
    final sources = await _sources();
    final stored = await _stored();
    return IncomeSnapshot(
      sources: sources,
      payments: buildPayments(sources, stored, today.addDays(windowDays)),
    );
  }

  Future<List<IncomeSource>> _sources() async {
    final rows =
        await (db.select(db.incomeSources)
              ..where((s) => s.archivedAtUtc.isNull())
              ..orderBy([(s) => OrderingTerm.asc(s.createdAtUtc)]))
            .get();
    final result = <IncomeSource>[];
    for (final s in rows) {
      final parts =
          await (db.select(db.incomeScheduleParts)
                ..where((p) => p.sourceId.equals(s.id))
                ..orderBy([
                  (p) => OrderingTerm.asc(p.validFrom),
                  (p) => OrderingTerm.asc(p.createdAtUtc),
                ]))
              .get();
      result.add(
        IncomeSource(
          id: s.id,
          name: s.name,
          kind: IncomeKind.fromDb(s.kind),
          holidayRule: HolidayRule.fromDb(s.holidayRule),
          trackedFrom: CalendarDate.parse(s.trackedFrom),
          accountId: s.accountId,
          parts: [
            for (final p in parts)
              SchedulePart(
                id: p.id,
                label: p.label,
                amount: Money(p.amountMinor),
                cadence: switch (p.cadence) {
                  'monthly' => Monthly(p.day!),
                  'weekly' => Weekly(p.day!),
                  'yearly' => Yearly(p.month!, p.day!),
                  _ => Once(CalendarDate.parse(p.onceOn!)),
                },
                validFrom: CalendarDate.parse(p.validFrom),
                validTo: p.validTo == null
                    ? null
                    : CalendarDate.parse(p.validTo!),
              ),
          ],
        ),
      );
    }
    return result;
  }

  Future<List<StoredPayment>> _stored() async {
    final rows = await db.select(db.incomeOccurrences).get();
    final receipts = await db
        .customSelect(
          '''
      SELECT r.id AS id, r.occurrence_id AS occ, r.entry_id AS entry,
             r.amount_minor AS amount, r.received_on AS on_,
             (SELECT 1 FROM entry_details d WHERE d.reverses_entry_id = r.entry_id) AS cancelled,
             (SELECT p.account_id FROM postings p JOIN accounts a ON a.id = p.account_id
               WHERE p.entry_id = r.entry_id AND a.kind NOT IN ('income', 'expense')
               LIMIT 1) AS account
      FROM income_receipts r ORDER BY r.created_at_utc
    ''',
          readsFrom: {db.incomeReceipts, db.entryDetails, db.postings},
        )
        .get();
    final byOccurrence = <String, List<Receipt>>{};
    for (final r in receipts) {
      byOccurrence
          .putIfAbsent(r.read<String>('occ'), () => [])
          .add(
            Receipt(
              id: r.read<String>('id'),
              entryId: r.read<String>('entry'),
              amount: Money(r.read<int>('amount')),
              receivedOn: CalendarDate.parse(r.read<String>('on_')),
              cancelled: r.read<int?>('cancelled') != null,
              accountId: r.read<String?>('account'),
            ),
          );
    }
    return [
      for (final o in rows)
        StoredPayment(
          id: o.id,
          sourceId: o.sourceId,
          partId: o.partId,
          plannedOn: CalendarDate.parse(o.plannedOn),
          plannedAmount: Money(o.plannedAmountMinor),
          expectedOn: o.expectedOn == null
              ? null
              : CalendarDate.parse(o.expectedOn!),
          dateUnknown: o.dateUnknown == 1,
          expectedAmount: o.expectedAmountMinor == null
              ? null
              : Money(o.expectedAmountMinor!),
          state: PaymentState.fromDb(o.state),
          receipts: byOccurrence[o.id] ?? const [],
        ),
    ];
  }

  // --- Schedule ---------------------------------------------------------------

  /// A new source with its schedule, tracked from [today].
  Future<String> createSource({
    required String name,
    required IncomeKind kind,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
    required CalendarDate today,
    required DateTime now,
  }) => db.transaction(() async {
    _checkName(name);
    if (parts.isEmpty) throw const InvalidOperation('empty schedule');
    final household = await db.select(db.households).getSingle();
    final id = newUuid();
    final at = now.toUtc().millisecondsSinceEpoch;
    await db
        .into(db.incomeSources)
        .insert(
          IncomeSourcesCompanion.insert(
            id: id,
            householdId: household.id,
            name: name.trim(),
            kind: kind.dbValue,
            accountId: Value(await _account(accountId)),
            holidayRule: holidayRule.dbValue,
            trackedFrom: today.iso,
            createdAtUtc: at,
          ),
        );
    for (final p in parts) {
      await _insertPart(id, p, today, at);
    }
    return id;
  });

  /// Changes a schedule from [effectiveFrom] on. Payments before that date
  /// — and every stored payment with its receipts — keep the version they
  /// were planned with; only later scheduled payments follow the new one.
  Future<void> updateSchedule(
    String sourceId, {
    required String name,
    required HolidayRule holidayRule,
    required List<PartSpec> parts,
    String? accountId,
    required CalendarDate effectiveFrom,
    required DateTime now,
  }) => db.transaction(() async {
    _checkName(name);
    if (parts.isEmpty) throw const InvalidOperation('empty schedule');
    final at = now.toUtc().millisecondsSinceEpoch;
    await (db.update(
      db.incomeSources,
    )..where((s) => s.id.equals(sourceId))).write(
      IncomeSourcesCompanion(
        name: Value(name.trim()),
        holidayRule: Value(holidayRule.dbValue),
        accountId: Value(await _account(accountId)),
      ),
    );
    final current = await (db.select(
      db.incomeScheduleParts,
    )..where((p) => p.sourceId.equals(sourceId) & p.validTo.isNull())).get();
    final kept = <String>{};
    for (final spec in parts) {
      final old = current.where((c) => c.id == spec.id).firstOrNull;
      if (old != null && _same(old, spec)) {
        kept.add(old.id);
        continue;
      }
      await _insertPart(sourceId, spec, effectiveFrom, at);
    }
    for (final old in current.where((c) => !kept.contains(c.id))) {
      await _closePart(old, effectiveFrom);
    }
  });

  bool _same(IncomeSchedulePartRow p, PartSpec s) {
    final c = _cadenceColumns(s.cadence);
    return p.label == s.label.trim() &&
        p.amountMinor == s.amount.minorUnits &&
        p.cadence == c.$1 &&
        p.day == c.$2 &&
        p.month == c.$3 &&
        p.onceOn == c.$4;
  }

  /// Ends a version before [from]. A version that has not started yet and
  /// has no payments is removed (plans are editable; nothing refers to it).
  Future<void> _closePart(IncomeSchedulePartRow p, CalendarDate from) async {
    final start = CalendarDate.parse(p.validFrom);
    if (start >= from) {
      final used = await (db.select(
        db.incomeOccurrences,
      )..where((o) => o.partId.equals(p.id))).get();
      if (used.isEmpty) {
        await (db.delete(
          db.incomeScheduleParts,
        )..where((x) => x.id.equals(p.id))).go();
        return;
      }
      // Referenced: keep it valid for its first day only.
      await (db.update(db.incomeScheduleParts)..where((x) => x.id.equals(p.id)))
          .write(IncomeSchedulePartsCompanion(validTo: Value(p.validFrom)));
      return;
    }
    await (db.update(
      db.incomeScheduleParts,
    )..where((x) => x.id.equals(p.id))).write(
      IncomeSchedulePartsCompanion(validTo: Value(from.addDays(-1).iso)),
    );
  }

  Future<void> _insertPart(
    String sourceId,
    PartSpec p,
    CalendarDate from,
    int at,
  ) async {
    if (p.amount.minorUnits <= 0 || p.amount.currency != Currency.rub) {
      throw const InvalidOperation('amount');
    }
    final label = p.label.trim();
    if (label.isEmpty || label.length > 40) {
      throw const InvalidOperation('label');
    }
    final c = _cadenceColumns(p.cadence);
    await db
        .into(db.incomeScheduleParts)
        .insert(
          IncomeSchedulePartsCompanion.insert(
            id: newUuid(),
            sourceId: sourceId,
            label: label,
            amountMinor: p.amount.minorUnits,
            currency: 'RUB',
            cadence: c.$1,
            day: Value(c.$2),
            month: Value(c.$3),
            onceOn: Value(c.$4),
            validFrom: from.iso,
            createdAtUtc: at,
          ),
        );
  }

  static (String, int?, int?, String?) _cadenceColumns(Cadence c) =>
      switch (c) {
        Monthly(:final day) => ('monthly', day, null, null),
        Weekly(:final weekday) => ('weekly', weekday, null, null),
        Yearly(:final month, :final day) => ('yearly', day, month, null),
        Once(:final date) => ('once', null, null, date.iso),
      };

  void _checkName(String name) {
    final n = name.trim();
    if (n.isEmpty || n.length > 60) throw const InvalidOperation('name');
  }

  Future<String?> _account(String? id) async {
    if (id == null) return null;
    final row = await (db.select(
      db.accounts,
    )..where((a) => a.id.equals(id))).getSingleOrNull();
    if (row == null || row.archivedAtUtc != null) {
      throw const InvalidOperation('unknown account');
    }
    return id;
  }

  Future<void> archiveSource(String id, DateTime now) =>
      (db.update(db.incomeSources)..where((s) => s.id.equals(id))).write(
        IncomeSourcesCompanion(
          archivedAtUtc: Value(now.toUtc().millisecondsSinceEpoch),
        ),
      );

  // --- One payment ------------------------------------------------------------

  /// The stored row for [key], created from the schedule if needed.
  Future<IncomeOccurrenceRow> _materialize(PaymentKey key, DateTime now) async {
    final existing =
        await (db.select(db.incomeOccurrences)..where(
              (o) =>
                  o.sourceId.equals(key.sourceId) &
                  (key.partId == null
                      ? o.partId.isNull()
                      : o.partId.equals(key.partId!)) &
                  o.plannedOn.equals(key.plannedOn.iso),
            ))
            .getSingleOrNull();
    if (existing != null) return existing;
    if (key.partId == null) throw const InvalidOperation('unknown payment');
    final part = await (db.select(
      db.incomeScheduleParts,
    )..where((p) => p.id.equals(key.partId!))).getSingleOrNull();
    if (part == null || part.sourceId != key.sourceId) {
      throw const InvalidOperation('unknown payment');
    }
    final at = now.toUtc().millisecondsSinceEpoch;
    final id = newUuid();
    await db
        .into(db.incomeOccurrences)
        .insert(
          IncomeOccurrencesCompanion.insert(
            id: id,
            sourceId: key.sourceId,
            partId: Value(key.partId),
            plannedOn: key.plannedOn.iso,
            plannedAmountMinor: part.amountMinor,
            dateUnknown: 0,
            state: 'open',
            createdAtUtc: at,
            updatedAtUtc: at,
          ),
        );
    return (db.select(
      db.incomeOccurrences,
    )..where((o) => o.id.equals(id))).getSingle();
  }

  Future<void> _update(
    PaymentKey key,
    DateTime now,
    IncomeOccurrencesCompanion Function(IncomeOccurrenceRow row) change,
  ) => db.transaction(() async {
    final row = await _materialize(key, now);
    await (db.update(
      db.incomeOccurrences,
    )..where((o) => o.id.equals(row.id))).write(
      change(row)
          .copyWith(updatedAtUtc: Value(now.toUtc().millisecondsSinceEpoch)),
    );
  });

  /// «Перенести»: a new expected date for this payment only.
  Future<void> move(PaymentKey key, CalendarDate to, DateTime now) =>
      _update(key, now, (row) {
        if (row.state != 'open') throw const InvalidOperation('not waiting');
        return IncomeOccurrencesCompanion(
          expectedOn: Value(to.iso),
          dateUnknown: const Value(0),
        );
      });

  /// «Не знаю когда»: delayed with no date (the forecast uses a period).
  Future<void> markDateUnknown(PaymentKey key, DateTime now) =>
      _update(key, now, (row) {
        if (row.state != 'open') throw const InvalidOperation('not waiting');
        return const IncomeOccurrencesCompanion(
          expectedOn: Value(null),
          dateUnknown: Value(1),
        );
      });

  /// A different expected amount for this payment only.
  Future<void> setExpectedAmount(PaymentKey key, Money amount, DateTime now) =>
      _update(key, now, (row) {
        if (row.state != 'open' || amount.minorUnits <= 0) {
          throw const InvalidOperation('amount');
        }
        return IncomeOccurrencesCompanion(
          expectedAmountMinor: Value(amount.minorUnits),
        );
      });

  /// «Не будет»: cancelled; nothing is expected any more.
  Future<void> cancel(PaymentKey key, DateTime now) => _update(key, now, (row) {
    if (row.state != 'open') throw const InvalidOperation('not waiting');
    return const IncomeOccurrencesCompanion(state: Value('cancelled'));
  });

  /// Undo «не будет».
  Future<void> reopen(PaymentKey key, DateTime now) => _update(key, now, (row) {
    if (row.state != 'cancelled') throw const InvalidOperation('not cancelled');
    return const IncomeOccurrencesCompanion(state: Value('open'));
  });

  // --- Receiving money --------------------------------------------------------

  Future<IncomeOp> _op(
    PaymentKey key,
    Money amount,
    String accountId,
    CalendarDate date,
  ) async {
    final source = await (db.select(
      db.incomeSources,
    )..where((s) => s.id.equals(key.sourceId))).getSingleOrNull();
    if (source == null) throw const InvalidOperation('unknown payment');
    final category =
        await (db.select(db.categories)..where(
              (c) => c.systemKey.equals(
                source.kind == 'salary' ? 'salary' : 'other_income',
              ),
            ))
            .getSingle();
    return IncomeOp(
      accountId: accountId,
      categoryId: category.id,
      amount: amount,
      date: date,
      description: source.name,
    );
  }

  /// What «Получено» will do — shown and confirmed BEFORE anything is
  /// written (owner requirement): the balance change, or that the money is
  /// already in a confirmed balance.
  Future<OperationPreview> previewReceipt(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
  }) async => Journal(db).preview(
    await _op(key, amount, accountId, date),
    now: now,
    placement: placement,
    answers: answers,
  );

  /// Books the received money (journal entry + receipt) and updates the
  /// payment, in one transaction. Less than expected: [shortfall] says
  /// whether the rest comes later ([restOn], or null = date unknown) or this
  /// was the whole payment.
  Future<String> receive(
    PaymentKey key, {
    required Money amount,
    required String accountId,
    required CalendarDate date,
    required DateTime now,
    SameDayPlacement placement = SameDayPlacement.auto,
    Map<String, ConfirmationAnswer> answers = const {},
    ShortfallChoice shortfall = ShortfallChoice.restLater,
    CalendarDate? restOn,
  }) => db.transaction(() async {
    final row = await _materialize(key, now);
    if (row.state != 'open') throw const InvalidOperation('not waiting');
    final op = await _op(key, amount, accountId, date);
    // A balance confirmed on or after the date: the person must have
    // answered about THAT confirmation (screens pass `auto` + answers).
    if (placement == SameDayPlacement.auto &&
        (await Journal(db).preview(
          op,
          now: now,
          answers: answers,
        )).unanswered(answers).isNotEmpty) {
      throw const InvalidOperation('answer required');
    }
    final recorded = await Journal(db)
        .record(op, now: now, placement: placement, answers: answers);
    final at = now.toUtc().millisecondsSinceEpoch;
    await db
        .into(db.incomeReceipts)
        .insert(
          IncomeReceiptsCompanion.insert(
            id: newUuid(),
            occurrenceId: row.id,
            entryId: recorded.entryId,
            amountMinor: amount.minorUnits,
            receivedOn: date.iso,
            createdAtUtc: at,
          ),
        );
    final total = await _receivedTotal(row.id);
    final expected = row.expectedAmountMinor ?? row.plannedAmountMinor;
    final IncomeOccurrencesCompanion change;
    if (total >= expected) {
      change = IncomeOccurrencesCompanion(
        state: const Value('received'),
        expectedAmountMinor: total > expected
            ? Value(total)
            : const Value.absent(),
      );
    } else if (shortfall == ShortfallChoice.wholePayment) {
      change = IncomeOccurrencesCompanion(
        state: const Value('received'),
        expectedAmountMinor: Value(total),
      );
    } else {
      change = IncomeOccurrencesCompanion(
        expectedOn: Value(restOn?.iso),
        dateUnknown: Value(restOn == null ? 1 : 0),
      );
    }
    await (db.update(db.incomeOccurrences)..where((o) => o.id.equals(row.id)))
        .write(change.copyWith(updatedAtUtc: Value(at)));
    return recorded.entryId;
  });

  Future<int> _receivedTotal(String occurrenceId) async {
    final r = await db
        .customSelect(
          'SELECT COALESCE(SUM(r.amount_minor), 0) AS s FROM income_receipts r '
          'WHERE r.occurrence_id = ? AND NOT EXISTS (SELECT 1 FROM entry_details d '
          'WHERE d.reverses_entry_id = r.entry_id)',
          variables: [Variable(occurrenceId)],
          readsFrom: {db.incomeReceipts, db.entryDetails},
        )
        .getSingle();
    return r.read<int>('s');
  }

  /// A receipt entered by mistake: its journal entry is reversed (the row
  /// and the history stay) and the payment is waiting again.
  Future<void> cancelReceipt(String receiptId, DateTime now) =>
      db.transaction(() async {
        final r = await (db.select(
          db.incomeReceipts,
        )..where((x) => x.id.equals(receiptId))).getSingle();
        await Journal(db).reverse(r.entryId, now);
        final row = await (db.select(
          db.incomeOccurrences,
        )..where((o) => o.id.equals(r.occurrenceId))).getSingle();
        if (row.state == 'received') {
          await (db.update(
            db.incomeOccurrences,
          )..where((o) => o.id.equals(row.id))).write(
            IncomeOccurrencesCompanion(
              state: const Value('open'),
              expectedAmountMinor: const Value(null),
              updatedAtUtc: Value(now.toUtc().millisecondsSinceEpoch),
            ),
          );
        }
      });

  // --- Forecast period --------------------------------------------------------

  Future<ForecastPeriod> period() async {
    final row = await db.select(db.forecastSettings).getSingleOrNull();
    if (row == null) return defaultForecastPeriod;
    if (row.periodDays != null) return PeriodDays(row.periodDays!);
    return PeriodUntil(CalendarDate.parse(row.periodUntil!));
  }

  Future<void> setPeriod(ForecastPeriod period) => db.transaction(() async {
    final household = await db.select(db.households).getSingle();
    await db
        .into(db.forecastSettings)
        .insertOnConflictUpdate(
          ForecastSettingsCompanion.insert(
            householdId: household.id,
            periodDays: Value(switch (period) {
              PeriodDays(:final days) => days,
              PeriodUntil() => null,
            }),
            periodUntil: Value(switch (period) {
              PeriodDays() => null,
              PeriodUntil(:final date) => date.iso,
            }),
          ),
        );
  });
}
