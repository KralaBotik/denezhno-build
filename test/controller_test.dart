import 'dart:async';

import 'package:denezhno/app/controller.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _Store implements PreferencesStore {
  Completer<AppTheme>? opening;
  final events = <String>[];
  bool failWrite = false;
  @override
  Future<AppTheme> open() async {
    events.add('open');
    return opening == null ? AppTheme.system : opening!.future;
  }

  @override
  Future<void> close() async {
    events.add('close');
  }

  @override
  Future<void> setTheme(AppTheme theme) async {
    if (failWrite) throw StateError('synthetic write failure');
    events.add('write');
  }
}

void main() {
  test('suspend closes a pending open before later resume', () async {
    final store = _Store()..opening = Completer<AppTheme>();
    final container = ProviderContainer(
      overrides: [preferencesStoreProvider.overrideWithValue(store)],
    );
    addTearDown(container.dispose);
    final controller = container.read(appControllerProvider.notifier);
    final opening = controller.resume();
    await Future<void>.delayed(Duration.zero);
    final closing = controller.suspend();
    store.opening!.complete(AppTheme.dark);
    await opening;
    await closing;
    expect(store.events, ['open', 'close']);
    expect(container.read(appControllerProvider).storage, StorageStatus.paused);
    await controller.setTheme(AppTheme.light);
    expect(store.events, ['open', 'close']);
    store.opening = null;
    await controller.resume();
    expect(container.read(appControllerProvider).storage, StorageStatus.ready);
  });
  test(
    'failed persistence does not display a successful theme change',
    () async {
      final store = _Store()..failWrite = true;
      final container = ProviderContainer(
        overrides: [preferencesStoreProvider.overrideWithValue(store)],
      );
      addTearDown(container.dispose);
      final controller = container.read(appControllerProvider.notifier);
      await controller.resume();
      await controller.setTheme(AppTheme.dark);
      expect(container.read(appControllerProvider).theme, AppTheme.system);
      expect(
        container.read(appControllerProvider).storage,
        StorageStatus.unavailable,
      );
      expect(store.events.last, 'close');
    },
  );
}
