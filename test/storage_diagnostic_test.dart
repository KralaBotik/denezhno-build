import 'package:denezhno/app/controller.dart';
import 'package:denezhno/core/security/storage_diagnostic.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';

class _FailingStore implements PreferencesStore {
  _FailingStore(this.error);
  final Object error;
  @override
  Future<AppTheme> open() => storageStage('keychain.read', () async {
    throw error;
  });
  @override
  Future<void> close() async {}
  @override
  Future<void> setTheme(AppTheme theme) async {}
}

void main() {
  test('stage tag rethrows the same object and the innermost stage wins', () {
    final original = StateError('SECRET /private/path 0123abcd');
    expect(
      storageStage<void>(
        'outer',
        () => storageStage<void>('inner', () => throw original),
      ),
      throwsA(same(original)),
    );
  });
  test('description has stage and type but never the message', () async {
    final error = StateError('SECRET /private/path 0123abcd');
    await expectLater(
      storageStage('bootstrap', () async => throw error),
      throwsA(same(error)),
    );
    final text = describeStorageFailure(error);
    expect(text, 'stage=bootstrap type=StateError');
    expect(text, isNot(contains('SECRET')));
  });
  test('platform exception keeps code and numeric/safe details only', () {
    expect(
      describeStorageFailure(
        PlatformException(
          code: 'Unexpected security result code',
          message: 'SECRET message /private/path',
          details: -34018,
        ),
      ),
      'type=PlatformException code=Unexpected security result code '
      'detail=-34018',
    );
    final unsafe = describeStorageFailure(
      PlatformException(
        code: 'storage_protection_failed',
        details: '/var/mobile/Containers/SECRET',
      ),
    );
    expect(unsafe, 'type=PlatformException code=storage_protection_failed');
    expect(
      describeStorageFailure(
        PlatformException(
          code: 'storage_protection_failed',
          details: 'protection_mismatch=absent;NSCocoaErrorDomain;1',
        ),
      ),
      contains('detail=protection_mismatch=absent;NSCocoaErrorDomain;1'),
    );
  });
  test('sqlite error reports numeric codes, not its message', () {
    final text = describeStorageFailure(
      SqliteException(
        extendedResultCode: 26,
        message: 'file is not a database: SECRET',
      ),
    );
    expect(text, startsWith('type=SqliteException sqlite=26/'));
    expect(text, isNot(contains('SECRET')));
  });
  test(
    'controller exposes the description when storage is unavailable',
    () async {
      final container = ProviderContainer(
        overrides: [
          preferencesStoreProvider.overrideWithValue(
            _FailingStore(StateError('SECRET key=0123')),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(appControllerProvider.notifier).resume();
      final state = container.read(appControllerProvider);
      expect(state.storage, StorageStatus.unavailable);
      expect(state.diagnostic, 'stage=keychain.read type=StateError');
    },
  );
}
