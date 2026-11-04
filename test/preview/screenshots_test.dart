@Tags(['screenshots'])
library;

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/app/router.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:denezhno/features/payments/reminders.dart';
import 'package:denezhno/features/payments/reminders_controller.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/fakes.dart';

/// Renders the main screens at iPhone 11 size (414×896 pt, @2x) in light and
/// dark themes into build/screenshots/. Opt-in: DENEZHNO_SCREENSHOTS=1.
/// Uses Roboto instead of SF (SF is only available on Apple platforms), so
/// glyphs differ slightly from the device; layout, colours and sizes match.
class _NoReminders implements ReminderScheduler {
  @override
  Future<bool> isPermitted() async => true;
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> replaceAll(List<Reminder> r) async {}
}

Future<void> _loadFonts() async {
  final exe = Platform.resolvedExecutable;
  final flutterRoot = exe.substring(0, exe.indexOf('/bin/cache/'));
  final fonts = '$flutterRoot/bin/cache/artifacts/material_fonts';
  Future<void> family(String name, List<String> files) async {
    final loader = FontLoader(name);
    for (final f in files) {
      final bytes = File('$fonts/$f').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  const roboto = ['Roboto-Regular.ttf', 'Roboto-Medium.ttf', 'Roboto-Bold.ttf'];
  for (final name in [
    'CupertinoSystemText',
    'CupertinoSystemDisplay',
    'Roboto',
  ]) {
    await family(name, roboto);
  }
  final pub = Platform.environment['PUB_CACHE']!;
  final icons = File(
    '$pub/hosted/pub.dev/cupertino_icons-2.0.0/assets/CupertinoIcons.ttf',
  );
  final loader = FontLoader('packages/cupertino_icons/CupertinoIcons')
    ..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync())));
  await loader.load();
}

void main() {
  final enabled = Platform.environment['DENEZHNO_SCREENSHOTS'] == '1';
  final out = Directory('build/screenshots');

  setUpAll(() async {
    if (!enabled) return;
    await _loadFonts();
    out.createSync(recursive: true);
  });

  for (final theme in [AppTheme.light, AppTheme.dark]) {
    for (final complete in [true, false]) {
      testWidgets('screens ${theme.name}${complete ? '' : ' preliminary'}', (
        tester,
      ) async {
        tester.view.physicalSize = const Size(828, 1792);
        tester.view.devicePixelRatio = 2;
        tester.view.padding = const FakeViewPadding(top: 96, bottom: 68);
        addTearDown(tester.view.reset);
        final data = sampleData(complete: complete);
        final container = ProviderContainer(
          overrides: [
            preferencesStoreProvider.overrideWithValue(FakePrefs(theme)),
            accountsStoreProvider.overrideWithValue(
              FakeAccountsStore(data.accounts),
            ),
            paymentsStoreProvider.overrideWithValue(data.payments),
            incomeStoreProvider.overrideWithValue(data.income),
            householdStoreProvider.overrideWithValue(FakeHouseholdStore()),
            backupStoreProvider.overrideWithValue(FakeBackupStore()),
            reminderSchedulerProvider.overrideWithValue(_NoReminders()),
          ],
        );
        addTearDown(container.dispose);
        final boundary = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundary,
            child: UncontrolledProviderScope(
              container: container,
              child: const DenezhnoApp(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        Future<void> shot(String name) async {
          await tester.pumpAndSettle();
          await tester.runAsync(() async {
            final render =
                boundary.currentContext!.findRenderObject()!
                    as RenderRepaintBoundary;
            final image = await render.toImage(pixelRatio: 1);
            final png = await image.toByteData(format: ui.ImageByteFormat.png);
            File(
              '${out.path}/${theme.name}${complete ? '' : '-preliminary'}-$name.png',
            ).writeAsBytesSync(png!.buffer.asUint8List());
          });
        }

        final router = container.read(routerProvider);
        await shot('home');
        if (complete) {
          final breakdown = find.byKey(const ValueKey('home.breakdown'));
          await tester.ensureVisible(breakdown);
          await tester.pumpAndSettle();
          await tester.tap(breakdown);
          await tester.pumpAndSettle();
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -500),
          );
          await shot('home-breakdown');
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, -3000),
          );
          await shot('home-scenarios');
          await tester.drag(
            find.byType(Scrollable).first,
            const Offset(0, 5000),
          );
        }
        if (!complete) return;
        router.go('/accounts');
        await shot('accounts');
        router.go('/payments');
        await shot('payments');
        for (final (path, name, extra) in <(String, String, Object?)>[
          ('/settings', 'settings', null),
          ('/backup', 'backup', null),
          ('/account', 'account', 'alfa-cc'),
          ('/update-balances', 'update-balances', null),
          ('/add-account', 'add-account', null),
          ('/income/schedule', 'salary-schedule', 'work'),
          (
            '/income/payment',
            'income-payment',
            PaymentKey(
              sourceId: 'work',
              partId: 'advance',
              plannedOn: CalendarDate.today().addDays(12),
            ),
          ),
          (
            '/income/receive',
            'income-receive',
            PaymentKey(
              sourceId: 'work',
              partId: 'advance',
              plannedOn: CalendarDate.today().addDays(12),
            ),
          ),
          ('/card-figures', 'card-figures', 'alfa-cc'),
        ]) {
          router.go('/');
          await tester.pumpAndSettle();
          unawaited(router.push<void>(path, extra: extra));
          await shot(name);
        }
      }, skip: !enabled);
    }
  }
}
