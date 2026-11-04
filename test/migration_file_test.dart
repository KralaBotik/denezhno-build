import 'dart:io';

import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:drift/drift.dart'
    show
        QueryInterceptor,
        QueryExecutor,
        QueryExecutorUser,
        OpeningDetails,
        ApplyInterceptor;
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import 'generated_migrations/schema_v1.dart' as v1;
import 'generated_migrations/schema_v3.dart' as v3;
import 'support/v3_fixture.dart';

const _key = '0202020202020202020202020202020202020202020202020202020202020202';

void main() {
  late Directory directory;
  late File file;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('denezhno-migration-');
    file = File('${directory.path}/denezhno.sqlite');
  });
  tearDown(() => directory.delete(recursive: true));

  /// A real encrypted file exactly as R1 left it: v1 tables, theme, audit row.
  Future<void> createV1File() async {
    final db = v1.DatabaseAtV1(await encryptedConnection(file, _key));
    await db.customStatement(
      "INSERT INTO app_settings VALUES ('theme', '\"dark\"', 1)",
    );
    await db.customStatement(
      'INSERT INTO schema_migrations VALUES (1, ?, 0, ?)',
      [AppDatabase.schemaV1Checksum, '0.1.0+1'],
    );
    await db.close();
  }

  int rawUserVersion(String path) {
    final raw = sqlite3.open(path);
    try {
      configureEncryptedDatabase(raw, _key);
      return raw.select('PRAGMA user_version').single.values.single as int;
    } finally {
      raw.close();
    }
  }

  test('upgrade keeps an encrypted pre-v1 copy and preserves data', () async {
    await createV1File();
    expect(rawUserVersion(file.path), 1);
    final db = AppDatabase(await encryptedConnection(file, _key));
    await db.customSelect('SELECT 1').get();
    expect((await db.select(db.appSettings).get()).single.valueJson, '"dark"');
    await db.close();

    final backup = File('${file.path}.pre-v1.bak');
    expect(backup.existsSync(), true);
    // The copy is encrypted (no plaintext header) and opens only with the key.
    final header = String.fromCharCodes(
      backup.readAsBytesSync().take(16).toList(),
    );
    expect(header, isNot('SQLite format 3\u0000'));
    expect(rawUserVersion(backup.path), 1);
    expect(rawUserVersion(file.path), AppDatabase.latestSchemaVersion);

    // Reopening does not touch or overwrite the copy.
    final modified = backup.lastModifiedSync();
    final again = AppDatabase(await encryptedConnection(file, _key));
    await again.customSelect('SELECT 1').get();
    await again.close();
    expect(backup.lastModifiedSync(), modified);
  });

  /// The phone's real case: an encrypted v3 file with financial data.
  Future<void> createV3File() async {
    final db = v3.DatabaseAtV3(await encryptedConnection(file, _key));
    await db.customSelect('SELECT 1').get(); // creates the v3 tables
    await db.close();
    final raw = sqlite3.open(file.path);
    try {
      configureEncryptedDatabase(raw, _key);
      raw.execute('BEGIN');
      V3.create(raw);
      raw.execute('COMMIT');
    } finally {
      raw.close();
    }
  }

  Map<String, List<Map<String, Object?>>> rawDump(String path) {
    final raw = sqlite3.open(path);
    try {
      configureEncryptedDatabase(raw, _key);
      return {
        for (final t in V3.userTables)
          t: [
            for (final r in raw.select('SELECT * FROM "$t" ORDER BY rowid'))
              {for (final c in r.keys) c: r[c]},
          ],
      };
    } finally {
      raw.close();
    }
  }

  test(
    'v3 file: a failed upgrade leaves v3 intact; the retry succeeds once',
    () async {
      await createV3File();
      expect(rawUserVersion(file.path), 3);
      final before = rawDump(file.path);

      final failing = AppDatabase(
        (await encryptedConnection(file, _key)).interceptWith(_FailUpgrade()),
      );
      await expectLater(
        failing.customSelect('SELECT 1').get(),
        throwsA(anything),
      );
      await failing.close();
      // Rolled back completely: still v3, no v4 tables, data identical.
      expect(rawUserVersion(file.path), 3);
      expect(rawDump(file.path), before);
      final raw = sqlite3.open(file.path);
      try {
        configureEncryptedDatabase(raw, _key);
        expect(
          raw.select(
            "SELECT name FROM sqlite_master WHERE name = 'categories'",
          ),
          isEmpty,
        );
      } finally {
        raw.close();
      }
      // The encrypted pre-migration copy is the v3 database.
      final copy = File('${file.path}.pre-v3.bak');
      expect(copy.existsSync(), true);
      expect(rawUserVersion(copy.path), 3);
      expect(rawDump(copy.path), before);

      // Retry: upgrades once, keeps every row, adds categories once.
      for (var run = 0; run < 2; run++) {
        final db = AppDatabase(await encryptedConnection(file, _key));
        await db.customSelect('SELECT 1').get();
        expect(await db.select(db.categories).get(), hasLength(14));
        expect(await db.select(db.journalEntries).get(), hasLength(4));
        await db.close();
      }
      expect(rawUserVersion(file.path), AppDatabase.latestSchemaVersion);
      final after = rawDump(file.path);
      for (final t in V3.userTables.where((t) => t != 'accounts')) {
        expect(after[t], before[t], reason: t);
      }
    },
  );

  test('failed upgrade rolls back to intact v1; copy remains', () async {
    await createV1File();
    final failing = AppDatabase(
      (await encryptedConnection(file, _key)).interceptWith(_FailUpgrade()),
    );
    await expectLater(
      failing.customSelect('SELECT 1').get(),
      throwsA(anything),
    );
    await failing.close();
    expect(rawUserVersion(file.path), 1);
    final raw = sqlite3.open(file.path);
    try {
      configureEncryptedDatabase(raw, _key);
      expect(
        raw.select(
          "SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'households'",
        ),
        isEmpty,
      );
      expect(raw.select('SELECT value_json FROM app_settings').single.values, [
        '"dark"',
      ]);
    } finally {
      raw.close();
    }
    expect(File('${file.path}.pre-v1.bak').existsSync(), true);

    final db = AppDatabase(await encryptedConnection(file, _key));
    await db.customSelect('SELECT 1').get();
    expect(await db.select(db.households).get(), hasLength(1));
    await db.close();
  });
}

class _FailUpgrade extends QueryInterceptor {
  @override
  Future<bool> ensureOpen(QueryExecutor executor, QueryExecutorUser user) =>
      executor.ensureOpen(_FaultingUser(user));
}

class _FaultingUser implements QueryExecutorUser {
  _FaultingUser(this.delegate);
  final QueryExecutorUser delegate;
  @override
  int get schemaVersion => delegate.schemaVersion;
  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) =>
      delegate.beforeOpen(executor.interceptWith(_FailHistory()), details);
}

class _FailHistory extends QueryInterceptor {
  @override
  Future<int> runInsert(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    if (statement.contains('schema_migrations')) {
      throw StateError('synthetic upgrade failure');
    }
    return super.runInsert(executor, statement, args);
  }
}
