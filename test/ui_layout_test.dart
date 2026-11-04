import 'dart:async';

import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/app/router.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/income/income.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/payments/reminders.dart';
import 'package:denezhno/features/payments/reminders_controller.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';

class _Reminders implements ReminderScheduler {
  @override
  Future<bool> isPermitted() async => false;
  @override
  Future<bool> requestPermission() async => false;
  @override
  Future<void> replaceAll(List<Reminder> r) async {}
}

/// Every screen, on the smallest supported iPhone and on iPhone 11, with
/// large Dynamic Type, both themes and very long names: no layout overflow,
/// no exceptions. Text must wrap instead of being cut.
void main() {
  const sizes = {
    'iPhone SE': Size(640, 1136), // 320×568 pt @2x
    'iPhone 11': Size(828, 1792), // 414×896 pt @2x
  };
  const routes = <(String, Object?)>[
    ('/', null),
    ('/accounts', null),
    ('/payments', null),
    ('/settings', null),
    ('/reserve', null),
    ('/backup', null),
    ('/developer', null),
    ('/account', 'alfa-cc'),
    ('/account', 'pillow'),
    ('/update-balances', null),
    ('/add-account', null),
    ('/card-figures', 'alfa-cc'),
    ('/flow', FlowDirection.outflow),
    ('/income/schedule', null),
    ('/income/schedule', 'work'),
    ('/income/payment', 'advanceKey'),
    ('/income/receive', 'advanceKey'),
  ];

  for (final size in sizes.entries) {
    for (final scale in [1.0, 2.0, 3.0]) {
      for (final theme in [AppTheme.light, AppTheme.dark]) {
        for (final variant in ['complete', 'preliminary', 'short']) {
          testWidgets('${size.key} ×$scale ${theme.name} $variant', (
            tester,
          ) async {
            tester.view.physicalSize = size.value;
            tester.view.devicePixelRatio = 2;
            tester.view.padding = const FakeViewPadding(top: 96, bottom: 68);
            tester.platformDispatcher.textScaleFactorTestValue = scale;
            addTearDown(() {
              tester.view.reset();
              tester.platformDispatcher.clearTextScaleFactorTestValue();
            });
            final data = sampleData(
              complete: variant != 'preliminary',
              longNames: true,
            );
            if (variant == 'short') {
              data.accounts[0] = account(
                'sber',
                'Дебетовая карта Сбера для повседневных покупок',
                AccountKind.debit,
                100,
              );
            }
            final household = FakeHouseholdStore()..value = Money(1000000);
            final container = ProviderContainer(
              overrides: [
                preferencesStoreProvider.overrideWithValue(FakePrefs(theme)),
                accountsStoreProvider.overrideWithValue(
                  FakeAccountsStore(data.accounts),
                ),
                paymentsStoreProvider.overrideWithValue(data.payments),
                incomeStoreProvider.overrideWithValue(data.income),
                householdStoreProvider.overrideWithValue(household),
                backupStoreProvider.overrideWithValue(FakeBackupStore()),
                reminderSchedulerProvider.overrideWithValue(_Reminders()),
              ],
            );
            addTearDown(container.dispose);
            await tester.pumpWidget(
              UncontrolledProviderScope(
                container: container,
                child: const DenezhnoApp(),
              ),
            );
            await tester.pumpAndSettle();
            final router = container.read(routerProvider);
            for (final (path, extra) in routes) {
              router.go('/');
              await tester.pumpAndSettle();
              if (path == '/' || path == '/accounts' || path == '/payments') {
                router.go(path);
              } else {
                unawaited(
                  router.push<void>(
                    path,
                    extra: extra == 'advanceKey'
                        ? PaymentKey(
                            sourceId: 'work',
                            partId: 'advance',
                            plannedOn: CalendarDate.today().addDays(12),
                          )
                        : extra,
                  ),
                );
              }
              await tester.pumpAndSettle();
              expect(tester.takeException(), isNull, reason: path);
              // Scroll to the end: lower parts must lay out too.
              final scrollable = find.byType(Scrollable);
              if (scrollable.evaluate().isNotEmpty) {
                await tester.drag(scrollable.first, const Offset(0, -3000));
                await tester.pumpAndSettle();
                expect(tester.takeException(), isNull, reason: '$path end');
              }
              if (path == '/') {
                final breakdown = find.byKey(const ValueKey('home.breakdown'));
                if (breakdown.evaluate().isNotEmpty) {
                  await tester.tap(breakdown);
                  await tester.pumpAndSettle();
                  expect(tester.takeException(), isNull, reason: 'breakdown');
                }
              }
            }
          });
        }
      }
    }
  }
}
