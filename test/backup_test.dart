import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:denezhno/core/backup/backup_crypto.dart';
import 'package:denezhno/core/calendar_date.dart';
import 'package:denezhno/core/database/app_database.dart' hide CardFigures;
import 'package:denezhno/core/database/backup_repo.dart';
import 'package:denezhno/core/database/encrypted_connection.dart';
import 'package:denezhno/core/money/money.dart';
import 'package:denezhno/core/security/storage_location.dart';
import 'package:denezhno/core/storage/local_store.dart';
import 'package:denezhno/features/accounts/accounts.dart';
import 'package:denezhno/features/forecast/safe_to_spend.dart';
import 'package:denezhno/features/payments/payments.dart';
import 'package:denezhno/features/settings/preferences.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated_migrations/schema.dart';
import 'support/v3_fixture.dart';

// Two «devices»: different directories and different Keychain keys.
const _keyA =
    'a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1a1';
const _keyB =
    'b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2b2';
const _password = 'correct horse battery';
const _marker = 'МАРКЕР-СЧЁТ-7f3a';

final class _Device {
  _Device(this.dir, this.key)
    : file = File('${dir.path}/denezhno.sqlite'),
      store = LocalStore(
        () async => StorageLocation(
          File('${dir.path}/denezhno.sqlite'),
          key,
          () async {},
        ),
      );
  final Directory dir;
  final String key;
  final File file;
  final LocalStore store;

  /// Every user table, as stored (for exact comparison between devices).
  Future<Map<String, Object?>> dump() async {
    await store.close();
    final db = AppDatabase(await encryptedConnection(file, key));
    try {
      final json = jsonDecode(
        utf8.decode(await BackupRepo(db).exportPayload(DateTime(2026))),
      ) as Map<String, Object?>;
      return json['tables']! as Map<String, Object?>;
    } finally {
      await db.close();
      await store.open();
    }
  }
}

CalendarDate d(String s) => CalendarDate.parse(s);

void main() {
  late Directory root;
  late _Device a;
  late _Device b;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('denezhno-backup-');
    a = _Device(await Directory('${root.path}/a').create(), _keyA);
    b = _Device(await Directory('${root.path}/b').create(), _keyB);
    await a.store.open();
    await b.store.open();
  });
  tearDown(() async {
    await a.store.close();
    await b.store.close();
    await root.delete(recursive: true);
  });

  /// Device A with every kind of data that exists today.
  Future<void> fillA() async {
    final s = a.store;
    await s.setTheme(AppTheme.dark);
    await s.setReserve(Money(1500000));
    await s.createAccount(
      NewAccount(
        kind: AccountKind.debit,
        name: _marker,
        amount: Money(5000000),
      ),
    );
    await s.createAccount(
      NewAccount(
        kind: AccountKind.creditCard,
        name: 'Сбер кредитка',
        amount: Money(840000),
        creditLimit: Money(10000000),
      ),
    );
    await s.createAccount(
      NewAccount(
        kind: AccountKind.savings,
        name: 'Подушка',
        amount: Money(30000000),
        isProtected: true,
      ),
    );
    final accounts = await s.accounts();
    final debit = accounts.firstWhere((x) => x.name == _marker).id;
    final card = accounts.firstWhere((x) => x.name == 'Сбер кредитка').id;
    await s.updateBalances({debit: Money(4680000), card: Money(900000)});
    await s.saveFlow(
      PlannedFlow(
        id: null,
        kind: FlowKind.salary,
        name: 'Зарплата',
        amount: Money(8000000),
        cadence: const Monthly(10),
        startsOn: d('2026-11-01'),
      ),
    );
    await s.saveFlow(
      PlannedFlow(
        id: null,
        kind: FlowKind.loanPayment,
        name: 'Платёж Сбер',
        amount: Money(840000),
        cadence: const Monthly(25),
        startsOn: d('2026-11-01'),
        accountId: card,
      ),
    );
    final flows = (await s.payments()).flows;
    await s.setFlowDone(flows.first.id!, d('2026-11-10'), true);
    await s.saveCardFigures(
      CardFigures(
        id: '',
        accountId: card,
        graceAmount: Money(840000),
        graceDueOn: d('2026-11-25'),
        minPayment: Money(30000),
        minDueOn: d('2026-11-25'),
      ),
    );
    await s.setIncludedInForecast(debit, true);
  }

  test(
    'full cycle A → B: identical data, settings, obligations, forecast',
    () async {
      await fillA();
      final file = await a.store.exportBackup(_password);
      expect(await b.store.canRestore(), true);
      await b.store.restoreBackup(file, _password);

      expect(await b.dump(), await a.dump()); // every user table, byte-exact
      expect(await b.store.open(), AppTheme.dark);
      expect(await b.store.reserve(), Money(1500000));
      expect(await b.store.canRestore(), false);

      final today = d('2026-11-04');
      SafeToSpend f(List<AccountSummary> acc, PaymentsSnapshot p, Money r) =>
          computeSafeToSpend(
            accounts: acc,
            payments: p,
            reserve: r,
            today: today,
          );
      final fa = f(
        await a.store.accounts(),
        await a.store.payments(),
        await a.store.reserve(),
      );
      final fb = f(
        await b.store.accounts(),
        await b.store.payments(),
        await b.store.reserve(),
      );
      expect(fb.available, fa.available);
      expect(fb.cardPayments.single.amount, Money(840000));

      // B persists with ITS OWN key after a restart.
      await b.store.close();
      expect(await b.store.open(), AppTheme.dark);
      expect((await b.store.accounts()).length, 3);
    },
  );

  test(
    'a v3 backup (made before the update) restores like the migration',
    () async {
      final verifier = SchemaVerifier(
        GeneratedHelper(),
        setup: (db) => db.execute('PRAGMA foreign_keys = ON'),
      );
      // The backup file the R2 app (schema v3) would have produced.
      final source = await verifier.schemaAt(3);
      V3.create(source.rawDatabase);
      const v3Tables = [
        'households',
        'members',
        'accounts',
        'journal_entries',
        'postings',
        'balance_assertions',
        'planned_flows',
        'flow_marks',
        'card_figures',
        'app_settings',
      ];
      final tables = {
        for (final t in v3Tables)
          t: [
            for (final r in source.rawDatabase.select(
              'SELECT * FROM "$t" ORDER BY rowid',
            ))
              {for (final c in r.keys) c: r[c]},
          ],
      };
      final payload = utf8.encode(
        jsonEncode({
          'format': 'denezhno-backup',
          'payloadVersion': 1,
          'schemaVersion': 3,
          'createdAtUtc': 0,
          'counts': {for (final e in tables.entries) e.key: e.value.length},
          'tables': tables,
        }),
      );
      final file = encryptBackup(Uint8List.fromList(payload), _password);
      await b.store.restoreBackup(file, _password);

      // The same fixture migrated on the phone.
      final migrated = AppDatabase(source.newConnection());
      await migrated.customSelect('SELECT 1').get();
      final expected = jsonDecode(
        utf8.decode(await BackupRepo(migrated).exportPayload(DateTime(2026))),
      ) as Map<String, Object?>;
      await migrated.close();
      final restored = await b.dump();
      final want = expected['tables']! as Map<String, Object?>;
      for (final t in v3Tables.where((t) => t != 'accounts')) {
        expect(restored[t], want[t], reason: t);
      }
      // Same accounts; categories created once, as by the migration.
      List<Object?> people(Object? rows) => [
        for (final r in rows! as List)
          if (!{'income', 'expense'}.contains((r as Map)['kind'])) r,
      ];
      expect(people(restored['accounts']), people(want['accounts']));
      List<Object?> names(Object? rows) => [
        for (final r in rows! as List) [(r as Map)['system_key'], r['name']],
      ];
      expect(names(restored['categories']), names(want['categories']));
      expect((restored['categories']! as List).length, 14);
      expect(restored['entry_details'], isEmpty); // nothing was posted

      // The person sees the same accounts, balances and forecast.
      final accounts = await b.store.accounts();
      expect(
        [for (final x in accounts) (x.name, x.amount)],
        [
          ('Сбер', Money(2873152)),
          ('Кредитка Альфа', Money(1629654)),
          ('Подушка', Money(15000000)),
        ],
      );
      expect(await b.store.open(), AppTheme.dark);
      expect(await b.store.canRestore(), false);
    },
  );

  test('no plaintext on disk; the file does not reveal data', () async {
    await fillA();
    final file = await a.store.exportBackup(_password);
    final needle = utf8.encode(_marker);
    bool contains(List<int> hay) {
      outer:
      for (var i = 0; i + needle.length <= hay.length; i++) {
        for (var j = 0; j < needle.length; j++) {
          if (hay[i + j] != needle[j]) continue outer;
        }
        return true;
      }
      return false;
    }

    expect(contains(file), false);
    expect(contains(utf8.encode(_password)), false);
    for (final e in root.listSync(recursive: true).whereType<File>()) {
      expect(contains(e.readAsBytesSync()), false, reason: e.path);
      expect(contains(utf8.encode(_password)), false);
    }
    expect(
      root
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.json')),
      isEmpty,
    );
  });

  test('container layout is fixed and big-endian (portable)', () async {
    await fillA();
    final file = await a.store.exportBackup(_password);
    expect(ascii.decode(file.sublist(0, 8)), 'DENEZHNO');
    final v = ByteData.sublistView(file);
    expect(v.getUint16(8), backupFormatVersion);
    expect(v.getUint8(10), kdfArgon2id);
    expect(v.getUint32(11), defaultOpsLimit);
    expect(v.getUint32(15), defaultMemLimit);
    // Two exports never share salt/nonce.
    final again = await a.store.exportBackup(_password);
    expect(again.sublist(19, 59), isNot(file.sublist(19, 59)));
  });

  group('failures leave the target database intact', () {
    late Uint8List good;
    setUp(() async {
      await fillA();
      good = await a.store.exportBackup(_password);
    });

    Future<void> expectIntact() async {
      expect(await b.store.canRestore(), true);
      expect(await b.store.accounts(), isEmpty);
      expect(await b.store.reserve(), Money(1000000));
      expect((await b.store.payments()).flows, isEmpty);
    }

    test('wrong password', () async {
      await expectLater(
        b.store.restoreBackup(good, 'wrong password!'),
        throwsA(isA<WrongPasswordOrDamaged>()),
      );
      await expectIntact();
    });

    test('damaged ciphertext, damaged header, truncated file', () async {
      for (final corrupt in [
        (Uint8List.fromList(good)..[good.length - 5] ^= 1),
        (Uint8List.fromList(good)..[12] ^= 1), // opsLimit is authenticated
        (Uint8List.fromList(good)..[40] ^= 1), // nonce
        Uint8List.sublistView(good, 0, good.length - 1),
        Uint8List.sublistView(good, 0, 60),
      ]) {
        await expectLater(
          b.store.restoreBackup(corrupt, _password),
          throwsA(isA<WrongPasswordOrDamaged>()),
        );
      }
      await expectIntact();
    });

    test('not a backup at all', () async {
      await expectLater(
        b.store.restoreBackup(
          Uint8List.fromList(utf8.encode('hello')),
          _password,
        ),
        throwsA(isA<NotABackup>()),
      );
      await expectIntact();
    });

    test(
      'incompatible container version is refused before decryption',
      () async {
        final future = encryptBackup(
          Uint8List.fromList(utf8.encode('{}')),
          _password,
          format: 2,
          opsLimit: 1,
          memLimit: 8 * 1024 * 1024,
        );
        await expectLater(
          b.store.restoreBackup(future, _password),
          throwsA(isA<UnsupportedBackupVersion>()),
        );
        await expectIntact();
      },
    );

    Uint8List repack(void Function(Map<String, Object?> payload) edit) {
      final payload = jsonDecode(
        utf8.decode(decryptBackup(good, _password)),
      ) as Map<String, Object?>;
      edit(payload);
      return encryptBackup(
        Uint8List.fromList(utf8.encode(jsonEncode(payload))),
        _password,
        opsLimit: 1,
        memLimit: 8 * 1024 * 1024,
      );
    }

    test('incompatible schema version inside the payload', () async {
      await expectLater(
        b.store.restoreBackup(
          repack((p) => p['schemaVersion'] = 99),
          _password,
        ),
        throwsA(isA<UnsupportedBackupVersion>()),
      );
      await expectIntact();
    });

    test('missing table, wrong counts, or missing postings', () async {
      Map<String, Object?> tables(Map<String, Object?> p) =>
          p['tables']! as Map<String, Object?>;
      Map<String, Object?> counts(Map<String, Object?> p) =>
          p['counts']! as Map<String, Object?>;
      final broken = [
        repack((p) => tables(p).remove('card_figures')),
        repack((p) => counts(p)['accounts'] = 99),
        // Postings dropped consistently: entries become orphans → refused.
        repack((p) {
          tables(p)['postings'] = <Object?>[];
          counts(p)['postings'] = 0;
        }),
        // Half of the postings of one entry: unbalanced → refused.
        repack((p) {
          final postings = (tables(p)['postings']! as List).toList();
          postings.removeAt(0);
          tables(p)['postings'] = postings;
          counts(p)['postings'] = postings.length;
        }),
      ];
      for (final file in broken) {
        await expectLater(
          b.store.restoreBackup(file, _password),
          throwsA(isA<IncompleteBackup>()),
        );
        await expectIntact();
      }
    });

    test('restore only into an empty app (MVP)', () async {
      await b.store.createAccount(
        NewAccount(kind: AccountKind.cash, name: 'Нал', amount: Money(100)),
      );
      await expectLater(
        b.store.restoreBackup(good, _password),
        throwsA(isA<RestoreTargetNotEmpty>()),
      );
      expect((await b.store.accounts()).single.name, 'Нал');
    });
  });

  test('weak password is refused', () async {
    await expectLater(
      a.store.exportBackup('short'),
      throwsA(isA<WeakPassword>()),
    );
  });
}
