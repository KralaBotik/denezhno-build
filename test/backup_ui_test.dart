import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/backup/backup_crypto.dart';
import 'package:denezhno/features/backup/backup.dart';
import 'package:denezhno/features/backup/backup_section.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:denezhno/ui/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Prefs implements PreferencesStore {
  int opens = 0;
  @override
  Future<AppTheme> open() async {
    opens++;
    return AppTheme.system;
  }

  @override
  Future<void> setTheme(AppTheme theme) async {}
  @override
  Future<void> close() async {}
}

class _Backup implements BackupStore {
  bool empty = true;
  String? exportedWith;
  String? restoredWith;
  @override
  Future<Uint8List> exportBackup(String password) async {
    exportedWith = password;
    return Uint8List.fromList([1, 2, 3]);
  }

  @override
  Future<bool> canRestore() async => empty;
  @override
  Future<void> restoreBackup(Uint8List file, String password) async {
    if (password != 'right password') throw const WrongPasswordOrDamaged();
    restoredWith = password;
    empty = false;
  }
}

class _Io implements BackupIo {
  Uint8List? shared;
  String? name;
  @override
  Future<void> share(Uint8List encrypted, String fileName) async {
    shared = encrypted;
    name = fileName;
  }

  @override
  Future<Uint8List?> pick() async => Uint8List.fromList([9]);
}

void main() {
  Future<(_Backup, _Io, _Prefs)> openSettings(
    WidgetTester tester, {
    bool empty = true,
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final backup = _Backup()..empty = empty;
    final io = _Io();
    final prefs = _Prefs();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesStoreProvider.overrideWithValue(prefs),
          backupStoreProvider.overrideWithValue(backup),
          backupIoProvider.overrideWithValue(io),
        ],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings.backup')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.backup')), findsOneWidget);
    return (backup, io, prefs);
  }

  Future<void> tapKey(WidgetTester tester, String key) async {
    await tester.ensureVisible(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ValueKey(key)));
    await tester.pumpAndSettle();
  }

  testWidgets('create: short and mismatched passwords, then share', (
    tester,
  ) async {
    final (backup, io, _) = await openSettings(tester);
    await tapKey(tester, 'backup.create');
    expect(find.textContaining('Без этого пароля'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('backup.password')),
      'short',
    );
    await tester.enterText(
      find.byKey(const ValueKey('backup.password2')),
      'short',
    );
    await tapKey(tester, 'backup.ok');
    expect(find.text('Пароль короче 8 символов'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('backup.password')),
      'long password 1',
    );
    await tester.enterText(
      find.byKey(const ValueKey('backup.password2')),
      'long password 2',
    );
    await tapKey(tester, 'backup.ok');
    expect(find.text('Пароли не совпадают'), findsOneWidget);
    await tester.enterText(
      find.byKey(const ValueKey('backup.password2')),
      'long password 1',
    );
    await tapKey(tester, 'backup.ok');
    expect(backup.exportedWith, 'long password 1');
    expect(io.shared, [1, 2, 3]);
    expect(io.name, matches(RegExp(r'^Denezhno-\d{4}-\d{2}-\d{2}\.dnzb$')));
    expect(find.text('Копия создана.'), findsOneWidget);
  });

  testWidgets('restore: wrong password is explained, nothing changes', (
    tester,
  ) async {
    final (backup, _, _) = await openSettings(tester);
    await tapKey(tester, 'backup.restore');
    await tester.enterText(
      find.byKey(const ValueKey('backup.password')),
      'nope',
    );
    await tapKey(tester, 'backup.ok');
    expect(
      find.text(
        'Неверный пароль или файл повреждён. Данные в приложении не изменены.',
      ),
      findsOneWidget,
    );
    expect(backup.restoredWith, isNull);
  });

  testWidgets('restore: success reloads the app data', (tester) async {
    final (backup, _, prefs) = await openSettings(tester);
    final opensBefore = prefs.opens;
    await tapKey(tester, 'backup.restore');
    await tester.enterText(
      find.byKey(const ValueKey('backup.password')),
      'right password',
    );
    await tapKey(tester, 'backup.ok');
    expect(backup.restoredWith, 'right password');
    expect(find.text('Данные восстановлены.'), findsOneWidget);
    expect(prefs.opens, greaterThan(opensBefore)); // storage reopened
  });

  testWidgets('restore is disabled when the app already has data', (
    tester,
  ) async {
    await openSettings(tester, empty: false);
    final row = tester.widget<SettingsRow>(
      find.byKey(const ValueKey('backup.restore')),
    );
    expect(row.onTap, isNull);
    expect(find.textContaining('только в пустое приложение'), findsOneWidget);
  });

  test('stale share folders are removed at launch; others are kept', () async {
    final root = await Directory.systemTemp.createTemp('denezhno-cleanup-');
    addTearDown(() => root.delete(recursive: true));
    final temp = await Directory('${root.path}/tmp').create();
    final cache = await Directory('${root.path}/cache').create();
    final stale = await Directory('${temp.path}/${shareTempPrefix}abc')
        .create();
    await File('${stale.path}/Denezhno-2026-11-04.dnzb').writeAsBytes([1, 2]);
    final foreign = await Directory('${temp.path}/other-app').create();
    final plugin = await Directory('${cache.path}/share_plus').create();
    await File('${plugin.path}/copy.dnzb').writeAsBytes([3]);
    expect(await cleanupStaleShareFiles(temp: temp, cache: cache), 2);
    expect(await stale.exists(), false);
    expect(await plugin.exists(), false);
    expect(await foreign.exists(), true);
    expect(await cleanupStaleShareFiles(temp: temp, cache: cache), 0);
  });

  test('a share deletes its temporary file only after it completes', () async {
    final io = _RecordingSystemIo();
    final done = io.share(Uint8List.fromList([7, 7]), 'x.dnzb');
    await io.started.future;
    expect(await File(io.path!).exists(), true); // still sharing
    io.finish.complete();
    await done;
    expect(await File(io.path!).exists(), false);
  });
}

/// Same lifecycle as SystemBackupIo, with the platform sheet replaced by a
/// completer, to prove the ordering «write → share completes → delete».
class _RecordingSystemIo {
  final started = Completer<void>();
  final finish = Completer<void>();
  String? path;
  Future<void> share(Uint8List bytes, String name) =>
      shareThrough(bytes, name, (file) async {
        path = file.path;
        started.complete();
        await finish.future;
        return null;
      });
}
