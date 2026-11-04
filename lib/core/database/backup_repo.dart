import 'dart:convert';

import 'package:drift/drift.dart';

import '../backup/backup_crypto.dart';
import 'app_database.dart';

/// Payload version inside the encrypted container (independent of the
/// container format and of the database schema).
const backupPayloadVersion = 1;

/// Database schema versions whose payload this app can restore. A payload
/// from a newer schema is refused; older ones need an explicit converter.
const restorableSchemaVersions = {3};

/// Every table with user data, in foreign-key order (parents first).
/// Reference tables (currencies, kinds, sources) are recreated by the schema;
/// schema_migrations is device history and is never copied.
const backupTables = [
  'households',
  'members',
  'accounts',
  'journal_entries',
  'postings',
  'balance_assertions',
  'planned_flows',
  'flow_marks',
  'card_figures',
  'app_settings',
];

/// Builds and restores backup payloads. Rows are exported generically by
/// SQL column name, so the payload follows the schema and does not depend
/// on the phone, its key or its file paths.
final class BackupRepo {
  BackupRepo(this.db);
  final AppDatabase db;

  TableInfo<Table, dynamic> _table(String name) =>
      db.allTables.singleWhere((t) => t.actualTableName == name);

  /// The plaintext payload (JSON). Lives only in memory; the caller
  /// encrypts it immediately.
  Future<Uint8List> exportPayload(DateTime now) async {
    final tables = <String, List<Map<String, Object?>>>{};
    await db.transaction(() async {
      for (final name in backupTables) {
        final rows = await db
            .customSelect(
              'SELECT * FROM "$name" ORDER BY rowid',
              readsFrom: {_table(name)},
            )
            .get();
        tables[name] = [for (final r in rows) r.data];
      }
    });
    final payload = {
      'format': 'denezhno-backup',
      'payloadVersion': backupPayloadVersion,
      'schemaVersion': AppDatabase.latestSchemaVersion,
      'createdAtUtc': now.toUtc().millisecondsSinceEpoch,
      'counts': {for (final e in tables.entries) e.key: e.value.length},
      'tables': tables,
    };
    return Uint8List.fromList(utf8.encode(jsonEncode(payload)));
  }

  /// True when the app holds no financial data yet (only the seed created
  /// with the schema). MVP restores only into such a database.
  Future<bool> isEmpty() async {
    final checks = await db.customSelect('''
      SELECT
        (SELECT COUNT(*) FROM journal_entries) +
        (SELECT COUNT(*) FROM balance_assertions) +
        (SELECT COUNT(*) FROM planned_flows) +
        (SELECT COUNT(*) FROM card_figures) +
        (SELECT COUNT(*) FROM accounts
           WHERE kind NOT IN ('opening_equity', 'suspense')) AS n
    ''').getSingle();
    return checks.read<int>('n') == 0;
  }

  /// Restores [payload] into this (empty) database in ONE transaction:
  /// any error rolls everything back and the database stays as it was.
  ///
  /// Future «replace existing data» mode must not reuse this path: it should
  /// restore into a new encrypted database file and switch to it only after
  /// full verification, keeping the old file (see docs/backup.md).
  Future<void> restoreIntoEmpty(Uint8List payload) async {
    final data = _parse(payload);
    await db.transaction(() async {
      if (!await isEmpty()) throw const RestoreTargetNotEmpty();
      // Remove the seed (household, member, system accounts, settings); the
      // backup brings its own with the same stable IDs.
      for (final name in [
        'app_settings',
        'accounts',
        'members',
        'households',
      ]) {
        await db.customStatement('DELETE FROM "$name"');
      }
      for (final name in backupTables) {
        final table = _table(name);
        for (final row in data[name]!) {
          await db.into(table).insert(table.map(row) as Insertable<dynamic>);
        }
      }
      await _verify(data);
    });
  }

  Map<String, List<Map<String, Object?>>> _parse(Uint8List payload) {
    final Object? json;
    try {
      json = jsonDecode(utf8.decode(payload));
    } on Object {
      throw const WrongPasswordOrDamaged();
    }
    if (json is! Map<String, Object?> || json['format'] != 'denezhno-backup') {
      throw const IncompleteBackup();
    }
    if (json['payloadVersion'] != backupPayloadVersion ||
        !restorableSchemaVersions.contains(json['schemaVersion'])) {
      throw const UnsupportedBackupVersion();
    }
    final tables = json['tables'];
    final counts = json['counts'];
    if (tables is! Map<String, Object?> || counts is! Map<String, Object?>) {
      throw const IncompleteBackup();
    }
    final result = <String, List<Map<String, Object?>>>{};
    for (final name in backupTables) {
      final rows = tables[name];
      if (rows is! List || counts[name] != rows.length) {
        throw const IncompleteBackup();
      }
      result[name] = [
        for (final r in rows)
          if (r is Map<String, Object?>) r else throw const IncompleteBackup(),
      ];
    }
    if (result['households']!.length != 1 || result['members']!.isEmpty) {
      throw const IncompleteBackup();
    }
    return result;
  }

  Future<void> _verify(Map<String, List<Map<String, Object?>>> data) async {
    for (final name in backupTables) {
      final n = await db
          .customSelect('SELECT COUNT(*) AS n FROM "$name"')
          .getSingle();
      if (n.read<int>('n') != data[name]!.length) {
        throw const IncompleteBackup();
      }
    }
    final unbalanced = await db.customSelect('''
      SELECT entry_id FROM postings GROUP BY entry_id, currency
      HAVING SUM(amount_minor) <> 0
    ''').get();
    final orphanEntries = await db.customSelect('''
      SELECT id FROM journal_entries
      WHERE id NOT IN (SELECT entry_id FROM postings)
    ''').get();
    final fk = await db.customSelect('PRAGMA foreign_key_check').get();
    if (unbalanced.isNotEmpty || orphanEntries.isNotEmpty || fk.isNotEmpty) {
      throw const IncompleteBackup();
    }
  }
}
