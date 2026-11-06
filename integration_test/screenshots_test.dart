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
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/support/fakes.dart';

/// Screenshots rendered ON iOS (system SF font, iOS text rendering) with
/// synthetic data and in-memory stores (no real storage is touched).
/// Written to `SCREENS_DIR` (a host path; simulator apps can write there)
/// or, if not given, to the app's own tmp directory.
class _NoReminders implements ReminderScheduler {
  @override
  Future<bool> isPermitted() async => true;
  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<void> replaceAll(List<Reminder> r) async {}
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  const dir = String.fromEnvironment('SCREENS_DIR');
  final out = Directory(
    dir.isNotEmpty ? dir : '${Directory.systemTemp.path}/denezhno-screens',
  );

  for (final theme in [AppTheme.light, AppTheme.dark]) {
    for (final complete in [true, false]) {
      testWidgets('iOS screenshots ${theme.name} $complete', (tester) async {
        out.createSync(recursive: true);
        // iPhone 11: 414×896 pt @2x, with notch and home-indicator insets.
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
        final prefix = '${theme.name}${complete ? '' : '-preliminary'}';
        Future<void> shot(String name) async {
          await tester.pumpAndSettle();
          final render =
              boundary.currentContext!.findRenderObject()!
                  as RenderRepaintBoundary;
          final image = await render.toImage(pixelRatio: 1);
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          File('${out.path}/$prefix-$name.png')
              .writeAsBytesSync(png!.buffer.asUint8List());
        }

        final router = container.read(routerProvider);
        await shot('home');
        if (!complete) return;
        final breakdown = find.byKey(const ValueKey('home.breakdown'));
        await tester.ensureVisible(breakdown);
        await tester.pumpAndSettle();
        await tester.tap(breakdown);
        await tester.pumpAndSettle();
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -500));
        await shot('home-breakdown');
        await tester.drag(
          find.byType(Scrollable).first,
          const Offset(0, -3000),
        );
        await shot('home-scenarios');
        await tester.drag(find.byType(Scrollable).first, const Offset(0, 5000));
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
          ('/income/schedule', 'salary-schedule', null),
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
        ]) {
          router.go('/');
          await tester.pumpAndSettle();
          unawaited(router.push<void>(path, extra: extra));
          await shot(name);
        }
      });
    }
  }
}
