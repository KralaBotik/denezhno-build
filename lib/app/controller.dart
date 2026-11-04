import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/security/ios_storage.dart';
import '../core/security/storage_diagnostic.dart';
import '../core/storage/local_store.dart';
import '../features/accounts/accounts.dart';
import '../features/backup/backup.dart';
import '../features/income/income.dart';
import '../features/payments/payments.dart';
import '../features/settings/preferences.dart';

/// The single owner of the encrypted database (one instance per app).
final localStoreProvider = Provider<LocalStore>(
  (ref) => LocalStore(IosStorage().prepare),
);
final preferencesStoreProvider = Provider<PreferencesStore>(
  (ref) => ref.watch(localStoreProvider),
);
final accountsStoreProvider = Provider<AccountsStore>(
  (ref) => ref.watch(localStoreProvider),
);
final paymentsStoreProvider = Provider<PaymentsStore>(
  (ref) => ref.watch(localStoreProvider),
);
final householdStoreProvider = Provider<HouseholdStore>(
  (ref) => ref.watch(localStoreProvider),
);
final backupStoreProvider = Provider<BackupStore>(
  (ref) => ref.watch(localStoreProvider),
);
final incomeStoreProvider = Provider<IncomeStore>(
  (ref) => ref.watch(localStoreProvider),
);
final upgradeStoreProvider = Provider<UpgradeStore>(
  (ref) => ref.watch(localStoreProvider),
);
final appControllerProvider = NotifierProvider<AppController, AppState>(
  AppController.new,
);

/// Most recent storage failure description in this launch (memory only).
/// Kept after a later successful retry so Settings can still show it.
final lastStorageFailureProvider =
    NotifierProvider<LastStorageFailure, String?>(LastStorageFailure.new);

class LastStorageFailure extends Notifier<String?> {
  @override
  String? build() => null;
  void record(String description) => state = description;
}

enum StorageStatus {
  opening,
  ready,
  paused,
  unavailable,

  /// The database is from an older version: a verified backup is offered
  /// before it is migrated (nothing has been changed yet).
  upgradeRequired,
}

final class AppState {
  const AppState({
    this.theme = AppTheme.system,
    this.storage = StorageStatus.opening,
    this.diagnostic,
  });
  final AppTheme theme;
  final StorageStatus storage;

  /// Allowlisted failure description (stage, type, numeric codes) when
  /// [storage] is unavailable. Never contains messages, paths, SQL or keys.
  /// Not shown in the UI; used by tests and debug logs.
  final String? diagnostic;
}

class AppController extends Notifier<AppState> {
  Future<void> _tail = Future.value();
  bool _active = true;

  @override
  AppState build() {
    final store = ref.watch(preferencesStoreProvider);
    ref.onDispose(() {
      unawaited(store.close().catchError((Object _) {}));
    });
    return const AppState();
  }

  Future<void> _enqueue(Future<void> Function() action) {
    final run = _tail.then((_) async {
      if (!ref.mounted) return;
      try {
        await action();
      } on UpgradeRequired {
        // Not a failure: the old database is untouched and waits for the
        // person's decision.
        if (ref.mounted) {
          state = AppState(
            theme: state.theme,
            storage: StorageStatus.upgradeRequired,
          );
        }
      } catch (error) {
        // Never surface SQL, keys, paths or platform exception messages: only
        // the allowlisted description from describeStorageFailure is kept.
        final diagnostic = describeStorageFailure(error);
        if (kDebugMode) debugPrint('Storage unavailable: $diagnostic');
        if (ref.mounted) {
          ref.read(lastStorageFailureProvider.notifier).record(diagnostic);
        }
        try {
          await ref.read(preferencesStoreProvider).close();
        } catch (_) {}
        if (ref.mounted) {
          state = AppState(
            theme: state.theme,
            storage: StorageStatus.unavailable,
            diagnostic: diagnostic,
          );
        }
      }
    });
    _tail = run;
    return run;
  }

  Future<void> resume() {
    _active = true;
    return _enqueue(() async {
      if (!_active) return;
      state = AppState(theme: state.theme);
      final theme = await ref.read(preferencesStoreProvider).open();
      if (ref.mounted) {
        state = AppState(theme: theme, storage: StorageStatus.ready);
      }
    });
  }

  /// The person chose to update the data (after the offered backup).
  Future<void> approveUpgrade() {
    ref.read(upgradeStoreProvider).allowUpgrade();
    return resume();
  }

  Future<void> suspend() {
    _active = false;
    return _enqueue(() async {
      await ref.read(preferencesStoreProvider).close();
      if (ref.mounted) {
        state = AppState(theme: state.theme, storage: StorageStatus.paused);
      }
    });
  }

  Future<void> setTheme(AppTheme theme) => _enqueue(() async {
    if (!_active || state.storage != StorageStatus.ready) return;
    await ref.read(preferencesStoreProvider).setTheme(theme);
    if (ref.mounted) {
      state = AppState(theme: theme, storage: StorageStatus.ready);
    }
  });
}
