import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import 'app_database.dart' show AppDatabase;
import 'backup_repo.dart' show buildPayload, tablesForSchema;

/// Runtime check, intentionally NOT an assert: release builds must fail closed.
void configureEncryptedDatabase(Database db, String keyHex) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(keyHex)) {
    throw StateError('Invalid storage key');
  }
  if (db.select('PRAGMA cipher').isEmpty) {
    throw StateError('Encrypted SQLite unavailable');
  }
  db.execute("PRAGMA cipher = 'chacha20'");
  db.execute('PRAGMA legacy = 0');
  db.execute('PRAGMA kdf_iter = 64007');
  db.execute('PRAGMA page_size = 4096');
  if (db.select('PRAGMA cipher').single.values.single != 'chacha20' ||
      db.select('PRAGMA legacy').single.values.single.toString() != '0' ||
      db.select('PRAGMA kdf_iter').single.values.single.toString() != '64007') {
    throw StateError('Unsupported cipher profile');
  }
  // A random 256-bit secret encoded as hex, used by the library's own KDF.
  // Never enable SQL tracing on this connection.
  db.execute("PRAGMA key = '$keyHex'");
  db.select(
    'SELECT count(*) FROM sqlite_master',
  ); // Wrong key/corruption fails here.
  db.execute('PRAGMA foreign_keys = ON');
  if (db.select('PRAGMA foreign_keys').single.values.single != 1) {
    throw StateError('Foreign keys unavailable');
  }
  db.execute('PRAGMA journal_mode = WAL');
  db.execute('PRAGMA synchronous = FULL');
  db.execute('PRAGMA temp_store = MEMORY');
}

/// Before a schema upgrade can touch user data, keep an exact encrypted copy
/// of the previous version next to the database (`<file>.pre-v<N>.bak`).
/// Runs on the raw connection after the key is set and before Drift migrates.
/// An existing copy is never overwritten; any failure aborts the opening.
void protectBeforeMigration(Database db, String path, int latestVersion) {
  final version = db.select('PRAGMA user_version').single.values.single;
  if (version is! int || version <= 0 || version >= latestVersion) return;
  final copy = File('$path.pre-v$version.bak');
  if (copy.existsSync()) return;
  // Move all committed WAL frames into the main file so the copy is complete.
  final checkpoint = db.select('PRAGMA wal_checkpoint(TRUNCATE)').single.values;
  if (checkpoint.first != 0) throw StateError('Checkpoint incomplete');
  final temporary = File('${copy.path}.tmp');
  File(path).copySync(temporary.path);
  final handle = temporary.openSync(mode: FileMode.append);
  try {
    handle.flushSync();
  } finally {
    handle.closeSync();
  }
  temporary.renameSync(copy.path);
}

Future<QueryExecutor> encryptedConnection(File file, String keyHex) async {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(keyHex)) {
    throw StateError('Invalid storage key');
  }
  if (await file.exists()) {
    final handle = await file.open();
    try {
      final header = await handle.read(16);
      if (String.fromCharCodes(header) == 'SQLite format 3\u0000') {
        throw StateError('Unencrypted database rejected');
      }
    } finally {
      await handle.close();
    }
  }
  return NativeDatabase.createInBackground(
    file,
    setup: (db) {
      configureEncryptedDatabase(db, keyHex);
      protectBeforeMigration(db, file.path, AppDatabase.latestSchemaVersion);
    },
    logStatements: false,
  );
}

/// The schema version of an existing encrypted database, read without
/// migrating or changing anything (in a background isolate).
Future<int> peekSchemaVersion(File file, String keyHex) => Isolate.run(() {
  final db = sqlite3.open(file.path);
  try {
    configureEncryptedDatabase(db, keyHex);
    return db.select('PRAGMA user_version').single.values.single! as int;
  } finally {
    db.close();
  }
});

/// A backup payload read directly from the database at its current
/// (older) schema version — before any migration touches it. Read-only;
/// runs in a background isolate. The caller encrypts it immediately.
Future<Uint8List> exportPayloadBeforeMigration(
  File file,
  String keyHex,
  DateTime now,
) => Isolate.run(() {
  final db = sqlite3.open(file.path);
  try {
    configureEncryptedDatabase(db, keyHex);
    final version = db.select('PRAGMA user_version').single.values.single;
    if (version is! int || version < 3) {
      throw StateError('Unsupported schema for a backup');
    }
    db.execute('BEGIN');
    try {
      final tables = {
        for (final t in tablesForSchema(version))
          t: [
            for (final r in db.select('SELECT * FROM "$t" ORDER BY rowid'))
              {for (final c in r.keys) c: r[c]},
          ],
      };
      return buildPayload(schemaVersion: version, tables: tables, now: now);
    } finally {
      db.execute('ROLLBACK');
    }
  } finally {
    db.close();
  }
});
