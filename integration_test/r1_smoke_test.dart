import 'dart:convert';
import 'dart:io';

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/app/diagnostics.dart';
import 'package:denezhno/core/backup/backup_crypto.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/features/forecast/forecast_controller.dart';
import 'package:denezhno/features/operations/operations.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/payments/payments_controller.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/accounts/accounts_controller.dart';
import 'package:denezhno/core/security/storage_diagnostic.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/crypto_primitives_test.dart' as crypto;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  crypto.main();
  testWidgets('iPhone native storage, lifecycle and navigation smoke', (
    tester,
  ) async {
    // Integration results are printed only at the end, so a hang would be silent:
    // every step has a deadline and a timeout reports the step and stage trace.
    Future<T> step<T>(String name, Future<T> future) => future.timeout(
      const Duration(seconds: 120),
      onTimeout: () => throw TestFailure(
        'Step "$name" did not finish in 120 s. Storage stages: '
        '${storageStageTrace()}',
      ),
    );
    Future<void> settle(String name) => step(
      name,
      tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 30),
      ),
    );
    const device = String.fromEnvironment('TEST_DEVICE');
    const os = String.fromEnvironment('TEST_OS');
    expect(Platform.isIOS, true, reason: 'Run this target on an iOS device');
    expect(device, isNotEmpty, reason: 'Record TEST_DEVICE with --dart-define');
    expect(os, isNotEmpty, reason: 'Record TEST_OS with --dart-define');
    binding.reportData = {
      'device': device,
      'os': os,
      'build_mode': kProfileMode
          ? 'profile'
          : (kReleaseMode ? 'release' : 'debug'),
      'financial_operations': 0,
      'scope':
          'R1 shell and settings; not cold process launch or large history',
    };
    await tester.pumpWidget(const ProviderScope(child: DenezhnoApp()));
    await settle('first frame');
    final container = ProviderScope.containerOf(
      tester.element(find.byType(DenezhnoApp)),
    );
    final controller = container.read(appControllerProvider.notifier);
    // Explicit await: native database work does not necessarily schedule frames.
    await step('resume', controller.resume());
    await settle('after resume');
    expect(
      container.read(appControllerProvider).storage,
      StorageStatus.ready,
      // Allowlisted description (stage/type/numeric codes), no secrets or paths.
      reason:
          '${container.read(appControllerProvider).diagnostic} '
          'Storage stages: ${storageStageTrace()}',
    );
    // Diagnostics screen on the real storage path: stage trace must show the
    // native Data Protection checks and Keychain access that actually ran.
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await settle('open settings');
    await tester.ensureVisible(
      find.byKey(const ValueKey('settings.developer')),
    );
    await settle('scroll to developer');
    await tester.tap(find.byKey(const ValueKey('settings.developer')));
    await settle('open developer');
    final reportText = tester
        .widget<Text>(
          find.descendant(
            of: find.byKey(const ValueKey('diagnostics.report')),
            matching: find.byType(Text),
          ),
        )
        .data!;
    expect(reportText, startsWith(diagnosticsMarker));
    expect(reportText, contains('storage: ready'));
    expect(reportText, contains('failure: none'));
    expect(reportText, contains('<native.prepare'));
    expect(reportText, contains('<native.verify_after_db'));
    expect(reportText, contains('<keychain.'));
    expect(reportText, isNot(contains('/var/')));
    expect(reportText, isNot(contains('Containers')));
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await settle('back from developer');
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await settle('back from settings');
    // R2: accounts on the real encrypted ledger (iOS SQLite3MC, DB isolate).
    final accounts = container.read(accountsProvider.notifier);
    final name = 'Тест ${DateTime.now().millisecondsSinceEpoch}';
    await step(
      'create account',
      accounts.create(
        NewAccount(kind: AccountKind.debit, name: name, amount: Money(100000)),
      ),
    );
    final created = (await step(
      'load accounts',
      container.read(accountsProvider.future),
    )).singleWhere((a) => a.name == name);
    expect(created.amount, Money(100000));
    final update = await step(
      'update balances',
      accounts.updateBalances({created.id: Money(90000)}),
    );
    expect(update.unexplained, Money(-10000));
    final reloaded = (await step(
      'reload accounts',
      container.read(accountsProvider.future),
    )).singleWhere((a) => a.name == name);
    expect(reloaded.amount, Money(90000));
    // R2 step 2: a plan and its «оплачено» mark on the real store.
    final payments = container.read(paymentsProvider.notifier);
    final today = CalendarDate.today();
    await step(
      'save plan',
      payments.saveFlow(
        PlannedFlow(
          id: null,
          kind: FlowKind.communication,
          name: name,
          amount: Money(70000),
          cadence: Once(today.addDays(3)),
          startsOn: today,
        ),
      ),
    );
    final plan = (await step(
      'load plans',
      container.read(paymentsProvider.future),
    )).flows.singleWhere((f) => f.name == name);
    // R3 Р1: «Оплачено» is an operation in the journal on the real store.
    await step(
      'pay through the journal',
      payments.pay(
        PlanDate(plan.id!, today.addDays(3)),
        amount: Money(70000),
        accountId: created.id,
        date: today,
        placement: SameDayPlacement.afterConfirmedBalance,
      ),
    );
    expect(
      (await step(
        'reload plans',
        container.read(paymentsProvider.future),
      )).doneMarks,
      contains((plan.id!, today.addDays(3))),
    );
    // R2 step 3: the reserve and «можно потратить» on the real store.
    expect(
      await step('load reserve', container.read(reserveProvider.future)),
      Money(1000000),
    );
    await settle('forecast');
    final forecast = container.read(safeToSpendProvider);
    expect(forecast.hasValue, true, reason: '$forecast');
    // 900 ₽ confirmed, 700 ₽ paid after it: 200 ₽ left on the card.
    expect(forecast.value!.money.minorUnits, greaterThanOrEqualTo(20000));
    // R2 backup: libsodium (Argon2id + XChaCha20-Poly1305) on iOS for real.
    final backupFile = await step(
      'export backup',
      container.read(backupStoreProvider).exportBackup('integration-pass-1'),
    );
    final payload = utf8.decode(
      decryptBackup(backupFile, 'integration-pass-1'),
    );
    expect(payload, contains('"format":"denezhno-backup"'));
    expect(payload, contains(name));
    expect(
      () => decryptBackup(backupFile, 'wrong-password-1'),
      throwsA(isA<WrongPasswordOrDamaged>()),
    );
    await tester.tap(find.byKey(const ValueKey('tab.payments')));
    await settle('payments tab');
    expect(find.text(name), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('tab.accounts')));
    await settle('accounts tab');
    expect(find.text(name), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('tab.home')));
    await settle('back home');
    final initialTheme = container.read(appControllerProvider).theme;
    final testTheme = initialTheme == AppTheme.dark
        ? AppTheme.light
        : AppTheme.dark;
    try {
      await step(
        'timeline trace',
        binding.traceAction(() async {
          for (final section in ['accounts', 'payments', 'home']) {
            await tester.tap(find.byKey(ValueKey('tab.$section')));
            await settle('tab $section');
          }
          await step('setTheme', controller.setTheme(testTheme));
          await step('suspend', controller.suspend());
          expect(
            container.read(appControllerProvider).storage,
            StorageStatus.paused,
          );
          await step('resume after suspend', controller.resume());
          expect(
            container.read(appControllerProvider).storage,
            StorageStatus.ready,
            reason: container.read(appControllerProvider).diagnostic,
          );
          expect(container.read(appControllerProvider).theme, testTheme);
        }, reportKey: 'r1_timeline'),
      );
    } finally {
      if (container.read(appControllerProvider).storage !=
          StorageStatus.ready) {
        await step('cleanup resume', controller.resume());
      }
      await step('cleanup setTheme', controller.setTheme(initialTheme));
      await step('cleanup suspend', controller.suspend());
    }
  });
}
