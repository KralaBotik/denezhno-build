// Synthetic host probe, not an iPhone performance acceptance test.
import 'dart:convert';
import 'dart:io';

import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:sodium/sodium.dart';
import 'package:sqlite3/sqlite3.dart';

Future<void> main() async {
  final directory = await Directory.systemTemp.createTemp('denezhno-probe-');
  final file = File('${directory.path}/probe.sqlite');
  const key =
      '0303030303030303030303030303030303030303030303030303030303030303';
  final store = LocalStore(() async => StorageLocation(file, key, () async {}));
  try {
    await store.open();
    final opens = <int>[];
    final writes = <int>[];
    for (var i = 0; i < 30; i++) {
      await store.close();
      var clock = Stopwatch()..start();
      await store.open();
      opens.add(clock.elapsedMicroseconds);
      clock = Stopwatch()..start();
      await store.setTheme(i.isEven ? AppTheme.light : AppTheme.dark);
      writes.add(clock.elapsedMicroseconds);
    }
    final sizes = <String, int>{};
    for (final suffix in ['', '-wal', '-shm']) {
      final part = File('${file.path}$suffix');
      sizes[suffix.isEmpty ? 'database' : suffix.substring(1)] =
          await part.exists() ? await part.length() : 0;
    }
    await store.close();
    final raw = sqlite3.open(file.path);
    late final Map<String, Object?> versions;
    try {
      configureEncryptedDatabase(raw, key);
      versions = Map.of(
        raw
            .select(
              'SELECT sqlite_version() AS sqlite, sqlite3mc_version() AS sqlite3mc',
            )
            .single,
      );
    } finally {
      raw.close();
    }
    final sodium = await SodiumInit.init();
    final result = {
      'purpose':
          'R1 synthetic settings host probe; not iPhone or finance benchmark',
      'os': Platform.operatingSystem,
      'os_version': Platform.operatingSystemVersion,
      'dart': Platform.version,
      'mode': 'Dart CLI JIT',
      'iterations': 30,
      'financial_operations': 0,
      ...versions,
      'libsodium': sodium.version.toString(),
      'open_p95_us': percentile95(opens),
      'settings_write_p95_us': percentile95(writes),
      'files_bytes_before_close': sizes,
      'process_max_rss_bytes': ProcessInfo.maxRss,
    };
    final output = File('build/r1-native-probe.json');
    await output.parent.create(recursive: true);
    await output.writeAsString(
      '${const JsonEncoder.withIndent('  ').convert(result)}\n',
    );
    // Only non-sensitive synthetic measurements and library versions.
    stdout.writeln(const JsonEncoder.withIndent('  ').convert(result));
  } finally {
    await store.close();
    await directory.delete(recursive: true);
  }
}

int percentile95(List<int> values) {
  final sorted = [...values]..sort();
  return sorted[((sorted.length * 95 + 99) ~/ 100) - 1];
}
