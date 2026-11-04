import 'package:drift/drift.dart';

import '../ids.dart';

part 'app_database.g.dart';

/// Reference data shared by fresh installs and the v1 → v2 migration.
/// New kinds are added by inserting rows, never by rebuilding CHECKs.
const currencySeed = {'RUB': 2};
const accountKindSeed = {
  'debit': 'asset',
  'cash': 'asset',
  'savings': 'asset',
  'deposit': 'asset',
  'credit_card': 'liability',
  'loan': 'liability',
  'opening_equity': 'equity',
  'suspense': 'system',
};
const entryKindSeed = ['opening_balance', 'balance_adjustment'];
const dataSourceSeed = [
  'user',
  'statement',
  'screenshot',
  'bank',
  'calculated',
  'open_api_cbr',
];

const flowKindSeed = {
  'salary': 'inflow',
  'other_income': 'inflow',
  'subscription': 'outflow',
  'utilities': 'outflow',
  'loan_payment': 'outflow',
  'rent': 'outflow',
  'communication': 'outflow',
  'other_payment': 'outflow',
};

/// v4: internal accounts behind categories (temporary equity accounts in
/// bookkeeping terms; never shown as accounts) and the kinds of operations.
const accountKindSeedV4 = {'income': 'equity', 'expense': 'equity'};
const entryKindSeedV4 = [
  'income',
  'expense',
  'transfer',
  'refund',
  'reversal',
  'anchor_correction',
  'reclass',
];

/// Default categories: (system key, direction, name, icon key).
const defaultCategories = [
  ('groceries', 'expense', 'Продукты', 'cart'),
  ('cafe', 'expense', 'Кафе и рестораны', 'cafe'),
  ('transport', 'expense', 'Транспорт', 'car'),
  ('home', 'expense', 'Дом и ЖКХ', 'house'),
  ('communication', 'expense', 'Связь и интернет', 'phone'),
  ('health', 'expense', 'Здоровье', 'heart'),
  ('clothes', 'expense', 'Одежда', 'bag'),
  ('fun', 'expense', 'Развлечения', 'film'),
  ('subscriptions', 'expense', 'Подписки', 'repeat'),
  ('gifts', 'expense', 'Подарки', 'gift'),
  ('fees', 'expense', 'Проценты и комиссии', 'percent'),
  ('other_expense', 'expense', 'Прочие расходы', 'ellipsis'),
  ('salary', 'income', 'Зарплата', 'briefcase'),
  ('other_income', 'income', 'Прочие доходы', 'plus'),
];

/// Technical name of a category's internal ledger account (never shown).
const categoryAccountName = 'Внутренний счёт категории';

/// Default «неприкосновенный» reserve: 10 000 ₽ (owner decision, R2 plan).
const defaultReserveMinor = 1000000;

@DriftDatabase(include: {'schema.drift'})
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// SHA-256 of the v1 schema.drift as released in R1. Historical: the file
  /// itself now contains v2, so this value is only checked against history.
  static const schemaV1Checksum =
      '57fa82075b0feb6333048cffc87c3ad98e1cf02dbe9b07a853cd85a8482737f0';

  /// SHA-256 of schema.drift as released at v2 (R2 step 1). Historical.
  static const schemaV2Checksum =
      '74cd8e6c76fafe812b8ae5a94f2025d55afdb33756b0bf141f514e14f1230b6a';

  /// SHA-256 of schema.drift as released at v3 (R2 step 2). Historical.
  static const schemaV3Checksum =
      '26e2a1bfbb16f4f5da74cb86edbf1710c08981e0e7f795ee138efa5544a50112';

  /// SHA-256 of schema.drift at v4 (R3 Э2). Historical.
  static const schemaV4Checksum =
      '436482421afc66175266e62d7bcabf77cdb1cefffcc0430a41261fd97efc26fd';

  /// SHA-256 of the current schema.drift (v5). A test recomputes it.
  static const schemaV5Checksum =
      '22bd67bd03bca031625617bfc18627529e39b67d6217847d0e79634f17f56634';

  static const latestSchemaVersion = 5;

  /// Checksum recorded for the current schema version.
  static String get latestChecksum => releasedChecksums[latestSchemaVersion]!;
  static const _appVersion = '0.3.0+3';

  /// Released schema versions and the checksum recorded for each.
  static const releasedChecksums = {
    1: schemaV1Checksum,
    2: schemaV2Checksum,
    3: schemaV3Checksum,
    4: schemaV4Checksum,
    5: schemaV5Checksum,
  };

  /// Which schema entities each version introduced. Every entity belongs to
  /// exactly one version (checked by a test); upgrades create only these.
  static const entitiesAddedIn = {
    1: {'app_settings', 'schema_migrations'},
    3: {
      'flow_kinds',
      'planned_flows',
      'flow_marks',
      'card_figures',
      'card_figures_by_account',
    },
    4: {
      'category_groups',
      'categories',
      'entry_details',
      'entry_details_by_cause',
      'entry_details_no_update',
      'entry_details_no_delete',
    },
    5: {
      'income_sources',
      'income_schedule_parts',
      'income_occurrences',
      'income_occurrences_by_source',
      'income_receipts',
      'income_receipts_by_occurrence',
      'income_receipts_no_update',
      'income_receipts_no_delete',
      'forecast_settings',
    },
  };

  /// v2 introduced everything not listed for another version.
  static Set<String> _introducedIn(int version, Iterable<String> all) =>
      version == 2
      ? {
          for (final name in all)
            if (!entitiesAddedIn.values.any((s) => s.contains(name))) name,
        }
      : entitiesAddedIn[version]!;

  @override
  int get schemaVersion => latestSchemaVersion;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => transaction(() async {
      await m.createAll();
      await _seedV2();
      await _seedV3();
      await _seedV4();
      await _dataV5();
      await _recordVersion(
        latestSchemaVersion,
        releasedChecksums[latestSchemaVersion]!,
      );
      // Drift updates user_version after the hook. Set it here too so DDL,
      // seed data, audit row and version survive a crash together.
      await customStatement('PRAGMA user_version = $latestSchemaVersion');
    }),
    onUpgrade: (m, from, to) async {
      // Only released forward steps. Never guess a downgrade or an unknown
      // version; those stay blocked (fail closed).
      if (from < 1 || to != latestSchemaVersion || from >= to) {
        throw StateError('Unsupported schema transition');
      }
      await transaction(() async {
        // Upgrade only a database whose history is exactly a released one up
        // to `from`; otherwise the result could pass as a fresh install.
        if (!_isReleasedHistory(await _history(), from)) {
          throw StateError('Schema history mismatch');
        }
        final names = [for (final e in allSchemaEntities) e.entityName];
        for (var version = from + 1; version <= to; version++) {
          final introduced = _introducedIn(version, names);
          for (final entity in allSchemaEntities) {
            if (introduced.contains(entity.entityName)) await m.create(entity);
          }
          if (version == 2) await _seedV2();
          if (version == 3) await _seedV3();
          if (version == 4) await _seedV4();
          if (version == 5) await _dataV5();
          await _recordVersion(version, releasedChecksums[version]!);
        }
        await customStatement('PRAGMA user_version = $to');
      });
    },
    beforeOpen: (_) async {
      final fk = await customSelect('PRAGMA foreign_keys').getSingle();
      if (fk.data.values.single != 1) throw StateError('Foreign keys disabled');
      if (!_isReleasedHistory(await _history(), latestSchemaVersion)) {
        throw StateError('Schema history mismatch');
      }
      if ((await select(households).get()).length != 1) {
        throw StateError('Household missing');
      }
      if ((await customSelect('PRAGMA foreign_key_check').get()).isNotEmpty) {
        throw StateError('Foreign key violation');
      }
    },
  );

  Future<List<(int, String)>> _history() async => [
    for (final v in await (select(
      schemaMigrations,
    )..orderBy([(t) => OrderingTerm.asc(t.version)])).get())
      (v.version, v.schemaChecksum),
  ];

  /// A released history is a contiguous run of versions ending at [upTo],
  /// each with its released checksum: [1,2,3], [2,3] or [3] for v3.
  static bool isReleasedHistory(List<(int, String)> history, int upTo) =>
      _isReleasedHistory(history, upTo);
  static bool _isReleasedHistory(List<(int, String)> history, int upTo) {
    if (history.isEmpty || history.last.$1 != upTo) return false;
    final first = history.first.$1;
    for (var i = 0; i < history.length; i++) {
      final version = first + i;
      final checksum = releasedChecksums[version];
      if (checksum == null || history[i] != (version, checksum)) return false;
    }
    return true;
  }

  Future<void> _recordVersion(int version, String checksum) =>
      into(schemaMigrations).insert(
        SchemaMigrationsCompanion.insert(
          version: Value(version),
          schemaChecksum: checksum,
          appliedAtUtc: DateTime.now().toUtc().millisecondsSinceEpoch,
          appVersion: _appVersion,
        ),
      );

  /// v4 reference rows, then the data step shared with restoring an older
  /// backup ([upgradeDataTo]).
  Future<void> _seedV4() async {
    for (final e in accountKindSeedV4.entries) {
      await into(accountKinds)
          .insert(AccountKindsCompanion.insert(kind: e.key, nature: e.value));
    }
    for (final k in entryKindSeedV4) {
      await into(entryKinds).insert(EntryKindsCompanion.insert(kind: k));
    }
    await _dataV4();
  }

  /// Default categories for every household that does not have them yet.
  /// Idempotent: a repeated run (or a restored backup that already has them)
  /// adds nothing.
  Future<void> _dataV4() async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    for (final household in await select(households).get()) {
      final existing = {
        for (final c in await (select(
          categories,
        )..where((c) => c.householdId.equals(household.id))).get())
          c.systemKey,
      };
      var order = 0;
      for (final (key, direction, name, icon) in defaultCategories) {
        order++;
        if (existing.contains(key)) continue;
        final account = newUuid();
        await into(accounts).insert(
          AccountsCompanion.insert(
            id: account,
            householdId: household.id,
            kind: direction,
            name: categoryAccountName,
            currency: household.baseCurrency,
            visibility: 'shared',
            isProtected: 0,
            sortOrder: 0,
            createdAtUtc: now,
          ),
        );
        await into(categories).insert(
          CategoriesCompanion.insert(
            id: newUuid(),
            householdId: household.id,
            direction: direction,
            name: name,
            icon: icon,
            ledgerAccountId: account,
            systemKey: Value(key),
            sortOrder: order,
            createdAtUtc: now,
          ),
        );
      }
    }
  }

  /// Brings data restored from an older backup (schema [from]) to the current
  /// version with the same data steps the migration runs. Reference data is
  /// already current (it comes with this schema).
  Future<void> upgradeDataTo(int from) async {
    if (from < 3 || from > latestSchemaVersion) {
      throw StateError('Unsupported backup schema');
    }
    if (from < 4) await _dataV4();
    if (from < 5) await _dataV5();
  }

  /// R2 salary plans → the income model (one source and one schedule part
  /// per plan; R2 «получено» marks → payments closed as «отмечено до
  /// обновления», «не будет» → cancelled). No journal entries are created:
  /// that money is already in the balances through «Обновить остатки». The
  /// R2 plan is archived. Idempotent: a plan already migrated is skipped
  /// (UNIQUE migrated_from_flow_id), and migrated plans are archived.
  Future<void> _dataV5() async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    final flows = await (select(
      plannedFlows,
    )..where((f) => f.kind.equals('salary') & f.archivedAtUtc.isNull())).get();
    for (final f in flows) {
      final done = await (select(
        incomeSources,
      )..where((s) => s.migratedFromFlowId.equals(f.id))).getSingleOrNull();
      if (done != null) continue;
      final source = newUuid();
      await into(incomeSources).insert(
        IncomeSourcesCompanion.insert(
          id: source,
          householdId: f.householdId,
          name: f.name,
          kind: 'salary',
          holidayRule: 'previous_workday',
          migratedFromFlowId: Value(f.id),
          createdAtUtc: now,
        ),
      );
      final part = newUuid();
      await into(incomeScheduleParts).insert(
        IncomeSchedulePartsCompanion.insert(
          id: part,
          sourceId: source,
          label: f.name,
          amountMinor: f.amountMinor,
          currency: f.currency,
          cadence: f.cadence,
          day: Value(f.day),
          month: Value(f.month),
          onceOn: Value(f.onceOn),
          validFrom: f.startsOn,
          createdAtUtc: now,
        ),
      );
      for (final m in await (select(
        flowMarks,
      )..where((m) => m.flowId.equals(f.id))).get()) {
        await into(incomeOccurrences).insert(
          IncomeOccurrencesCompanion.insert(
            id: newUuid(),
            sourceId: source,
            partId: Value(part),
            plannedOn: m.dueOn,
            plannedAmountMinor: f.amountMinor,
            dateUnknown: 0,
            state: m.status == 'done' ? 'legacy_mark' : 'cancelled',
            createdAtUtc: now,
            updatedAtUtc: now,
          ),
        );
      }
      await (update(plannedFlows)..where((x) => x.id.equals(f.id))).write(
        PlannedFlowsCompanion(archivedAtUtc: Value(now)),
      );
    }
  }

  Future<void> _seedV3() async {
    for (final e in flowKindSeed.entries) {
      await into(flowKinds)
          .insert(FlowKindsCompanion.insert(kind: e.key, direction: e.value));
    }
  }

  /// Reference data + the household with its single member and the two
  /// system accounts every balanced entry needs.
  Future<void> _seedV2() async {
    final now = DateTime.now().toUtc().millisecondsSinceEpoch;
    for (final e in currencySeed.entries) {
      await into(currencies).insert(
        CurrenciesCompanion.insert(code: e.key, fractionDigits: e.value),
      );
    }
    for (final e in accountKindSeed.entries) {
      await into(accountKinds)
          .insert(AccountKindsCompanion.insert(kind: e.key, nature: e.value));
    }
    for (final k in entryKindSeed) {
      await into(entryKinds).insert(EntryKindsCompanion.insert(kind: k));
    }
    for (final s in dataSourceSeed) {
      await into(dataSources).insert(DataSourcesCompanion.insert(source: s));
    }
    final household = newUuid();
    await into(households).insert(
      HouseholdsCompanion.insert(
        id: household,
        baseCurrency: 'RUB',
        reserveMinor: defaultReserveMinor,
        createdAtUtc: now,
      ),
    );
    await into(members).insert(
      MembersCompanion.insert(
        id: newUuid(),
        householdId: household,
        createdAtUtc: now,
      ),
    );
    for (final (kind, name, order) in [
      ('opening_equity', 'Начальные остатки', -2),
      ('suspense', 'Невыясненное', -1),
    ]) {
      await into(accounts).insert(
        AccountsCompanion.insert(
          id: newUuid(),
          householdId: household,
          kind: kind,
          name: name,
          currency: 'RUB',
          visibility: 'shared',
          isProtected: 0,
          sortOrder: order,
          createdAtUtc: now,
        ),
      );
    }
  }
}
