// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class AppSettings extends Table with TableInfo<AppSettings, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AppSettings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK ("key" IN (\'theme\'))',
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (json_valid(value_json) AND json_type(value_json) = \'text\' AND json_extract(value_json, \'\$\') IN (\'system\', \'light\', \'dark\'))',
  );
  static const VerificationMeta _valueVersionMeta = const VerificationMeta(
    'valueVersion',
  );
  late final GeneratedColumn<int> valueVersion = GeneratedColumn<int>(
    'value_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(value_version) = \'integer\' AND value_version = 1)',
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, valueVersion];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('value_version')) {
      context.handle(
        _valueVersionMeta,
        valueVersion.isAcceptableOrUnknown(
          data['value_version']!,
          _valueVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_valueVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      valueVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_version'],
      )!,
    );
  }

  @override
  AppSettings createAlias(String alias) {
    return AppSettings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String valueJson;
  final int valueVersion;
  const AppSetting({
    required this.key,
    required this.valueJson,
    required this.valueVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['value_version'] = Variable<int>(valueVersion);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      valueVersion: Value(valueVersion),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['value_json']),
      valueVersion: serializer.fromJson<int>(json['value_version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value_json': serializer.toJson<String>(valueJson),
      'value_version': serializer.toJson<int>(valueVersion),
    };
  }

  AppSetting copyWith({String? key, String? valueJson, int? valueVersion}) =>
      AppSetting(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        valueVersion: valueVersion ?? this.valueVersion,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      valueVersion: data.valueVersion.present
          ? data.valueVersion.value
          : this.valueVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('valueVersion: $valueVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, valueVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.valueVersion == this.valueVersion);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<int> valueVersion;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.valueVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String valueJson,
    required int valueVersion,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson),
       valueVersion = Value(valueVersion);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<int>? valueVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (valueVersion != null) 'value_version': valueVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<int>? valueVersion,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      valueVersion: valueVersion ?? this.valueVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (valueVersion.present) {
      map['value_version'] = Variable<int>(valueVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('valueVersion: $valueVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class SchemaMigrations extends Table
    with TableInfo<SchemaMigrations, SchemaMigration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SchemaMigrations(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (version > 0)',
  );
  static const VerificationMeta _schemaChecksumMeta = const VerificationMeta(
    'schemaChecksum',
  );
  late final GeneratedColumn<String> schemaChecksum = GeneratedColumn<String>(
    'schema_checksum',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(schema_checksum) = 64)',
  );
  static const VerificationMeta _appliedAtUtcMeta = const VerificationMeta(
    'appliedAtUtc',
  );
  late final GeneratedColumn<int> appliedAtUtc = GeneratedColumn<int>(
    'applied_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(applied_at_utc) = \'integer\')',
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    version,
    schemaChecksum,
    appliedAtUtc,
    appVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_migrations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaMigration> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    }
    if (data.containsKey('schema_checksum')) {
      context.handle(
        _schemaChecksumMeta,
        schemaChecksum.isAcceptableOrUnknown(
          data['schema_checksum']!,
          _schemaChecksumMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_schemaChecksumMeta);
    }
    if (data.containsKey('applied_at_utc')) {
      context.handle(
        _appliedAtUtcMeta,
        appliedAtUtc.isAcceptableOrUnknown(
          data['applied_at_utc']!,
          _appliedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_appliedAtUtcMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {version};
  @override
  SchemaMigration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaMigration(
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      schemaChecksum: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}schema_checksum'],
      )!,
      appliedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}applied_at_utc'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
    );
  }

  @override
  SchemaMigrations createAlias(String alias) {
    return SchemaMigrations(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class SchemaMigration extends DataClass implements Insertable<SchemaMigration> {
  final int version;
  final String schemaChecksum;
  final int appliedAtUtc;
  final String appVersion;
  const SchemaMigration({
    required this.version,
    required this.schemaChecksum,
    required this.appliedAtUtc,
    required this.appVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['version'] = Variable<int>(version);
    map['schema_checksum'] = Variable<String>(schemaChecksum);
    map['applied_at_utc'] = Variable<int>(appliedAtUtc);
    map['app_version'] = Variable<String>(appVersion);
    return map;
  }

  SchemaMigrationsCompanion toCompanion(bool nullToAbsent) {
    return SchemaMigrationsCompanion(
      version: Value(version),
      schemaChecksum: Value(schemaChecksum),
      appliedAtUtc: Value(appliedAtUtc),
      appVersion: Value(appVersion),
    );
  }

  factory SchemaMigration.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaMigration(
      version: serializer.fromJson<int>(json['version']),
      schemaChecksum: serializer.fromJson<String>(json['schema_checksum']),
      appliedAtUtc: serializer.fromJson<int>(json['applied_at_utc']),
      appVersion: serializer.fromJson<String>(json['app_version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'version': serializer.toJson<int>(version),
      'schema_checksum': serializer.toJson<String>(schemaChecksum),
      'applied_at_utc': serializer.toJson<int>(appliedAtUtc),
      'app_version': serializer.toJson<String>(appVersion),
    };
  }

  SchemaMigration copyWith({
    int? version,
    String? schemaChecksum,
    int? appliedAtUtc,
    String? appVersion,
  }) => SchemaMigration(
    version: version ?? this.version,
    schemaChecksum: schemaChecksum ?? this.schemaChecksum,
    appliedAtUtc: appliedAtUtc ?? this.appliedAtUtc,
    appVersion: appVersion ?? this.appVersion,
  );
  SchemaMigration copyWithCompanion(SchemaMigrationsCompanion data) {
    return SchemaMigration(
      version: data.version.present ? data.version.value : this.version,
      schemaChecksum: data.schemaChecksum.present
          ? data.schemaChecksum.value
          : this.schemaChecksum,
      appliedAtUtc: data.appliedAtUtc.present
          ? data.appliedAtUtc.value
          : this.appliedAtUtc,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMigration(')
          ..write('version: $version, ')
          ..write('schemaChecksum: $schemaChecksum, ')
          ..write('appliedAtUtc: $appliedAtUtc, ')
          ..write('appVersion: $appVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(version, schemaChecksum, appliedAtUtc, appVersion);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SchemaMigration &&
          other.version == this.version &&
          other.schemaChecksum == this.schemaChecksum &&
          other.appliedAtUtc == this.appliedAtUtc &&
          other.appVersion == this.appVersion);
}

class SchemaMigrationsCompanion extends UpdateCompanion<SchemaMigration> {
  final Value<int> version;
  final Value<String> schemaChecksum;
  final Value<int> appliedAtUtc;
  final Value<String> appVersion;
  const SchemaMigrationsCompanion({
    this.version = const Value.absent(),
    this.schemaChecksum = const Value.absent(),
    this.appliedAtUtc = const Value.absent(),
    this.appVersion = const Value.absent(),
  });
  SchemaMigrationsCompanion.insert({
    this.version = const Value.absent(),
    required String schemaChecksum,
    required int appliedAtUtc,
    required String appVersion,
  }) : schemaChecksum = Value(schemaChecksum),
       appliedAtUtc = Value(appliedAtUtc),
       appVersion = Value(appVersion);
  static Insertable<SchemaMigration> custom({
    Expression<int>? version,
    Expression<String>? schemaChecksum,
    Expression<int>? appliedAtUtc,
    Expression<String>? appVersion,
  }) {
    return RawValuesInsertable({
      if (version != null) 'version': version,
      if (schemaChecksum != null) 'schema_checksum': schemaChecksum,
      if (appliedAtUtc != null) 'applied_at_utc': appliedAtUtc,
      if (appVersion != null) 'app_version': appVersion,
    });
  }

  SchemaMigrationsCompanion copyWith({
    Value<int>? version,
    Value<String>? schemaChecksum,
    Value<int>? appliedAtUtc,
    Value<String>? appVersion,
  }) {
    return SchemaMigrationsCompanion(
      version: version ?? this.version,
      schemaChecksum: schemaChecksum ?? this.schemaChecksum,
      appliedAtUtc: appliedAtUtc ?? this.appliedAtUtc,
      appVersion: appVersion ?? this.appVersion,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (schemaChecksum.present) {
      map['schema_checksum'] = Variable<String>(schemaChecksum.value);
    }
    if (appliedAtUtc.present) {
      map['applied_at_utc'] = Variable<int>(appliedAtUtc.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaMigrationsCompanion(')
          ..write('version: $version, ')
          ..write('schemaChecksum: $schemaChecksum, ')
          ..write('appliedAtUtc: $appliedAtUtc, ')
          ..write('appVersion: $appVersion')
          ..write(')'))
        .toString();
  }
}

class Currencies extends Table with TableInfo<Currencies, CurrencyRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Currencies(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL PRIMARY KEY CHECK (length(code) = 3 AND code = upper(code))',
  );
  static const VerificationMeta _fractionDigitsMeta = const VerificationMeta(
    'fractionDigits',
  );
  late final GeneratedColumn<int> fractionDigits = GeneratedColumn<int>(
    'fraction_digits',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(fraction_digits) = \'integer\' AND fraction_digits BETWEEN 0 AND 4)',
  );
  @override
  List<GeneratedColumn> get $columns => [code, fractionDigits];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'currencies';
  @override
  VerificationContext validateIntegrity(
    Insertable<CurrencyRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('fraction_digits')) {
      context.handle(
        _fractionDigitsMeta,
        fractionDigits.isAcceptableOrUnknown(
          data['fraction_digits']!,
          _fractionDigitsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fractionDigitsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  CurrencyRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CurrencyRow(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      fractionDigits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fraction_digits'],
      )!,
    );
  }

  @override
  Currencies createAlias(String alias) {
    return Currencies(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CurrencyRow extends DataClass implements Insertable<CurrencyRow> {
  final String code;
  final int fractionDigits;
  const CurrencyRow({required this.code, required this.fractionDigits});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['fraction_digits'] = Variable<int>(fractionDigits);
    return map;
  }

  CurrenciesCompanion toCompanion(bool nullToAbsent) {
    return CurrenciesCompanion(
      code: Value(code),
      fractionDigits: Value(fractionDigits),
    );
  }

  factory CurrencyRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CurrencyRow(
      code: serializer.fromJson<String>(json['code']),
      fractionDigits: serializer.fromJson<int>(json['fraction_digits']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'fraction_digits': serializer.toJson<int>(fractionDigits),
    };
  }

  CurrencyRow copyWith({String? code, int? fractionDigits}) => CurrencyRow(
    code: code ?? this.code,
    fractionDigits: fractionDigits ?? this.fractionDigits,
  );
  CurrencyRow copyWithCompanion(CurrenciesCompanion data) {
    return CurrencyRow(
      code: data.code.present ? data.code.value : this.code,
      fractionDigits: data.fractionDigits.present
          ? data.fractionDigits.value
          : this.fractionDigits,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CurrencyRow(')
          ..write('code: $code, ')
          ..write('fractionDigits: $fractionDigits')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, fractionDigits);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CurrencyRow &&
          other.code == this.code &&
          other.fractionDigits == this.fractionDigits);
}

class CurrenciesCompanion extends UpdateCompanion<CurrencyRow> {
  final Value<String> code;
  final Value<int> fractionDigits;
  final Value<int> rowid;
  const CurrenciesCompanion({
    this.code = const Value.absent(),
    this.fractionDigits = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CurrenciesCompanion.insert({
    required String code,
    required int fractionDigits,
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       fractionDigits = Value(fractionDigits);
  static Insertable<CurrencyRow> custom({
    Expression<String>? code,
    Expression<int>? fractionDigits,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (fractionDigits != null) 'fraction_digits': fractionDigits,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CurrenciesCompanion copyWith({
    Value<String>? code,
    Value<int>? fractionDigits,
    Value<int>? rowid,
  }) {
    return CurrenciesCompanion(
      code: code ?? this.code,
      fractionDigits: fractionDigits ?? this.fractionDigits,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (fractionDigits.present) {
      map['fraction_digits'] = Variable<int>(fractionDigits.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CurrenciesCompanion(')
          ..write('code: $code, ')
          ..write('fractionDigits: $fractionDigits, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AccountKinds extends Table with TableInfo<AccountKinds, AccountKindRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AccountKinds(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _natureMeta = const VerificationMeta('nature');
  late final GeneratedColumn<String> nature = GeneratedColumn<String>(
    'nature',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (nature IN (\'asset\', \'liability\', \'equity\', \'system\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [kind, nature];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'account_kinds';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountKindRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('nature')) {
      context.handle(
        _natureMeta,
        nature.isAcceptableOrUnknown(data['nature']!, _natureMeta),
      );
    } else if (isInserting) {
      context.missing(_natureMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  AccountKindRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountKindRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      nature: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nature'],
      )!,
    );
  }

  @override
  AccountKinds createAlias(String alias) {
    return AccountKinds(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AccountKindRow extends DataClass implements Insertable<AccountKindRow> {
  final String kind;
  final String nature;
  const AccountKindRow({required this.kind, required this.nature});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['nature'] = Variable<String>(nature);
    return map;
  }

  AccountKindsCompanion toCompanion(bool nullToAbsent) {
    return AccountKindsCompanion(kind: Value(kind), nature: Value(nature));
  }

  factory AccountKindRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountKindRow(
      kind: serializer.fromJson<String>(json['kind']),
      nature: serializer.fromJson<String>(json['nature']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'nature': serializer.toJson<String>(nature),
    };
  }

  AccountKindRow copyWith({String? kind, String? nature}) =>
      AccountKindRow(kind: kind ?? this.kind, nature: nature ?? this.nature);
  AccountKindRow copyWithCompanion(AccountKindsCompanion data) {
    return AccountKindRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      nature: data.nature.present ? data.nature.value : this.nature,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountKindRow(')
          ..write('kind: $kind, ')
          ..write('nature: $nature')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, nature);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountKindRow &&
          other.kind == this.kind &&
          other.nature == this.nature);
}

class AccountKindsCompanion extends UpdateCompanion<AccountKindRow> {
  final Value<String> kind;
  final Value<String> nature;
  final Value<int> rowid;
  const AccountKindsCompanion({
    this.kind = const Value.absent(),
    this.nature = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountKindsCompanion.insert({
    required String kind,
    required String nature,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       nature = Value(nature);
  static Insertable<AccountKindRow> custom({
    Expression<String>? kind,
    Expression<String>? nature,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (nature != null) 'nature': nature,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountKindsCompanion copyWith({
    Value<String>? kind,
    Value<String>? nature,
    Value<int>? rowid,
  }) {
    return AccountKindsCompanion(
      kind: kind ?? this.kind,
      nature: nature ?? this.nature,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (nature.present) {
      map['nature'] = Variable<String>(nature.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountKindsCompanion(')
          ..write('kind: $kind, ')
          ..write('nature: $nature, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class EntryKinds extends Table with TableInfo<EntryKinds, EntryKindRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EntryKinds(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  @override
  List<GeneratedColumn> get $columns => [kind];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_kinds';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryKindRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  EntryKindRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryKindRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
    );
  }

  @override
  EntryKinds createAlias(String alias) {
    return EntryKinds(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class EntryKindRow extends DataClass implements Insertable<EntryKindRow> {
  final String kind;
  const EntryKindRow({required this.kind});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    return map;
  }

  EntryKindsCompanion toCompanion(bool nullToAbsent) {
    return EntryKindsCompanion(kind: Value(kind));
  }

  factory EntryKindRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryKindRow(kind: serializer.fromJson<String>(json['kind']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'kind': serializer.toJson<String>(kind)};
  }

  EntryKindRow copyWith({String? kind}) =>
      EntryKindRow(kind: kind ?? this.kind);
  EntryKindRow copyWithCompanion(EntryKindsCompanion data) {
    return EntryKindRow(kind: data.kind.present ? data.kind.value : this.kind);
  }

  @override
  String toString() {
    return (StringBuffer('EntryKindRow(')
          ..write('kind: $kind')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => kind.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryKindRow && other.kind == this.kind);
}

class EntryKindsCompanion extends UpdateCompanion<EntryKindRow> {
  final Value<String> kind;
  final Value<int> rowid;
  const EntryKindsCompanion({
    this.kind = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryKindsCompanion.insert({
    required String kind,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind);
  static Insertable<EntryKindRow> custom({
    Expression<String>? kind,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryKindsCompanion copyWith({Value<String>? kind, Value<int>? rowid}) {
    return EntryKindsCompanion(
      kind: kind ?? this.kind,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryKindsCompanion(')
          ..write('kind: $kind, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DataSources extends Table with TableInfo<DataSources, DataSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DataSources(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  @override
  List<GeneratedColumn> get $columns => [source];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'data_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<DataSourceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {source};
  @override
  DataSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DataSourceRow(
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
    );
  }

  @override
  DataSources createAlias(String alias) {
    return DataSources(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DataSourceRow extends DataClass implements Insertable<DataSourceRow> {
  final String source;
  const DataSourceRow({required this.source});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['source'] = Variable<String>(source);
    return map;
  }

  DataSourcesCompanion toCompanion(bool nullToAbsent) {
    return DataSourcesCompanion(source: Value(source));
  }

  factory DataSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DataSourceRow(source: serializer.fromJson<String>(json['source']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'source': serializer.toJson<String>(source)};
  }

  DataSourceRow copyWith({String? source}) =>
      DataSourceRow(source: source ?? this.source);
  DataSourceRow copyWithCompanion(DataSourcesCompanion data) {
    return DataSourceRow(
      source: data.source.present ? data.source.value : this.source,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DataSourceRow(')
          ..write('source: $source')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => source.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DataSourceRow && other.source == this.source);
}

class DataSourcesCompanion extends UpdateCompanion<DataSourceRow> {
  final Value<String> source;
  final Value<int> rowid;
  const DataSourcesCompanion({
    this.source = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DataSourcesCompanion.insert({
    required String source,
    this.rowid = const Value.absent(),
  }) : source = Value(source);
  static Insertable<DataSourceRow> custom({
    Expression<String>? source,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (source != null) 'source': source,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DataSourcesCompanion copyWith({Value<String>? source, Value<int>? rowid}) {
    return DataSourcesCompanion(
      source: source ?? this.source,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DataSourcesCompanion(')
          ..write('source: $source, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Households extends Table with TableInfo<Households, HouseholdRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Households(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES currencies(code)',
  );
  static const VerificationMeta _reserveMinorMeta = const VerificationMeta(
    'reserveMinor',
  );
  late final GeneratedColumn<int> reserveMinor = GeneratedColumn<int>(
    'reserve_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(reserve_minor) = \'integer\' AND reserve_minor >= 0)',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(created_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    baseCurrency,
    reserveMinor,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'households';
  @override
  VerificationContext validateIntegrity(
    Insertable<HouseholdRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('reserve_minor')) {
      context.handle(
        _reserveMinorMeta,
        reserveMinor.isAcceptableOrUnknown(
          data['reserve_minor']!,
          _reserveMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reserveMinorMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HouseholdRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HouseholdRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      reserveMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reserve_minor'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  Households createAlias(String alias) {
    return Households(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class HouseholdRow extends DataClass implements Insertable<HouseholdRow> {
  final String id;
  final String baseCurrency;
  final int reserveMinor;
  final int createdAtUtc;
  const HouseholdRow({
    required this.id,
    required this.baseCurrency,
    required this.reserveMinor,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['reserve_minor'] = Variable<int>(reserveMinor);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  HouseholdsCompanion toCompanion(bool nullToAbsent) {
    return HouseholdsCompanion(
      id: Value(id),
      baseCurrency: Value(baseCurrency),
      reserveMinor: Value(reserveMinor),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory HouseholdRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HouseholdRow(
      id: serializer.fromJson<String>(json['id']),
      baseCurrency: serializer.fromJson<String>(json['base_currency']),
      reserveMinor: serializer.fromJson<int>(json['reserve_minor']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'base_currency': serializer.toJson<String>(baseCurrency),
      'reserve_minor': serializer.toJson<int>(reserveMinor),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
    };
  }

  HouseholdRow copyWith({
    String? id,
    String? baseCurrency,
    int? reserveMinor,
    int? createdAtUtc,
  }) => HouseholdRow(
    id: id ?? this.id,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    reserveMinor: reserveMinor ?? this.reserveMinor,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  HouseholdRow copyWithCompanion(HouseholdsCompanion data) {
    return HouseholdRow(
      id: data.id.present ? data.id.value : this.id,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      reserveMinor: data.reserveMinor.present
          ? data.reserveMinor.value
          : this.reserveMinor,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdRow(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('reserveMinor: $reserveMinor, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, baseCurrency, reserveMinor, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HouseholdRow &&
          other.id == this.id &&
          other.baseCurrency == this.baseCurrency &&
          other.reserveMinor == this.reserveMinor &&
          other.createdAtUtc == this.createdAtUtc);
}

class HouseholdsCompanion extends UpdateCompanion<HouseholdRow> {
  final Value<String> id;
  final Value<String> baseCurrency;
  final Value<int> reserveMinor;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const HouseholdsCompanion({
    this.id = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.reserveMinor = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HouseholdsCompanion.insert({
    required String id,
    required String baseCurrency,
    required int reserveMinor,
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       baseCurrency = Value(baseCurrency),
       reserveMinor = Value(reserveMinor),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<HouseholdRow> custom({
    Expression<String>? id,
    Expression<String>? baseCurrency,
    Expression<int>? reserveMinor,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (reserveMinor != null) 'reserve_minor': reserveMinor,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HouseholdsCompanion copyWith({
    Value<String>? id,
    Value<String>? baseCurrency,
    Value<int>? reserveMinor,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return HouseholdsCompanion(
      id: id ?? this.id,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      reserveMinor: reserveMinor ?? this.reserveMinor,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (reserveMinor.present) {
      map['reserve_minor'] = Variable<int>(reserveMinor.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HouseholdsCompanion(')
          ..write('id: $id, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('reserveMinor: $reserveMinor, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Members extends Table with TableInfo<Members, MemberRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Members(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES households(id)',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(created_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [id, householdId, createdAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemberRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemberRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemberRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  Members createAlias(String alias) {
    return Members(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class MemberRow extends DataClass implements Insertable<MemberRow> {
  final String id;
  final String householdId;
  final int createdAtUtc;
  const MemberRow({
    required this.id,
    required this.householdId,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      householdId: Value(householdId),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory MemberRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemberRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household_id': serializer.toJson<String>(householdId),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
    };
  }

  MemberRow copyWith({String? id, String? householdId, int? createdAtUtc}) =>
      MemberRow(
        id: id ?? this.id,
        householdId: householdId ?? this.householdId,
        createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      );
  MemberRow copyWithCompanion(MembersCompanion data) {
    return MemberRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemberRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, householdId, createdAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemberRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.createdAtUtc == this.createdAtUtc);
}

class MembersCompanion extends UpdateCompanion<MemberRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required String householdId,
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<MemberRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Accounts extends Table with TableInfo<Accounts, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Accounts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES households(id)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES account_kinds(kind)',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) BETWEEN 1 AND 60)',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES currencies(code)',
  );
  static const VerificationMeta _ownerMemberIdMeta = const VerificationMeta(
    'ownerMemberId',
  );
  late final GeneratedColumn<String> ownerMemberId = GeneratedColumn<String>(
    'owner_member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES members(id)',
  );
  static const VerificationMeta _visibilityMeta = const VerificationMeta(
    'visibility',
  );
  late final GeneratedColumn<String> visibility = GeneratedColumn<String>(
    'visibility',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (visibility IN (\'shared\', \'private\'))',
  );
  static const VerificationMeta _isProtectedMeta = const VerificationMeta(
    'isProtected',
  );
  late final GeneratedColumn<int> isProtected = GeneratedColumn<int>(
    'is_protected',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (is_protected IN (0, 1))',
  );
  static const VerificationMeta _creditLimitMinorMeta = const VerificationMeta(
    'creditLimitMinor',
  );
  late final GeneratedColumn<int> creditLimitMinor = GeneratedColumn<int>(
    'credit_limit_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (credit_limit_minor IS NULL OR(typeof(credit_limit_minor) = \'integer\' AND credit_limit_minor >= 0))',
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(sort_order) = \'integer\')',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(created_at_utc) = \'integer\')',
  );
  static const VerificationMeta _archivedAtUtcMeta = const VerificationMeta(
    'archivedAtUtc',
  );
  late final GeneratedColumn<int> archivedAtUtc = GeneratedColumn<int>(
    'archived_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (archived_at_utc IS NULL OR typeof(archived_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    kind,
    name,
    currency,
    ownerMemberId,
    visibility,
    isProtected,
    creditLimitMinor,
    sortOrder,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('owner_member_id')) {
      context.handle(
        _ownerMemberIdMeta,
        ownerMemberId.isAcceptableOrUnknown(
          data['owner_member_id']!,
          _ownerMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('visibility')) {
      context.handle(
        _visibilityMeta,
        visibility.isAcceptableOrUnknown(data['visibility']!, _visibilityMeta),
      );
    } else if (isInserting) {
      context.missing(_visibilityMeta);
    }
    if (data.containsKey('is_protected')) {
      context.handle(
        _isProtectedMeta,
        isProtected.isAcceptableOrUnknown(
          data['is_protected']!,
          _isProtectedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isProtectedMeta);
    }
    if (data.containsKey('credit_limit_minor')) {
      context.handle(
        _creditLimitMinorMeta,
        creditLimitMinor.isAcceptableOrUnknown(
          data['credit_limit_minor']!,
          _creditLimitMinorMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('archived_at_utc')) {
      context.handle(
        _archivedAtUtcMeta,
        archivedAtUtc.isAcceptableOrUnknown(
          data['archived_at_utc']!,
          _archivedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      ownerMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_member_id'],
      ),
      visibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visibility'],
      )!,
      isProtected: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_protected'],
      )!,
      creditLimitMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit_minor'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at_utc'],
      ),
    );
  }

  @override
  Accounts createAlias(String alias) {
    return Accounts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String id;
  final String householdId;
  final String kind;
  final String name;
  final String currency;
  final String? ownerMemberId;
  final String visibility;
  final int isProtected;
  final int? creditLimitMinor;
  final int sortOrder;
  final int createdAtUtc;
  final int? archivedAtUtc;
  const AccountRow({
    required this.id,
    required this.householdId,
    required this.kind,
    required this.name,
    required this.currency,
    this.ownerMemberId,
    required this.visibility,
    required this.isProtected,
    this.creditLimitMinor,
    required this.sortOrder,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || ownerMemberId != null) {
      map['owner_member_id'] = Variable<String>(ownerMemberId);
    }
    map['visibility'] = Variable<String>(visibility);
    map['is_protected'] = Variable<int>(isProtected);
    if (!nullToAbsent || creditLimitMinor != null) {
      map['credit_limit_minor'] = Variable<int>(creditLimitMinor);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      kind: Value(kind),
      name: Value(name),
      currency: Value(currency),
      ownerMemberId: ownerMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerMemberId),
      visibility: Value(visibility),
      isProtected: Value(isProtected),
      creditLimitMinor: creditLimitMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimitMinor),
      sortOrder: Value(sortOrder),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      currency: serializer.fromJson<String>(json['currency']),
      ownerMemberId: serializer.fromJson<String?>(json['owner_member_id']),
      visibility: serializer.fromJson<String>(json['visibility']),
      isProtected: serializer.fromJson<int>(json['is_protected']),
      creditLimitMinor: serializer.fromJson<int?>(json['credit_limit_minor']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
      archivedAtUtc: serializer.fromJson<int?>(json['archived_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household_id': serializer.toJson<String>(householdId),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'currency': serializer.toJson<String>(currency),
      'owner_member_id': serializer.toJson<String?>(ownerMemberId),
      'visibility': serializer.toJson<String>(visibility),
      'is_protected': serializer.toJson<int>(isProtected),
      'credit_limit_minor': serializer.toJson<int?>(creditLimitMinor),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
      'archived_at_utc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  AccountRow copyWith({
    String? id,
    String? householdId,
    String? kind,
    String? name,
    String? currency,
    Value<String?> ownerMemberId = const Value.absent(),
    String? visibility,
    int? isProtected,
    Value<int?> creditLimitMinor = const Value.absent(),
    int? sortOrder,
    int? createdAtUtc,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => AccountRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    currency: currency ?? this.currency,
    ownerMemberId: ownerMemberId.present
        ? ownerMemberId.value
        : this.ownerMemberId,
    visibility: visibility ?? this.visibility,
    isProtected: isProtected ?? this.isProtected,
    creditLimitMinor: creditLimitMinor.present
        ? creditLimitMinor.value
        : this.creditLimitMinor,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      currency: data.currency.present ? data.currency.value : this.currency,
      ownerMemberId: data.ownerMemberId.present
          ? data.ownerMemberId.value
          : this.ownerMemberId,
      visibility: data.visibility.present
          ? data.visibility.value
          : this.visibility,
      isProtected: data.isProtected.present
          ? data.isProtected.value
          : this.isProtected,
      creditLimitMinor: data.creditLimitMinor.present
          ? data.creditLimitMinor.value
          : this.creditLimitMinor,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('ownerMemberId: $ownerMemberId, ')
          ..write('visibility: $visibility, ')
          ..write('isProtected: $isProtected, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    kind,
    name,
    currency,
    ownerMemberId,
    visibility,
    isProtected,
    creditLimitMinor,
    sortOrder,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.currency == this.currency &&
          other.ownerMemberId == this.ownerMemberId &&
          other.visibility == this.visibility &&
          other.isProtected == this.isProtected &&
          other.creditLimitMinor == this.creditLimitMinor &&
          other.sortOrder == this.sortOrder &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> kind;
  final Value<String> name;
  final Value<String> currency;
  final Value<String?> ownerMemberId;
  final Value<String> visibility;
  final Value<int> isProtected;
  final Value<int?> creditLimitMinor;
  final Value<int> sortOrder;
  final Value<int> createdAtUtc;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.currency = const Value.absent(),
    this.ownerMemberId = const Value.absent(),
    this.visibility = const Value.absent(),
    this.isProtected = const Value.absent(),
    this.creditLimitMinor = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String householdId,
    required String kind,
    required String name,
    required String currency,
    this.ownerMemberId = const Value.absent(),
    required String visibility,
    required int isProtected,
    this.creditLimitMinor = const Value.absent(),
    required int sortOrder,
    required int createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       kind = Value(kind),
       name = Value(name),
       currency = Value(currency),
       visibility = Value(visibility),
       isProtected = Value(isProtected),
       sortOrder = Value(sortOrder),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<AccountRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<String>? currency,
    Expression<String>? ownerMemberId,
    Expression<String>? visibility,
    Expression<int>? isProtected,
    Expression<int>? creditLimitMinor,
    Expression<int>? sortOrder,
    Expression<int>? createdAtUtc,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (currency != null) 'currency': currency,
      if (ownerMemberId != null) 'owner_member_id': ownerMemberId,
      if (visibility != null) 'visibility': visibility,
      if (isProtected != null) 'is_protected': isProtected,
      if (creditLimitMinor != null) 'credit_limit_minor': creditLimitMinor,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? kind,
    Value<String>? name,
    Value<String>? currency,
    Value<String?>? ownerMemberId,
    Value<String>? visibility,
    Value<int>? isProtected,
    Value<int?>? creditLimitMinor,
    Value<int>? sortOrder,
    Value<int>? createdAtUtc,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      currency: currency ?? this.currency,
      ownerMemberId: ownerMemberId ?? this.ownerMemberId,
      visibility: visibility ?? this.visibility,
      isProtected: isProtected ?? this.isProtected,
      creditLimitMinor: creditLimitMinor ?? this.creditLimitMinor,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (ownerMemberId.present) {
      map['owner_member_id'] = Variable<String>(ownerMemberId.value);
    }
    if (visibility.present) {
      map['visibility'] = Variable<String>(visibility.value);
    }
    if (isProtected.present) {
      map['is_protected'] = Variable<int>(isProtected.value);
    }
    if (creditLimitMinor.present) {
      map['credit_limit_minor'] = Variable<int>(creditLimitMinor.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (archivedAtUtc.present) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('currency: $currency, ')
          ..write('ownerMemberId: $ownerMemberId, ')
          ..write('visibility: $visibility, ')
          ..write('isProtected: $isProtected, ')
          ..write('creditLimitMinor: $creditLimitMinor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class JournalEntries extends Table
    with TableInfo<JournalEntries, JournalEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  JournalEntries(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES households(id)',
  );
  static const VerificationMeta _commandIdMeta = const VerificationMeta(
    'commandId',
  );
  late final GeneratedColumn<String> commandId = GeneratedColumn<String>(
    'command_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE CHECK (length(command_id) = 36)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES entry_kinds(kind)',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES data_sources(source)',
  );
  static const VerificationMeta _actorMemberIdMeta = const VerificationMeta(
    'actorMemberId',
  );
  late final GeneratedColumn<String> actorMemberId = GeneratedColumn<String>(
    'actor_member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES members(id)',
  );
  static const VerificationMeta _occurredAtUtcMeta = const VerificationMeta(
    'occurredAtUtc',
  );
  late final GeneratedColumn<int> occurredAtUtc = GeneratedColumn<int>(
    'occurred_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(occurred_at_utc) = \'integer\')',
  );
  static const VerificationMeta _recordedAtUtcMeta = const VerificationMeta(
    'recordedAtUtc',
  );
  late final GeneratedColumn<int> recordedAtUtc = GeneratedColumn<int>(
    'recorded_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(recorded_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    commandId,
    kind,
    source,
    actorMemberId,
    occurredAtUtc,
    recordedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('command_id')) {
      context.handle(
        _commandIdMeta,
        commandId.isAcceptableOrUnknown(data['command_id']!, _commandIdMeta),
      );
    } else if (isInserting) {
      context.missing(_commandIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('actor_member_id')) {
      context.handle(
        _actorMemberIdMeta,
        actorMemberId.isAcceptableOrUnknown(
          data['actor_member_id']!,
          _actorMemberIdMeta,
        ),
      );
    }
    if (data.containsKey('occurred_at_utc')) {
      context.handle(
        _occurredAtUtcMeta,
        occurredAtUtc.isAcceptableOrUnknown(
          data['occurred_at_utc']!,
          _occurredAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurredAtUtcMeta);
    }
    if (data.containsKey('recorded_at_utc')) {
      context.handle(
        _recordedAtUtcMeta,
        recordedAtUtc.isAcceptableOrUnknown(
          data['recorded_at_utc']!,
          _recordedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      commandId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}command_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      actorMemberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_member_id'],
      ),
      occurredAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurred_at_utc'],
      )!,
      recordedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at_utc'],
      )!,
    );
  }

  @override
  JournalEntries createAlias(String alias) {
    return JournalEntries(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class JournalEntryRow extends DataClass implements Insertable<JournalEntryRow> {
  final String id;
  final String householdId;
  final String commandId;
  final String kind;
  final String source;
  final String? actorMemberId;
  final int occurredAtUtc;
  final int recordedAtUtc;
  const JournalEntryRow({
    required this.id,
    required this.householdId,
    required this.commandId,
    required this.kind,
    required this.source,
    this.actorMemberId,
    required this.occurredAtUtc,
    required this.recordedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['command_id'] = Variable<String>(commandId);
    map['kind'] = Variable<String>(kind);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || actorMemberId != null) {
      map['actor_member_id'] = Variable<String>(actorMemberId);
    }
    map['occurred_at_utc'] = Variable<int>(occurredAtUtc);
    map['recorded_at_utc'] = Variable<int>(recordedAtUtc);
    return map;
  }

  JournalEntriesCompanion toCompanion(bool nullToAbsent) {
    return JournalEntriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      commandId: Value(commandId),
      kind: Value(kind),
      source: Value(source),
      actorMemberId: actorMemberId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorMemberId),
      occurredAtUtc: Value(occurredAtUtc),
      recordedAtUtc: Value(recordedAtUtc),
    );
  }

  factory JournalEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalEntryRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      commandId: serializer.fromJson<String>(json['command_id']),
      kind: serializer.fromJson<String>(json['kind']),
      source: serializer.fromJson<String>(json['source']),
      actorMemberId: serializer.fromJson<String?>(json['actor_member_id']),
      occurredAtUtc: serializer.fromJson<int>(json['occurred_at_utc']),
      recordedAtUtc: serializer.fromJson<int>(json['recorded_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household_id': serializer.toJson<String>(householdId),
      'command_id': serializer.toJson<String>(commandId),
      'kind': serializer.toJson<String>(kind),
      'source': serializer.toJson<String>(source),
      'actor_member_id': serializer.toJson<String?>(actorMemberId),
      'occurred_at_utc': serializer.toJson<int>(occurredAtUtc),
      'recorded_at_utc': serializer.toJson<int>(recordedAtUtc),
    };
  }

  JournalEntryRow copyWith({
    String? id,
    String? householdId,
    String? commandId,
    String? kind,
    String? source,
    Value<String?> actorMemberId = const Value.absent(),
    int? occurredAtUtc,
    int? recordedAtUtc,
  }) => JournalEntryRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    commandId: commandId ?? this.commandId,
    kind: kind ?? this.kind,
    source: source ?? this.source,
    actorMemberId: actorMemberId.present
        ? actorMemberId.value
        : this.actorMemberId,
    occurredAtUtc: occurredAtUtc ?? this.occurredAtUtc,
    recordedAtUtc: recordedAtUtc ?? this.recordedAtUtc,
  );
  JournalEntryRow copyWithCompanion(JournalEntriesCompanion data) {
    return JournalEntryRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      commandId: data.commandId.present ? data.commandId.value : this.commandId,
      kind: data.kind.present ? data.kind.value : this.kind,
      source: data.source.present ? data.source.value : this.source,
      actorMemberId: data.actorMemberId.present
          ? data.actorMemberId.value
          : this.actorMemberId,
      occurredAtUtc: data.occurredAtUtc.present
          ? data.occurredAtUtc.value
          : this.occurredAtUtc,
      recordedAtUtc: data.recordedAtUtc.present
          ? data.recordedAtUtc.value
          : this.recordedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntryRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('commandId: $commandId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('actorMemberId: $actorMemberId, ')
          ..write('occurredAtUtc: $occurredAtUtc, ')
          ..write('recordedAtUtc: $recordedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    commandId,
    kind,
    source,
    actorMemberId,
    occurredAtUtc,
    recordedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalEntryRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.commandId == this.commandId &&
          other.kind == this.kind &&
          other.source == this.source &&
          other.actorMemberId == this.actorMemberId &&
          other.occurredAtUtc == this.occurredAtUtc &&
          other.recordedAtUtc == this.recordedAtUtc);
}

class JournalEntriesCompanion extends UpdateCompanion<JournalEntryRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> commandId;
  final Value<String> kind;
  final Value<String> source;
  final Value<String?> actorMemberId;
  final Value<int> occurredAtUtc;
  final Value<int> recordedAtUtc;
  final Value<int> rowid;
  const JournalEntriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.commandId = const Value.absent(),
    this.kind = const Value.absent(),
    this.source = const Value.absent(),
    this.actorMemberId = const Value.absent(),
    this.occurredAtUtc = const Value.absent(),
    this.recordedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalEntriesCompanion.insert({
    required String id,
    required String householdId,
    required String commandId,
    required String kind,
    required String source,
    this.actorMemberId = const Value.absent(),
    required int occurredAtUtc,
    required int recordedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       commandId = Value(commandId),
       kind = Value(kind),
       source = Value(source),
       occurredAtUtc = Value(occurredAtUtc),
       recordedAtUtc = Value(recordedAtUtc);
  static Insertable<JournalEntryRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? commandId,
    Expression<String>? kind,
    Expression<String>? source,
    Expression<String>? actorMemberId,
    Expression<int>? occurredAtUtc,
    Expression<int>? recordedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (commandId != null) 'command_id': commandId,
      if (kind != null) 'kind': kind,
      if (source != null) 'source': source,
      if (actorMemberId != null) 'actor_member_id': actorMemberId,
      if (occurredAtUtc != null) 'occurred_at_utc': occurredAtUtc,
      if (recordedAtUtc != null) 'recorded_at_utc': recordedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? commandId,
    Value<String>? kind,
    Value<String>? source,
    Value<String?>? actorMemberId,
    Value<int>? occurredAtUtc,
    Value<int>? recordedAtUtc,
    Value<int>? rowid,
  }) {
    return JournalEntriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      commandId: commandId ?? this.commandId,
      kind: kind ?? this.kind,
      source: source ?? this.source,
      actorMemberId: actorMemberId ?? this.actorMemberId,
      occurredAtUtc: occurredAtUtc ?? this.occurredAtUtc,
      recordedAtUtc: recordedAtUtc ?? this.recordedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (commandId.present) {
      map['command_id'] = Variable<String>(commandId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (actorMemberId.present) {
      map['actor_member_id'] = Variable<String>(actorMemberId.value);
    }
    if (occurredAtUtc.present) {
      map['occurred_at_utc'] = Variable<int>(occurredAtUtc.value);
    }
    if (recordedAtUtc.present) {
      map['recorded_at_utc'] = Variable<int>(recordedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('commandId: $commandId, ')
          ..write('kind: $kind, ')
          ..write('source: $source, ')
          ..write('actorMemberId: $actorMemberId, ')
          ..write('occurredAtUtc: $occurredAtUtc, ')
          ..write('recordedAtUtc: $recordedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Postings extends Table with TableInfo<Postings, PostingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Postings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES journal_entries(id)',
  );
  static const VerificationMeta _lineNoMeta = const VerificationMeta('lineNo');
  late final GeneratedColumn<int> lineNo = GeneratedColumn<int>(
    'line_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(line_no) = \'integer\' AND line_no >= 0)',
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES accounts(id)',
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(amount_minor) = \'integer\' AND amount_minor <> 0)',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES currencies(code)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    lineNo,
    accountId,
    amountMinor,
    currency,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'postings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PostingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('line_no')) {
      context.handle(
        _lineNoMeta,
        lineNo.isAcceptableOrUnknown(data['line_no']!, _lineNoMeta),
      );
    } else if (isInserting) {
      context.missing(_lineNoMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId, lineNo};
  @override
  PostingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PostingRow(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      lineNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}line_no'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
    );
  }

  @override
  Postings createAlias(String alias) {
    return Postings(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(entry_id, line_no)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class PostingRow extends DataClass implements Insertable<PostingRow> {
  final String entryId;
  final int lineNo;
  final String accountId;
  final int amountMinor;
  final String currency;
  const PostingRow({
    required this.entryId,
    required this.lineNo,
    required this.accountId,
    required this.amountMinor,
    required this.currency,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<String>(entryId);
    map['line_no'] = Variable<int>(lineNo);
    map['account_id'] = Variable<String>(accountId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    return map;
  }

  PostingsCompanion toCompanion(bool nullToAbsent) {
    return PostingsCompanion(
      entryId: Value(entryId),
      lineNo: Value(lineNo),
      accountId: Value(accountId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
    );
  }

  factory PostingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PostingRow(
      entryId: serializer.fromJson<String>(json['entry_id']),
      lineNo: serializer.fromJson<int>(json['line_no']),
      accountId: serializer.fromJson<String>(json['account_id']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      currency: serializer.fromJson<String>(json['currency']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entry_id': serializer.toJson<String>(entryId),
      'line_no': serializer.toJson<int>(lineNo),
      'account_id': serializer.toJson<String>(accountId),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
    };
  }

  PostingRow copyWith({
    String? entryId,
    int? lineNo,
    String? accountId,
    int? amountMinor,
    String? currency,
  }) => PostingRow(
    entryId: entryId ?? this.entryId,
    lineNo: lineNo ?? this.lineNo,
    accountId: accountId ?? this.accountId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
  );
  PostingRow copyWithCompanion(PostingsCompanion data) {
    return PostingRow(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      lineNo: data.lineNo.present ? data.lineNo.value : this.lineNo,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PostingRow(')
          ..write('entryId: $entryId, ')
          ..write('lineNo: $lineNo, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(entryId, lineNo, accountId, amountMinor, currency);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PostingRow &&
          other.entryId == this.entryId &&
          other.lineNo == this.lineNo &&
          other.accountId == this.accountId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency);
}

class PostingsCompanion extends UpdateCompanion<PostingRow> {
  final Value<String> entryId;
  final Value<int> lineNo;
  final Value<String> accountId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<int> rowid;
  const PostingsCompanion({
    this.entryId = const Value.absent(),
    this.lineNo = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PostingsCompanion.insert({
    required String entryId,
    required int lineNo,
    required String accountId,
    required int amountMinor,
    required String currency,
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       lineNo = Value(lineNo),
       accountId = Value(accountId),
       amountMinor = Value(amountMinor),
       currency = Value(currency);
  static Insertable<PostingRow> custom({
    Expression<String>? entryId,
    Expression<int>? lineNo,
    Expression<String>? accountId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (lineNo != null) 'line_no': lineNo,
      if (accountId != null) 'account_id': accountId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PostingsCompanion copyWith({
    Value<String>? entryId,
    Value<int>? lineNo,
    Value<String>? accountId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<int>? rowid,
  }) {
    return PostingsCompanion(
      entryId: entryId ?? this.entryId,
      lineNo: lineNo ?? this.lineNo,
      accountId: accountId ?? this.accountId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (lineNo.present) {
      map['line_no'] = Variable<int>(lineNo.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PostingsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('lineNo: $lineNo, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class BalanceAssertions extends Table
    with TableInfo<BalanceAssertions, BalanceAssertionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  BalanceAssertions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES accounts(id)',
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(amount_minor) = \'integer\')',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES currencies(code)',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES data_sources(source)',
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES journal_entries(id)',
  );
  static const VerificationMeta _assertedAtUtcMeta = const VerificationMeta(
    'assertedAtUtc',
  );
  late final GeneratedColumn<int> assertedAtUtc = GeneratedColumn<int>(
    'asserted_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(asserted_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    amountMinor,
    currency,
    source,
    entryId,
    assertedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance_assertions';
  @override
  VerificationContext validateIntegrity(
    Insertable<BalanceAssertionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    }
    if (data.containsKey('asserted_at_utc')) {
      context.handle(
        _assertedAtUtcMeta,
        assertedAtUtc.isAcceptableOrUnknown(
          data['asserted_at_utc']!,
          _assertedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_assertedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceAssertionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceAssertionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      ),
      assertedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}asserted_at_utc'],
      )!,
    );
  }

  @override
  BalanceAssertions createAlias(String alias) {
    return BalanceAssertions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class BalanceAssertionRow extends DataClass
    implements Insertable<BalanceAssertionRow> {
  final String id;
  final String accountId;
  final int amountMinor;
  final String currency;
  final String source;
  final String? entryId;
  final int assertedAtUtc;
  const BalanceAssertionRow({
    required this.id,
    required this.accountId,
    required this.amountMinor,
    required this.currency,
    required this.source,
    this.entryId,
    required this.assertedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || entryId != null) {
      map['entry_id'] = Variable<String>(entryId);
    }
    map['asserted_at_utc'] = Variable<int>(assertedAtUtc);
    return map;
  }

  BalanceAssertionsCompanion toCompanion(bool nullToAbsent) {
    return BalanceAssertionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      source: Value(source),
      entryId: entryId == null && nullToAbsent
          ? const Value.absent()
          : Value(entryId),
      assertedAtUtc: Value(assertedAtUtc),
    );
  }

  factory BalanceAssertionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceAssertionRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['account_id']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      currency: serializer.fromJson<String>(json['currency']),
      source: serializer.fromJson<String>(json['source']),
      entryId: serializer.fromJson<String?>(json['entry_id']),
      assertedAtUtc: serializer.fromJson<int>(json['asserted_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'account_id': serializer.toJson<String>(accountId),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'source': serializer.toJson<String>(source),
      'entry_id': serializer.toJson<String?>(entryId),
      'asserted_at_utc': serializer.toJson<int>(assertedAtUtc),
    };
  }

  BalanceAssertionRow copyWith({
    String? id,
    String? accountId,
    int? amountMinor,
    String? currency,
    String? source,
    Value<String?> entryId = const Value.absent(),
    int? assertedAtUtc,
  }) => BalanceAssertionRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    source: source ?? this.source,
    entryId: entryId.present ? entryId.value : this.entryId,
    assertedAtUtc: assertedAtUtc ?? this.assertedAtUtc,
  );
  BalanceAssertionRow copyWithCompanion(BalanceAssertionsCompanion data) {
    return BalanceAssertionRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      source: data.source.present ? data.source.value : this.source,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      assertedAtUtc: data.assertedAtUtc.present
          ? data.assertedAtUtc.value
          : this.assertedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceAssertionRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('source: $source, ')
          ..write('entryId: $entryId, ')
          ..write('assertedAtUtc: $assertedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    amountMinor,
    currency,
    source,
    entryId,
    assertedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceAssertionRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.source == this.source &&
          other.entryId == this.entryId &&
          other.assertedAtUtc == this.assertedAtUtc);
}

class BalanceAssertionsCompanion extends UpdateCompanion<BalanceAssertionRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> source;
  final Value<String?> entryId;
  final Value<int> assertedAtUtc;
  final Value<int> rowid;
  const BalanceAssertionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.source = const Value.absent(),
    this.entryId = const Value.absent(),
    this.assertedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BalanceAssertionsCompanion.insert({
    required String id,
    required String accountId,
    required int amountMinor,
    required String currency,
    required String source,
    this.entryId = const Value.absent(),
    required int assertedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       source = Value(source),
       assertedAtUtc = Value(assertedAtUtc);
  static Insertable<BalanceAssertionRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? source,
    Expression<String>? entryId,
    Expression<int>? assertedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (source != null) 'source': source,
      if (entryId != null) 'entry_id': entryId,
      if (assertedAtUtc != null) 'asserted_at_utc': assertedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BalanceAssertionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? source,
    Value<String?>? entryId,
    Value<int>? assertedAtUtc,
    Value<int>? rowid,
  }) {
    return BalanceAssertionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      source: source ?? this.source,
      entryId: entryId ?? this.entryId,
      assertedAtUtc: assertedAtUtc ?? this.assertedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (assertedAtUtc.present) {
      map['asserted_at_utc'] = Variable<int>(assertedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceAssertionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('source: $source, ')
          ..write('entryId: $entryId, ')
          ..write('assertedAtUtc: $assertedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FlowKinds extends Table with TableInfo<FlowKinds, FlowKindRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FlowKinds(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY',
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (direction IN (\'outflow\', \'inflow\'))',
  );
  @override
  List<GeneratedColumn> get $columns => [kind, direction];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flow_kinds';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlowKindRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  FlowKindRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlowKindRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
    );
  }

  @override
  FlowKinds createAlias(String alias) {
    return FlowKinds(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class FlowKindRow extends DataClass implements Insertable<FlowKindRow> {
  final String kind;
  final String direction;
  const FlowKindRow({required this.kind, required this.direction});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['direction'] = Variable<String>(direction);
    return map;
  }

  FlowKindsCompanion toCompanion(bool nullToAbsent) {
    return FlowKindsCompanion(kind: Value(kind), direction: Value(direction));
  }

  factory FlowKindRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlowKindRow(
      kind: serializer.fromJson<String>(json['kind']),
      direction: serializer.fromJson<String>(json['direction']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'direction': serializer.toJson<String>(direction),
    };
  }

  FlowKindRow copyWith({String? kind, String? direction}) => FlowKindRow(
    kind: kind ?? this.kind,
    direction: direction ?? this.direction,
  );
  FlowKindRow copyWithCompanion(FlowKindsCompanion data) {
    return FlowKindRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      direction: data.direction.present ? data.direction.value : this.direction,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlowKindRow(')
          ..write('kind: $kind, ')
          ..write('direction: $direction')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, direction);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlowKindRow &&
          other.kind == this.kind &&
          other.direction == this.direction);
}

class FlowKindsCompanion extends UpdateCompanion<FlowKindRow> {
  final Value<String> kind;
  final Value<String> direction;
  final Value<int> rowid;
  const FlowKindsCompanion({
    this.kind = const Value.absent(),
    this.direction = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlowKindsCompanion.insert({
    required String kind,
    required String direction,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       direction = Value(direction);
  static Insertable<FlowKindRow> custom({
    Expression<String>? kind,
    Expression<String>? direction,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (direction != null) 'direction': direction,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlowKindsCompanion copyWith({
    Value<String>? kind,
    Value<String>? direction,
    Value<int>? rowid,
  }) {
    return FlowKindsCompanion(
      kind: kind ?? this.kind,
      direction: direction ?? this.direction,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlowKindsCompanion(')
          ..write('kind: $kind, ')
          ..write('direction: $direction, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class PlannedFlows extends Table with TableInfo<PlannedFlows, PlannedFlowRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  PlannedFlows(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES households(id)',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES flow_kinds(kind)',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) BETWEEN 1 AND 60)',
  );
  static const VerificationMeta _amountMinorMeta = const VerificationMeta(
    'amountMinor',
  );
  late final GeneratedColumn<int> amountMinor = GeneratedColumn<int>(
    'amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(amount_minor) = \'integer\' AND amount_minor > 0)',
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES currencies(code)',
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES accounts(id)',
  );
  static const VerificationMeta _cadenceMeta = const VerificationMeta(
    'cadence',
  );
  late final GeneratedColumn<String> cadence = GeneratedColumn<String>(
    'cadence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (cadence IN (\'monthly\', \'weekly\', \'yearly\', \'once\'))',
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (day IS NULL OR typeof(day) = \'integer\')',
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (month IS NULL OR(typeof(month) = \'integer\' AND month BETWEEN 1 AND 12))',
  );
  static const VerificationMeta _onceOnMeta = const VerificationMeta('onceOn');
  late final GeneratedColumn<String> onceOn = GeneratedColumn<String>(
    'once_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (once_on IS NULL OR(length(once_on) = 10 AND date(once_on) = once_on))',
  );
  static const VerificationMeta _startsOnMeta = const VerificationMeta(
    'startsOn',
  );
  late final GeneratedColumn<String> startsOn = GeneratedColumn<String>(
    'starts_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(starts_on) = 10 AND date(starts_on) = starts_on)',
  );
  static const VerificationMeta _createdAtUtcMeta = const VerificationMeta(
    'createdAtUtc',
  );
  late final GeneratedColumn<int> createdAtUtc = GeneratedColumn<int>(
    'created_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(created_at_utc) = \'integer\')',
  );
  static const VerificationMeta _archivedAtUtcMeta = const VerificationMeta(
    'archivedAtUtc',
  );
  late final GeneratedColumn<int> archivedAtUtc = GeneratedColumn<int>(
    'archived_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (archived_at_utc IS NULL OR typeof(archived_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    householdId,
    kind,
    name,
    amountMinor,
    currency,
    accountId,
    cadence,
    day,
    month,
    onceOn,
    startsOn,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'planned_flows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlannedFlowRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('household_id')) {
      context.handle(
        _householdIdMeta,
        householdId.isAcceptableOrUnknown(
          data['household_id']!,
          _householdIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_householdIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount_minor')) {
      context.handle(
        _amountMinorMeta,
        amountMinor.isAcceptableOrUnknown(
          data['amount_minor']!,
          _amountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMinorMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('cadence')) {
      context.handle(
        _cadenceMeta,
        cadence.isAcceptableOrUnknown(data['cadence']!, _cadenceMeta),
      );
    } else if (isInserting) {
      context.missing(_cadenceMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    }
    if (data.containsKey('once_on')) {
      context.handle(
        _onceOnMeta,
        onceOn.isAcceptableOrUnknown(data['once_on']!, _onceOnMeta),
      );
    }
    if (data.containsKey('starts_on')) {
      context.handle(
        _startsOnMeta,
        startsOn.isAcceptableOrUnknown(data['starts_on']!, _startsOnMeta),
      );
    } else if (isInserting) {
      context.missing(_startsOnMeta);
    }
    if (data.containsKey('created_at_utc')) {
      context.handle(
        _createdAtUtcMeta,
        createdAtUtc.isAcceptableOrUnknown(
          data['created_at_utc']!,
          _createdAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_createdAtUtcMeta);
    }
    if (data.containsKey('archived_at_utc')) {
      context.handle(
        _archivedAtUtcMeta,
        archivedAtUtc.isAcceptableOrUnknown(
          data['archived_at_utc']!,
          _archivedAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlannedFlowRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlannedFlowRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      cadence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cadence'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      ),
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      ),
      onceOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}once_on'],
      ),
      startsOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}starts_on'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at_utc'],
      ),
    );
  }

  @override
  PlannedFlows createAlias(String alias) {
    return PlannedFlows(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((cadence = \'monthly\' AND day BETWEEN 1 AND 31 AND month IS NULL AND once_on IS NULL)OR(cadence = \'weekly\' AND day BETWEEN 1 AND 7 AND month IS NULL AND once_on IS NULL)OR(cadence = \'yearly\' AND day BETWEEN 1 AND 31 AND month IS NOT NULL AND once_on IS NULL)OR(cadence = \'once\' AND day IS NULL AND month IS NULL AND once_on IS NOT NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class PlannedFlowRow extends DataClass implements Insertable<PlannedFlowRow> {
  final String id;
  final String householdId;
  final String kind;
  final String name;
  final int amountMinor;
  final String currency;
  final String? accountId;
  final String cadence;
  final int? day;
  final int? month;
  final String? onceOn;
  final String startsOn;
  final int createdAtUtc;
  final int? archivedAtUtc;
  const PlannedFlowRow({
    required this.id,
    required this.householdId,
    required this.kind,
    required this.name,
    required this.amountMinor,
    required this.currency,
    this.accountId,
    required this.cadence,
    this.day,
    this.month,
    this.onceOn,
    required this.startsOn,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['kind'] = Variable<String>(kind);
    map['name'] = Variable<String>(name);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['cadence'] = Variable<String>(cadence);
    if (!nullToAbsent || day != null) {
      map['day'] = Variable<int>(day);
    }
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<int>(month);
    }
    if (!nullToAbsent || onceOn != null) {
      map['once_on'] = Variable<String>(onceOn);
    }
    map['starts_on'] = Variable<String>(startsOn);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  PlannedFlowsCompanion toCompanion(bool nullToAbsent) {
    return PlannedFlowsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      kind: Value(kind),
      name: Value(name),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      cadence: Value(cadence),
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      month: month == null && nullToAbsent
          ? const Value.absent()
          : Value(month),
      onceOn: onceOn == null && nullToAbsent
          ? const Value.absent()
          : Value(onceOn),
      startsOn: Value(startsOn),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory PlannedFlowRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlannedFlowRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      kind: serializer.fromJson<String>(json['kind']),
      name: serializer.fromJson<String>(json['name']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      currency: serializer.fromJson<String>(json['currency']),
      accountId: serializer.fromJson<String?>(json['account_id']),
      cadence: serializer.fromJson<String>(json['cadence']),
      day: serializer.fromJson<int?>(json['day']),
      month: serializer.fromJson<int?>(json['month']),
      onceOn: serializer.fromJson<String?>(json['once_on']),
      startsOn: serializer.fromJson<String>(json['starts_on']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
      archivedAtUtc: serializer.fromJson<int?>(json['archived_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household_id': serializer.toJson<String>(householdId),
      'kind': serializer.toJson<String>(kind),
      'name': serializer.toJson<String>(name),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'account_id': serializer.toJson<String?>(accountId),
      'cadence': serializer.toJson<String>(cadence),
      'day': serializer.toJson<int?>(day),
      'month': serializer.toJson<int?>(month),
      'once_on': serializer.toJson<String?>(onceOn),
      'starts_on': serializer.toJson<String>(startsOn),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
      'archived_at_utc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  PlannedFlowRow copyWith({
    String? id,
    String? householdId,
    String? kind,
    String? name,
    int? amountMinor,
    String? currency,
    Value<String?> accountId = const Value.absent(),
    String? cadence,
    Value<int?> day = const Value.absent(),
    Value<int?> month = const Value.absent(),
    Value<String?> onceOn = const Value.absent(),
    String? startsOn,
    int? createdAtUtc,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => PlannedFlowRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    kind: kind ?? this.kind,
    name: name ?? this.name,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    accountId: accountId.present ? accountId.value : this.accountId,
    cadence: cadence ?? this.cadence,
    day: day.present ? day.value : this.day,
    month: month.present ? month.value : this.month,
    onceOn: onceOn.present ? onceOn.value : this.onceOn,
    startsOn: startsOn ?? this.startsOn,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  PlannedFlowRow copyWithCompanion(PlannedFlowsCompanion data) {
    return PlannedFlowRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      kind: data.kind.present ? data.kind.value : this.kind,
      name: data.name.present ? data.name.value : this.name,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      day: data.day.present ? data.day.value : this.day,
      month: data.month.present ? data.month.value : this.month,
      onceOn: data.onceOn.present ? data.onceOn.value : this.onceOn,
      startsOn: data.startsOn.present ? data.startsOn.value : this.startsOn,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlannedFlowRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('accountId: $accountId, ')
          ..write('cadence: $cadence, ')
          ..write('day: $day, ')
          ..write('month: $month, ')
          ..write('onceOn: $onceOn, ')
          ..write('startsOn: $startsOn, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    kind,
    name,
    amountMinor,
    currency,
    accountId,
    cadence,
    day,
    month,
    onceOn,
    startsOn,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlannedFlowRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.kind == this.kind &&
          other.name == this.name &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.accountId == this.accountId &&
          other.cadence == this.cadence &&
          other.day == this.day &&
          other.month == this.month &&
          other.onceOn == this.onceOn &&
          other.startsOn == this.startsOn &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class PlannedFlowsCompanion extends UpdateCompanion<PlannedFlowRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> kind;
  final Value<String> name;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String?> accountId;
  final Value<String> cadence;
  final Value<int?> day;
  final Value<int?> month;
  final Value<String?> onceOn;
  final Value<String> startsOn;
  final Value<int> createdAtUtc;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const PlannedFlowsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.kind = const Value.absent(),
    this.name = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.accountId = const Value.absent(),
    this.cadence = const Value.absent(),
    this.day = const Value.absent(),
    this.month = const Value.absent(),
    this.onceOn = const Value.absent(),
    this.startsOn = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlannedFlowsCompanion.insert({
    required String id,
    required String householdId,
    required String kind,
    required String name,
    required int amountMinor,
    required String currency,
    this.accountId = const Value.absent(),
    required String cadence,
    this.day = const Value.absent(),
    this.month = const Value.absent(),
    this.onceOn = const Value.absent(),
    required String startsOn,
    required int createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       kind = Value(kind),
       name = Value(name),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       cadence = Value(cadence),
       startsOn = Value(startsOn),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<PlannedFlowRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? kind,
    Expression<String>? name,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? accountId,
    Expression<String>? cadence,
    Expression<int>? day,
    Expression<int>? month,
    Expression<String>? onceOn,
    Expression<String>? startsOn,
    Expression<int>? createdAtUtc,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (kind != null) 'kind': kind,
      if (name != null) 'name': name,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (accountId != null) 'account_id': accountId,
      if (cadence != null) 'cadence': cadence,
      if (day != null) 'day': day,
      if (month != null) 'month': month,
      if (onceOn != null) 'once_on': onceOn,
      if (startsOn != null) 'starts_on': startsOn,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlannedFlowsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? kind,
    Value<String>? name,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String?>? accountId,
    Value<String>? cadence,
    Value<int?>? day,
    Value<int?>? month,
    Value<String?>? onceOn,
    Value<String>? startsOn,
    Value<int>? createdAtUtc,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return PlannedFlowsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      kind: kind ?? this.kind,
      name: name ?? this.name,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      accountId: accountId ?? this.accountId,
      cadence: cadence ?? this.cadence,
      day: day ?? this.day,
      month: month ?? this.month,
      onceOn: onceOn ?? this.onceOn,
      startsOn: startsOn ?? this.startsOn,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      archivedAtUtc: archivedAtUtc ?? this.archivedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (cadence.present) {
      map['cadence'] = Variable<String>(cadence.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (onceOn.present) {
      map['once_on'] = Variable<String>(onceOn.value);
    }
    if (startsOn.present) {
      map['starts_on'] = Variable<String>(startsOn.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (archivedAtUtc.present) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlannedFlowsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('kind: $kind, ')
          ..write('name: $name, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('accountId: $accountId, ')
          ..write('cadence: $cadence, ')
          ..write('day: $day, ')
          ..write('month: $month, ')
          ..write('onceOn: $onceOn, ')
          ..write('startsOn: $startsOn, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FlowMarks extends Table with TableInfo<FlowMarks, FlowMarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FlowMarks(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _flowIdMeta = const VerificationMeta('flowId');
  late final GeneratedColumn<String> flowId = GeneratedColumn<String>(
    'flow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES planned_flows(id)',
  );
  static const VerificationMeta _dueOnMeta = const VerificationMeta('dueOn');
  late final GeneratedColumn<String> dueOn = GeneratedColumn<String>(
    'due_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (length(due_on) = 10 AND date(due_on) = due_on)',
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (status IN (\'done\', \'skipped\'))',
  );
  static const VerificationMeta _markedAtUtcMeta = const VerificationMeta(
    'markedAtUtc',
  );
  late final GeneratedColumn<int> markedAtUtc = GeneratedColumn<int>(
    'marked_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(marked_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [flowId, dueOn, status, markedAtUtc];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flow_marks';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlowMarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('flow_id')) {
      context.handle(
        _flowIdMeta,
        flowId.isAcceptableOrUnknown(data['flow_id']!, _flowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_flowIdMeta);
    }
    if (data.containsKey('due_on')) {
      context.handle(
        _dueOnMeta,
        dueOn.isAcceptableOrUnknown(data['due_on']!, _dueOnMeta),
      );
    } else if (isInserting) {
      context.missing(_dueOnMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('marked_at_utc')) {
      context.handle(
        _markedAtUtcMeta,
        markedAtUtc.isAcceptableOrUnknown(
          data['marked_at_utc']!,
          _markedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_markedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {flowId, dueOn};
  @override
  FlowMarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlowMarkRow(
      flowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_id'],
      )!,
      dueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_on'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      markedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}marked_at_utc'],
      )!,
    );
  }

  @override
  FlowMarks createAlias(String alias) {
    return FlowMarks(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['PRIMARY KEY(flow_id, due_on)'];
  @override
  bool get dontWriteConstraints => true;
}

class FlowMarkRow extends DataClass implements Insertable<FlowMarkRow> {
  final String flowId;
  final String dueOn;
  final String status;
  final int markedAtUtc;
  const FlowMarkRow({
    required this.flowId,
    required this.dueOn,
    required this.status,
    required this.markedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['flow_id'] = Variable<String>(flowId);
    map['due_on'] = Variable<String>(dueOn);
    map['status'] = Variable<String>(status);
    map['marked_at_utc'] = Variable<int>(markedAtUtc);
    return map;
  }

  FlowMarksCompanion toCompanion(bool nullToAbsent) {
    return FlowMarksCompanion(
      flowId: Value(flowId),
      dueOn: Value(dueOn),
      status: Value(status),
      markedAtUtc: Value(markedAtUtc),
    );
  }

  factory FlowMarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlowMarkRow(
      flowId: serializer.fromJson<String>(json['flow_id']),
      dueOn: serializer.fromJson<String>(json['due_on']),
      status: serializer.fromJson<String>(json['status']),
      markedAtUtc: serializer.fromJson<int>(json['marked_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'flow_id': serializer.toJson<String>(flowId),
      'due_on': serializer.toJson<String>(dueOn),
      'status': serializer.toJson<String>(status),
      'marked_at_utc': serializer.toJson<int>(markedAtUtc),
    };
  }

  FlowMarkRow copyWith({
    String? flowId,
    String? dueOn,
    String? status,
    int? markedAtUtc,
  }) => FlowMarkRow(
    flowId: flowId ?? this.flowId,
    dueOn: dueOn ?? this.dueOn,
    status: status ?? this.status,
    markedAtUtc: markedAtUtc ?? this.markedAtUtc,
  );
  FlowMarkRow copyWithCompanion(FlowMarksCompanion data) {
    return FlowMarkRow(
      flowId: data.flowId.present ? data.flowId.value : this.flowId,
      dueOn: data.dueOn.present ? data.dueOn.value : this.dueOn,
      status: data.status.present ? data.status.value : this.status,
      markedAtUtc: data.markedAtUtc.present
          ? data.markedAtUtc.value
          : this.markedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlowMarkRow(')
          ..write('flowId: $flowId, ')
          ..write('dueOn: $dueOn, ')
          ..write('status: $status, ')
          ..write('markedAtUtc: $markedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(flowId, dueOn, status, markedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlowMarkRow &&
          other.flowId == this.flowId &&
          other.dueOn == this.dueOn &&
          other.status == this.status &&
          other.markedAtUtc == this.markedAtUtc);
}

class FlowMarksCompanion extends UpdateCompanion<FlowMarkRow> {
  final Value<String> flowId;
  final Value<String> dueOn;
  final Value<String> status;
  final Value<int> markedAtUtc;
  final Value<int> rowid;
  const FlowMarksCompanion({
    this.flowId = const Value.absent(),
    this.dueOn = const Value.absent(),
    this.status = const Value.absent(),
    this.markedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlowMarksCompanion.insert({
    required String flowId,
    required String dueOn,
    required String status,
    required int markedAtUtc,
    this.rowid = const Value.absent(),
  }) : flowId = Value(flowId),
       dueOn = Value(dueOn),
       status = Value(status),
       markedAtUtc = Value(markedAtUtc);
  static Insertable<FlowMarkRow> custom({
    Expression<String>? flowId,
    Expression<String>? dueOn,
    Expression<String>? status,
    Expression<int>? markedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (flowId != null) 'flow_id': flowId,
      if (dueOn != null) 'due_on': dueOn,
      if (status != null) 'status': status,
      if (markedAtUtc != null) 'marked_at_utc': markedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlowMarksCompanion copyWith({
    Value<String>? flowId,
    Value<String>? dueOn,
    Value<String>? status,
    Value<int>? markedAtUtc,
    Value<int>? rowid,
  }) {
    return FlowMarksCompanion(
      flowId: flowId ?? this.flowId,
      dueOn: dueOn ?? this.dueOn,
      status: status ?? this.status,
      markedAtUtc: markedAtUtc ?? this.markedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (flowId.present) {
      map['flow_id'] = Variable<String>(flowId.value);
    }
    if (dueOn.present) {
      map['due_on'] = Variable<String>(dueOn.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (markedAtUtc.present) {
      map['marked_at_utc'] = Variable<int>(markedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlowMarksCompanion(')
          ..write('flowId: $flowId, ')
          ..write('dueOn: $dueOn, ')
          ..write('status: $status, ')
          ..write('markedAtUtc: $markedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class CardFigures extends Table with TableInfo<CardFigures, CardFiguresRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CardFigures(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES accounts(id)',
  );
  static const VerificationMeta _graceAmountMinorMeta = const VerificationMeta(
    'graceAmountMinor',
  );
  late final GeneratedColumn<int> graceAmountMinor = GeneratedColumn<int>(
    'grace_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (grace_amount_minor IS NULL OR(typeof(grace_amount_minor) = \'integer\' AND grace_amount_minor >= 0))',
  );
  static const VerificationMeta _graceDueOnMeta = const VerificationMeta(
    'graceDueOn',
  );
  late final GeneratedColumn<String> graceDueOn = GeneratedColumn<String>(
    'grace_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (grace_due_on IS NULL OR(length(grace_due_on) = 10 AND date(grace_due_on) = grace_due_on))',
  );
  static const VerificationMeta _minPaymentMinorMeta = const VerificationMeta(
    'minPaymentMinor',
  );
  late final GeneratedColumn<int> minPaymentMinor = GeneratedColumn<int>(
    'min_payment_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (min_payment_minor IS NULL OR(typeof(min_payment_minor) = \'integer\' AND min_payment_minor >= 0))',
  );
  static const VerificationMeta _minDueOnMeta = const VerificationMeta(
    'minDueOn',
  );
  late final GeneratedColumn<String> minDueOn = GeneratedColumn<String>(
    'min_due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (min_due_on IS NULL OR(length(min_due_on) = 10 AND date(min_due_on) = min_due_on))',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES data_sources(source)',
  );
  static const VerificationMeta _recordedAtUtcMeta = const VerificationMeta(
    'recordedAtUtc',
  );
  late final GeneratedColumn<int> recordedAtUtc = GeneratedColumn<int>(
    'recorded_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(recorded_at_utc) = \'integer\')',
  );
  static const VerificationMeta _settledAtUtcMeta = const VerificationMeta(
    'settledAtUtc',
  );
  late final GeneratedColumn<int> settledAtUtc = GeneratedColumn<int>(
    'settled_at_utc',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (settled_at_utc IS NULL OR typeof(settled_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    graceAmountMinor,
    graceDueOn,
    minPaymentMinor,
    minDueOn,
    source,
    recordedAtUtc,
    settledAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_figures';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardFiguresRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('grace_amount_minor')) {
      context.handle(
        _graceAmountMinorMeta,
        graceAmountMinor.isAcceptableOrUnknown(
          data['grace_amount_minor']!,
          _graceAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('grace_due_on')) {
      context.handle(
        _graceDueOnMeta,
        graceDueOn.isAcceptableOrUnknown(
          data['grace_due_on']!,
          _graceDueOnMeta,
        ),
      );
    }
    if (data.containsKey('min_payment_minor')) {
      context.handle(
        _minPaymentMinorMeta,
        minPaymentMinor.isAcceptableOrUnknown(
          data['min_payment_minor']!,
          _minPaymentMinorMeta,
        ),
      );
    }
    if (data.containsKey('min_due_on')) {
      context.handle(
        _minDueOnMeta,
        minDueOn.isAcceptableOrUnknown(data['min_due_on']!, _minDueOnMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('recorded_at_utc')) {
      context.handle(
        _recordedAtUtcMeta,
        recordedAtUtc.isAcceptableOrUnknown(
          data['recorded_at_utc']!,
          _recordedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordedAtUtcMeta);
    }
    if (data.containsKey('settled_at_utc')) {
      context.handle(
        _settledAtUtcMeta,
        settledAtUtc.isAcceptableOrUnknown(
          data['settled_at_utc']!,
          _settledAtUtcMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardFiguresRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardFiguresRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      graceAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}grace_amount_minor'],
      ),
      graceDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grace_due_on'],
      ),
      minPaymentMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_payment_minor'],
      ),
      minDueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}min_due_on'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      recordedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recorded_at_utc'],
      )!,
      settledAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}settled_at_utc'],
      ),
    );
  }

  @override
  CardFigures createAlias(String alias) {
    return CardFigures(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(grace_amount_minor IS NOT NULL OR min_payment_minor IS NOT NULL)',
    'CHECK((grace_amount_minor IS NULL)=(grace_due_on IS NULL))',
    'CHECK((min_payment_minor IS NULL)=(min_due_on IS NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class CardFiguresRow extends DataClass implements Insertable<CardFiguresRow> {
  final String id;
  final String accountId;
  final int? graceAmountMinor;
  final String? graceDueOn;
  final int? minPaymentMinor;
  final String? minDueOn;
  final String source;
  final int recordedAtUtc;
  final int? settledAtUtc;
  const CardFiguresRow({
    required this.id,
    required this.accountId,
    this.graceAmountMinor,
    this.graceDueOn,
    this.minPaymentMinor,
    this.minDueOn,
    required this.source,
    required this.recordedAtUtc,
    this.settledAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || graceAmountMinor != null) {
      map['grace_amount_minor'] = Variable<int>(graceAmountMinor);
    }
    if (!nullToAbsent || graceDueOn != null) {
      map['grace_due_on'] = Variable<String>(graceDueOn);
    }
    if (!nullToAbsent || minPaymentMinor != null) {
      map['min_payment_minor'] = Variable<int>(minPaymentMinor);
    }
    if (!nullToAbsent || minDueOn != null) {
      map['min_due_on'] = Variable<String>(minDueOn);
    }
    map['source'] = Variable<String>(source);
    map['recorded_at_utc'] = Variable<int>(recordedAtUtc);
    if (!nullToAbsent || settledAtUtc != null) {
      map['settled_at_utc'] = Variable<int>(settledAtUtc);
    }
    return map;
  }

  CardFiguresCompanion toCompanion(bool nullToAbsent) {
    return CardFiguresCompanion(
      id: Value(id),
      accountId: Value(accountId),
      graceAmountMinor: graceAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(graceAmountMinor),
      graceDueOn: graceDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(graceDueOn),
      minPaymentMinor: minPaymentMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(minPaymentMinor),
      minDueOn: minDueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(minDueOn),
      source: Value(source),
      recordedAtUtc: Value(recordedAtUtc),
      settledAtUtc: settledAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(settledAtUtc),
    );
  }

  factory CardFiguresRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardFiguresRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['account_id']),
      graceAmountMinor: serializer.fromJson<int?>(json['grace_amount_minor']),
      graceDueOn: serializer.fromJson<String?>(json['grace_due_on']),
      minPaymentMinor: serializer.fromJson<int?>(json['min_payment_minor']),
      minDueOn: serializer.fromJson<String?>(json['min_due_on']),
      source: serializer.fromJson<String>(json['source']),
      recordedAtUtc: serializer.fromJson<int>(json['recorded_at_utc']),
      settledAtUtc: serializer.fromJson<int?>(json['settled_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'account_id': serializer.toJson<String>(accountId),
      'grace_amount_minor': serializer.toJson<int?>(graceAmountMinor),
      'grace_due_on': serializer.toJson<String?>(graceDueOn),
      'min_payment_minor': serializer.toJson<int?>(minPaymentMinor),
      'min_due_on': serializer.toJson<String?>(minDueOn),
      'source': serializer.toJson<String>(source),
      'recorded_at_utc': serializer.toJson<int>(recordedAtUtc),
      'settled_at_utc': serializer.toJson<int?>(settledAtUtc),
    };
  }

  CardFiguresRow copyWith({
    String? id,
    String? accountId,
    Value<int?> graceAmountMinor = const Value.absent(),
    Value<String?> graceDueOn = const Value.absent(),
    Value<int?> minPaymentMinor = const Value.absent(),
    Value<String?> minDueOn = const Value.absent(),
    String? source,
    int? recordedAtUtc,
    Value<int?> settledAtUtc = const Value.absent(),
  }) => CardFiguresRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    graceAmountMinor: graceAmountMinor.present
        ? graceAmountMinor.value
        : this.graceAmountMinor,
    graceDueOn: graceDueOn.present ? graceDueOn.value : this.graceDueOn,
    minPaymentMinor: minPaymentMinor.present
        ? minPaymentMinor.value
        : this.minPaymentMinor,
    minDueOn: minDueOn.present ? minDueOn.value : this.minDueOn,
    source: source ?? this.source,
    recordedAtUtc: recordedAtUtc ?? this.recordedAtUtc,
    settledAtUtc: settledAtUtc.present ? settledAtUtc.value : this.settledAtUtc,
  );
  CardFiguresRow copyWithCompanion(CardFiguresCompanion data) {
    return CardFiguresRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      graceAmountMinor: data.graceAmountMinor.present
          ? data.graceAmountMinor.value
          : this.graceAmountMinor,
      graceDueOn: data.graceDueOn.present
          ? data.graceDueOn.value
          : this.graceDueOn,
      minPaymentMinor: data.minPaymentMinor.present
          ? data.minPaymentMinor.value
          : this.minPaymentMinor,
      minDueOn: data.minDueOn.present ? data.minDueOn.value : this.minDueOn,
      source: data.source.present ? data.source.value : this.source,
      recordedAtUtc: data.recordedAtUtc.present
          ? data.recordedAtUtc.value
          : this.recordedAtUtc,
      settledAtUtc: data.settledAtUtc.present
          ? data.settledAtUtc.value
          : this.settledAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardFiguresRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('graceAmountMinor: $graceAmountMinor, ')
          ..write('graceDueOn: $graceDueOn, ')
          ..write('minPaymentMinor: $minPaymentMinor, ')
          ..write('minDueOn: $minDueOn, ')
          ..write('source: $source, ')
          ..write('recordedAtUtc: $recordedAtUtc, ')
          ..write('settledAtUtc: $settledAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    graceAmountMinor,
    graceDueOn,
    minPaymentMinor,
    minDueOn,
    source,
    recordedAtUtc,
    settledAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardFiguresRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.graceAmountMinor == this.graceAmountMinor &&
          other.graceDueOn == this.graceDueOn &&
          other.minPaymentMinor == this.minPaymentMinor &&
          other.minDueOn == this.minDueOn &&
          other.source == this.source &&
          other.recordedAtUtc == this.recordedAtUtc &&
          other.settledAtUtc == this.settledAtUtc);
}

class CardFiguresCompanion extends UpdateCompanion<CardFiguresRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<int?> graceAmountMinor;
  final Value<String?> graceDueOn;
  final Value<int?> minPaymentMinor;
  final Value<String?> minDueOn;
  final Value<String> source;
  final Value<int> recordedAtUtc;
  final Value<int?> settledAtUtc;
  final Value<int> rowid;
  const CardFiguresCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.graceAmountMinor = const Value.absent(),
    this.graceDueOn = const Value.absent(),
    this.minPaymentMinor = const Value.absent(),
    this.minDueOn = const Value.absent(),
    this.source = const Value.absent(),
    this.recordedAtUtc = const Value.absent(),
    this.settledAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardFiguresCompanion.insert({
    required String id,
    required String accountId,
    this.graceAmountMinor = const Value.absent(),
    this.graceDueOn = const Value.absent(),
    this.minPaymentMinor = const Value.absent(),
    this.minDueOn = const Value.absent(),
    required String source,
    required int recordedAtUtc,
    this.settledAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       source = Value(source),
       recordedAtUtc = Value(recordedAtUtc);
  static Insertable<CardFiguresRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<int>? graceAmountMinor,
    Expression<String>? graceDueOn,
    Expression<int>? minPaymentMinor,
    Expression<String>? minDueOn,
    Expression<String>? source,
    Expression<int>? recordedAtUtc,
    Expression<int>? settledAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (graceAmountMinor != null) 'grace_amount_minor': graceAmountMinor,
      if (graceDueOn != null) 'grace_due_on': graceDueOn,
      if (minPaymentMinor != null) 'min_payment_minor': minPaymentMinor,
      if (minDueOn != null) 'min_due_on': minDueOn,
      if (source != null) 'source': source,
      if (recordedAtUtc != null) 'recorded_at_utc': recordedAtUtc,
      if (settledAtUtc != null) 'settled_at_utc': settledAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardFiguresCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<int?>? graceAmountMinor,
    Value<String?>? graceDueOn,
    Value<int?>? minPaymentMinor,
    Value<String?>? minDueOn,
    Value<String>? source,
    Value<int>? recordedAtUtc,
    Value<int?>? settledAtUtc,
    Value<int>? rowid,
  }) {
    return CardFiguresCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      graceAmountMinor: graceAmountMinor ?? this.graceAmountMinor,
      graceDueOn: graceDueOn ?? this.graceDueOn,
      minPaymentMinor: minPaymentMinor ?? this.minPaymentMinor,
      minDueOn: minDueOn ?? this.minDueOn,
      source: source ?? this.source,
      recordedAtUtc: recordedAtUtc ?? this.recordedAtUtc,
      settledAtUtc: settledAtUtc ?? this.settledAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (graceAmountMinor.present) {
      map['grace_amount_minor'] = Variable<int>(graceAmountMinor.value);
    }
    if (graceDueOn.present) {
      map['grace_due_on'] = Variable<String>(graceDueOn.value);
    }
    if (minPaymentMinor.present) {
      map['min_payment_minor'] = Variable<int>(minPaymentMinor.value);
    }
    if (minDueOn.present) {
      map['min_due_on'] = Variable<String>(minDueOn.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (recordedAtUtc.present) {
      map['recorded_at_utc'] = Variable<int>(recordedAtUtc.value);
    }
    if (settledAtUtc.present) {
      map['settled_at_utc'] = Variable<int>(settledAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardFiguresCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('graceAmountMinor: $graceAmountMinor, ')
          ..write('graceDueOn: $graceDueOn, ')
          ..write('minPaymentMinor: $minPaymentMinor, ')
          ..write('minDueOn: $minDueOn, ')
          ..write('source: $source, ')
          ..write('recordedAtUtc: $recordedAtUtc, ')
          ..write('settledAtUtc: $settledAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final AppSettings appSettings = AppSettings(this);
  late final SchemaMigrations schemaMigrations = SchemaMigrations(this);
  late final Currencies currencies = Currencies(this);
  late final AccountKinds accountKinds = AccountKinds(this);
  late final EntryKinds entryKinds = EntryKinds(this);
  late final DataSources dataSources = DataSources(this);
  late final Households households = Households(this);
  late final Members members = Members(this);
  late final Accounts accounts = Accounts(this);
  late final JournalEntries journalEntries = JournalEntries(this);
  late final Postings postings = Postings(this);
  late final Index postingsByAccount = Index(
    'postings_by_account',
    'CREATE INDEX postings_by_account ON postings (account_id)',
  );
  late final BalanceAssertions balanceAssertions = BalanceAssertions(this);
  late final Index balanceAssertionsByAccount = Index(
    'balance_assertions_by_account',
    'CREATE INDEX balance_assertions_by_account ON balance_assertions (account_id, asserted_at_utc)',
  );
  late final Trigger journalEntriesNoUpdate = Trigger(
    'CREATE TRIGGER journal_entries_no_update BEFORE UPDATE ON journal_entries BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'journal_entries_no_update',
  );
  late final Trigger journalEntriesNoDelete = Trigger(
    'CREATE TRIGGER journal_entries_no_delete BEFORE DELETE ON journal_entries BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'journal_entries_no_delete',
  );
  late final Trigger postingsNoUpdate = Trigger(
    'CREATE TRIGGER postings_no_update BEFORE UPDATE ON postings BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'postings_no_update',
  );
  late final Trigger postingsNoDelete = Trigger(
    'CREATE TRIGGER postings_no_delete BEFORE DELETE ON postings BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'postings_no_delete',
  );
  late final Trigger balanceAssertionsNoUpdate = Trigger(
    'CREATE TRIGGER balance_assertions_no_update BEFORE UPDATE ON balance_assertions BEGIN SELECT RAISE (ABORT, \'assertions are append-only\');END',
    'balance_assertions_no_update',
  );
  late final Trigger balanceAssertionsNoDelete = Trigger(
    'CREATE TRIGGER balance_assertions_no_delete BEFORE DELETE ON balance_assertions BEGIN SELECT RAISE (ABORT, \'assertions are append-only\');END',
    'balance_assertions_no_delete',
  );
  late final FlowKinds flowKinds = FlowKinds(this);
  late final PlannedFlows plannedFlows = PlannedFlows(this);
  late final FlowMarks flowMarks = FlowMarks(this);
  late final CardFigures cardFigures = CardFigures(this);
  late final Index cardFiguresByAccount = Index(
    'card_figures_by_account',
    'CREATE INDEX card_figures_by_account ON card_figures (account_id, recorded_at_utc)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appSettings,
    schemaMigrations,
    currencies,
    accountKinds,
    entryKinds,
    dataSources,
    households,
    members,
    accounts,
    journalEntries,
    postings,
    postingsByAccount,
    balanceAssertions,
    balanceAssertionsByAccount,
    journalEntriesNoUpdate,
    journalEntriesNoDelete,
    postingsNoUpdate,
    postingsNoDelete,
    balanceAssertionsNoUpdate,
    balanceAssertionsNoDelete,
    flowKinds,
    plannedFlows,
    flowMarks,
    cardFigures,
    cardFiguresByAccount,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'journal_entries',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'postings',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'postings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'balance_assertions',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'balance_assertions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
  ]);
}

typedef $AppSettingsCreateCompanionBuilder = AppSettingsCompanion Function({
  required String key,
  required String valueJson,
  required int valueVersion,
  Value<int> rowid,
});
typedef $AppSettingsUpdateCompanionBuilder = AppSettingsCompanion Function({
  Value<String> key,
  Value<String> valueJson,
  Value<int> valueVersion,
  Value<int> rowid,
});

class $AppSettingsFilterComposer extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueVersion => $composableBuilder(
    column: $table.valueVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $AppSettingsOrderingComposer
    extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueVersion => $composableBuilder(
    column: $table.valueVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AppSettingsAnnotationComposer
    extends Composer<_$AppDatabase, AppSettings> {
  $AppSettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<int> get valueVersion => $composableBuilder(
    column: $table.valueVersion,
    builder: (column) => column,
  );
}

class $AppSettingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AppSettings,
          AppSetting,
          $AppSettingsFilterComposer,
          $AppSettingsOrderingComposer,
          $AppSettingsAnnotationComposer,
          $AppSettingsCreateCompanionBuilder,
          $AppSettingsUpdateCompanionBuilder,
          (AppSetting, BaseReferences<_$AppDatabase, AppSettings, AppSetting>),
          AppSetting,
          PrefetchHooks Function()
        > {
  $AppSettingsTableManager(_$AppDatabase db, AppSettings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AppSettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AppSettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AppSettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<int> valueVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                valueJson: valueJson,
                valueVersion: valueVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                required int valueVersion,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                valueJson: valueJson,
                valueVersion: valueVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AppSettings, AppSetting>(table),
                  BaseReferences<_$AppDatabase, AppSettings, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $AppSettingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AppSettings,
      AppSetting,
      $AppSettingsFilterComposer,
      $AppSettingsOrderingComposer,
      $AppSettingsAnnotationComposer,
      $AppSettingsCreateCompanionBuilder,
      $AppSettingsUpdateCompanionBuilder,
      (AppSetting, BaseReferences<_$AppDatabase, AppSettings, AppSetting>),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $SchemaMigrationsCreateCompanionBuilder =
    SchemaMigrationsCompanion Function({
      Value<int> version,
      required String schemaChecksum,
      required int appliedAtUtc,
      required String appVersion,
    });
typedef $SchemaMigrationsUpdateCompanionBuilder =
    SchemaMigrationsCompanion Function({
      Value<int> version,
      Value<String> schemaChecksum,
      Value<int> appliedAtUtc,
      Value<String> appVersion,
    });

class $SchemaMigrationsFilterComposer
    extends Composer<_$AppDatabase, SchemaMigrations> {
  $SchemaMigrationsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get schemaChecksum => $composableBuilder(
    column: $table.schemaChecksum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $SchemaMigrationsOrderingComposer
    extends Composer<_$AppDatabase, SchemaMigrations> {
  $SchemaMigrationsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get schemaChecksum => $composableBuilder(
    column: $table.schemaChecksum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SchemaMigrationsAnnotationComposer
    extends Composer<_$AppDatabase, SchemaMigrations> {
  $SchemaMigrationsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<String> get schemaChecksum => $composableBuilder(
    column: $table.schemaChecksum,
    builder: (column) => column,
  );

  GeneratedColumn<int> get appliedAtUtc => $composableBuilder(
    column: $table.appliedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );
}

class $SchemaMigrationsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          SchemaMigrations,
          SchemaMigration,
          $SchemaMigrationsFilterComposer,
          $SchemaMigrationsOrderingComposer,
          $SchemaMigrationsAnnotationComposer,
          $SchemaMigrationsCreateCompanionBuilder,
          $SchemaMigrationsUpdateCompanionBuilder,
          (
            SchemaMigration,
            BaseReferences<_$AppDatabase, SchemaMigrations, SchemaMigration>,
          ),
          SchemaMigration,
          PrefetchHooks Function()
        > {
  $SchemaMigrationsTableManager(_$AppDatabase db, SchemaMigrations table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SchemaMigrationsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SchemaMigrationsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SchemaMigrationsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                Value<String> schemaChecksum = const Value.absent(),
                Value<int> appliedAtUtc = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
              }) => SchemaMigrationsCompanion(
                version: version,
                schemaChecksum: schemaChecksum,
                appliedAtUtc: appliedAtUtc,
                appVersion: appVersion,
              ),
          createCompanionCallback:
              ({
                Value<int> version = const Value.absent(),
                required String schemaChecksum,
                required int appliedAtUtc,
                required String appVersion,
              }) => SchemaMigrationsCompanion.insert(
                version: version,
                schemaChecksum: schemaChecksum,
                appliedAtUtc: appliedAtUtc,
                appVersion: appVersion,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<SchemaMigrations, SchemaMigration>(table),
                  BaseReferences<
                    _$AppDatabase,
                    SchemaMigrations,
                    SchemaMigration
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SchemaMigrationsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      SchemaMigrations,
      SchemaMigration,
      $SchemaMigrationsFilterComposer,
      $SchemaMigrationsOrderingComposer,
      $SchemaMigrationsAnnotationComposer,
      $SchemaMigrationsCreateCompanionBuilder,
      $SchemaMigrationsUpdateCompanionBuilder,
      (
        SchemaMigration,
        BaseReferences<_$AppDatabase, SchemaMigrations, SchemaMigration>,
      ),
      SchemaMigration,
      PrefetchHooks Function()
    >;
typedef $CurrenciesCreateCompanionBuilder = CurrenciesCompanion Function({
  required String code,
  required int fractionDigits,
  Value<int> rowid,
});
typedef $CurrenciesUpdateCompanionBuilder = CurrenciesCompanion Function({
  Value<String> code,
  Value<int> fractionDigits,
  Value<int> rowid,
});

final class $CurrenciesReferences
    extends BaseReferences<_$AppDatabase, Currencies, CurrencyRow> {
  $CurrenciesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Households, List<HouseholdRow>>
  _householdsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.households,
    aliasName: 'currencies__code__households__base_currency',
  );

  $HouseholdsProcessedTableManager get householdsRefs {
    final manager = $HouseholdsTableManager($_db, $_db.households).filter(
      (f) => f.baseCurrency.code.sqlEquals($_itemColumn<String>('code')!),
    );

    final cache = $_typedResult.readTableOrNull(_householdsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Accounts, List<AccountRow>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'currencies__code__accounts__currency',
  );

  $AccountsProcessedTableManager get accountsRefs {
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Postings, List<PostingRow>> _postingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.postings,
    aliasName: 'currencies__code__postings__currency',
  );

  $PostingsProcessedTableManager get postingsRefs {
    final manager = $PostingsTableManager(
      $_db,
      $_db.postings,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_postingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<BalanceAssertions, List<BalanceAssertionRow>>
  _balanceAssertionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.balanceAssertions,
        aliasName: 'currencies__code__balance_assertions__currency',
      );

  $BalanceAssertionsProcessedTableManager get balanceAssertionsRefs {
    final manager = $BalanceAssertionsTableManager(
      $_db,
      $_db.balanceAssertions,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceAssertionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<PlannedFlows, List<PlannedFlowRow>>
  _plannedFlowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedFlows,
    aliasName: 'currencies__code__planned_flows__currency',
  );

  $PlannedFlowsProcessedTableManager get plannedFlowsRefs {
    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(_plannedFlowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CurrenciesFilterComposer extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fractionDigits => $composableBuilder(
    column: $table.fractionDigits,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> householdsRefs(
    Expression<bool> Function($HouseholdsFilterComposer f) f,
  ) {
    final $HouseholdsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.baseCurrency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountsRefs(
    Expression<bool> Function($AccountsFilterComposer f) f,
  ) {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> postingsRefs(
    Expression<bool> Function($PostingsFilterComposer f) f,
  ) {
    final $PostingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsFilterComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> balanceAssertionsRefs(
    Expression<bool> Function($BalanceAssertionsFilterComposer f) f,
  ) {
    final $BalanceAssertionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsFilterComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plannedFlowsRefs(
    Expression<bool> Function($PlannedFlowsFilterComposer f) f,
  ) {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsFilterComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CurrenciesOrderingComposer extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fractionDigits => $composableBuilder(
    column: $table.fractionDigits,
    builder: (column) => ColumnOrderings(column),
  );
}

class $CurrenciesAnnotationComposer
    extends Composer<_$AppDatabase, Currencies> {
  $CurrenciesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get fractionDigits => $composableBuilder(
    column: $table.fractionDigits,
    builder: (column) => column,
  );

  Expression<T> householdsRefs<T extends Object>(
    Expression<T> Function($HouseholdsAnnotationComposer a) f,
  ) {
    final $HouseholdsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.baseCurrency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($AccountsAnnotationComposer a) f,
  ) {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> postingsRefs<T extends Object>(
    Expression<T> Function($PostingsAnnotationComposer a) f,
  ) {
    final $PostingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsAnnotationComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> balanceAssertionsRefs<T extends Object>(
    Expression<T> Function($BalanceAssertionsAnnotationComposer a) f,
  ) {
    final $BalanceAssertionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsAnnotationComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plannedFlowsRefs<T extends Object>(
    Expression<T> Function($PlannedFlowsAnnotationComposer a) f,
  ) {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsAnnotationComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CurrenciesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Currencies,
          CurrencyRow,
          $CurrenciesFilterComposer,
          $CurrenciesOrderingComposer,
          $CurrenciesAnnotationComposer,
          $CurrenciesCreateCompanionBuilder,
          $CurrenciesUpdateCompanionBuilder,
          (CurrencyRow, $CurrenciesReferences),
          CurrencyRow,
          PrefetchHooks Function({
            bool householdsRefs,
            bool accountsRefs,
            bool postingsRefs,
            bool balanceAssertionsRefs,
            bool plannedFlowsRefs,
          })
        > {
  $CurrenciesTableManager(_$AppDatabase db, Currencies table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CurrenciesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CurrenciesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CurrenciesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<int> fractionDigits = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion(
                code: code,
                fractionDigits: fractionDigits,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required int fractionDigits,
                Value<int> rowid = const Value.absent(),
              }) => CurrenciesCompanion.insert(
                code: code,
                fractionDigits: fractionDigits,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Currencies, CurrencyRow>(table),
                  $CurrenciesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdsRefs = false,
                accountsRefs = false,
                postingsRefs = false,
                balanceAssertionsRefs = false,
                plannedFlowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (householdsRefs) db.households,
                    if (accountsRefs) db.accounts,
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (plannedFlowsRefs) db.plannedFlows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (householdsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          HouseholdRow,
                          Households
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._householdsRefsTable(db),
                          managerFromTypedResult: (p0) => $CurrenciesReferences(
                            db,
                            table,
                            p0,
                          ).householdsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'base_currency',
                          typedResults: items,
                        ),
                      if (accountsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          AccountRow,
                          Accounts
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._accountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CurrenciesReferences(db, table, p0).accountsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                      if (postingsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          PostingRow,
                          Postings
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._postingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CurrenciesReferences(db, table, p0).postingsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                      if (balanceAssertionsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          BalanceAssertionRow,
                          BalanceAssertions
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._balanceAssertionsRefsTable(db),
                          managerFromTypedResult: (p0) => $CurrenciesReferences(
                            db,
                            table,
                            p0,
                          ).balanceAssertionsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                      if (plannedFlowsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          PlannedFlowRow,
                          PlannedFlows
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._plannedFlowsRefsTable(db),
                          managerFromTypedResult: (p0) => $CurrenciesReferences(
                            db,
                            table,
                            p0,
                          ).plannedFlowsRefs,
                          currentColumn: 'code',
                          referencedColumn: 'currency',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CurrenciesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Currencies,
      CurrencyRow,
      $CurrenciesFilterComposer,
      $CurrenciesOrderingComposer,
      $CurrenciesAnnotationComposer,
      $CurrenciesCreateCompanionBuilder,
      $CurrenciesUpdateCompanionBuilder,
      (CurrencyRow, $CurrenciesReferences),
      CurrencyRow,
      PrefetchHooks Function({
        bool householdsRefs,
        bool accountsRefs,
        bool postingsRefs,
        bool balanceAssertionsRefs,
        bool plannedFlowsRefs,
      })
    >;
typedef $AccountKindsCreateCompanionBuilder = AccountKindsCompanion Function({
  required String kind,
  required String nature,
  Value<int> rowid,
});
typedef $AccountKindsUpdateCompanionBuilder = AccountKindsCompanion Function({
  Value<String> kind,
  Value<String> nature,
  Value<int> rowid,
});

final class $AccountKindsReferences
    extends BaseReferences<_$AppDatabase, AccountKinds, AccountKindRow> {
  $AccountKindsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<Accounts, List<AccountRow>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'account_kinds__kind__accounts__kind',
  );

  $AccountsProcessedTableManager get accountsRefs {
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.kind.kind.sqlEquals($_itemColumn<String>('kind')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AccountKindsFilterComposer
    extends Composer<_$AppDatabase, AccountKinds> {
  $AccountKindsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($AccountsFilterComposer f) f,
  ) {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountKindsOrderingComposer
    extends Composer<_$AppDatabase, AccountKinds> {
  $AccountKindsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nature => $composableBuilder(
    column: $table.nature,
    builder: (column) => ColumnOrderings(column),
  );
}

class $AccountKindsAnnotationComposer
    extends Composer<_$AppDatabase, AccountKinds> {
  $AccountKindsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get nature =>
      $composableBuilder(column: $table.nature, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($AccountsAnnotationComposer a) f,
  ) {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountKindsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AccountKinds,
          AccountKindRow,
          $AccountKindsFilterComposer,
          $AccountKindsOrderingComposer,
          $AccountKindsAnnotationComposer,
          $AccountKindsCreateCompanionBuilder,
          $AccountKindsUpdateCompanionBuilder,
          (AccountKindRow, $AccountKindsReferences),
          AccountKindRow,
          PrefetchHooks Function({bool accountsRefs})
        > {
  $AccountKindsTableManager(_$AppDatabase db, AccountKinds table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountKindsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountKindsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountKindsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> kind = const Value.absent(),
            Value<String> nature = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AccountKindsCompanion(kind: kind, nature: nature, rowid: rowid),
          createCompanionCallback:
              ({
                required String kind,
                required String nature,
                Value<int> rowid = const Value.absent(),
              }) => AccountKindsCompanion.insert(
                kind: kind,
                nature: nature,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AccountKinds, AccountKindRow>(table),
                  $AccountKindsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountsRefs) db.accounts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedDataByColumns<
                      AccountKindRow,
                      AccountKinds,
                      AccountRow,
                      Accounts
                    >(
                      currentTable: table,
                      referencedTable: $AccountKindsReferences
                          ._accountsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $AccountKindsReferences(db, table, p0).accountsRefs,
                      currentColumn: 'kind',
                      referencedColumn: 'kind',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $AccountKindsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AccountKinds,
      AccountKindRow,
      $AccountKindsFilterComposer,
      $AccountKindsOrderingComposer,
      $AccountKindsAnnotationComposer,
      $AccountKindsCreateCompanionBuilder,
      $AccountKindsUpdateCompanionBuilder,
      (AccountKindRow, $AccountKindsReferences),
      AccountKindRow,
      PrefetchHooks Function({bool accountsRefs})
    >;
typedef $EntryKindsCreateCompanionBuilder = EntryKindsCompanion Function({
  required String kind,
  Value<int> rowid,
});
typedef $EntryKindsUpdateCompanionBuilder = EntryKindsCompanion Function({
  Value<String> kind,
  Value<int> rowid,
});

final class $EntryKindsReferences
    extends BaseReferences<_$AppDatabase, EntryKinds, EntryKindRow> {
  $EntryKindsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<JournalEntries, List<JournalEntryRow>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: 'entry_kinds__kind__journal_entries__kind',
  );

  $JournalEntriesProcessedTableManager get journalEntriesRefs {
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.kind.kind.sqlEquals($_itemColumn<String>('kind')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $EntryKindsFilterComposer extends Composer<_$AppDatabase, EntryKinds> {
  $EntryKindsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($JournalEntriesFilterComposer f) f,
  ) {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EntryKindsOrderingComposer extends Composer<_$AppDatabase, EntryKinds> {
  $EntryKindsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );
}

class $EntryKindsAnnotationComposer
    extends Composer<_$AppDatabase, EntryKinds> {
  $EntryKindsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($JournalEntriesAnnotationComposer a) f,
  ) {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $EntryKindsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          EntryKinds,
          EntryKindRow,
          $EntryKindsFilterComposer,
          $EntryKindsOrderingComposer,
          $EntryKindsAnnotationComposer,
          $EntryKindsCreateCompanionBuilder,
          $EntryKindsUpdateCompanionBuilder,
          (EntryKindRow, $EntryKindsReferences),
          EntryKindRow,
          PrefetchHooks Function({bool journalEntriesRefs})
        > {
  $EntryKindsTableManager(_$AppDatabase db, EntryKinds table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EntryKindsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EntryKindsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EntryKindsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> kind = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => EntryKindsCompanion(kind: kind, rowid: rowid),
          createCompanionCallback: ({
            required String kind,
            Value<int> rowid = const Value.absent(),
          }) => EntryKindsCompanion.insert(kind: kind, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<EntryKinds, EntryKindRow>(table),
                  $EntryKindsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journalEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (journalEntriesRefs) db.journalEntries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalEntriesRefs)
                    await $_getPrefetchedDataByColumns<
                      EntryKindRow,
                      EntryKinds,
                      JournalEntryRow,
                      JournalEntries
                    >(
                      currentTable: table,
                      referencedTable: $EntryKindsReferences
                          ._journalEntriesRefsTable(db),
                      managerFromTypedResult: (p0) => $EntryKindsReferences(
                        db,
                        table,
                        p0,
                      ).journalEntriesRefs,
                      currentColumn: 'kind',
                      referencedColumn: 'kind',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $EntryKindsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      EntryKinds,
      EntryKindRow,
      $EntryKindsFilterComposer,
      $EntryKindsOrderingComposer,
      $EntryKindsAnnotationComposer,
      $EntryKindsCreateCompanionBuilder,
      $EntryKindsUpdateCompanionBuilder,
      (EntryKindRow, $EntryKindsReferences),
      EntryKindRow,
      PrefetchHooks Function({bool journalEntriesRefs})
    >;
typedef $DataSourcesCreateCompanionBuilder = DataSourcesCompanion Function({
  required String source,
  Value<int> rowid,
});
typedef $DataSourcesUpdateCompanionBuilder = DataSourcesCompanion Function({
  Value<String> source,
  Value<int> rowid,
});

final class $DataSourcesReferences
    extends BaseReferences<_$AppDatabase, DataSources, DataSourceRow> {
  $DataSourcesReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<JournalEntries, List<JournalEntryRow>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: 'data_sources__source__journal_entries__source',
  );

  $JournalEntriesProcessedTableManager get journalEntriesRefs {
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.source.source.sqlEquals($_itemColumn<String>('source')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<BalanceAssertions, List<BalanceAssertionRow>>
  _balanceAssertionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.balanceAssertions,
        aliasName: 'data_sources__source__balance_assertions__source',
      );

  $BalanceAssertionsProcessedTableManager get balanceAssertionsRefs {
    final manager = $BalanceAssertionsTableManager(
      $_db,
      $_db.balanceAssertions,
    ).filter((f) => f.source.source.sqlEquals($_itemColumn<String>('source')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceAssertionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CardFigures, List<CardFiguresRow>>
  _cardFiguresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardFigures,
    aliasName: 'data_sources__source__card_figures__source',
  );

  $CardFiguresProcessedTableManager get cardFiguresRefs {
    final manager = $CardFiguresTableManager(
      $_db,
      $_db.cardFigures,
    ).filter((f) => f.source.source.sqlEquals($_itemColumn<String>('source')!));

    final cache = $_typedResult.readTableOrNull(_cardFiguresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $DataSourcesFilterComposer extends Composer<_$AppDatabase, DataSources> {
  $DataSourcesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($JournalEntriesFilterComposer f) f,
  ) {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> balanceAssertionsRefs(
    Expression<bool> Function($BalanceAssertionsFilterComposer f) f,
  ) {
    final $BalanceAssertionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsFilterComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardFiguresRefs(
    Expression<bool> Function($CardFiguresFilterComposer f) f,
  ) {
    final $CardFiguresFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresFilterComposer(
            $db: $db,
            $table: $db.cardFigures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DataSourcesOrderingComposer
    extends Composer<_$AppDatabase, DataSources> {
  $DataSourcesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DataSourcesAnnotationComposer
    extends Composer<_$AppDatabase, DataSources> {
  $DataSourcesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($JournalEntriesAnnotationComposer a) f,
  ) {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> balanceAssertionsRefs<T extends Object>(
    Expression<T> Function($BalanceAssertionsAnnotationComposer a) f,
  ) {
    final $BalanceAssertionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsAnnotationComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardFiguresRefs<T extends Object>(
    Expression<T> Function($CardFiguresAnnotationComposer a) f,
  ) {
    final $CardFiguresAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresAnnotationComposer(
            $db: $db,
            $table: $db.cardFigures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $DataSourcesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DataSources,
          DataSourceRow,
          $DataSourcesFilterComposer,
          $DataSourcesOrderingComposer,
          $DataSourcesAnnotationComposer,
          $DataSourcesCreateCompanionBuilder,
          $DataSourcesUpdateCompanionBuilder,
          (DataSourceRow, $DataSourcesReferences),
          DataSourceRow,
          PrefetchHooks Function({
            bool journalEntriesRefs,
            bool balanceAssertionsRefs,
            bool cardFiguresRefs,
          })
        > {
  $DataSourcesTableManager(_$AppDatabase db, DataSources table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DataSourcesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DataSourcesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DataSourcesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> source = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => DataSourcesCompanion(source: source, rowid: rowid),
          createCompanionCallback: ({
            required String source,
            Value<int> rowid = const Value.absent(),
          }) => DataSourcesCompanion.insert(source: source, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DataSources, DataSourceRow>(table),
                  $DataSourcesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                journalEntriesRefs = false,
                balanceAssertionsRefs = false,
                cardFiguresRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalEntriesRefs) db.journalEntries,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (cardFiguresRefs) db.cardFigures,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          DataSourceRow,
                          DataSources,
                          JournalEntryRow,
                          JournalEntries
                        >(
                          currentTable: table,
                          referencedTable: $DataSourcesReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $DataSourcesReferences(
                                db,
                                table,
                                p0,
                              ).journalEntriesRefs,
                          currentColumn: 'source',
                          referencedColumn: 'source',
                          typedResults: items,
                        ),
                      if (balanceAssertionsRefs)
                        await $_getPrefetchedDataByColumns<
                          DataSourceRow,
                          DataSources,
                          BalanceAssertionRow,
                          BalanceAssertions
                        >(
                          currentTable: table,
                          referencedTable: $DataSourcesReferences
                              ._balanceAssertionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $DataSourcesReferences(
                                db,
                                table,
                                p0,
                              ).balanceAssertionsRefs,
                          currentColumn: 'source',
                          referencedColumn: 'source',
                          typedResults: items,
                        ),
                      if (cardFiguresRefs)
                        await $_getPrefetchedDataByColumns<
                          DataSourceRow,
                          DataSources,
                          CardFiguresRow,
                          CardFigures
                        >(
                          currentTable: table,
                          referencedTable: $DataSourcesReferences
                              ._cardFiguresRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $DataSourcesReferences(
                                db,
                                table,
                                p0,
                              ).cardFiguresRefs,
                          currentColumn: 'source',
                          referencedColumn: 'source',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $DataSourcesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DataSources,
      DataSourceRow,
      $DataSourcesFilterComposer,
      $DataSourcesOrderingComposer,
      $DataSourcesAnnotationComposer,
      $DataSourcesCreateCompanionBuilder,
      $DataSourcesUpdateCompanionBuilder,
      (DataSourceRow, $DataSourcesReferences),
      DataSourceRow,
      PrefetchHooks Function({
        bool journalEntriesRefs,
        bool balanceAssertionsRefs,
        bool cardFiguresRefs,
      })
    >;
typedef $HouseholdsCreateCompanionBuilder = HouseholdsCompanion Function({
  required String id,
  required String baseCurrency,
  required int reserveMinor,
  required int createdAtUtc,
  Value<int> rowid,
});
typedef $HouseholdsUpdateCompanionBuilder = HouseholdsCompanion Function({
  Value<String> id,
  Value<String> baseCurrency,
  Value<int> reserveMinor,
  Value<int> createdAtUtc,
  Value<int> rowid,
});

final class $HouseholdsReferences
    extends BaseReferences<_$AppDatabase, Households, HouseholdRow> {
  $HouseholdsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Currencies _baseCurrencyTable(_$AppDatabase db) =>
      db.currencies.createAlias('households__base_currency__currencies__code');

  $CurrenciesProcessedTableManager get baseCurrency {
    final $_column = $_itemColumn<String>('base_currency')!;

    final manager = $CurrenciesTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_baseCurrencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Members, List<MemberRow>> _membersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.members,
    aliasName: 'households__id__members__household_id',
  );

  $MembersProcessedTableManager get membersRefs {
    final manager = $MembersTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_membersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Accounts, List<AccountRow>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'households__id__accounts__household_id',
  );

  $AccountsProcessedTableManager get accountsRefs {
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<JournalEntries, List<JournalEntryRow>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: 'households__id__journal_entries__household_id',
  );

  $JournalEntriesProcessedTableManager get journalEntriesRefs {
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<PlannedFlows, List<PlannedFlowRow>>
  _plannedFlowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedFlows,
    aliasName: 'households__id__planned_flows__household_id',
  );

  $PlannedFlowsProcessedTableManager get plannedFlowsRefs {
    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plannedFlowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $HouseholdsFilterComposer extends Composer<_$AppDatabase, Households> {
  $HouseholdsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reserveMinor => $composableBuilder(
    column: $table.reserveMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $CurrenciesFilterComposer get baseCurrency {
    final $CurrenciesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> membersRefs(
    Expression<bool> Function($MembersFilterComposer f) f,
  ) {
    final $MembersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountsRefs(
    Expression<bool> Function($AccountsFilterComposer f) f,
  ) {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($JournalEntriesFilterComposer f) f,
  ) {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plannedFlowsRefs(
    Expression<bool> Function($PlannedFlowsFilterComposer f) f,
  ) {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsFilterComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $HouseholdsOrderingComposer extends Composer<_$AppDatabase, Households> {
  $HouseholdsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reserveMinor => $composableBuilder(
    column: $table.reserveMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $CurrenciesOrderingComposer get baseCurrency {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $HouseholdsAnnotationComposer
    extends Composer<_$AppDatabase, Households> {
  $HouseholdsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get reserveMinor => $composableBuilder(
    column: $table.reserveMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $CurrenciesAnnotationComposer get baseCurrency {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.baseCurrency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> membersRefs<T extends Object>(
    Expression<T> Function($MembersAnnotationComposer a) f,
  ) {
    final $MembersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($AccountsAnnotationComposer a) f,
  ) {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($JournalEntriesAnnotationComposer a) f,
  ) {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plannedFlowsRefs<T extends Object>(
    Expression<T> Function($PlannedFlowsAnnotationComposer a) f,
  ) {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsAnnotationComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $HouseholdsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Households,
          HouseholdRow,
          $HouseholdsFilterComposer,
          $HouseholdsOrderingComposer,
          $HouseholdsAnnotationComposer,
          $HouseholdsCreateCompanionBuilder,
          $HouseholdsUpdateCompanionBuilder,
          (HouseholdRow, $HouseholdsReferences),
          HouseholdRow,
          PrefetchHooks Function({
            bool baseCurrency,
            bool membersRefs,
            bool accountsRefs,
            bool journalEntriesRefs,
            bool plannedFlowsRefs,
          })
        > {
  $HouseholdsTableManager(_$AppDatabase db, Households table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $HouseholdsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $HouseholdsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $HouseholdsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<int> reserveMinor = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HouseholdsCompanion(
                id: id,
                baseCurrency: baseCurrency,
                reserveMinor: reserveMinor,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String baseCurrency,
                required int reserveMinor,
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => HouseholdsCompanion.insert(
                id: id,
                baseCurrency: baseCurrency,
                reserveMinor: reserveMinor,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Households, HouseholdRow>(table),
                  $HouseholdsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                baseCurrency = false,
                membersRefs = false,
                accountsRefs = false,
                journalEntriesRefs = false,
                plannedFlowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (membersRefs) db.members,
                    if (accountsRefs) db.accounts,
                    if (journalEntriesRefs) db.journalEntries,
                    if (plannedFlowsRefs) db.plannedFlows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (baseCurrency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.baseCurrency,
                            referencedTable: $HouseholdsReferences
                                ._baseCurrencyTable(db),
                            referencedColumn: $HouseholdsReferences
                                ._baseCurrencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (membersRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          MemberRow,
                          Members
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._membersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $HouseholdsReferences(db, table, p0).membersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (accountsRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          AccountRow,
                          Accounts
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._accountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $HouseholdsReferences(db, table, p0).accountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (journalEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          JournalEntryRow,
                          JournalEntries
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).journalEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (plannedFlowsRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          PlannedFlowRow,
                          PlannedFlows
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._plannedFlowsRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).plannedFlowsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $HouseholdsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Households,
      HouseholdRow,
      $HouseholdsFilterComposer,
      $HouseholdsOrderingComposer,
      $HouseholdsAnnotationComposer,
      $HouseholdsCreateCompanionBuilder,
      $HouseholdsUpdateCompanionBuilder,
      (HouseholdRow, $HouseholdsReferences),
      HouseholdRow,
      PrefetchHooks Function({
        bool baseCurrency,
        bool membersRefs,
        bool accountsRefs,
        bool journalEntriesRefs,
        bool plannedFlowsRefs,
      })
    >;
typedef $MembersCreateCompanionBuilder = MembersCompanion Function({
  required String id,
  required String householdId,
  required int createdAtUtc,
  Value<int> rowid,
});
typedef $MembersUpdateCompanionBuilder = MembersCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<int> createdAtUtc,
  Value<int> rowid,
});

final class $MembersReferences
    extends BaseReferences<_$AppDatabase, Members, MemberRow> {
  $MembersReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias('members__household_id__households__id');

  $HouseholdsProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $HouseholdsTableManager(
      $_db,
      $_db.households,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Accounts, List<AccountRow>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'members__id__accounts__owner_member_id',
  );

  $AccountsProcessedTableManager get accountsRefs {
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.ownerMemberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<JournalEntries, List<JournalEntryRow>>
  _journalEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalEntries,
    aliasName: 'members__id__journal_entries__actor_member_id',
  );

  $JournalEntriesProcessedTableManager get journalEntriesRefs {
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.actorMemberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $MembersFilterComposer extends Composer<_$AppDatabase, Members> {
  $MembersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $HouseholdsFilterComposer get householdId {
    final $HouseholdsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> accountsRefs(
    Expression<bool> Function($AccountsFilterComposer f) f,
  ) {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.ownerMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> journalEntriesRefs(
    Expression<bool> Function($JournalEntriesFilterComposer f) f,
  ) {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.actorMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $MembersOrderingComposer extends Composer<_$AppDatabase, Members> {
  $MembersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $HouseholdsOrderingComposer get householdId {
    final $HouseholdsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsOrderingComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $MembersAnnotationComposer extends Composer<_$AppDatabase, Members> {
  $MembersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $HouseholdsAnnotationComposer get householdId {
    final $HouseholdsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($AccountsAnnotationComposer a) f,
  ) {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.ownerMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> journalEntriesRefs<T extends Object>(
    Expression<T> Function($JournalEntriesAnnotationComposer a) f,
  ) {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.actorMemberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $MembersTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Members,
          MemberRow,
          $MembersFilterComposer,
          $MembersOrderingComposer,
          $MembersAnnotationComposer,
          $MembersCreateCompanionBuilder,
          $MembersUpdateCompanionBuilder,
          (MemberRow, $MembersReferences),
          MemberRow,
          PrefetchHooks Function({
            bool householdId,
            bool accountsRefs,
            bool journalEntriesRefs,
          })
        > {
  $MembersTableManager(_$AppDatabase db, Members table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $MembersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $MembersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $MembersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                householdId: householdId,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                householdId: householdId,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Members, MemberRow>(table),
                  $MembersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                accountsRefs = false,
                journalEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (accountsRefs) db.accounts,
                    if (journalEntriesRefs) db.journalEntries,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (householdId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.householdId,
                            referencedTable: $MembersReferences
                                ._householdIdTable(db),
                            referencedColumn: $MembersReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (accountsRefs)
                        await $_getPrefetchedDataByColumns<
                          MemberRow,
                          Members,
                          AccountRow,
                          Accounts
                        >(
                          currentTable: table,
                          referencedTable: $MembersReferences
                              ._accountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $MembersReferences(db, table, p0).accountsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'owner_member_id',
                          typedResults: items,
                        ),
                      if (journalEntriesRefs)
                        await $_getPrefetchedDataByColumns<
                          MemberRow,
                          Members,
                          JournalEntryRow,
                          JournalEntries
                        >(
                          currentTable: table,
                          referencedTable: $MembersReferences
                              ._journalEntriesRefsTable(db),
                          managerFromTypedResult: (p0) => $MembersReferences(
                            db,
                            table,
                            p0,
                          ).journalEntriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'actor_member_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $MembersProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Members,
      MemberRow,
      $MembersFilterComposer,
      $MembersOrderingComposer,
      $MembersAnnotationComposer,
      $MembersCreateCompanionBuilder,
      $MembersUpdateCompanionBuilder,
      (MemberRow, $MembersReferences),
      MemberRow,
      PrefetchHooks Function({
        bool householdId,
        bool accountsRefs,
        bool journalEntriesRefs,
      })
    >;
typedef $AccountsCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String householdId,
  required String kind,
  required String name,
  required String currency,
  Value<String?> ownerMemberId,
  required String visibility,
  required int isProtected,
  Value<int?> creditLimitMinor,
  required int sortOrder,
  required int createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});
typedef $AccountsUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> kind,
  Value<String> name,
  Value<String> currency,
  Value<String?> ownerMemberId,
  Value<String> visibility,
  Value<int> isProtected,
  Value<int?> creditLimitMinor,
  Value<int> sortOrder,
  Value<int> createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});

final class $AccountsReferences
    extends BaseReferences<_$AppDatabase, Accounts, AccountRow> {
  $AccountsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias('accounts__household_id__households__id');

  $HouseholdsProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $HouseholdsTableManager(
      $_db,
      $_db.households,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static AccountKinds _kindTable(_$AppDatabase db) =>
      db.accountKinds.createAlias('accounts__kind__account_kinds__kind');

  $AccountKindsProcessedTableManager get kind {
    final $_column = $_itemColumn<String>('kind')!;

    final manager = $AccountKindsTableManager(
      $_db,
      $_db.accountKinds,
    ).filter((f) => f.kind.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kindTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Currencies _currencyTable(_$AppDatabase db) =>
      db.currencies.createAlias('accounts__currency__currencies__code');

  $CurrenciesProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $CurrenciesTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Members _ownerMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('accounts__owner_member_id__members__id');

  $MembersProcessedTableManager? get ownerMemberId {
    final $_column = $_itemColumn<String>('owner_member_id');
    if ($_column == null) return null;
    final manager = $MembersTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ownerMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Postings, List<PostingRow>> _postingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.postings,
    aliasName: 'accounts__id__postings__account_id',
  );

  $PostingsProcessedTableManager get postingsRefs {
    final manager = $PostingsTableManager(
      $_db,
      $_db.postings,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<BalanceAssertions, List<BalanceAssertionRow>>
  _balanceAssertionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.balanceAssertions,
        aliasName: 'accounts__id__balance_assertions__account_id',
      );

  $BalanceAssertionsProcessedTableManager get balanceAssertionsRefs {
    final manager = $BalanceAssertionsTableManager(
      $_db,
      $_db.balanceAssertions,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceAssertionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<PlannedFlows, List<PlannedFlowRow>>
  _plannedFlowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedFlows,
    aliasName: 'accounts__id__planned_flows__account_id',
  );

  $PlannedFlowsProcessedTableManager get plannedFlowsRefs {
    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_plannedFlowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<CardFigures, List<CardFiguresRow>>
  _cardFiguresRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardFigures,
    aliasName: 'accounts__id__card_figures__account_id',
  );

  $CardFiguresProcessedTableManager get cardFiguresRefs {
    final manager = $CardFiguresTableManager(
      $_db,
      $_db.cardFigures,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardFiguresRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $AccountsFilterComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $HouseholdsFilterComposer get householdId {
    final $HouseholdsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountKindsFilterComposer get kind {
    final $AccountKindsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.accountKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountKindsFilterComposer(
            $db: $db,
            $table: $db.accountKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesFilterComposer get currency {
    final $CurrenciesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersFilterComposer get ownerMemberId {
    final $MembersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postingsRefs(
    Expression<bool> Function($PostingsFilterComposer f) f,
  ) {
    final $PostingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsFilterComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> balanceAssertionsRefs(
    Expression<bool> Function($BalanceAssertionsFilterComposer f) f,
  ) {
    final $BalanceAssertionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsFilterComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> plannedFlowsRefs(
    Expression<bool> Function($PlannedFlowsFilterComposer f) f,
  ) {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsFilterComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cardFiguresRefs(
    Expression<bool> Function($CardFiguresFilterComposer f) f,
  ) {
    final $CardFiguresFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresFilterComposer(
            $db: $db,
            $table: $db.cardFigures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountsOrderingComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $HouseholdsOrderingComposer get householdId {
    final $HouseholdsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsOrderingComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountKindsOrderingComposer get kind {
    final $AccountKindsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.accountKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountKindsOrderingComposer(
            $db: $db,
            $table: $db.accountKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesOrderingComposer get currency {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersOrderingComposer get ownerMemberId {
    final $MembersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AccountsAnnotationComposer extends Composer<_$AppDatabase, Accounts> {
  $AccountsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get visibility => $composableBuilder(
    column: $table.visibility,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isProtected => $composableBuilder(
    column: $table.isProtected,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditLimitMinor => $composableBuilder(
    column: $table.creditLimitMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => column,
  );

  $HouseholdsAnnotationComposer get householdId {
    final $HouseholdsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountKindsAnnotationComposer get kind {
    final $AccountKindsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.accountKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountKindsAnnotationComposer(
            $db: $db,
            $table: $db.accountKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesAnnotationComposer get currency {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersAnnotationComposer get ownerMemberId {
    final $MembersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ownerMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postingsRefs<T extends Object>(
    Expression<T> Function($PostingsAnnotationComposer a) f,
  ) {
    final $PostingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsAnnotationComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> balanceAssertionsRefs<T extends Object>(
    Expression<T> Function($BalanceAssertionsAnnotationComposer a) f,
  ) {
    final $BalanceAssertionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsAnnotationComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> plannedFlowsRefs<T extends Object>(
    Expression<T> Function($PlannedFlowsAnnotationComposer a) f,
  ) {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsAnnotationComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cardFiguresRefs<T extends Object>(
    Expression<T> Function($CardFiguresAnnotationComposer a) f,
  ) {
    final $CardFiguresAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresAnnotationComposer(
            $db: $db,
            $table: $db.cardFigures,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $AccountsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Accounts,
          AccountRow,
          $AccountsFilterComposer,
          $AccountsOrderingComposer,
          $AccountsAnnotationComposer,
          $AccountsCreateCompanionBuilder,
          $AccountsUpdateCompanionBuilder,
          (AccountRow, $AccountsReferences),
          AccountRow,
          PrefetchHooks Function({
            bool householdId,
            bool kind,
            bool currency,
            bool ownerMemberId,
            bool postingsRefs,
            bool balanceAssertionsRefs,
            bool plannedFlowsRefs,
            bool cardFiguresRefs,
          })
        > {
  $AccountsTableManager(_$AppDatabase db, Accounts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AccountsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AccountsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AccountsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> ownerMemberId = const Value.absent(),
                Value<String> visibility = const Value.absent(),
                Value<int> isProtected = const Value.absent(),
                Value<int?> creditLimitMinor = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                householdId: householdId,
                kind: kind,
                name: name,
                currency: currency,
                ownerMemberId: ownerMemberId,
                visibility: visibility,
                isProtected: isProtected,
                creditLimitMinor: creditLimitMinor,
                sortOrder: sortOrder,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String kind,
                required String name,
                required String currency,
                Value<String?> ownerMemberId = const Value.absent(),
                required String visibility,
                required int isProtected,
                Value<int?> creditLimitMinor = const Value.absent(),
                required int sortOrder,
                required int createdAtUtc,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                householdId: householdId,
                kind: kind,
                name: name,
                currency: currency,
                ownerMemberId: ownerMemberId,
                visibility: visibility,
                isProtected: isProtected,
                creditLimitMinor: creditLimitMinor,
                sortOrder: sortOrder,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Accounts, AccountRow>(table),
                  $AccountsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                kind = false,
                currency = false,
                ownerMemberId = false,
                postingsRefs = false,
                balanceAssertionsRefs = false,
                plannedFlowsRefs = false,
                cardFiguresRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (plannedFlowsRefs) db.plannedFlows,
                    if (cardFiguresRefs) db.cardFigures,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (householdId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.householdId,
                            referencedTable: $AccountsReferences
                                ._householdIdTable(db),
                            referencedColumn: $AccountsReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (kind) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.kind,
                            referencedTable: $AccountsReferences._kindTable(db),
                            referencedColumn: $AccountsReferences
                                ._kindTable(db)
                                .kind,
                          ) as T;
                        }
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $AccountsReferences._currencyTable(
                              db,
                            ),
                            referencedColumn: $AccountsReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }
                        if (ownerMemberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ownerMemberId,
                            referencedTable: $AccountsReferences
                                ._ownerMemberIdTable(db),
                            referencedColumn: $AccountsReferences
                                ._ownerMemberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postingsRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          PostingRow,
                          Postings
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._postingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $AccountsReferences(db, table, p0).postingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (balanceAssertionsRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          BalanceAssertionRow,
                          BalanceAssertions
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._balanceAssertionsRefsTable(db),
                          managerFromTypedResult: (p0) => $AccountsReferences(
                            db,
                            table,
                            p0,
                          ).balanceAssertionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (plannedFlowsRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          PlannedFlowRow,
                          PlannedFlows
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._plannedFlowsRefsTable(db),
                          managerFromTypedResult: (p0) => $AccountsReferences(
                            db,
                            table,
                            p0,
                          ).plannedFlowsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (cardFiguresRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          CardFiguresRow,
                          CardFigures
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._cardFiguresRefsTable(db),
                          managerFromTypedResult: (p0) => $AccountsReferences(
                            db,
                            table,
                            p0,
                          ).cardFiguresRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $AccountsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Accounts,
      AccountRow,
      $AccountsFilterComposer,
      $AccountsOrderingComposer,
      $AccountsAnnotationComposer,
      $AccountsCreateCompanionBuilder,
      $AccountsUpdateCompanionBuilder,
      (AccountRow, $AccountsReferences),
      AccountRow,
      PrefetchHooks Function({
        bool householdId,
        bool kind,
        bool currency,
        bool ownerMemberId,
        bool postingsRefs,
        bool balanceAssertionsRefs,
        bool plannedFlowsRefs,
        bool cardFiguresRefs,
      })
    >;
typedef $JournalEntriesCreateCompanionBuilder =
    JournalEntriesCompanion Function({
      required String id,
      required String householdId,
      required String commandId,
      required String kind,
      required String source,
      Value<String?> actorMemberId,
      required int occurredAtUtc,
      required int recordedAtUtc,
      Value<int> rowid,
    });
typedef $JournalEntriesUpdateCompanionBuilder =
    JournalEntriesCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> commandId,
      Value<String> kind,
      Value<String> source,
      Value<String?> actorMemberId,
      Value<int> occurredAtUtc,
      Value<int> recordedAtUtc,
      Value<int> rowid,
    });

final class $JournalEntriesReferences
    extends BaseReferences<_$AppDatabase, JournalEntries, JournalEntryRow> {
  $JournalEntriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('journal_entries__household_id__households__id');

  $HouseholdsProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $HouseholdsTableManager(
      $_db,
      $_db.households,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static EntryKinds _kindTable(_$AppDatabase db) =>
      db.entryKinds.createAlias('journal_entries__kind__entry_kinds__kind');

  $EntryKindsProcessedTableManager get kind {
    final $_column = $_itemColumn<String>('kind')!;

    final manager = $EntryKindsTableManager(
      $_db,
      $_db.entryKinds,
    ).filter((f) => f.kind.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kindTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static DataSources _sourceTable(_$AppDatabase db) => db.dataSources
      .createAlias('journal_entries__source__data_sources__source');

  $DataSourcesProcessedTableManager get source {
    final $_column = $_itemColumn<String>('source')!;

    final manager = $DataSourcesTableManager(
      $_db,
      $_db.dataSources,
    ).filter((f) => f.source.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Members _actorMemberIdTable(_$AppDatabase db) =>
      db.members.createAlias('journal_entries__actor_member_id__members__id');

  $MembersProcessedTableManager? get actorMemberId {
    final $_column = $_itemColumn<String>('actor_member_id');
    if ($_column == null) return null;
    final manager = $MembersTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actorMemberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<Postings, List<PostingRow>> _postingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.postings,
    aliasName: 'journal_entries__id__postings__entry_id',
  );

  $PostingsProcessedTableManager get postingsRefs {
    final manager = $PostingsTableManager(
      $_db,
      $_db.postings,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_postingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<BalanceAssertions, List<BalanceAssertionRow>>
  _balanceAssertionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.balanceAssertions,
        aliasName: 'journal_entries__id__balance_assertions__entry_id',
      );

  $BalanceAssertionsProcessedTableManager get balanceAssertionsRefs {
    final manager = $BalanceAssertionsTableManager(
      $_db,
      $_db.balanceAssertions,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceAssertionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $JournalEntriesFilterComposer
    extends Composer<_$AppDatabase, JournalEntries> {
  $JournalEntriesFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $HouseholdsFilterComposer get householdId {
    final $HouseholdsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntryKindsFilterComposer get kind {
    final $EntryKindsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.entryKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntryKindsFilterComposer(
            $db: $db,
            $table: $db.entryKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesFilterComposer get source {
    final $DataSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesFilterComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersFilterComposer get actorMemberId {
    final $MembersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actorMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersFilterComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> postingsRefs(
    Expression<bool> Function($PostingsFilterComposer f) f,
  ) {
    final $PostingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsFilterComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> balanceAssertionsRefs(
    Expression<bool> Function($BalanceAssertionsFilterComposer f) f,
  ) {
    final $BalanceAssertionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsFilterComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $JournalEntriesOrderingComposer
    extends Composer<_$AppDatabase, JournalEntries> {
  $JournalEntriesOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commandId => $composableBuilder(
    column: $table.commandId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $HouseholdsOrderingComposer get householdId {
    final $HouseholdsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsOrderingComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntryKindsOrderingComposer get kind {
    final $EntryKindsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.entryKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntryKindsOrderingComposer(
            $db: $db,
            $table: $db.entryKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesOrderingComposer get source {
    final $DataSourcesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesOrderingComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersOrderingComposer get actorMemberId {
    final $MembersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actorMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersOrderingComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $JournalEntriesAnnotationComposer
    extends Composer<_$AppDatabase, JournalEntries> {
  $JournalEntriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get commandId =>
      $composableBuilder(column: $table.commandId, builder: (column) => column);

  GeneratedColumn<int> get occurredAtUtc => $composableBuilder(
    column: $table.occurredAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => column,
  );

  $HouseholdsAnnotationComposer get householdId {
    final $HouseholdsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $EntryKindsAnnotationComposer get kind {
    final $EntryKindsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.entryKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $EntryKindsAnnotationComposer(
            $db: $db,
            $table: $db.entryKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesAnnotationComposer get source {
    final $DataSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesAnnotationComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $MembersAnnotationComposer get actorMemberId {
    final $MembersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actorMemberId,
      referencedTable: $db.members,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $MembersAnnotationComposer(
            $db: $db,
            $table: $db.members,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> postingsRefs<T extends Object>(
    Expression<T> Function($PostingsAnnotationComposer a) f,
  ) {
    final $PostingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.postings,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PostingsAnnotationComposer(
            $db: $db,
            $table: $db.postings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> balanceAssertionsRefs<T extends Object>(
    Expression<T> Function($BalanceAssertionsAnnotationComposer a) f,
  ) {
    final $BalanceAssertionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceAssertions,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $BalanceAssertionsAnnotationComposer(
            $db: $db,
            $table: $db.balanceAssertions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $JournalEntriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          JournalEntries,
          JournalEntryRow,
          $JournalEntriesFilterComposer,
          $JournalEntriesOrderingComposer,
          $JournalEntriesAnnotationComposer,
          $JournalEntriesCreateCompanionBuilder,
          $JournalEntriesUpdateCompanionBuilder,
          (JournalEntryRow, $JournalEntriesReferences),
          JournalEntryRow,
          PrefetchHooks Function({
            bool householdId,
            bool kind,
            bool source,
            bool actorMemberId,
            bool postingsRefs,
            bool balanceAssertionsRefs,
          })
        > {
  $JournalEntriesTableManager(_$AppDatabase db, JournalEntries table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $JournalEntriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $JournalEntriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $JournalEntriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> commandId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> actorMemberId = const Value.absent(),
                Value<int> occurredAtUtc = const Value.absent(),
                Value<int> recordedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion(
                id: id,
                householdId: householdId,
                commandId: commandId,
                kind: kind,
                source: source,
                actorMemberId: actorMemberId,
                occurredAtUtc: occurredAtUtc,
                recordedAtUtc: recordedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String commandId,
                required String kind,
                required String source,
                Value<String?> actorMemberId = const Value.absent(),
                required int occurredAtUtc,
                required int recordedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => JournalEntriesCompanion.insert(
                id: id,
                householdId: householdId,
                commandId: commandId,
                kind: kind,
                source: source,
                actorMemberId: actorMemberId,
                occurredAtUtc: occurredAtUtc,
                recordedAtUtc: recordedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<JournalEntries, JournalEntryRow>(table),
                  $JournalEntriesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                kind = false,
                source = false,
                actorMemberId = false,
                postingsRefs = false,
                balanceAssertionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (householdId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.householdId,
                            referencedTable: $JournalEntriesReferences
                                ._householdIdTable(db),
                            referencedColumn: $JournalEntriesReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (kind) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.kind,
                            referencedTable: $JournalEntriesReferences
                                ._kindTable(db),
                            referencedColumn: $JournalEntriesReferences
                                ._kindTable(db)
                                .kind,
                          ) as T;
                        }
                        if (source) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.source,
                            referencedTable: $JournalEntriesReferences
                                ._sourceTable(db),
                            referencedColumn: $JournalEntriesReferences
                                ._sourceTable(db)
                                .source,
                          ) as T;
                        }
                        if (actorMemberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.actorMemberId,
                            referencedTable: $JournalEntriesReferences
                                ._actorMemberIdTable(db),
                            referencedColumn: $JournalEntriesReferences
                                ._actorMemberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (postingsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntryRow,
                          JournalEntries,
                          PostingRow,
                          Postings
                        >(
                          currentTable: table,
                          referencedTable: $JournalEntriesReferences
                              ._postingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalEntriesReferences(
                                db,
                                table,
                                p0,
                              ).postingsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (balanceAssertionsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntryRow,
                          JournalEntries,
                          BalanceAssertionRow,
                          BalanceAssertions
                        >(
                          currentTable: table,
                          referencedTable: $JournalEntriesReferences
                              ._balanceAssertionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalEntriesReferences(
                                db,
                                table,
                                p0,
                              ).balanceAssertionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $JournalEntriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      JournalEntries,
      JournalEntryRow,
      $JournalEntriesFilterComposer,
      $JournalEntriesOrderingComposer,
      $JournalEntriesAnnotationComposer,
      $JournalEntriesCreateCompanionBuilder,
      $JournalEntriesUpdateCompanionBuilder,
      (JournalEntryRow, $JournalEntriesReferences),
      JournalEntryRow,
      PrefetchHooks Function({
        bool householdId,
        bool kind,
        bool source,
        bool actorMemberId,
        bool postingsRefs,
        bool balanceAssertionsRefs,
      })
    >;
typedef $PostingsCreateCompanionBuilder = PostingsCompanion Function({
  required String entryId,
  required int lineNo,
  required String accountId,
  required int amountMinor,
  required String currency,
  Value<int> rowid,
});
typedef $PostingsUpdateCompanionBuilder = PostingsCompanion Function({
  Value<String> entryId,
  Value<int> lineNo,
  Value<String> accountId,
  Value<int> amountMinor,
  Value<String> currency,
  Value<int> rowid,
});

final class $PostingsReferences
    extends BaseReferences<_$AppDatabase, Postings, PostingRow> {
  $PostingsReferences(super.$_db, super.$_table, super.$_typedResult);

  static JournalEntries _entryIdTable(_$AppDatabase db) =>
      db.journalEntries.createAlias('postings__entry_id__journal_entries__id');

  $JournalEntriesProcessedTableManager get entryId {
    final $_column = $_itemColumn<String>('entry_id')!;

    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Accounts _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('postings__account_id__accounts__id');

  $AccountsProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Currencies _currencyTable(_$AppDatabase db) =>
      db.currencies.createAlias('postings__currency__currencies__code');

  $CurrenciesProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $CurrenciesTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $PostingsFilterComposer extends Composer<_$AppDatabase, Postings> {
  $PostingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get lineNo => $composableBuilder(
    column: $table.lineNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  $JournalEntriesFilterComposer get entryId {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsFilterComposer get accountId {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesFilterComposer get currency {
    final $CurrenciesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PostingsOrderingComposer extends Composer<_$AppDatabase, Postings> {
  $PostingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get lineNo => $composableBuilder(
    column: $table.lineNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  $JournalEntriesOrderingComposer get entryId {
    final $JournalEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsOrderingComposer get accountId {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesOrderingComposer get currency {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PostingsAnnotationComposer extends Composer<_$AppDatabase, Postings> {
  $PostingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get lineNo =>
      $composableBuilder(column: $table.lineNo, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  $JournalEntriesAnnotationComposer get entryId {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsAnnotationComposer get accountId {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesAnnotationComposer get currency {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PostingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Postings,
          PostingRow,
          $PostingsFilterComposer,
          $PostingsOrderingComposer,
          $PostingsAnnotationComposer,
          $PostingsCreateCompanionBuilder,
          $PostingsUpdateCompanionBuilder,
          (PostingRow, $PostingsReferences),
          PostingRow,
          PrefetchHooks Function({bool entryId, bool accountId, bool currency})
        > {
  $PostingsTableManager(_$AppDatabase db, Postings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $PostingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $PostingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $PostingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entryId = const Value.absent(),
                Value<int> lineNo = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PostingsCompanion(
                entryId: entryId,
                lineNo: lineNo,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entryId,
                required int lineNo,
                required String accountId,
                required int amountMinor,
                required String currency,
                Value<int> rowid = const Value.absent(),
              }) => PostingsCompanion.insert(
                entryId: entryId,
                lineNo: lineNo,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Postings, PostingRow>(table),
                  $PostingsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({entryId = false, accountId = false, currency = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (entryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $PostingsReferences._entryIdTable(
                              db,
                            ),
                            referencedColumn: $PostingsReferences
                                ._entryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $PostingsReferences
                                ._accountIdTable(db),
                            referencedColumn: $PostingsReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $PostingsReferences._currencyTable(
                              db,
                            ),
                            referencedColumn: $PostingsReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $PostingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Postings,
      PostingRow,
      $PostingsFilterComposer,
      $PostingsOrderingComposer,
      $PostingsAnnotationComposer,
      $PostingsCreateCompanionBuilder,
      $PostingsUpdateCompanionBuilder,
      (PostingRow, $PostingsReferences),
      PostingRow,
      PrefetchHooks Function({bool entryId, bool accountId, bool currency})
    >;
typedef $BalanceAssertionsCreateCompanionBuilder =
    BalanceAssertionsCompanion Function({
      required String id,
      required String accountId,
      required int amountMinor,
      required String currency,
      required String source,
      Value<String?> entryId,
      required int assertedAtUtc,
      Value<int> rowid,
    });
typedef $BalanceAssertionsUpdateCompanionBuilder =
    BalanceAssertionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String> source,
      Value<String?> entryId,
      Value<int> assertedAtUtc,
      Value<int> rowid,
    });

final class $BalanceAssertionsReferences
    extends
        BaseReferences<_$AppDatabase, BalanceAssertions, BalanceAssertionRow> {
  $BalanceAssertionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Accounts _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('balance_assertions__account_id__accounts__id');

  $AccountsProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Currencies _currencyTable(_$AppDatabase db) => db.currencies
      .createAlias('balance_assertions__currency__currencies__code');

  $CurrenciesProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $CurrenciesTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static DataSources _sourceTable(_$AppDatabase db) => db.dataSources
      .createAlias('balance_assertions__source__data_sources__source');

  $DataSourcesProcessedTableManager get source {
    final $_column = $_itemColumn<String>('source')!;

    final manager = $DataSourcesTableManager(
      $_db,
      $_db.dataSources,
    ).filter((f) => f.source.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _entryIdTable(_$AppDatabase db) => db.journalEntries
      .createAlias('balance_assertions__entry_id__journal_entries__id');

  $JournalEntriesProcessedTableManager? get entryId {
    final $_column = $_itemColumn<String>('entry_id');
    if ($_column == null) return null;
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_entryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $BalanceAssertionsFilterComposer
    extends Composer<_$AppDatabase, BalanceAssertions> {
  $BalanceAssertionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assertedAtUtc => $composableBuilder(
    column: $table.assertedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $AccountsFilterComposer get accountId {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesFilterComposer get currency {
    final $CurrenciesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesFilterComposer get source {
    final $DataSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesFilterComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $JournalEntriesFilterComposer get entryId {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesFilterComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BalanceAssertionsOrderingComposer
    extends Composer<_$AppDatabase, BalanceAssertions> {
  $BalanceAssertionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assertedAtUtc => $composableBuilder(
    column: $table.assertedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $AccountsOrderingComposer get accountId {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesOrderingComposer get currency {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesOrderingComposer get source {
    final $DataSourcesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesOrderingComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $JournalEntriesOrderingComposer get entryId {
    final $JournalEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesOrderingComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BalanceAssertionsAnnotationComposer
    extends Composer<_$AppDatabase, BalanceAssertions> {
  $BalanceAssertionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get assertedAtUtc => $composableBuilder(
    column: $table.assertedAtUtc,
    builder: (column) => column,
  );

  $AccountsAnnotationComposer get accountId {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesAnnotationComposer get currency {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesAnnotationComposer get source {
    final $DataSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesAnnotationComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $JournalEntriesAnnotationComposer get entryId {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.entryId,
      referencedTable: $db.journalEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $JournalEntriesAnnotationComposer(
            $db: $db,
            $table: $db.journalEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $BalanceAssertionsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          BalanceAssertions,
          BalanceAssertionRow,
          $BalanceAssertionsFilterComposer,
          $BalanceAssertionsOrderingComposer,
          $BalanceAssertionsAnnotationComposer,
          $BalanceAssertionsCreateCompanionBuilder,
          $BalanceAssertionsUpdateCompanionBuilder,
          (BalanceAssertionRow, $BalanceAssertionsReferences),
          BalanceAssertionRow,
          PrefetchHooks Function({
            bool accountId,
            bool currency,
            bool source,
            bool entryId,
          })
        > {
  $BalanceAssertionsTableManager(_$AppDatabase db, BalanceAssertions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $BalanceAssertionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $BalanceAssertionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $BalanceAssertionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> entryId = const Value.absent(),
                Value<int> assertedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BalanceAssertionsCompanion(
                id: id,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                source: source,
                entryId: entryId,
                assertedAtUtc: assertedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required int amountMinor,
                required String currency,
                required String source,
                Value<String?> entryId = const Value.absent(),
                required int assertedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => BalanceAssertionsCompanion.insert(
                id: id,
                accountId: accountId,
                amountMinor: amountMinor,
                currency: currency,
                source: source,
                entryId: entryId,
                assertedAtUtc: assertedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<BalanceAssertions, BalanceAssertionRow>(table),
                  $BalanceAssertionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                currency = false,
                source = false,
                entryId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $BalanceAssertionsReferences
                                ._accountIdTable(db),
                            referencedColumn: $BalanceAssertionsReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $BalanceAssertionsReferences
                                ._currencyTable(db),
                            referencedColumn: $BalanceAssertionsReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }
                        if (source) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.source,
                            referencedTable: $BalanceAssertionsReferences
                                ._sourceTable(db),
                            referencedColumn: $BalanceAssertionsReferences
                                ._sourceTable(db)
                                .source,
                          ) as T;
                        }
                        if (entryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $BalanceAssertionsReferences
                                ._entryIdTable(db),
                            referencedColumn: $BalanceAssertionsReferences
                                ._entryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $BalanceAssertionsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      BalanceAssertions,
      BalanceAssertionRow,
      $BalanceAssertionsFilterComposer,
      $BalanceAssertionsOrderingComposer,
      $BalanceAssertionsAnnotationComposer,
      $BalanceAssertionsCreateCompanionBuilder,
      $BalanceAssertionsUpdateCompanionBuilder,
      (BalanceAssertionRow, $BalanceAssertionsReferences),
      BalanceAssertionRow,
      PrefetchHooks Function({
        bool accountId,
        bool currency,
        bool source,
        bool entryId,
      })
    >;
typedef $FlowKindsCreateCompanionBuilder = FlowKindsCompanion Function({
  required String kind,
  required String direction,
  Value<int> rowid,
});
typedef $FlowKindsUpdateCompanionBuilder = FlowKindsCompanion Function({
  Value<String> kind,
  Value<String> direction,
  Value<int> rowid,
});

final class $FlowKindsReferences
    extends BaseReferences<_$AppDatabase, FlowKinds, FlowKindRow> {
  $FlowKindsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<PlannedFlows, List<PlannedFlowRow>>
  _plannedFlowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.plannedFlows,
    aliasName: 'flow_kinds__kind__planned_flows__kind',
  );

  $PlannedFlowsProcessedTableManager get plannedFlowsRefs {
    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.kind.kind.sqlEquals($_itemColumn<String>('kind')!));

    final cache = $_typedResult.readTableOrNull(_plannedFlowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $FlowKindsFilterComposer extends Composer<_$AppDatabase, FlowKinds> {
  $FlowKindsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> plannedFlowsRefs(
    Expression<bool> Function($PlannedFlowsFilterComposer f) f,
  ) {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsFilterComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FlowKindsOrderingComposer extends Composer<_$AppDatabase, FlowKinds> {
  $FlowKindsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );
}

class $FlowKindsAnnotationComposer extends Composer<_$AppDatabase, FlowKinds> {
  $FlowKindsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  Expression<T> plannedFlowsRefs<T extends Object>(
    Expression<T> Function($PlannedFlowsAnnotationComposer a) f,
  ) {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsAnnotationComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $FlowKindsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FlowKinds,
          FlowKindRow,
          $FlowKindsFilterComposer,
          $FlowKindsOrderingComposer,
          $FlowKindsAnnotationComposer,
          $FlowKindsCreateCompanionBuilder,
          $FlowKindsUpdateCompanionBuilder,
          (FlowKindRow, $FlowKindsReferences),
          FlowKindRow,
          PrefetchHooks Function({bool plannedFlowsRefs})
        > {
  $FlowKindsTableManager(_$AppDatabase db, FlowKinds table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FlowKindsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FlowKindsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FlowKindsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlowKindsCompanion(
                kind: kind,
                direction: direction,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String kind,
                required String direction,
                Value<int> rowid = const Value.absent(),
              }) => FlowKindsCompanion.insert(
                kind: kind,
                direction: direction,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<FlowKinds, FlowKindRow>(table),
                  $FlowKindsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({plannedFlowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (plannedFlowsRefs) db.plannedFlows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (plannedFlowsRefs)
                    await $_getPrefetchedDataByColumns<
                      FlowKindRow,
                      FlowKinds,
                      PlannedFlowRow,
                      PlannedFlows
                    >(
                      currentTable: table,
                      referencedTable: $FlowKindsReferences
                          ._plannedFlowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $FlowKindsReferences(db, table, p0).plannedFlowsRefs,
                      currentColumn: 'kind',
                      referencedColumn: 'kind',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $FlowKindsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FlowKinds,
      FlowKindRow,
      $FlowKindsFilterComposer,
      $FlowKindsOrderingComposer,
      $FlowKindsAnnotationComposer,
      $FlowKindsCreateCompanionBuilder,
      $FlowKindsUpdateCompanionBuilder,
      (FlowKindRow, $FlowKindsReferences),
      FlowKindRow,
      PrefetchHooks Function({bool plannedFlowsRefs})
    >;
typedef $PlannedFlowsCreateCompanionBuilder = PlannedFlowsCompanion Function({
  required String id,
  required String householdId,
  required String kind,
  required String name,
  required int amountMinor,
  required String currency,
  Value<String?> accountId,
  required String cadence,
  Value<int?> day,
  Value<int?> month,
  Value<String?> onceOn,
  required String startsOn,
  required int createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});
typedef $PlannedFlowsUpdateCompanionBuilder = PlannedFlowsCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> kind,
  Value<String> name,
  Value<int> amountMinor,
  Value<String> currency,
  Value<String?> accountId,
  Value<String> cadence,
  Value<int?> day,
  Value<int?> month,
  Value<String?> onceOn,
  Value<String> startsOn,
  Value<int> createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});

final class $PlannedFlowsReferences
    extends BaseReferences<_$AppDatabase, PlannedFlows, PlannedFlowRow> {
  $PlannedFlowsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias('planned_flows__household_id__households__id');

  $HouseholdsProcessedTableManager get householdId {
    final $_column = $_itemColumn<String>('household_id')!;

    final manager = $HouseholdsTableManager(
      $_db,
      $_db.households,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_householdIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static FlowKinds _kindTable(_$AppDatabase db) =>
      db.flowKinds.createAlias('planned_flows__kind__flow_kinds__kind');

  $FlowKindsProcessedTableManager get kind {
    final $_column = $_itemColumn<String>('kind')!;

    final manager = $FlowKindsTableManager(
      $_db,
      $_db.flowKinds,
    ).filter((f) => f.kind.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_kindTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Currencies _currencyTable(_$AppDatabase db) =>
      db.currencies.createAlias('planned_flows__currency__currencies__code');

  $CurrenciesProcessedTableManager get currency {
    final $_column = $_itemColumn<String>('currency')!;

    final manager = $CurrenciesTableManager(
      $_db,
      $_db.currencies,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_currencyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Accounts _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('planned_flows__account_id__accounts__id');

  $AccountsProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<FlowMarks, List<FlowMarkRow>> _flowMarksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.flowMarks,
    aliasName: 'planned_flows__id__flow_marks__flow_id',
  );

  $FlowMarksProcessedTableManager get flowMarksRefs {
    final manager = $FlowMarksTableManager(
      $_db,
      $_db.flowMarks,
    ).filter((f) => f.flowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_flowMarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $PlannedFlowsFilterComposer
    extends Composer<_$AppDatabase, PlannedFlows> {
  $PlannedFlowsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onceOn => $composableBuilder(
    column: $table.onceOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get startsOn => $composableBuilder(
    column: $table.startsOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $HouseholdsFilterComposer get householdId {
    final $HouseholdsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsFilterComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FlowKindsFilterComposer get kind {
    final $FlowKindsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.flowKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowKindsFilterComposer(
            $db: $db,
            $table: $db.flowKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesFilterComposer get currency {
    final $CurrenciesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesFilterComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsFilterComposer get accountId {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> flowMarksRefs(
    Expression<bool> Function($FlowMarksFilterComposer f) f,
  ) {
    final $FlowMarksFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flowMarks,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowMarksFilterComposer(
            $db: $db,
            $table: $db.flowMarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $PlannedFlowsOrderingComposer
    extends Composer<_$AppDatabase, PlannedFlows> {
  $PlannedFlowsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cadence => $composableBuilder(
    column: $table.cadence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onceOn => $composableBuilder(
    column: $table.onceOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startsOn => $composableBuilder(
    column: $table.startsOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $HouseholdsOrderingComposer get householdId {
    final $HouseholdsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsOrderingComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FlowKindsOrderingComposer get kind {
    final $FlowKindsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.flowKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowKindsOrderingComposer(
            $db: $db,
            $table: $db.flowKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesOrderingComposer get currency {
    final $CurrenciesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesOrderingComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsOrderingComposer get accountId {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $PlannedFlowsAnnotationComposer
    extends Composer<_$AppDatabase, PlannedFlows> {
  $PlannedFlowsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cadence =>
      $composableBuilder(column: $table.cadence, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<String> get onceOn =>
      $composableBuilder(column: $table.onceOn, builder: (column) => column);

  GeneratedColumn<String> get startsOn =>
      $composableBuilder(column: $table.startsOn, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get archivedAtUtc => $composableBuilder(
    column: $table.archivedAtUtc,
    builder: (column) => column,
  );

  $HouseholdsAnnotationComposer get householdId {
    final $HouseholdsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.householdId,
      referencedTable: $db.households,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $HouseholdsAnnotationComposer(
            $db: $db,
            $table: $db.households,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $FlowKindsAnnotationComposer get kind {
    final $FlowKindsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.kind,
      referencedTable: $db.flowKinds,
      getReferencedColumn: (t) => t.kind,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowKindsAnnotationComposer(
            $db: $db,
            $table: $db.flowKinds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $CurrenciesAnnotationComposer get currency {
    final $CurrenciesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.currency,
      referencedTable: $db.currencies,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CurrenciesAnnotationComposer(
            $db: $db,
            $table: $db.currencies,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsAnnotationComposer get accountId {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> flowMarksRefs<T extends Object>(
    Expression<T> Function($FlowMarksAnnotationComposer a) f,
  ) {
    final $FlowMarksAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flowMarks,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowMarksAnnotationComposer(
            $db: $db,
            $table: $db.flowMarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $PlannedFlowsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          PlannedFlows,
          PlannedFlowRow,
          $PlannedFlowsFilterComposer,
          $PlannedFlowsOrderingComposer,
          $PlannedFlowsAnnotationComposer,
          $PlannedFlowsCreateCompanionBuilder,
          $PlannedFlowsUpdateCompanionBuilder,
          (PlannedFlowRow, $PlannedFlowsReferences),
          PlannedFlowRow,
          PrefetchHooks Function({
            bool householdId,
            bool kind,
            bool currency,
            bool accountId,
            bool flowMarksRefs,
          })
        > {
  $PlannedFlowsTableManager(_$AppDatabase db, PlannedFlows table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $PlannedFlowsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $PlannedFlowsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $PlannedFlowsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String> cadence = const Value.absent(),
                Value<int?> day = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<String?> onceOn = const Value.absent(),
                Value<String> startsOn = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannedFlowsCompanion(
                id: id,
                householdId: householdId,
                kind: kind,
                name: name,
                amountMinor: amountMinor,
                currency: currency,
                accountId: accountId,
                cadence: cadence,
                day: day,
                month: month,
                onceOn: onceOn,
                startsOn: startsOn,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String kind,
                required String name,
                required int amountMinor,
                required String currency,
                Value<String?> accountId = const Value.absent(),
                required String cadence,
                Value<int?> day = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<String?> onceOn = const Value.absent(),
                required String startsOn,
                required int createdAtUtc,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlannedFlowsCompanion.insert(
                id: id,
                householdId: householdId,
                kind: kind,
                name: name,
                amountMinor: amountMinor,
                currency: currency,
                accountId: accountId,
                cadence: cadence,
                day: day,
                month: month,
                onceOn: onceOn,
                startsOn: startsOn,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<PlannedFlows, PlannedFlowRow>(table),
                  $PlannedFlowsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                kind = false,
                currency = false,
                accountId = false,
                flowMarksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (flowMarksRefs) db.flowMarks],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (householdId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.householdId,
                            referencedTable: $PlannedFlowsReferences
                                ._householdIdTable(db),
                            referencedColumn: $PlannedFlowsReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (kind) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.kind,
                            referencedTable: $PlannedFlowsReferences._kindTable(
                              db,
                            ),
                            referencedColumn: $PlannedFlowsReferences
                                ._kindTable(db)
                                .kind,
                          ) as T;
                        }
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $PlannedFlowsReferences
                                ._currencyTable(db),
                            referencedColumn: $PlannedFlowsReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $PlannedFlowsReferences
                                ._accountIdTable(db),
                            referencedColumn: $PlannedFlowsReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (flowMarksRefs)
                        await $_getPrefetchedDataByColumns<
                          PlannedFlowRow,
                          PlannedFlows,
                          FlowMarkRow,
                          FlowMarks
                        >(
                          currentTable: table,
                          referencedTable: $PlannedFlowsReferences
                              ._flowMarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $PlannedFlowsReferences(
                                db,
                                table,
                                p0,
                              ).flowMarksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'flow_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $PlannedFlowsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      PlannedFlows,
      PlannedFlowRow,
      $PlannedFlowsFilterComposer,
      $PlannedFlowsOrderingComposer,
      $PlannedFlowsAnnotationComposer,
      $PlannedFlowsCreateCompanionBuilder,
      $PlannedFlowsUpdateCompanionBuilder,
      (PlannedFlowRow, $PlannedFlowsReferences),
      PlannedFlowRow,
      PrefetchHooks Function({
        bool householdId,
        bool kind,
        bool currency,
        bool accountId,
        bool flowMarksRefs,
      })
    >;
typedef $FlowMarksCreateCompanionBuilder = FlowMarksCompanion Function({
  required String flowId,
  required String dueOn,
  required String status,
  required int markedAtUtc,
  Value<int> rowid,
});
typedef $FlowMarksUpdateCompanionBuilder = FlowMarksCompanion Function({
  Value<String> flowId,
  Value<String> dueOn,
  Value<String> status,
  Value<int> markedAtUtc,
  Value<int> rowid,
});

final class $FlowMarksReferences
    extends BaseReferences<_$AppDatabase, FlowMarks, FlowMarkRow> {
  $FlowMarksReferences(super.$_db, super.$_table, super.$_typedResult);

  static PlannedFlows _flowIdTable(_$AppDatabase db) =>
      db.plannedFlows.createAlias('flow_marks__flow_id__planned_flows__id');

  $PlannedFlowsProcessedTableManager get flowId {
    final $_column = $_itemColumn<String>('flow_id')!;

    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_flowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $FlowMarksFilterComposer extends Composer<_$AppDatabase, FlowMarks> {
  $FlowMarksFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get markedAtUtc => $composableBuilder(
    column: $table.markedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $PlannedFlowsFilterComposer get flowId {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsFilterComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FlowMarksOrderingComposer extends Composer<_$AppDatabase, FlowMarks> {
  $FlowMarksOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get markedAtUtc => $composableBuilder(
    column: $table.markedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $PlannedFlowsOrderingComposer get flowId {
    final $PlannedFlowsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsOrderingComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FlowMarksAnnotationComposer extends Composer<_$AppDatabase, FlowMarks> {
  $FlowMarksAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dueOn =>
      $composableBuilder(column: $table.dueOn, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get markedAtUtc => $composableBuilder(
    column: $table.markedAtUtc,
    builder: (column) => column,
  );

  $PlannedFlowsAnnotationComposer get flowId {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.flowId,
      referencedTable: $db.plannedFlows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $PlannedFlowsAnnotationComposer(
            $db: $db,
            $table: $db.plannedFlows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $FlowMarksTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FlowMarks,
          FlowMarkRow,
          $FlowMarksFilterComposer,
          $FlowMarksOrderingComposer,
          $FlowMarksAnnotationComposer,
          $FlowMarksCreateCompanionBuilder,
          $FlowMarksUpdateCompanionBuilder,
          (FlowMarkRow, $FlowMarksReferences),
          FlowMarkRow,
          PrefetchHooks Function({bool flowId})
        > {
  $FlowMarksTableManager(_$AppDatabase db, FlowMarks table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FlowMarksFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FlowMarksOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FlowMarksAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> flowId = const Value.absent(),
                Value<String> dueOn = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> markedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlowMarksCompanion(
                flowId: flowId,
                dueOn: dueOn,
                status: status,
                markedAtUtc: markedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String flowId,
                required String dueOn,
                required String status,
                required int markedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => FlowMarksCompanion.insert(
                flowId: flowId,
                dueOn: dueOn,
                status: status,
                markedAtUtc: markedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<FlowMarks, FlowMarkRow>(table),
                  $FlowMarksReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({flowId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (flowId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.flowId,
                        referencedTable: $FlowMarksReferences._flowIdTable(db),
                        referencedColumn: $FlowMarksReferences
                            ._flowIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $FlowMarksProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FlowMarks,
      FlowMarkRow,
      $FlowMarksFilterComposer,
      $FlowMarksOrderingComposer,
      $FlowMarksAnnotationComposer,
      $FlowMarksCreateCompanionBuilder,
      $FlowMarksUpdateCompanionBuilder,
      (FlowMarkRow, $FlowMarksReferences),
      FlowMarkRow,
      PrefetchHooks Function({bool flowId})
    >;
typedef $CardFiguresCreateCompanionBuilder = CardFiguresCompanion Function({
  required String id,
  required String accountId,
  Value<int?> graceAmountMinor,
  Value<String?> graceDueOn,
  Value<int?> minPaymentMinor,
  Value<String?> minDueOn,
  required String source,
  required int recordedAtUtc,
  Value<int?> settledAtUtc,
  Value<int> rowid,
});
typedef $CardFiguresUpdateCompanionBuilder = CardFiguresCompanion Function({
  Value<String> id,
  Value<String> accountId,
  Value<int?> graceAmountMinor,
  Value<String?> graceDueOn,
  Value<int?> minPaymentMinor,
  Value<String?> minDueOn,
  Value<String> source,
  Value<int> recordedAtUtc,
  Value<int?> settledAtUtc,
  Value<int> rowid,
});

final class $CardFiguresReferences
    extends BaseReferences<_$AppDatabase, CardFigures, CardFiguresRow> {
  $CardFiguresReferences(super.$_db, super.$_table, super.$_typedResult);

  static Accounts _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('card_figures__account_id__accounts__id');

  $AccountsProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static DataSources _sourceTable(_$AppDatabase db) =>
      db.dataSources.createAlias('card_figures__source__data_sources__source');

  $DataSourcesProcessedTableManager get source {
    final $_column = $_itemColumn<String>('source')!;

    final manager = $DataSourcesTableManager(
      $_db,
      $_db.dataSources,
    ).filter((f) => f.source.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CardFiguresFilterComposer extends Composer<_$AppDatabase, CardFigures> {
  $CardFiguresFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get graceAmountMinor => $composableBuilder(
    column: $table.graceAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get graceDueOn => $composableBuilder(
    column: $table.graceDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minPaymentMinor => $composableBuilder(
    column: $table.minPaymentMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get minDueOn => $composableBuilder(
    column: $table.minDueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get settledAtUtc => $composableBuilder(
    column: $table.settledAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $AccountsFilterComposer get accountId {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesFilterComposer get source {
    final $DataSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesFilterComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CardFiguresOrderingComposer
    extends Composer<_$AppDatabase, CardFigures> {
  $CardFiguresOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get graceAmountMinor => $composableBuilder(
    column: $table.graceAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get graceDueOn => $composableBuilder(
    column: $table.graceDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minPaymentMinor => $composableBuilder(
    column: $table.minPaymentMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get minDueOn => $composableBuilder(
    column: $table.minDueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get settledAtUtc => $composableBuilder(
    column: $table.settledAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $AccountsOrderingComposer get accountId {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesOrderingComposer get source {
    final $DataSourcesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesOrderingComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CardFiguresAnnotationComposer
    extends Composer<_$AppDatabase, CardFigures> {
  $CardFiguresAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get graceAmountMinor => $composableBuilder(
    column: $table.graceAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get graceDueOn => $composableBuilder(
    column: $table.graceDueOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minPaymentMinor => $composableBuilder(
    column: $table.minPaymentMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get minDueOn =>
      $composableBuilder(column: $table.minDueOn, builder: (column) => column);

  GeneratedColumn<int> get recordedAtUtc => $composableBuilder(
    column: $table.recordedAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get settledAtUtc => $composableBuilder(
    column: $table.settledAtUtc,
    builder: (column) => column,
  );

  $AccountsAnnotationComposer get accountId {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AccountsAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $DataSourcesAnnotationComposer get source {
    final $DataSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.source,
      referencedTable: $db.dataSources,
      getReferencedColumn: (t) => t.source,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DataSourcesAnnotationComposer(
            $db: $db,
            $table: $db.dataSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $CardFiguresTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CardFigures,
          CardFiguresRow,
          $CardFiguresFilterComposer,
          $CardFiguresOrderingComposer,
          $CardFiguresAnnotationComposer,
          $CardFiguresCreateCompanionBuilder,
          $CardFiguresUpdateCompanionBuilder,
          (CardFiguresRow, $CardFiguresReferences),
          CardFiguresRow,
          PrefetchHooks Function({bool accountId, bool source})
        > {
  $CardFiguresTableManager(_$AppDatabase db, CardFigures table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CardFiguresFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CardFiguresOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CardFiguresAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<int?> graceAmountMinor = const Value.absent(),
                Value<String?> graceDueOn = const Value.absent(),
                Value<int?> minPaymentMinor = const Value.absent(),
                Value<String?> minDueOn = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<int> recordedAtUtc = const Value.absent(),
                Value<int?> settledAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardFiguresCompanion(
                id: id,
                accountId: accountId,
                graceAmountMinor: graceAmountMinor,
                graceDueOn: graceDueOn,
                minPaymentMinor: minPaymentMinor,
                minDueOn: minDueOn,
                source: source,
                recordedAtUtc: recordedAtUtc,
                settledAtUtc: settledAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                Value<int?> graceAmountMinor = const Value.absent(),
                Value<String?> graceDueOn = const Value.absent(),
                Value<int?> minPaymentMinor = const Value.absent(),
                Value<String?> minDueOn = const Value.absent(),
                required String source,
                required int recordedAtUtc,
                Value<int?> settledAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardFiguresCompanion.insert(
                id: id,
                accountId: accountId,
                graceAmountMinor: graceAmountMinor,
                graceDueOn: graceDueOn,
                minPaymentMinor: minPaymentMinor,
                minDueOn: minDueOn,
                source: source,
                recordedAtUtc: recordedAtUtc,
                settledAtUtc: settledAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CardFigures, CardFiguresRow>(table),
                  $CardFiguresReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false, source = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.accountId,
                        referencedTable: $CardFiguresReferences._accountIdTable(
                          db,
                        ),
                        referencedColumn: $CardFiguresReferences
                            ._accountIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (source) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.source,
                        referencedTable: $CardFiguresReferences._sourceTable(
                          db,
                        ),
                        referencedColumn: $CardFiguresReferences
                            ._sourceTable(db)
                            .source,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $CardFiguresProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CardFigures,
      CardFiguresRow,
      $CardFiguresFilterComposer,
      $CardFiguresOrderingComposer,
      $CardFiguresAnnotationComposer,
      $CardFiguresCreateCompanionBuilder,
      $CardFiguresUpdateCompanionBuilder,
      (CardFiguresRow, $CardFiguresReferences),
      CardFiguresRow,
      PrefetchHooks Function({bool accountId, bool source})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $AppSettingsTableManager get appSettings =>
      $AppSettingsTableManager(_db, _db.appSettings);
  $SchemaMigrationsTableManager get schemaMigrations =>
      $SchemaMigrationsTableManager(_db, _db.schemaMigrations);
  $CurrenciesTableManager get currencies =>
      $CurrenciesTableManager(_db, _db.currencies);
  $AccountKindsTableManager get accountKinds =>
      $AccountKindsTableManager(_db, _db.accountKinds);
  $EntryKindsTableManager get entryKinds =>
      $EntryKindsTableManager(_db, _db.entryKinds);
  $DataSourcesTableManager get dataSources =>
      $DataSourcesTableManager(_db, _db.dataSources);
  $HouseholdsTableManager get households =>
      $HouseholdsTableManager(_db, _db.households);
  $MembersTableManager get members => $MembersTableManager(_db, _db.members);
  $AccountsTableManager get accounts =>
      $AccountsTableManager(_db, _db.accounts);
  $JournalEntriesTableManager get journalEntries =>
      $JournalEntriesTableManager(_db, _db.journalEntries);
  $PostingsTableManager get postings =>
      $PostingsTableManager(_db, _db.postings);
  $BalanceAssertionsTableManager get balanceAssertions =>
      $BalanceAssertionsTableManager(_db, _db.balanceAssertions);
  $FlowKindsTableManager get flowKinds =>
      $FlowKindsTableManager(_db, _db.flowKinds);
  $PlannedFlowsTableManager get plannedFlows =>
      $PlannedFlowsTableManager(_db, _db.plannedFlows);
  $FlowMarksTableManager get flowMarks =>
      $FlowMarksTableManager(_db, _db.flowMarks);
  $CardFiguresTableManager get cardFigures =>
      $CardFiguresTableManager(_db, _db.cardFigures);
}
