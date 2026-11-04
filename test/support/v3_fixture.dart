import 'package:denezhno/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

/// A realistic database exactly as R2 (schema v3) leaves it on the phone:
/// reference data, household, accounts of every role, opening balances, a
/// balance update with an unexplained difference, plans (salary twice a
/// month, payments, a card payment linked to the card), marks, bank figures
/// and the theme. Written with raw SQL against the v3 tables, so it does not
/// depend on the current code.
abstract final class V3 {
  static const household = '11111111-1111-4111-8111-111111111111';
  static const member = '22222222-2222-4222-8222-222222222222';
  static const equity = '30000000-0000-4000-8000-000000000001';
  static const suspense = '30000000-0000-4000-8000-000000000002';
  static const sber = '30000000-0000-4000-8000-000000000003';
  static const alfaCard = '30000000-0000-4000-8000-000000000004';
  static const pillow = '30000000-0000-4000-8000-000000000005';
  static const salary = '40000000-0000-4000-8000-000000000001';
  static const advance = '40000000-0000-4000-8000-000000000002';
  static const internet = '40000000-0000-4000-8000-000000000003';
  static const cardPayment = '40000000-0000-4000-8000-000000000004';
  static const bonus = '40000000-0000-4000-8000-000000000005';

  /// Stored balances (assets +, liabilities −) after the fixture.
  static const balances = {
    sber: 2873152,
    alfaCard: -1629654,
    pillow: 15000000,
    suspense: 50000,
    equity: -16293498,
  };

  // 2026-10-01 and 2026-11-03 (UTC ms).
  static const t1 = 1790812800000;
  static const t2 = 1793664000000;

  static void create(Database db, {bool withHistory = true}) {
    db.execute("INSERT INTO currencies VALUES ('RUB', 2)");
    for (final k in accountKindSeed.entries) {
      db.execute('INSERT INTO account_kinds VALUES (?, ?)', [k.key, k.value]);
    }
    for (final k in entryKindSeed) {
      db.execute('INSERT INTO entry_kinds VALUES (?)', [k]);
    }
    for (final k in dataSourceSeed) {
      db.execute('INSERT INTO data_sources VALUES (?)', [k]);
    }
    for (final e in flowKindSeed.entries) {
      db.execute('INSERT INTO flow_kinds VALUES (?, ?)', [e.key, e.value]);
    }
    db.execute("INSERT INTO households VALUES (?, 'RUB', 1000000, ?)", [
      household,
      t1,
    ]);
    db.execute('INSERT INTO members VALUES (?, ?, ?)', [member, household, t1]);
    void account(
      String id,
      String kind,
      String name,
      int order, {
      int protected = 0,
      int? limit,
    }) {
      db.execute(
        'INSERT INTO accounts (id, household_id, kind, name, currency, '
        'owner_member_id, visibility, is_protected, credit_limit_minor, '
        "sort_order, created_at_utc, archived_at_utc) VALUES (?, ?, ?, ?, 'RUB', "
        "NULL, 'shared', ?, ?, ?, ?, NULL)",
        [id, household, kind, name, protected, limit, order, t1],
      );
    }

    account(equity, 'opening_equity', 'Начальные остатки', -2);
    account(suspense, 'suspense', 'Невыясненное', -1);
    account(sber, 'debit', 'Сбер', 1);
    account(alfaCard, 'credit_card', 'Кредитка Альфа', 2, limit: 2000000);
    account(pillow, 'savings', 'Подушка', 3, protected: 1);

    var n = 0;
    String entry(String kind, int at, List<(String, int)> lines) {
      n++;
      final id = '50000000-0000-4000-8000-${n.toString().padLeft(12, '0')}';
      final command =
          '60000000-0000-4000-8000-${n.toString().padLeft(12, '0')}';
      db.execute(
        "INSERT INTO journal_entries VALUES (?, ?, ?, ?, 'user', NULL, ?, ?)",
        [id, household, command, kind, at, at],
      );
      for (var i = 0; i < lines.length; i++) {
        db.execute("INSERT INTO postings VALUES (?, ?, ?, ?, 'RUB')", [
          id,
          i,
          lines[i].$1,
          lines[i].$2,
        ]);
      }
      return id;
    }

    var a = 0;
    void assertion(String accountId, int amount, int at, String? entryId) {
      a++;
      db.execute(
        "INSERT INTO balance_assertions VALUES (?, ?, ?, 'RUB', 'user', ?, ?)",
        [
          '70000000-0000-4000-8000-${a.toString().padLeft(12, '0')}',
          accountId,
          amount,
          entryId,
          at,
        ],
      );
    }

    final e1 = entry('opening_balance', t1, [
      (sber, 2923152),
      (equity, -2923152),
    ]);
    assertion(sber, 2923152, t1, e1);
    final e2 = entry('opening_balance', t1, [
      (alfaCard, -1629654),
      (equity, 1629654),
    ]);
    assertion(alfaCard, -1629654, t1, e2);
    final e3 = entry('opening_balance', t1, [
      (pillow, 15000000),
      (equity, -15000000),
    ]);
    assertion(pillow, 15000000, t1, e3);
    // «Обновить остатки» on 3 Nov: Сбер −500 ₽ unexplained; card unchanged.
    final e4 = entry('balance_adjustment', t2, [
      (sber, -50000),
      (suspense, 50000),
    ]);
    assertion(sber, 2873152, t2, e4);
    assertion(alfaCard, -1629654, t2, null);

    void plan(
      String id,
      String kind,
      String name,
      int amount,
      String cadence, {
      int? day,
      int? month,
      String? once,
      String? account,
    }) {
      db.execute(
        'INSERT INTO planned_flows (id, household_id, kind, name, amount_minor, '
        'currency, account_id, cadence, day, month, once_on, starts_on, '
        "created_at_utc, archived_at_utc) VALUES (?, ?, ?, ?, ?, 'RUB', ?, ?, "
        "?, ?, ?, '2026-10-01', ?, NULL)",
        [
          id,
          household,
          kind,
          name,
          amount,
          account,
          cadence,
          day,
          month,
          once,
          t1,
        ],
      );
    }

    plan(salary, 'salary', 'Зарплата', 6000000, 'monthly', day: 5);
    plan(advance, 'salary', 'Аванс', 4000000, 'monthly', day: 20);
    plan(internet, 'communication', 'Интернет', 70000, 'monthly', day: 5);
    plan(
      cardPayment,
      'other_payment',
      'Кредитка',
      500000,
      'monthly',
      day: 12,
      account: alfaCard,
    );
    plan(bonus, 'other_income', 'Премия', 2000000, 'once', once: '2026-12-25');
    db.execute("INSERT INTO flow_marks VALUES (?, '2026-10-05', 'done', ?)", [
      salary,
      t1,
    ]);
    db.execute("INSERT INTO flow_marks VALUES (?, '2026-10-20', 'done', ?)", [
      advance,
      t2,
    ]);
    db.execute("INSERT INTO flow_marks VALUES (?, '2026-11-05', 'done', ?)", [
      internet,
      t2,
    ]);
    db.execute(
      'INSERT INTO card_figures VALUES (?, ?, 1629654, ?, 81483, ?, '
      "'user', ?, NULL)",
      [
        '80000000-0000-4000-8000-000000000001',
        alfaCard,
        '2026-11-12',
        '2026-11-12',
        t2,
      ],
    );
    db.execute("INSERT INTO app_settings VALUES ('theme', '\"dark\"', 1)");
    if (withHistory) {
      for (final (v, c) in [
        (1, AppDatabase.schemaV1Checksum),
        (2, AppDatabase.schemaV2Checksum),
        (3, AppDatabase.schemaV3Checksum),
      ]) {
        db.execute('INSERT INTO schema_migrations VALUES (?, ?, ?, ?)', [
          v,
          c,
          t1,
          '0.$v.0+$v',
        ]);
      }
    }
  }

  /// Tables of v3 with user data; their rows must survive every migration.
  static const userTables = [
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
}
