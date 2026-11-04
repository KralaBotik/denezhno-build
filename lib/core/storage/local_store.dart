import 'dart:convert';

import 'dart:typed_data';

import '../../features/accounts/accounts.dart';
import '../../features/backup/backup.dart';
import '../backup/backup_crypto.dart';
import '../database/backup_repo.dart';
import '../../features/payments/payments.dart';
import '../calendar_date.dart';
import '../database/payments_repo.dart';
import '../../features/settings/preferences.dart';
import '../database/app_database.dart' hide CardFigures;
import '../database/encrypted_connection.dart';
import '../database/ledger.dart';
import '../money/money.dart';
import '../performance/measure.dart';
import '../security/storage_diagnostic.dart';
import '../security/storage_location.dart';

/// The single owner of the encrypted database. Every operation is serialized;
/// native SQL, KDF and migrations run in the DB isolate. Financial writes go
/// through [Ledger] (balanced, append-only, one transaction).
final class LocalStore
    implements
        PreferencesStore,
        AccountsStore,
        PaymentsStore,
        HouseholdStore,
        BackupStore {
  LocalStore(this.prepare);
  final Future<StorageLocation> Function() prepare;
  AppDatabase? _database;
  Future<void> _tail = Future.value();

  Future<T> _serial<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace _) {});
    return result;
  }

  @override
  Future<AppTheme> open() => _serial(
    () => measure(MeasuredOperation.storageOpen, () async {
      if (_database == null) {
        final location = await storageStage('bootstrap', prepare);
        final db = AppDatabase(
          await storageStage(
            'db.connection',
            () => encryptedConnection(location.file, location.keyHex),
          ),
        );
        try {
          await storageStage(
            'db.open_migrate',
            // Forces migration and validation.
            () => db.customSelect('SELECT 1').get(),
          );
          await storageStage('db.protection', location.verifyProtection);
          _database = db;
        } catch (_) {
          await db.close();
          rethrow;
        }
      }
      final rows = await storageStage(
        'db.read_settings',
        () => (_database!.select(
          _database!.appSettings,
        )..where((s) => s.key.equals('theme'))).get(),
      );
      return rows.isEmpty
          ? AppTheme.system
          : AppTheme.values.byName(jsonDecode(rows.single.valueJson) as String);
    }),
  );

  @override
  Future<void> setTheme(AppTheme theme) => _serial(
    () => measure(MeasuredOperation.settingsWrite, () async {
      final db = _database;
      if (db == null) throw StateError('Storage is closed');
      await db.transaction(
        () => db
            .into(db.appSettings)
            .insertOnConflictUpdate(
              AppSettingsCompanion.insert(
                key: 'theme',
                valueJson: jsonEncode(theme.name),
                valueVersion: 1,
              ),
            ),
      );
    }),
  );

  @override
  Future<void> close() => _serial(() async {
    final db = _database;
    await db?.close();
    _database = null;
  });

  AppDatabase _open() {
    final db = _database;
    if (db == null) throw StateError('Storage is closed');
    return db;
  }

  @override
  Future<List<AccountSummary>> accounts() =>
      _serial(() => Ledger(_open()).accounts());

  @override
  Future<void> createAccount(NewAccount account) =>
      _serial(() => Ledger(_open()).createAccount(account, DateTime.now()));

  @override
  Future<BalanceUpdateResult> updateBalances(Map<String, Money> amounts) =>
      _serial(() => Ledger(_open()).updateBalances(amounts, DateTime.now()));

  @override
  Future<PaymentsSnapshot> payments() =>
      _serial(() => PaymentsRepo(_open()).payments());

  @override
  Future<void> saveFlow(PlannedFlow flow) =>
      _serial(() => PaymentsRepo(_open()).saveFlow(flow, DateTime.now()));

  @override
  Future<void> archiveFlow(String id) =>
      _serial(() => PaymentsRepo(_open()).archiveFlow(id, DateTime.now()));

  @override
  Future<void> setFlowDone(String flowId, CalendarDate dueOn, bool done) =>
      _serial(
        () =>
            PaymentsRepo(_open())
                .setFlowDone(flowId, dueOn, done, DateTime.now()),
      );

  @override
  Future<void> saveCardFigures(CardFigures figures) => _serial(
    () => PaymentsRepo(_open()).saveCardFigures(figures, DateTime.now()),
  );

  @override
  Future<void> setCardSettled(String figuresId, bool settled) => _serial(
    () =>
        PaymentsRepo(_open())
            .setCardSettled(figuresId, settled, DateTime.now()),
  );

  @override
  Future<Money> reserve() => _serial(() => Ledger(_open()).reserve());

  @override
  Future<void> setReserve(Money reserve) =>
      _serial(() => Ledger(_open()).setReserve(reserve));

  @override
  Future<void> setIncludedInForecast(String accountId, bool included) =>
      _serial(() => Ledger(_open()).setIncludedInForecast(accountId, included));

  @override
  Future<Uint8List> exportBackup(String password) => _serial(() async {
    if (password.length < minBackupPasswordLength) throw const WeakPassword();
    final payload = await BackupRepo(_open()).exportPayload(DateTime.now());
    try {
      return encryptBackup(payload, password);
    } finally {
      payload.fillRange(0, payload.length, 0);
    }
  });

  @override
  Future<bool> canRestore() => _serial(() => BackupRepo(_open()).isEmpty());

  @override
  Future<void> restoreBackup(Uint8List file, String password) =>
      _serial(() async {
        final payload = decryptBackup(file, password);
        try {
          await BackupRepo(_open()).restoreIntoEmpty(payload);
        } finally {
          payload.fillRange(0, payload.length, 0);
        }
      });
}
