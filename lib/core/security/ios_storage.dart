import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'storage_diagnostic.dart';
import 'storage_location.dart';

/// iOS-only native boundary. Missing platform support is an error, not fallback.
final class IosStorage {
  IosStorage({FlutterSecureStorage? keychain, MethodChannel? channel})
    : _keychain =
          keychain ??
          const FlutterSecureStorage(
            iOptions: IOSOptions(
              accountName: 'app.denezhno.local-storage',
              accessibility: KeychainAccessibility.unlocked_this_device,
              synchronizable: false,
            ),
          ),
      _channel = channel ?? const MethodChannel('app.denezhno/storage');
  final FlutterSecureStorage _keychain;
  final MethodChannel _channel;

  /// Calls the native port; the stage tag is diagnostic only (see storage_diagnostic.dart).
  Future<T?> _native<T>(String method, String stage) =>
      storageStage(stage, () => _channel.invokeMethod<T>(method));

  Future<StorageLocation> prepare() async {
    final path = await _native<String>('prepareStorage', 'native.prepare');
    if (path == null || path.isEmpty) {
      throw StateError('Protected storage unavailable');
    }
    final marker = File('$path/generation');
    final initialized = File('$path/initialized');
    final file = File('$path/denezhno.sqlite');
    late final String generation;
    late final String key;
    if (await marker.exists()) {
      generation = await storageStage('fs.marker', marker.readAsString);
      if (!RegExp(r'^[0-9a-f]{32}$').hasMatch(generation)) {
        throw StateError('Invalid storage generation');
      }
      final saved = await storageStage(
        'keychain.read',
        () => _keychain.read(key: 'db.$generation'),
      );
      if (saved == null || !RegExp(r'^[0-9a-f]{64}$').hasMatch(saved)) {
        throw StateError('Storage key unavailable');
      }
      key = saved;
      if (await initialized.exists() &&
          (!await file.exists() ||
              await initialized.readAsString() != generation)) {
        throw StateError('Initialized storage is missing');
      }
    } else {
      if (await file.exists() ||
          await File('${file.path}-wal').exists() ||
          await File('${file.path}-shm').exists() ||
          await initialized.exists()) {
        throw StateError('Storage generation unavailable');
      }
      generation = _randomHex(16);
      key = _randomHex(32);
      await storageStage(
        'keychain.write',
        () => _keychain.write(key: 'db.$generation', value: key),
      );
      final stored = await storageStage(
        'keychain.verify',
        () => _keychain.read(key: 'db.$generation'),
      );
      if (stored != key) {
        throw StateError('Keychain verification failed');
      }
      final temporary = File('$path/generation.tmp');
      await storageStage('fs.marker_write', () async {
        await temporary.writeAsString(generation, flush: true);
        await temporary.rename(marker.path);
      });
    }
    await _native<void>('verifyStorage', 'native.verify_before_db');
    return StorageLocation(file, key, () async {
      await _native<void>('verifyStorage', 'native.verify_after_db');
      if (!await initialized.exists()) {
        await storageStage(
          'fs.initialized_write',
          () => initialized.writeAsString(generation, flush: true),
        );
      }
      await _native<void>('verifyStorage', 'native.verify_after_init');
    });
  }

  static String _randomHex(int length) {
    final random = Random.secure();
    return List.generate(
      length,
      (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
    ).join();
  }
}
