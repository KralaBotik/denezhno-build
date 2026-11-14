import 'dart:convert';

import 'package:drift/drift.dart';

import '../backup/backup_crypto.dart';
import 'app_database.dart';

/// Payload version inside the encrypted container (independent of the
/// container format and of the database schema).
const backupPayloadVersion = 1;

/// Database schema versions whose payload this app can restore. A payload
/// from a newer schema is refused; an older one is inserted as is and then
/// brought to the current version by the migration's own data steps
/// ([AppDatabase.upgradeDataTo]).
const restorableSchemaVersions = {3, 4, 5, 6};

/// Tables each payload version contains (older payloads lack newer tables).
const _tablesSince = {
  'category_groups': 4,
  'categories': 4,
  'entry_details': 4,
  'income_sources': 5,
  'income_schedule_parts': 5,
  'income_occurrences': 5,
  'income_receipts': 5,
  'forecast_settings': 5,
  'flow_tracking': 6,
  'obligation_payments': 6,
  'figures_transfer_answers': 6,
};

/// Every table with user data, in foreign-key order (parents first).
/// Reference tables (currencies, kinds, sources) are recreated by the schema;
/// schema_migrations is device history and is never copied.
const backupTables = [
  'households',
  'members',
  'accounts',
  'category_groups',
  'categories',
  'journal_entries',
  'postings',
  'entry_details',
  'balance_assertions',
  'planned_flows',
  'flow_marks',
  'card_figures',
  'flow_tracking',
  'obligation_payments',
  'figures_transfer_answers',
  'income_sources',
  'income_schedule_parts',
  'income_occurrences',
  'income_receipts',
  'forecast_settings',
  'app_settings',
];

/// Tables a payload of schema [version] contains.
List<String> tablesForSchema(int version) => [
  for (final t in backupTables)
    if ((_tablesSince[t] ?? 0) <= version) t,
];

/// Builds the payload JSON from rows read by any means (drift, or the raw
/// encrypted file before a migration).
Uint8List buildPayload({
  required int schemaVersion,
  required Map<String, List<Map<String, Object?>>> tables,
  required DateTime now,
}) => Uint8List.fromList(
  utf8.encode(
    jsonEncode({
      'format': 'denezhno-backup',
      'payloadVersion': backupPayloadVersion,
      'schemaVersion': schemaVersion,
      'createdAtUtc': now.toUtc().millisecondsSinceEpoch,
      'counts': {for (final e in tables.entries) e.key: e.value.length},
      'tables': tables,
    }),
  ),
);

/// Checks a finished backup file the way a restore would read it: it
/// decrypts with [password], the payload is complete (every table, counts
/// match) and the journal in it is consistent (every entry balanced, no
/// entry without lines). Returns what it holds. Plaintext is wiped.
BackupSummary verifyBackupFile(Uint8List file, String password) {
  final payload = decryptBackup(file, password);
  try {
    final parsed = BackupRepo.parse(payload);
    final sums = <String, int>{};
    for (final p in parsed.tables['postings']!) {
      final entry = p['entry_id']! as String;
      sums[entry] = (sums[entry] ?? 0) + (p['amount_minor']! as int);
    }
    for (final e in parsed.tables['journal_entries']!) {
      if (sums[e['id']] == null) throw const IncompleteBackup();
    }
    if (sums.values.any((v) => v != 0)) throw const IncompleteBackup();
    const own = {'debit', 'cash', 'savings', 'deposit', 'credit_card', 'loan'};
    return BackupSummary(
      schemaVersion: parsed.schemaVersion,
      ownAccounts: parsed.tables['accounts']!
          .where((a) => own.contains(a['kind']))
          .length,
      entries: parsed.tables['journal_entries']!.length,
    );
  } finally {
    payload.fillRange(0, payload.length, 0);
  }
}

/// What a verified backup holds (shown to the person).
final class BackupSummary {
  const BackupSummary({
    required this.schemaVersion,
    required this.ownAccounts,
    required this.entries,
  });
  final int schemaVersion;
  final int ownAccounts;
  final int entries;
}

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
    return buildPayload(
      schemaVersion: AppDatabase.latestSchemaVersion,
      tables: tables,
      now: now,
    );
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
        (SELECT COUNT(*) FROM income_sources) +
        (SELECT COUNT(*) FROM accounts a JOIN account_kinds k ON k.kind = a.kind
           WHERE k.nature IN ('asset', 'liability')) AS n
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
    final data = parse(payload);
    await db.transaction(() async {
      if (!await isEmpty()) throw const RestoreTargetNotEmpty();
      // Remove the seed (household, member, system and category accounts,
      // categories, settings); the backup brings its own with the same IDs.
      for (final name in [
        'app_settings',
        'forecast_settings',
        'categories',
        'category_groups',
        'accounts',
        'members',
        'households',
      ]) {
        await db.customStatement('DELETE FROM "$name"');
      }
      for (final name in backupTables) {
        final table = _table(name);
        for (final row in data.tables[name]!) {
          await db.into(table).insert(table.map(row) as Insertable<dynamic>);
        }
      }
      await _verify(data.tables);
      // An older backup: the same data steps as the migration.
      if (data.schemaVersion < AppDatabase.latestSchemaVersion) {
        await db.upgradeDataTo(data.schemaVersion);
      }
    });
  }

  /// Reads and checks a payload (format, version, tables, counts).
  static ({int schemaVersion, Map<String, List<Map<String, Object?>>> tables})
  parse(Uint8List payload) {
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
    final version = json['schemaVersion']! as int;
    final result = <String, List<Map<String, Object?>>>{};
    for (final name in backupTables) {
      if ((_tablesSince[name] ?? 0) > version) {
        if (tables.containsKey(name)) throw const IncompleteBackup();
        result[name] = const [];
        continue;
      }
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
    return (schemaVersion: version, tables: result);
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
