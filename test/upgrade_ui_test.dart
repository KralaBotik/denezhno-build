import 'dart:typed_data';

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/features/backup/backup.dart';
import 'package:denezhno/features/backup/backup_section.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';

/// An older database: the app waits for the person's decision.
class _OldDatabase implements PreferencesStore, UpgradeStore {
  bool allowed = false;
  int opens = 0;
  String? backupPassword;
  @override
  Future<AppTheme> open() async {
    opens++;
    if (!allowed) throw const UpgradeRequired(3);
    return AppTheme.light;
  }

  @override
  Future<void> setTheme(AppTheme theme) async {}
  @override
  Future<void> close() async {}
  @override
  Future<VerifiedBackup> exportBeforeUpgrade(String password) async {
    backupPassword = password;
    return VerifiedBackup(Uint8List(4), ownAccounts: 3, entries: 4);
  }

  @override
  void allowUpgrade() => allowed = true;
}

class _Io implements BackupIo {
  Uint8List? shared;
  @override
  Future<void> share(Uint8List encrypted, String fileName) async =>
      shared = encrypted;
  @override
  Future<Uint8List?> pick() async => null;
}

void main() {
  Future<(_OldDatabase, _Io)> launch(WidgetTester tester) async {
    tester.view.physicalSize = const Size(828, 1792);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    final db = _OldDatabase();
    final io = _Io();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(db),
          upgradeStoreProvider.overrideWithValue(db),
          backupIoProvider.overrideWithValue(io),
          accountsStoreProvider.overrideWithValue(FakeAccountsStore()),
          paymentsStoreProvider.overrideWithValue(FakePaymentsStore()),
          incomeStoreProvider.overrideWithValue(FakeIncomeStore()),
          householdStoreProvider.overrideWithValue(FakeHouseholdStore()),
          backupStoreProvider.overrideWithValue(FakeBackupStore()),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    return (db, io);
  }

  testWidgets('older database: verified backup first, then update', (
    tester,
  ) async {
    final (db, io) = await launch(tester);
    expect(find.byKey(const ValueKey('upgrade.notice')), findsOneWidget);
    expect(find.textContaining('Ваши данные пока не изменены'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('upgrade.backup')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('backup.password')),
      'correct horse battery',
    );
    await tester.enterText(
      find.byKey(const ValueKey('backup.password2')),
      'correct horse battery',
    );
    await tester.tap(find.byKey(const ValueKey('backup.ok')));
    await tester.pumpAndSettle();
    expect(db.backupPassword, 'correct horse battery');
    expect(io.shared, isNotNull);
    expect(find.textContaining('создана и проверена'), findsOneWidget);
    expect(db.allowed, false); // still nothing changed

    await tester.tap(find.byKey(const ValueKey('upgrade.continue')));
    await tester.pumpAndSettle();
    expect(db.allowed, true);
    expect(find.byKey(const ValueKey('upgrade.notice')), findsNothing);
  });

  testWidgets('updating without a backup asks first', (tester) async {
    final (db, _) = await launch(tester);
    await tester.tap(find.byKey(const ValueKey('upgrade.continue')));
    await tester.pumpAndSettle();
    expect(find.text('Обновить без копии?'), findsOneWidget);
    await tester.tap(find.text('Отмена'));
    await tester.pumpAndSettle();
    expect(db.allowed, false);
    await tester.tap(find.byKey(const ValueKey('upgrade.continue')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('upgrade.anyway')));
    await tester.pumpAndSettle();
    expect(db.allowed, true);
  });
}
