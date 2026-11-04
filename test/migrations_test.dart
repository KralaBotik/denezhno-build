import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/ledger.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';
import 'support/v3_fixture.dart';

const latest = AppDatabase.latestSchemaVersion;

void main() {
  late SchemaVerifier verifier;
  setUp(() {
    verifier = SchemaVerifier(
      GeneratedHelper(),
      setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
    );
  });

  Future<List<int>> history(AppDatabase db) async => [
    for (final h in await (db.select(
      db.schemaMigrations,
    )..orderBy([(t) => OrderingTerm.asc(t.version)])).get())
      h.version,
  ];

  test('new database exactly matches the committed latest snapshot', () async {
    final db = AppDatabase(
      NativeDatabase.memory(
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      ),
    );
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, latest);
    expect(await history(db), [latest]);
  });

  test('every schema entity is introduced by exactly one version', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final all = {for (final e in db.allSchemaEntities) e.entityName};
    final listed = AppDatabase.entitiesAddedIn.values.toList();
    for (final set in listed) {
      expect(all.containsAll(set), true);
    }
    for (var i = 0; i < listed.length; i++) {
      for (var j = i + 1; j < listed.length; j++) {
        expect(listed[i].intersection(listed[j]), isEmpty);
      }
    }
    expect(AppDatabase.releasedChecksums.keys, [1, 2, 3, 4, 5]);
  });

  test('v1 snapshot upgrades to latest without losing settings', () async {
    final schema = await verifier.schemaAt(1);
    schema.rawDatabase.execute('INSERT INTO app_settings VALUES (?, ?, ?)', [
      'theme',
      '"dark"',
      1,
    ]);
    schema.rawDatabase.execute(
      'INSERT INTO schema_migrations VALUES (?, ?, ?, ?)',
      [1, AppDatabase.schemaV1Checksum, 0, '0.1.0+1'],
    );
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, latest);
    expect((await db.select(db.appSettings).get()).single.valueJson, '"dark"');
    expect(await history(db), [1, 2, 3, 4, 5]);
    expect(await db.select(db.households).get(), hasLength(1));
    final system = await db.select(db.accounts).get();
    expect(
      {for (final a in system) a.kind},
      {'opening_equity', 'suspense', 'income', 'expense'},
    );
    expect(await db.select(db.categories).get(), hasLength(14));
    expect(await db.select(db.flowKinds).get(), hasLength(8));
  });

  test('v2 snapshot (step 1 on the phone) upgrades to v3 keeping data', () async {
    final schema = await verifier.schemaAt(2);
    final raw = schema.rawDatabase;
    raw.execute("INSERT INTO currencies VALUES ('RUB', 2)");
    for (final k in accountKindSeed.entries) {
      raw.execute('INSERT INTO account_kinds VALUES (?, ?)', [k.key, k.value]);
    }
    for (final k in entryKindSeed) {
      raw.execute('INSERT INTO entry_kinds VALUES (?)', [k]);
    }
    for (final k in dataSourceSeed) {
      raw.execute('INSERT INTO data_sources VALUES (?)', [k]);
    }
    const h = '11111111-1111-4111-8111-111111111111';
    raw.execute("INSERT INTO households VALUES (?, 'RUB', 1000000, 0)", [h]);
    raw.execute('INSERT INTO members VALUES (?, ?, 0)', [
      '22222222-2222-4222-8222-222222222222',
      h,
    ]);
    const card = '33333333-3333-4333-8333-333333333333';
    raw.execute(
      "INSERT INTO accounts VALUES (?, ?, 'credit_card', 'Сбер', 'RUB', NULL, "
      "'shared', 0, 5000000, 1, 0, NULL)",
      [card, h],
    );
    raw.execute('INSERT INTO schema_migrations VALUES (?, ?, ?, ?)', [
      2,
      AppDatabase.schemaV2Checksum,
      0,
      '0.2.0+2',
    ]);
    final db = AppDatabase(schema.newConnection());
    addTearDown(db.close);
    await verifier.migrateAndValidate(db, latest);
    expect(await history(db), [2, 3, 4, 5]);
    expect(
      (await db.select(db.accounts).get())
          .where((a) => a.kind == 'credit_card')
          .single
          .name,
      'Сбер',
    );
    // v3 reference data was seeded; v2 data was not re-seeded.
    expect(await db.select(db.flowKinds).get(), hasLength(8));
    expect(await db.select(db.households).get(), hasLength(1));
  });

  test('a database with unexpected history is not upgraded', () async {
    for (final version in [1, 2]) {
      final schema = await verifier.schemaAt(version);
      // No audit row: inconsistent with any released database.
      final db = AppDatabase(schema.newConnection());
      await expectLater(
        db.customSelect('SELECT 1').get(),
        throwsStateError,
        reason: 'v$version',
      );
      await db.close();
    }
  });

  test('released-history rule', () {
    const c = AppDatabase.releasedChecksums;
    bool ok(List<int> versions, int upTo) => AppDatabase.isReleasedHistory([
      for (final v in versions) (v, c[v]!),
    ], upTo);
    expect(ok([1, 2, 3], 3), true);
    expect(ok([2, 3], 3), true);
    expect(ok([3], 3), true);
    expect(ok([1, 3], 3), false);
    expect(ok([1, 2], 3), false);
    expect(ok([1, 2, 3, 4], 4), true);
    expect(ok([3, 4], 4), true);
    expect(ok([1, 2, 4], 4), false);
    expect(ok([1, 2, 3, 4, 5], 5), true);
    expect(ok([3, 4, 5], 5), true);
    expect(ok([3, 5], 5), false);
    expect(AppDatabase.isReleasedHistory([(3, 'x' * 64)], 3), false);
  });

  group('v3 database from the phone (realistic data)', () {
    Future<Map<String, List<Map<String, Object?>>>> dump(
      Future<List<Map<String, Object?>>> Function(String sql) query,
    ) async => {
      for (final t in V3.userTables)
        t: await query('SELECT * FROM "$t" ORDER BY rowid'),
    };

    test('upgrades to v5: every row kept, categories and incomes added, '
        'no new entries', () async {
      final schema = await verifier.schemaAt(3);
      V3.create(schema.rawDatabase);
      final before = await dump(
        (sql) async => [
          for (final r in schema.rawDatabase.select(sql))
            {for (final c in r.keys) c: r[c]},
        ],
      );
      final db = AppDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, latest);
      expect(await history(db), [1, 2, 3, 4, 5]);

      final after = await dump(
        (sql) async => [
          for (final r in await db.customSelect(sql).get()) r.data,
        ],
      );
      for (final t in V3.userTables) {
        if (t == 'accounts' || t == 'planned_flows') continue;
        expect(after[t], before[t], reason: t);
      }
      // R2 plans: unchanged except that salary plans are archived (they
      // live in the income model now); the rows stay in the database.
      final plans = after['planned_flows']!;
      expect(plans, hasLength(before['planned_flows']!.length));
      for (var i = 0; i < plans.length; i++) {
        final was = Map.of(before['planned_flows']![i])
          ..remove('archived_at_utc');
        final now = Map.of(plans[i])..remove('archived_at_utc');
        expect(now, was);
        expect(
          plans[i]['archived_at_utc'] != null,
          plans[i]['kind'] == 'salary',
          reason: '${plans[i]['name']}',
        );
      }
      // Accounts: the old ones untouched, plus one internal per category.
      expect(after['accounts']!.take(5).toList(), before['accounts']);
      final added = after['accounts']!.skip(5).toList();
      expect(added, hasLength(14));
      expect({for (final a in added) a['kind']}, {'income', 'expense'});

      // Balances unchanged: the migration posts nothing.
      final sums = {
        for (final r
            in await db
                .customSelect(
                  'SELECT account_id, SUM(amount_minor) AS s FROM postings '
                  'GROUP BY account_id',
                )
                .get())
          r.read<String>('account_id'): r.read<int>('s'),
      };
      expect(sums, V3.balances);

      final categories = await db.select(db.categories).get();
      expect(categories, hasLength(14));
      expect(
        categories.where((c) => c.systemKey == 'salary').single.name,
        'Зарплата',
      );
      for (final c in categories) {
        final a = added.singleWhere((a) => a['id'] == c.ledgerAccountId);
        expect(a['kind'], c.direction);
      }
      // Category accounts never appear as the person's accounts.
      expect(
        [for (final a in await Ledger(db).accounts()) a.name],
        ['Сбер', 'Кредитка Альфа', 'Подушка'],
      );

      // Income model: one source + part per salary plan; R2 marks kept as
      // payments «отмечено до обновления»; the bonus (other income) stays.
      final sources = await db.select(db.incomeSources).get();
      expect({for (final x in sources) x.name}, {'Зарплата', 'Аванс'});
      expect(
        {for (final x in sources) x.migratedFromFlowId},
        {V3.salary, V3.advance},
      );
      expect({for (final x in sources) x.holidayRule}, {'previous_workday'});
      final parts = await db.select(db.incomeScheduleParts).get();
      expect(
        {for (final x in parts) (x.label, x.amountMinor, x.day)},
        {('Зарплата', 6000000, 5), ('Аванс', 4000000, 20)},
      );
      final occurrences = await db.select(db.incomeOccurrences).get();
      expect(
        {for (final x in occurrences) (x.plannedOn, x.state)},
        {('2026-10-05', 'legacy_mark'), ('2026-10-20', 'legacy_mark')},
      );
      expect(await db.select(db.incomeReceipts).get(), isEmpty);

      // Running the data steps again (a retried migration or a restored
      // backup that already has them) adds nothing.
      await db.upgradeDataTo(3);
      expect(await db.select(db.categories).get(), hasLength(14));
      expect(await db.select(db.accounts).get(), hasLength(19));
      expect(await db.select(db.incomeSources).get(), hasLength(2));
      expect(await db.select(db.incomeOccurrences).get(), hasLength(2));
    });
  });
}
