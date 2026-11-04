import 'dart:io';

import 'package:denezhno/core/backup/backup_crypto.dart';
import 'package:denezhno/core/database/app_database.dart';
import 'package:denezhno/core/database/backup_repo.dart';
import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/backup/backup.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

import 'generated_migrations/schema_v3.dart' as v3;
import 'support/v3_fixture.dart';

const _keyA =
    'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1';
const _keyB =
    'b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2';
const _password = 'correct horse battery';

/// R3 requirement: before the real database on the phone is migrated, the
/// person can make a verified backup of it as it is.
void main() {
  late Directory root;
  late File file;
  setUp(() async {
    root = await Directory.systemTemp.createTemp('denezhno-upgrade-');
    file = File('${root.path}/a/denezhno.sqlite');
    await file.parent.create();
    // The phone's database after R2: schema v3 with realistic data.
    final db = v3.DatabaseAtV3(await encryptedConnection(file, _keyA));
    await db.customSelect('SELECT 1').get();
    await db.close();
    final raw = sqlite3.open(file.path);
    try {
      configureEncryptedDatabase(raw, _keyA);
      raw.execute('BEGIN');
      V3.create(raw);
      raw.execute('COMMIT');
    } finally {
      raw.close();
    }
  });
  tearDown(() => root.delete(recursive: true));

  int version(String path) {
    final raw = sqlite3.open(path);
    try {
      configureEncryptedDatabase(raw, _keyA);
      return raw.select('PRAGMA user_version').single.values.single! as int;
    } finally {
      raw.close();
    }
  }

  List<int> bytes() => file.readAsBytesSync();

  test('nothing is migrated until the person decides; the backup is made '
      'from the old database and verified', () async {
    final store = LocalStore(
      () async => StorageLocation(file, _keyA, () async {}),
    );
    await expectLater(
      store.open(),
      throwsA(isA<UpgradeRequired>().having((e) => e.fromVersion, 'from', 3)),
    );
    expect(version(file.path), 3);
    expect(File('${file.path}.pre-v3.bak').existsSync(), false);

    await expectLater(
      store.exportBeforeUpgrade('short'),
      throwsA(isA<WeakPassword>()),
    );
    final before = bytes();
    final backup = await store.exportBeforeUpgrade(_password);
    expect((backup.ownAccounts, backup.entries), (3, 4));
    expect(bytes(), before); // read-only
    final summary = verifyBackupFile(backup.file, _password);
    expect(summary.schemaVersion, 3);
    expect(
      () => verifyBackupFile(backup.file, 'wrong password!'),
      throwsA(isA<WrongPasswordOrDamaged>()),
    );

    // Only now: migrate (with the automatic encrypted copy of v3).
    store.allowUpgrade();
    expect(await store.open(), AppTheme.dark);
    expect(version(file.path), AppDatabase.latestSchemaVersion);
    expect(File('${file.path}.pre-v3.bak').existsSync(), true);
    expect((await store.accounts()).map((a) => a.amount), [
      Money(2873152),
      Money(1629654),
      Money(15000000),
    ]);
    await store.close();

    // That backup restores on another phone with the same result.
    final other = File('${root.path}/b/denezhno.sqlite');
    await other.parent.create();
    final b = LocalStore(
      () async => StorageLocation(other, _keyB, () async {}),
    );
    await b.open();
    await b.restoreBackup(backup.file, _password);
    expect(
      [for (final a in await b.accounts()) (a.name, a.amount)],
      [
        ('Сбер', Money(2873152)),
        ('Кредитка Альфа', Money(1629654)),
        ('Подушка', Money(15000000)),
      ],
    );
    expect((await b.income()).sources.map((s) => s.name).toSet(), {
      'Зарплата',
      'Аванс',
    });
    await b.close();
  });

  test('every new backup is verified after encryption', () async {
    final store = LocalStore(
      () async => StorageLocation(file, _keyA, () async {}),
    )..allowUpgrade();
    await store.open();
    final exported = await store.exportBackup(_password);
    final summary = verifyBackupFile(exported, _password);
    expect(summary.schemaVersion, AppDatabase.latestSchemaVersion);
    expect(summary.ownAccounts, 3);
    await store.close();
  });

  test('a fresh install is not asked anything', () async {
    final fresh = File('${root.path}/c/denezhno.sqlite');
    await fresh.parent.create();
    final store = LocalStore(
      () async => StorageLocation(fresh, _keyB, () async {}),
    );
    expect(await store.open(), AppTheme.system);
    await store.close();
  });
}
