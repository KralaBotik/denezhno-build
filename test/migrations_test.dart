import 'package:denezhno/core/database/app_database.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';

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
    final v1 = AppDatabase.entitiesAddedIn[1]!;
    final v3 = AppDatabase.entitiesAddedIn[3]!;
    expect(all.containsAll(v1) && all.containsAll(v3), true);
    expect(v1.intersection(v3), isEmpty);
    expect(AppDatabase.releasedChecksums.keys, [1, 2, 3]);
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
    expect(await history(db), [1, 2, 3]);
    expect(await db.select(db.households).get(), hasLength(1));
    final system = await db.select(db.accounts).get();
    expect({for (final a in system) a.kind}, {'opening_equity', 'suspense'});
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
    expect(await history(db), [2, 3]);
    expect((await db.select(db.accounts).get()).single.name, 'Сбер');
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
    expect(AppDatabase.isReleasedHistory([(3, 'x' * 64)], 3), false);
  });
}
