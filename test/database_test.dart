import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:drift/drift.dart'
    show
        QueryInterceptor,
        QueryExecutor,
        QueryExecutorUser,
        ApplyInterceptor,
        OpeningDetails;
// Test-only inspection of the pinned Drift isolate error wrapper.
// ignore: experimental_member_use
import 'package:drift/remote.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

// Synthetic key, only for tests. Production keys come from the OS CSPRNG.
const testKey =
    '0101010101010101010101010101010101010101010101010101010101010101';

void main() {
  late Directory directory;
  late File file;
  late Set<AppDatabase> activeDatabases;
  setUp(() async {
    activeDatabases = {};
    directory = await Directory.systemTemp.createTemp('denezhno-test-');
    file = File('${directory.path}/test.sqlite');
  });
  Future<void> closeDb(AppDatabase db) async {
    if (activeDatabases.remove(db)) await db.close();
  }

  tearDown(() async {
    for (final db in activeDatabases.toList()) {
      await closeDb(db);
    }
    await directory.delete(recursive: true);
  });

  Future<AppDatabase> open() async {
    final db = AppDatabase(await encryptedConnection(file, testKey));
    activeDatabases.add(db);
    await db.customSelect('SELECT 1').get();
    return db;
  }

  test(
    'creates the latest schema, verifies it and reopens with persisted theme',
    () async {
      final store = LocalStore(
        () async => StorageLocation(file, testKey, () async {}),
      );
      addTearDown(store.close);
      expect(await store.open(), AppTheme.system);
      await store.setTheme(AppTheme.dark);
      await store.close();
      expect(await store.open(), AppTheme.dark);
      await store.close();
      final db = await open();
      await db.validateDatabaseSchema();
      expect(
        (await db.customSelect('PRAGMA user_version').getSingle())
            .data
            .values
            .single,
        AppDatabase.latestSchemaVersion,
      );
      final history = await db.select(db.schemaMigrations).get();
      expect(history.single.version, AppDatabase.latestSchemaVersion);
      expect(history.single.schemaChecksum, AppDatabase.schemaV3Checksum);
      expect(await db.select(db.households).get(), hasLength(1));
    },
  );

  test('schema checksum matches the tracked source', () async {
    expect(
      sha256
          .convert(await File('lib/core/database/schema.drift').readAsBytes())
          .toString(),
      AppDatabase.schemaV3Checksum,
    );
  });

  test(
    'failure during first migration rolls back DDL, history and version',
    () async {
      final executor = await encryptedConnection(file, testKey);
      final failing = AppDatabase(
        executor.interceptWith(_FailMigrationJournal()),
      );
      activeDatabases.add(failing);
      await expectLater(
        failing.customSelect('SELECT 1').get(),
        throwsA(
          isA<DriftRemoteException>().having(
            (e) => e.toString(),
            'injected failure',
            contains('synthetic migration failure'),
          ),
        ),
      );
      await closeDb(failing);
      final raw = sqlite3.open(file.path);
      try {
        configureEncryptedDatabase(raw, testKey);
        expect(raw.select('PRAGMA user_version').single.values.single, 0);
        expect(
          raw.select(
            "SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'",
          ),
          isEmpty,
        );
      } finally {
        raw.close();
      }
      await open();
    },
  );

  test('foreign keys are on and an orphan is rejected', () async {
    final db = await open();
    expect(
      (await db.customSelect('PRAGMA foreign_keys').getSingle())
          .data
          .values
          .single,
      1,
    );
    await db.customStatement(
      'CREATE TEMP TABLE parent (id INTEGER PRIMARY KEY)',
    );
    await db.customStatement(
      'CREATE TEMP TABLE child (parent_id INTEGER REFERENCES parent(id))',
    );
    await expectLater(
      db.customStatement('INSERT INTO child VALUES (42)'),
      throwsA(
        isA<DriftRemoteException>().having(
          (e) => e.remoteCause,
          'SQLite cause',
          isA<SqliteException>(),
        ),
      ),
    );
  });

  test('invalid setting rolls back the entire transaction', () async {
    final db = await open();
    await expectLater(
      db.transaction(() async {
        await db.customStatement('INSERT INTO app_settings VALUES (?, ?, ?)', [
          'theme',
          '"dark"',
          1,
        ]);
        await db.customStatement('UPDATE app_settings SET value_version = 2');
      }),
      throwsA(
        isA<DriftRemoteException>().having(
          (e) => e.remoteCause,
          'SQLite cause',
          isA<SqliteException>(),
        ),
      ),
    );
    expect(await db.select(db.appSettings).get(), isEmpty);
    await expectLater(
      db.customStatement('INSERT INTO app_settings VALUES (?, ?, ?)', [
        'token',
        '"secret"',
        1,
      ]),
      throwsA(
        isA<DriftRemoteException>().having(
          (e) => e.remoteCause,
          'SQLite cause',
          isA<SqliteException>(),
        ),
      ),
    );
  });

  test('cipher encrypts pages and WAL; opening without a key fails', () async {
    final db = await open();
    const marker = 'SYNTHETIC_FINANCIAL_MARKER_NOT_USER_DATA_125075';
    await db.customStatement('CREATE TABLE cipher_probe (value TEXT NOT NULL)');
    await db.customStatement('INSERT INTO cipher_probe VALUES (?)', [marker]);
    for (final entity in directory.listSync().whereType<File>()) {
      expect(
        String.fromCharCodes(await entity.readAsBytes()),
        isNot(contains(marker)),
      );
    }
    await closeDb(db);
    expect(
      String.fromCharCodes((await file.readAsBytes()).take(16)),
      isNot('SQLite format 3\u0000'),
    );
    final raw = sqlite3.open(file.path);
    try {
      expect(
        () => raw.select('SELECT * FROM sqlite_master'),
        throwsA(isA<SqliteException>()),
      );
    } finally {
      raw.close();
    }
  });

  test('wrong key is rejected and the original file still opens', () async {
    final db = await open();
    await closeDb(db);
    final before = await file.readAsBytes();
    final wrong = AppDatabase(
      await encryptedConnection(
        file,
        '0202020202020202020202020202020202020202020202020202020202020202',
      ),
    );
    activeDatabases.add(wrong);
    await expectLater(wrong.customSelect('SELECT 1').get(), throwsA(anything));
    await closeDb(wrong);
    expect(await file.readAsBytes(), before);
    await open();
  });

  test('empty key and plaintext files never fall back', () async {
    await expectLater(encryptedConnection(file, ''), throwsStateError);
    expect(await file.exists(), false);
    final raw = sqlite3.open(file.path);
    raw.execute('CREATE TABLE existing (value TEXT)');
    raw.close();
    final before = await file.readAsBytes();
    await expectLater(encryptedConnection(file, testKey), throwsStateError);
    expect(await file.readAsBytes(), before);
  });

  test('missing cipher is rejected before executing any PRAGMA key', () {
    expect(
      () => configureEncryptedDatabase(_NoCipherDatabase(), testKey),
      throwsStateError,
    );
  });

  test('unknown future schema is rejected without downgrade', () async {
    final db = await open();
    await db.customStatement('PRAGMA user_version = 99');
    await closeDb(db);
    final future = AppDatabase(await encryptedConnection(file, testKey));
    activeDatabases.add(future);
    await expectLater(future.customSelect('SELECT 1').get(), throwsA(anything));
    await closeDb(future);
    final raw = sqlite3.open(file.path);
    try {
      configureEncryptedDatabase(raw, testKey);
      expect(raw.select('PRAGMA user_version').single.values.single, 99);
    } finally {
      raw.close();
    }
  });

  test('corrupt encrypted first page is rejected, never reset', () async {
    final db = await open();
    await closeDb(db);
    final bytes = await file.readAsBytes();
    bytes[100] ^= 1;
    await file.writeAsBytes(bytes, flush: true);
    final corrupt = AppDatabase(await encryptedConnection(file, testKey));
    activeDatabases.add(corrupt);
    await expectLater(
      corrupt.customSelect('SELECT 1').get(),
      throwsA(anything),
    );
    await closeDb(corrupt);
    expect(await file.readAsBytes(), bytes);
  });
}

class _NoCipherDatabase implements Database {
  @override
  ResultSet select(String sql, [List<Object?> parameters = const []]) {
    expect(sql, 'PRAGMA cipher');
    return ResultSet([], [], []);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) =>
      throw StateError('Unexpected operation before cipher check');
}

class _FailMigrationJournal extends QueryInterceptor {
  @override
  Future<bool> ensureOpen(QueryExecutor executor, QueryExecutorUser user) =>
      executor.ensureOpen(_FaultingUser(user));
  @override
  Future<int> runInsert(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    if (statement.contains('schema_migrations')) {
      throw StateError('synthetic migration failure');
    }
    return super.runInsert(executor, statement, args);
  }
}

class _FaultingUser implements QueryExecutorUser {
  _FaultingUser(this.delegate);
  final QueryExecutorUser delegate;
  @override
  int get schemaVersion => delegate.schemaVersion;
  @override
  Future<void> beforeOpen(QueryExecutor executor, OpeningDetails details) =>
      delegate.beforeOpen(
        executor.interceptWith(_FailMigrationJournal()),
        details,
      );
}
