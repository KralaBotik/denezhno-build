import 'dart:io';

import 'package:denezhno/core/security/ios_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('app.denezhno/storage');
  late Directory directory;
  late IosStorage storage;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('denezhno-bootstrap-');
    FlutterSecureStorage.setMockInitialValues({});
    storage = IosStorage();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          channel,
          (call) async =>
              call.method == 'prepareStorage' ? directory.path : null,
        );
  });
  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
    await directory.delete(recursive: true);
  });

  test('new generation retains the same key on subsequent opening', () async {
    final first = await storage.prepare();
    final second = await storage.prepare();
    expect(first.keyHex.length, 64);
    expect(second.keyHex, first.keyHex);
    expect(await first.file.exists(), false);
  });
  test(
    'missing key never replaces a generation or touches the database',
    () async {
      final location = await storage.prepare();
      await location.file.writeAsString('synthetic encrypted fixture');
      final before = await File('${directory.path}/generation').readAsString();
      FlutterSecureStorage.setMockInitialValues({});
      await expectLater(storage.prepare(), throwsStateError);
      expect(await File('${directory.path}/generation').readAsString(), before);
      expect(await location.file.readAsString(), 'synthetic encrypted fixture');
    },
  );
  test(
    'existing database without a generation is preserved and rejected',
    () async {
      final file = File('${directory.path}/denezhno.sqlite');
      await file.writeAsString('synthetic fixture');
      await expectLater(storage.prepare(), throwsStateError);
      expect(await file.readAsString(), 'synthetic fixture');
      expect(await File('${directory.path}/generation').exists(), false);
    },
  );
  test(
    'initialized storage is never silently recreated after file loss',
    () async {
      final location = await storage.prepare();
      await location.file.writeAsString('synthetic fixture');
      await location.verifyProtection();
      await location.file.delete();
      await expectLater(storage.prepare(), throwsStateError);
      expect(await location.file.exists(), false);
    },
  );
  test(
    'native protection failure aborts before creating a key or database',
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
            channel,
            (_) async =>
                throw PlatformException(code: 'protected_data_unavailable'),
          );
      await expectLater(storage.prepare(), throwsA(isA<PlatformException>()));
      expect(await directory.list().toList(), isEmpty);
    },
  );
}
