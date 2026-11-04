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
