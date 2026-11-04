import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/app/diagnostics.dart';
import 'package:denezhno/core/security/storage_diagnostic.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

// Synthetic "secrets": none of them may ever reach the screen or clipboard.
const _key = '0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef';
const _path =
    '/var/mobile/Containers/Data/Application/AAAA/Library/denezhno.sqlite';
const _secrets = [_key, _path, 'hunter2', 'Containers', 'denezhno.sqlite'];

class _Store implements PreferencesStore {
  Object? error;
  final events = <String>[];
  @override
  Future<AppTheme> open() async {
    events.add('open');
    if (error != null) {
      await storageStage<void>('keychain.read', () async => throw error!);
    }
    return AppTheme.system;
  }

  @override
  Future<void> close() async => events.add('close');
  @override
  Future<void> setTheme(AppTheme theme) async {}
}

void main() {
  final copied = <String>[];
  bool clipboardFails = false;
  setUp(() {
    copied.clear();
    clipboardFails = false;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, (call) async {
          if (call.method == 'Clipboard.setData') {
            if (clipboardFails) throw PlatformException(code: 'denied');
            copied.add((call.arguments as Map)['text'] as String);
          }
          return null;
        });
  });
  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null);
  });

  Future<void> launch(WidgetTester tester, _Store store) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Object leaky() => PlatformException(
    code: 'Unexpected security result code',
    message: 'password=hunter2 key=$_key at $_path',
    details: -34018,
  );

  group('report content', () {
    test('sanitizer redacts hex keys and absolute paths', () {
      final text = sanitizeDiagnostic('k=$_key at $_path\n(x) /tmp/a;b');
      expect(text, isNot(contains(_key)));
      expect(text, isNot(contains('Containers')));
      expect(text, isNot(contains('/tmp')));
      expect(text, contains('[hex]'));
      expect(text, contains('[path]'));
    });
    test('trace markers and the version label survive sanitizing', () {
      final report = buildDiagnosticReport(
        status: StorageStatus.ready,
        trace:
            '>native.prepare <native.prepare >keychain.write !keychain.write',
        platform: 'ios Version 26.2 (Build 23C54)',
        buildMode: 'release',
      );
      expect(report, contains('app: 0.3.0+3 release'));
      expect(
        report,
        contains(
          'stages: >native.prepare <native.prepare >keychain.write '
          '!keychain.write',
        ),
      );
    });
    test('numeric sqlite codes such as 26/26 survive', () {
      expect(
        sanitizeDiagnostic('sqlite=26/26 code=-34018'),
        'sqlite=26/26 code=-34018',
      );
    });
    test('report for assorted failures never contains the secrets', () {
      final errors = <Object>[
        leaky(),
        StateError('password=hunter2 $_key $_path'),
        PlatformException(
          code: 'storage_protection_failed',
          details: 'protection_mismatch=absent;NSCocoaErrorDomain;513',
          message: _path,
        ),
        SqliteException(
          extendedResultCode: 26,
          message: 'file is not a database: $_path hunter2',
        ),
        FormatException('hunter2 $_key', _path),
      ];
      for (final error in errors) {
        final report = buildDiagnosticReport(
          status: StorageStatus.unavailable,
          failure: describeStorageFailure(error),
          lastFailure: describeStorageFailure(error),
        );
        expect(report, startsWith(diagnosticsMarker));
        for (final secret in _secrets) {
          expect(report, isNot(contains(secret)), reason: '$error');
        }
        expect(RegExp(r'[0-9a-fA-F]{24,}').hasMatch(report), false);
        expect(RegExp(r'(^|[\s=:;(])/[A-Za-z]').hasMatch(report), false);
      }
    });
  });

  testWidgets('error screen shows diagnostics and copy puts the same text '
      'on the clipboard', (tester) async {
    final store = _Store()..error = leaky();
    await launch(tester, store);
    expect(
      find.textContaining('Защищённое хранилище недоступно'),
      findsOneWidget,
    );
    final reportFinder = find.descendant(
      of: find.byKey(const ValueKey('diagnostics.report')),
      matching: find.byType(Text),
    );
    final shown = tester.widget<Text>(reportFinder).data!;
    expect(shown, contains(diagnosticsMarker));
    expect(shown, contains('storage: unavailable'));
    expect(
      shown,
      contains(
        'failure: stage=keychain.read type=PlatformException '
        'code=Unexpected security result code detail=-34018',
      ),
    );
    for (final secret in _secrets) {
      expect(shown, isNot(contains(secret)));
    }
    await tester.ensureVisible(find.byKey(const ValueKey('diagnostics.copy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diagnostics.copy')));
    await tester.pumpAndSettle();
    expect(copied, hasLength(1));
    expect(copied.single, shown);
    expect(find.text('Диагностика скопирована.'), findsOneWidget);
  });
  testWidgets('copy failure is reported, not hidden', (tester) async {
    clipboardFails = true;
    await launch(tester, _Store()..error = leaky());
    await tester.ensureVisible(find.byKey(const ValueKey('diagnostics.copy')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('diagnostics.copy')));
    await tester.pumpAndSettle();
    expect(copied, isEmpty);
    expect(find.text('Не удалось скопировать диагностику.'), findsOneWidget);
  });
  testWidgets('retry only reopens: nothing is deleted or recreated', (
    tester,
  ) async {
    final store = _Store()..error = leaky();
    await launch(tester, store);
    store.error = null;
    await tester.ensureVisible(find.text('Повторить'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(store.events.where((e) => e == 'open'), hasLength(2));
    expect(store.events, isNot(contains('delete')));
    expect(
      find.textContaining('Защищённое хранилище недоступно'),
      findsNothing,
    );
  });
  testWidgets('settings has a diagnostics section after a successful start '
      'and keeps an earlier failure', (tester) async {
    final store = _Store()..error = leaky();
    await launch(tester, store);
    store.error = null;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    // Diagnostics are not in everyday settings, but in «Для разработчика».
    expect(find.byKey(const ValueKey('diagnostics.report')), findsNothing);
    await tester.ensureVisible(
      find.byKey(const ValueKey('settings.developer')),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('settings.developer')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.developer')), findsOneWidget);
    final shown = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('diagnostics.report')),
            matching: find.byType(Text),
          ),
        )
        .data!;
    expect(shown, contains('storage: ready'));
    expect(shown, contains('failure: none'));
    expect(
      shown,
      contains('earlier failure in this launch: stage=keychain.read'),
    );
    expect(find.byKey(const ValueKey('diagnostics.copy')), findsOneWidget);
  });
}
