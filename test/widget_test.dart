import 'package:denezhno/app/app.dart';
import 'package:denezhno/app/controller.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MemoryPreferences implements PreferencesStore {
  AppTheme theme = AppTheme.system;
  bool fail = false;
  @override
  Future<AppTheme> open() async {
    if (fail) throw StateError('synthetic failure');
    return theme;
  }

  @override
  Future<void> setTheme(AppTheme value) async {
    theme = value;
  }

  @override
  Future<void> close() async {}
}

void main() {
  Future<void> launch(WidgetTester tester, MemoryPreferences store) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
        child: const DenezhnoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('five tabs, settings and back navigation work in Russian', (
    tester,
  ) async {
    await launch(tester, MemoryPreferences());
    expect(find.text('Денежно'), findsOneWidget);
    for (final section in [
      'accounts',
      'transactions',
      'payments',
      'forecast',
      'home',
    ]) {
      await tester.tap(find.byKey(ValueKey('tab.$section')));
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('screen.$section')), findsOneWidget);
    }
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.settings')), findsOneWidget);
    await tester.tap(find.byType(CupertinoNavigationBarBackButton));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('screen.home')), findsOneWidget);
  });
  testWidgets('explicit light/dark themes are stored and applied', (
    tester,
  ) async {
    final store = MemoryPreferences();
    await launch(tester, store);
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    for (final choice in [AppTheme.dark, AppTheme.light, AppTheme.system]) {
      await tester.tap(find.byKey(ValueKey('theme.${choice.name}')));
      await tester.pumpAndSettle();
      expect(store.theme, choice);
      final app = tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(app.theme!.brightness, switch (choice) {
        AppTheme.dark => Brightness.dark,
        AppTheme.light => Brightness.light,
        AppTheme.system => null,
      });
    }
  });
  testWidgets('small screen and large text have no layout exceptions', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 3.2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });
    await launch(tester, MemoryPreferences());
    for (final section in [
      'accounts',
      'transactions',
      'payments',
      'forecast',
      'home',
    ]) {
      await tester.tap(find.byKey(ValueKey('tab.$section')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
    await tester.tap(find.byKey(const ValueKey('open.settings')));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
  testWidgets('storage error is visible and a retry can recover', (
    tester,
  ) async {
    final store = MemoryPreferences()..fail = true;
    await launch(tester, store);
    expect(
      find.textContaining('Защищённое хранилище недоступно'),
      findsOneWidget,
    );
    store.fail = false;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(
      find.text('Настройки сохраняются на этом устройстве.'),
      findsOneWidget,
    );
  });
}
