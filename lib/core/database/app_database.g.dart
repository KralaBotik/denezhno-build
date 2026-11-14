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

class CategoryGroups extends Table
    with TableInfo<CategoryGroups, CategoryGroupRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CategoryGroups(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) BETWEEN 1 AND 40)',
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
    name,
    sortOrder,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryGroupRow> instance, {
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
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
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
  CategoryGroupRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryGroupRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      archivedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}archived_at_utc'],
      ),
    );
  }

  @override
  CategoryGroups createAlias(String alias) {
    return CategoryGroups(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class CategoryGroupRow extends DataClass
    implements Insertable<CategoryGroupRow> {
  final String id;
  final String householdId;
  final String name;
  final int sortOrder;
  final int? archivedAtUtc;
  const CategoryGroupRow({
    required this.id,
    required this.householdId,
    required this.name,
    required this.sortOrder,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  CategoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return CategoryGroupsCompanion(
      id: Value(id),
      householdId: Value(householdId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory CategoryGroupRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryGroupRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      archivedAtUtc: serializer.fromJson<int?>(json['archived_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'household_id': serializer.toJson<String>(householdId),
      'name': serializer.toJson<String>(name),
      'sort_order': serializer.toJson<int>(sortOrder),
      'archived_at_utc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  CategoryGroupRow copyWith({
    String? id,
    String? householdId,
    String? name,
    int? sortOrder,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => CategoryGroupRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  CategoryGroupRow copyWithCompanion(CategoryGroupsCompanion data) {
    return CategoryGroupRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      archivedAtUtc: data.archivedAtUtc.present
          ? data.archivedAtUtc.value
          : this.archivedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryGroupRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, householdId, name, sortOrder, archivedAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryGroupRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class CategoryGroupsCompanion extends UpdateCompanion<CategoryGroupRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const CategoryGroupsCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryGroupsCompanion.insert({
    required String id,
    required String householdId,
    required String name,
    required int sortOrder,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<CategoryGroupRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return CategoryGroupsCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
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
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
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
    return (StringBuffer('CategoryGroupsCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Categories extends Table with TableInfo<Categories, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Categories(this.attachedDatabase, [this._alias]);
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
        'NOT NULL CHECK (direction IN (\'expense\', \'income\'))',
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(name)) BETWEEN 1 AND 40)',
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(icon) BETWEEN 1 AND 40)',
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES category_groups(id)',
  );
  static const VerificationMeta _ledgerAccountIdMeta = const VerificationMeta(
    'ledgerAccountId',
  );
  late final GeneratedColumn<String> ledgerAccountId = GeneratedColumn<String>(
    'ledger_account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE REFERENCES accounts(id)',
  );
  static const VerificationMeta _systemKeyMeta = const VerificationMeta(
    'systemKey',
  );
  late final GeneratedColumn<String> systemKey = GeneratedColumn<String>(
    'system_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (system_key IS NULL OR length(system_key) BETWEEN 1 AND 40)',
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
    direction,
    name,
    icon,
    groupId,
    ledgerAccountId,
    systemKey,
    sortOrder,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
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
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    }
    if (data.containsKey('ledger_account_id')) {
      context.handle(
        _ledgerAccountIdMeta,
        ledgerAccountId.isAcceptableOrUnknown(
          data['ledger_account_id']!,
          _ledgerAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ledgerAccountIdMeta);
    }
    if (data.containsKey('system_key')) {
      context.handle(
        _systemKeyMeta,
        systemKey.isAcceptableOrUnknown(data['system_key']!, _systemKeyMeta),
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {householdId, systemKey},
  ];
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      ),
      ledgerAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ledger_account_id'],
      )!,
      systemKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}system_key'],
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
  Categories createAlias(String alias) {
    return Categories(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(household_id, system_key)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String householdId;
  final String direction;
  final String name;
  final String icon;
  final String? groupId;
  final String ledgerAccountId;

  /// Stable key of a default category ('salary', 'groceries', ...) so the app
  /// finds «Зарплата» even after the person renames it. NULL for own ones.
  final String? systemKey;
  final int sortOrder;
  final int createdAtUtc;
  final int? archivedAtUtc;
  const CategoryRow({
    required this.id,
    required this.householdId,
    required this.direction,
    required this.name,
    required this.icon,
    this.groupId,
    required this.ledgerAccountId,
    this.systemKey,
    required this.sortOrder,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    map['direction'] = Variable<String>(direction);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['ledger_account_id'] = Variable<String>(ledgerAccountId);
    if (!nullToAbsent || systemKey != null) {
      map['system_key'] = Variable<String>(systemKey);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      direction: Value(direction),
      name: Value(name),
      icon: Value(icon),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      ledgerAccountId: Value(ledgerAccountId),
      systemKey: systemKey == null && nullToAbsent
          ? const Value.absent()
          : Value(systemKey),
      sortOrder: Value(sortOrder),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      direction: serializer.fromJson<String>(json['direction']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      groupId: serializer.fromJson<String?>(json['group_id']),
      ledgerAccountId: serializer.fromJson<String>(json['ledger_account_id']),
      systemKey: serializer.fromJson<String?>(json['system_key']),
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
      'direction': serializer.toJson<String>(direction),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'group_id': serializer.toJson<String?>(groupId),
      'ledger_account_id': serializer.toJson<String>(ledgerAccountId),
      'system_key': serializer.toJson<String?>(systemKey),
      'sort_order': serializer.toJson<int>(sortOrder),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
      'archived_at_utc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? householdId,
    String? direction,
    String? name,
    String? icon,
    Value<String?> groupId = const Value.absent(),
    String? ledgerAccountId,
    Value<String?> systemKey = const Value.absent(),
    int? sortOrder,
    int? createdAtUtc,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => CategoryRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    direction: direction ?? this.direction,
    name: name ?? this.name,
    icon: icon ?? this.icon,
    groupId: groupId.present ? groupId.value : this.groupId,
    ledgerAccountId: ledgerAccountId ?? this.ledgerAccountId,
    systemKey: systemKey.present ? systemKey.value : this.systemKey,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      direction: data.direction.present ? data.direction.value : this.direction,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      ledgerAccountId: data.ledgerAccountId.present
          ? data.ledgerAccountId.value
          : this.ledgerAccountId,
      systemKey: data.systemKey.present ? data.systemKey.value : this.systemKey,
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
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('direction: $direction, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('groupId: $groupId, ')
          ..write('ledgerAccountId: $ledgerAccountId, ')
          ..write('systemKey: $systemKey, ')
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
    direction,
    name,
    icon,
    groupId,
    ledgerAccountId,
    systemKey,
    sortOrder,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.direction == this.direction &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.groupId == this.groupId &&
          other.ledgerAccountId == this.ledgerAccountId &&
          other.systemKey == this.systemKey &&
          other.sortOrder == this.sortOrder &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String> direction;
  final Value<String> name;
  final Value<String> icon;
  final Value<String?> groupId;
  final Value<String> ledgerAccountId;
  final Value<String?> systemKey;
  final Value<int> sortOrder;
  final Value<int> createdAtUtc;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.direction = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.groupId = const Value.absent(),
    this.ledgerAccountId = const Value.absent(),
    this.systemKey = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String householdId,
    required String direction,
    required String name,
    required String icon,
    this.groupId = const Value.absent(),
    required String ledgerAccountId,
    this.systemKey = const Value.absent(),
    required int sortOrder,
    required int createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       direction = Value(direction),
       name = Value(name),
       icon = Value(icon),
       ledgerAccountId = Value(ledgerAccountId),
       sortOrder = Value(sortOrder),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? direction,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? groupId,
    Expression<String>? ledgerAccountId,
    Expression<String>? systemKey,
    Expression<int>? sortOrder,
    Expression<int>? createdAtUtc,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (direction != null) 'direction': direction,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (groupId != null) 'group_id': groupId,
      if (ledgerAccountId != null) 'ledger_account_id': ledgerAccountId,
      if (systemKey != null) 'system_key': systemKey,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String>? direction,
    Value<String>? name,
    Value<String>? icon,
    Value<String?>? groupId,
    Value<String>? ledgerAccountId,
    Value<String?>? systemKey,
    Value<int>? sortOrder,
    Value<int>? createdAtUtc,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      direction: direction ?? this.direction,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      groupId: groupId ?? this.groupId,
      ledgerAccountId: ledgerAccountId ?? this.ledgerAccountId,
      systemKey: systemKey ?? this.systemKey,
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
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (ledgerAccountId.present) {
      map['ledger_account_id'] = Variable<String>(ledgerAccountId.value);
    }
    if (systemKey.present) {
      map['system_key'] = Variable<String>(systemKey.value);
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
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('direction: $direction, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('groupId: $groupId, ')
          ..write('ledgerAccountId: $ledgerAccountId, ')
          ..write('systemKey: $systemKey, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class EntryDetails extends Table with TableInfo<EntryDetails, EntryDetailsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  EntryDetails(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES journal_entries(id)',
  );
  static const VerificationMeta _occurredOnMeta = const VerificationMeta(
    'occurredOn',
  );
  late final GeneratedColumn<String> occurredOn = GeneratedColumn<String>(
    'occurred_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(occurred_on) = 10 AND date(occurred_on) = occurred_on)',
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (description IS NULL OR length(description) <= 200)',
  );
  static const VerificationMeta _counterpartyMeta = const VerificationMeta(
    'counterparty',
  );
  late final GeneratedColumn<String> counterparty = GeneratedColumn<String>(
    'counterparty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'CHECK (counterparty IS NULL OR length(counterparty) <= 100)',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (note IS NULL OR length(note) <= 500)',
  );
  static const VerificationMeta _reversesEntryIdMeta = const VerificationMeta(
    'reversesEntryId',
  );
  late final GeneratedColumn<String> reversesEntryId = GeneratedColumn<String>(
    'reverses_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'UNIQUE REFERENCES journal_entries(id)',
  );
  static const VerificationMeta _supersedesEntryIdMeta = const VerificationMeta(
    'supersedesEntryId',
  );
  late final GeneratedColumn<String> supersedesEntryId =
      GeneratedColumn<String>(
        'supersedes_entry_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: 'UNIQUE REFERENCES journal_entries(id)',
      );
  static const VerificationMeta _causedByEntryIdMeta = const VerificationMeta(
    'causedByEntryId',
  );
  late final GeneratedColumn<String> causedByEntryId = GeneratedColumn<String>(
    'caused_by_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES journal_entries(id)',
  );
  @override
  List<GeneratedColumn> get $columns => [
    entryId,
    occurredOn,
    description,
    counterparty,
    note,
    reversesEntryId,
    supersedesEntryId,
    causedByEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entry_details';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryDetailsRow> instance, {
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
    if (data.containsKey('occurred_on')) {
      context.handle(
        _occurredOnMeta,
        occurredOn.isAcceptableOrUnknown(data['occurred_on']!, _occurredOnMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredOnMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('counterparty')) {
      context.handle(
        _counterpartyMeta,
        counterparty.isAcceptableOrUnknown(
          data['counterparty']!,
          _counterpartyMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('reverses_entry_id')) {
      context.handle(
        _reversesEntryIdMeta,
        reversesEntryId.isAcceptableOrUnknown(
          data['reverses_entry_id']!,
          _reversesEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('supersedes_entry_id')) {
      context.handle(
        _supersedesEntryIdMeta,
        supersedesEntryId.isAcceptableOrUnknown(
          data['supersedes_entry_id']!,
          _supersedesEntryIdMeta,
        ),
      );
    }
    if (data.containsKey('caused_by_entry_id')) {
      context.handle(
        _causedByEntryIdMeta,
        causedByEntryId.isAcceptableOrUnknown(
          data['caused_by_entry_id']!,
          _causedByEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {entryId};
  @override
  EntryDetailsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryDetailsRow(
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      occurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_on'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      counterparty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}counterparty'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      reversesEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reverses_entry_id'],
      ),
      supersedesEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supersedes_entry_id'],
      ),
      causedByEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caused_by_entry_id'],
      ),
    );
  }

  @override
  EntryDetails createAlias(String alias) {
    return EntryDetails(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(reverses_entry_id IS NULL OR reverses_entry_id <> entry_id)',
    'CHECK(supersedes_entry_id IS NULL OR supersedes_entry_id <> entry_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class EntryDetailsRow extends DataClass implements Insertable<EntryDetailsRow> {
  final String entryId;
  final String occurredOn;
  final String? description;
  final String? counterparty;
  final String? note;
  final String? reversesEntryId;
  final String? supersedesEntryId;
  final String? causedByEntryId;
  const EntryDetailsRow({
    required this.entryId,
    required this.occurredOn,
    this.description,
    this.counterparty,
    this.note,
    this.reversesEntryId,
    this.supersedesEntryId,
    this.causedByEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['entry_id'] = Variable<String>(entryId);
    map['occurred_on'] = Variable<String>(occurredOn);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || counterparty != null) {
      map['counterparty'] = Variable<String>(counterparty);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || reversesEntryId != null) {
      map['reverses_entry_id'] = Variable<String>(reversesEntryId);
    }
    if (!nullToAbsent || supersedesEntryId != null) {
      map['supersedes_entry_id'] = Variable<String>(supersedesEntryId);
    }
    if (!nullToAbsent || causedByEntryId != null) {
      map['caused_by_entry_id'] = Variable<String>(causedByEntryId);
    }
    return map;
  }

  EntryDetailsCompanion toCompanion(bool nullToAbsent) {
    return EntryDetailsCompanion(
      entryId: Value(entryId),
      occurredOn: Value(occurredOn),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      counterparty: counterparty == null && nullToAbsent
          ? const Value.absent()
          : Value(counterparty),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      reversesEntryId: reversesEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversesEntryId),
      supersedesEntryId: supersedesEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(supersedesEntryId),
      causedByEntryId: causedByEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(causedByEntryId),
    );
  }

  factory EntryDetailsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryDetailsRow(
      entryId: serializer.fromJson<String>(json['entry_id']),
      occurredOn: serializer.fromJson<String>(json['occurred_on']),
      description: serializer.fromJson<String?>(json['description']),
      counterparty: serializer.fromJson<String?>(json['counterparty']),
      note: serializer.fromJson<String?>(json['note']),
      reversesEntryId: serializer.fromJson<String?>(json['reverses_entry_id']),
      supersedesEntryId: serializer.fromJson<String?>(
        json['supersedes_entry_id'],
      ),
      causedByEntryId: serializer.fromJson<String?>(json['caused_by_entry_id']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'entry_id': serializer.toJson<String>(entryId),
      'occurred_on': serializer.toJson<String>(occurredOn),
      'description': serializer.toJson<String?>(description),
      'counterparty': serializer.toJson<String?>(counterparty),
      'note': serializer.toJson<String?>(note),
      'reverses_entry_id': serializer.toJson<String?>(reversesEntryId),
      'supersedes_entry_id': serializer.toJson<String?>(supersedesEntryId),
      'caused_by_entry_id': serializer.toJson<String?>(causedByEntryId),
    };
  }

  EntryDetailsRow copyWith({
    String? entryId,
    String? occurredOn,
    Value<String?> description = const Value.absent(),
    Value<String?> counterparty = const Value.absent(),
    Value<String?> note = const Value.absent(),
    Value<String?> reversesEntryId = const Value.absent(),
    Value<String?> supersedesEntryId = const Value.absent(),
    Value<String?> causedByEntryId = const Value.absent(),
  }) => EntryDetailsRow(
    entryId: entryId ?? this.entryId,
    occurredOn: occurredOn ?? this.occurredOn,
    description: description.present ? description.value : this.description,
    counterparty: counterparty.present ? counterparty.value : this.counterparty,
    note: note.present ? note.value : this.note,
    reversesEntryId: reversesEntryId.present
        ? reversesEntryId.value
        : this.reversesEntryId,
    supersedesEntryId: supersedesEntryId.present
        ? supersedesEntryId.value
        : this.supersedesEntryId,
    causedByEntryId: causedByEntryId.present
        ? causedByEntryId.value
        : this.causedByEntryId,
  );
  EntryDetailsRow copyWithCompanion(EntryDetailsCompanion data) {
    return EntryDetailsRow(
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      occurredOn: data.occurredOn.present
          ? data.occurredOn.value
          : this.occurredOn,
      description: data.description.present
          ? data.description.value
          : this.description,
      counterparty: data.counterparty.present
          ? data.counterparty.value
          : this.counterparty,
      note: data.note.present ? data.note.value : this.note,
      reversesEntryId: data.reversesEntryId.present
          ? data.reversesEntryId.value
          : this.reversesEntryId,
      supersedesEntryId: data.supersedesEntryId.present
          ? data.supersedesEntryId.value
          : this.supersedesEntryId,
      causedByEntryId: data.causedByEntryId.present
          ? data.causedByEntryId.value
          : this.causedByEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryDetailsRow(')
          ..write('entryId: $entryId, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('description: $description, ')
          ..write('counterparty: $counterparty, ')
          ..write('note: $note, ')
          ..write('reversesEntryId: $reversesEntryId, ')
          ..write('supersedesEntryId: $supersedesEntryId, ')
          ..write('causedByEntryId: $causedByEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    entryId,
    occurredOn,
    description,
    counterparty,
    note,
    reversesEntryId,
    supersedesEntryId,
    causedByEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryDetailsRow &&
          other.entryId == this.entryId &&
          other.occurredOn == this.occurredOn &&
          other.description == this.description &&
          other.counterparty == this.counterparty &&
          other.note == this.note &&
          other.reversesEntryId == this.reversesEntryId &&
          other.supersedesEntryId == this.supersedesEntryId &&
          other.causedByEntryId == this.causedByEntryId);
}

class EntryDetailsCompanion extends UpdateCompanion<EntryDetailsRow> {
  final Value<String> entryId;
  final Value<String> occurredOn;
  final Value<String?> description;
  final Value<String?> counterparty;
  final Value<String?> note;
  final Value<String?> reversesEntryId;
  final Value<String?> supersedesEntryId;
  final Value<String?> causedByEntryId;
  final Value<int> rowid;
  const EntryDetailsCompanion({
    this.entryId = const Value.absent(),
    this.occurredOn = const Value.absent(),
    this.description = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.note = const Value.absent(),
    this.reversesEntryId = const Value.absent(),
    this.supersedesEntryId = const Value.absent(),
    this.causedByEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EntryDetailsCompanion.insert({
    required String entryId,
    required String occurredOn,
    this.description = const Value.absent(),
    this.counterparty = const Value.absent(),
    this.note = const Value.absent(),
    this.reversesEntryId = const Value.absent(),
    this.supersedesEntryId = const Value.absent(),
    this.causedByEntryId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : entryId = Value(entryId),
       occurredOn = Value(occurredOn);
  static Insertable<EntryDetailsRow> custom({
    Expression<String>? entryId,
    Expression<String>? occurredOn,
    Expression<String>? description,
    Expression<String>? counterparty,
    Expression<String>? note,
    Expression<String>? reversesEntryId,
    Expression<String>? supersedesEntryId,
    Expression<String>? causedByEntryId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (entryId != null) 'entry_id': entryId,
      if (occurredOn != null) 'occurred_on': occurredOn,
      if (description != null) 'description': description,
      if (counterparty != null) 'counterparty': counterparty,
      if (note != null) 'note': note,
      if (reversesEntryId != null) 'reverses_entry_id': reversesEntryId,
      if (supersedesEntryId != null) 'supersedes_entry_id': supersedesEntryId,
      if (causedByEntryId != null) 'caused_by_entry_id': causedByEntryId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EntryDetailsCompanion copyWith({
    Value<String>? entryId,
    Value<String>? occurredOn,
    Value<String?>? description,
    Value<String?>? counterparty,
    Value<String?>? note,
    Value<String?>? reversesEntryId,
    Value<String?>? supersedesEntryId,
    Value<String?>? causedByEntryId,
    Value<int>? rowid,
  }) {
    return EntryDetailsCompanion(
      entryId: entryId ?? this.entryId,
      occurredOn: occurredOn ?? this.occurredOn,
      description: description ?? this.description,
      counterparty: counterparty ?? this.counterparty,
      note: note ?? this.note,
      reversesEntryId: reversesEntryId ?? this.reversesEntryId,
      supersedesEntryId: supersedesEntryId ?? this.supersedesEntryId,
      causedByEntryId: causedByEntryId ?? this.causedByEntryId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (occurredOn.present) {
      map['occurred_on'] = Variable<String>(occurredOn.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (counterparty.present) {
      map['counterparty'] = Variable<String>(counterparty.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (reversesEntryId.present) {
      map['reverses_entry_id'] = Variable<String>(reversesEntryId.value);
    }
    if (supersedesEntryId.present) {
      map['supersedes_entry_id'] = Variable<String>(supersedesEntryId.value);
    }
    if (causedByEntryId.present) {
      map['caused_by_entry_id'] = Variable<String>(causedByEntryId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntryDetailsCompanion(')
          ..write('entryId: $entryId, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('description: $description, ')
          ..write('counterparty: $counterparty, ')
          ..write('note: $note, ')
          ..write('reversesEntryId: $reversesEntryId, ')
          ..write('supersedesEntryId: $supersedesEntryId, ')
          ..write('causedByEntryId: $causedByEntryId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class IncomeSources extends Table
    with TableInfo<IncomeSources, IncomeSourceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IncomeSources(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES members(id)',
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (kind IN (\'salary\', \'other\'))',
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
  static const VerificationMeta _holidayRuleMeta = const VerificationMeta(
    'holidayRule',
  );
  late final GeneratedColumn<String> holidayRule = GeneratedColumn<String>(
    'holiday_rule',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (holiday_rule IN (\'previous_workday\', \'next_workday\', \'none\'))',
  );
  static const VerificationMeta _trackedFromMeta = const VerificationMeta(
    'trackedFrom',
  );
  late final GeneratedColumn<String> trackedFrom = GeneratedColumn<String>(
    'tracked_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(tracked_from) = 10 AND date(tracked_from) = tracked_from)',
  );
  static const VerificationMeta _migratedFromFlowIdMeta =
      const VerificationMeta('migratedFromFlowId');
  late final GeneratedColumn<String> migratedFromFlowId =
      GeneratedColumn<String>(
        'migrated_from_flow_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        $customConstraints: 'UNIQUE REFERENCES planned_flows(id)',
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
    memberId,
    name,
    kind,
    accountId,
    holidayRule,
    trackedFrom,
    migratedFromFlowId,
    createdAtUtc,
    archivedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_sources';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeSourceRow> instance, {
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
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('holiday_rule')) {
      context.handle(
        _holidayRuleMeta,
        holidayRule.isAcceptableOrUnknown(
          data['holiday_rule']!,
          _holidayRuleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_holidayRuleMeta);
    }
    if (data.containsKey('tracked_from')) {
      context.handle(
        _trackedFromMeta,
        trackedFrom.isAcceptableOrUnknown(
          data['tracked_from']!,
          _trackedFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackedFromMeta);
    }
    if (data.containsKey('migrated_from_flow_id')) {
      context.handle(
        _migratedFromFlowIdMeta,
        migratedFromFlowId.isAcceptableOrUnknown(
          data['migrated_from_flow_id']!,
          _migratedFromFlowIdMeta,
        ),
      );
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
  IncomeSourceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeSourceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      holidayRule: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}holiday_rule'],
      )!,
      trackedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracked_from'],
      )!,
      migratedFromFlowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}migrated_from_flow_id'],
      ),
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
  IncomeSources createAlias(String alias) {
    return IncomeSources(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class IncomeSourceRow extends DataClass implements Insertable<IncomeSourceRow> {
  final String id;
  final String householdId;
  final String? memberId;
  final String name;
  final String kind;

  /// Default account the money comes to.
  final String? accountId;

  /// A pay date on a weekend or holiday moves to the previous working day
  /// (art. 136 of the Labour Code), the next one, or stays.
  final String holidayRule;

  /// Payments by the schedule are tracked from this date: earlier ones are
  /// not «waiting» (R2 did not require marks). Payments written to
  /// income_occurrences are kept regardless of the date.
  final String trackedFrom;

  /// The R2 plan this source was made from (makes the migration idempotent).
  final String? migratedFromFlowId;
  final int createdAtUtc;
  final int? archivedAtUtc;
  const IncomeSourceRow({
    required this.id,
    required this.householdId,
    this.memberId,
    required this.name,
    required this.kind,
    this.accountId,
    required this.holidayRule,
    required this.trackedFrom,
    this.migratedFromFlowId,
    required this.createdAtUtc,
    this.archivedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['name'] = Variable<String>(name);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['holiday_rule'] = Variable<String>(holidayRule);
    map['tracked_from'] = Variable<String>(trackedFrom);
    if (!nullToAbsent || migratedFromFlowId != null) {
      map['migrated_from_flow_id'] = Variable<String>(migratedFromFlowId);
    }
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    if (!nullToAbsent || archivedAtUtc != null) {
      map['archived_at_utc'] = Variable<int>(archivedAtUtc);
    }
    return map;
  }

  IncomeSourcesCompanion toCompanion(bool nullToAbsent) {
    return IncomeSourcesCompanion(
      id: Value(id),
      householdId: Value(householdId),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      name: Value(name),
      kind: Value(kind),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      holidayRule: Value(holidayRule),
      trackedFrom: Value(trackedFrom),
      migratedFromFlowId: migratedFromFlowId == null && nullToAbsent
          ? const Value.absent()
          : Value(migratedFromFlowId),
      createdAtUtc: Value(createdAtUtc),
      archivedAtUtc: archivedAtUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAtUtc),
    );
  }

  factory IncomeSourceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeSourceRow(
      id: serializer.fromJson<String>(json['id']),
      householdId: serializer.fromJson<String>(json['household_id']),
      memberId: serializer.fromJson<String?>(json['member_id']),
      name: serializer.fromJson<String>(json['name']),
      kind: serializer.fromJson<String>(json['kind']),
      accountId: serializer.fromJson<String?>(json['account_id']),
      holidayRule: serializer.fromJson<String>(json['holiday_rule']),
      trackedFrom: serializer.fromJson<String>(json['tracked_from']),
      migratedFromFlowId: serializer.fromJson<String?>(
        json['migrated_from_flow_id'],
      ),
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
      'member_id': serializer.toJson<String?>(memberId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(kind),
      'account_id': serializer.toJson<String?>(accountId),
      'holiday_rule': serializer.toJson<String>(holidayRule),
      'tracked_from': serializer.toJson<String>(trackedFrom),
      'migrated_from_flow_id': serializer.toJson<String?>(migratedFromFlowId),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
      'archived_at_utc': serializer.toJson<int?>(archivedAtUtc),
    };
  }

  IncomeSourceRow copyWith({
    String? id,
    String? householdId,
    Value<String?> memberId = const Value.absent(),
    String? name,
    String? kind,
    Value<String?> accountId = const Value.absent(),
    String? holidayRule,
    String? trackedFrom,
    Value<String?> migratedFromFlowId = const Value.absent(),
    int? createdAtUtc,
    Value<int?> archivedAtUtc = const Value.absent(),
  }) => IncomeSourceRow(
    id: id ?? this.id,
    householdId: householdId ?? this.householdId,
    memberId: memberId.present ? memberId.value : this.memberId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    accountId: accountId.present ? accountId.value : this.accountId,
    holidayRule: holidayRule ?? this.holidayRule,
    trackedFrom: trackedFrom ?? this.trackedFrom,
    migratedFromFlowId: migratedFromFlowId.present
        ? migratedFromFlowId.value
        : this.migratedFromFlowId,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    archivedAtUtc: archivedAtUtc.present
        ? archivedAtUtc.value
        : this.archivedAtUtc,
  );
  IncomeSourceRow copyWithCompanion(IncomeSourcesCompanion data) {
    return IncomeSourceRow(
      id: data.id.present ? data.id.value : this.id,
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      holidayRule: data.holidayRule.present
          ? data.holidayRule.value
          : this.holidayRule,
      trackedFrom: data.trackedFrom.present
          ? data.trackedFrom.value
          : this.trackedFrom,
      migratedFromFlowId: data.migratedFromFlowId.present
          ? data.migratedFromFlowId.value
          : this.migratedFromFlowId,
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
    return (StringBuffer('IncomeSourceRow(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('accountId: $accountId, ')
          ..write('holidayRule: $holidayRule, ')
          ..write('trackedFrom: $trackedFrom, ')
          ..write('migratedFromFlowId: $migratedFromFlowId, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    householdId,
    memberId,
    name,
    kind,
    accountId,
    holidayRule,
    trackedFrom,
    migratedFromFlowId,
    createdAtUtc,
    archivedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeSourceRow &&
          other.id == this.id &&
          other.householdId == this.householdId &&
          other.memberId == this.memberId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.accountId == this.accountId &&
          other.holidayRule == this.holidayRule &&
          other.trackedFrom == this.trackedFrom &&
          other.migratedFromFlowId == this.migratedFromFlowId &&
          other.createdAtUtc == this.createdAtUtc &&
          other.archivedAtUtc == this.archivedAtUtc);
}

class IncomeSourcesCompanion extends UpdateCompanion<IncomeSourceRow> {
  final Value<String> id;
  final Value<String> householdId;
  final Value<String?> memberId;
  final Value<String> name;
  final Value<String> kind;
  final Value<String?> accountId;
  final Value<String> holidayRule;
  final Value<String> trackedFrom;
  final Value<String?> migratedFromFlowId;
  final Value<int> createdAtUtc;
  final Value<int?> archivedAtUtc;
  final Value<int> rowid;
  const IncomeSourcesCompanion({
    this.id = const Value.absent(),
    this.householdId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.accountId = const Value.absent(),
    this.holidayRule = const Value.absent(),
    this.trackedFrom = const Value.absent(),
    this.migratedFromFlowId = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeSourcesCompanion.insert({
    required String id,
    required String householdId,
    this.memberId = const Value.absent(),
    required String name,
    required String kind,
    this.accountId = const Value.absent(),
    required String holidayRule,
    required String trackedFrom,
    this.migratedFromFlowId = const Value.absent(),
    required int createdAtUtc,
    this.archivedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       householdId = Value(householdId),
       name = Value(name),
       kind = Value(kind),
       holidayRule = Value(holidayRule),
       trackedFrom = Value(trackedFrom),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<IncomeSourceRow> custom({
    Expression<String>? id,
    Expression<String>? householdId,
    Expression<String>? memberId,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? accountId,
    Expression<String>? holidayRule,
    Expression<String>? trackedFrom,
    Expression<String>? migratedFromFlowId,
    Expression<int>? createdAtUtc,
    Expression<int>? archivedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (householdId != null) 'household_id': householdId,
      if (memberId != null) 'member_id': memberId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (accountId != null) 'account_id': accountId,
      if (holidayRule != null) 'holiday_rule': holidayRule,
      if (trackedFrom != null) 'tracked_from': trackedFrom,
      if (migratedFromFlowId != null)
        'migrated_from_flow_id': migratedFromFlowId,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (archivedAtUtc != null) 'archived_at_utc': archivedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeSourcesCompanion copyWith({
    Value<String>? id,
    Value<String>? householdId,
    Value<String?>? memberId,
    Value<String>? name,
    Value<String>? kind,
    Value<String?>? accountId,
    Value<String>? holidayRule,
    Value<String>? trackedFrom,
    Value<String?>? migratedFromFlowId,
    Value<int>? createdAtUtc,
    Value<int?>? archivedAtUtc,
    Value<int>? rowid,
  }) {
    return IncomeSourcesCompanion(
      id: id ?? this.id,
      householdId: householdId ?? this.householdId,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      accountId: accountId ?? this.accountId,
      holidayRule: holidayRule ?? this.holidayRule,
      trackedFrom: trackedFrom ?? this.trackedFrom,
      migratedFromFlowId: migratedFromFlowId ?? this.migratedFromFlowId,
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
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (holidayRule.present) {
      map['holiday_rule'] = Variable<String>(holidayRule.value);
    }
    if (trackedFrom.present) {
      map['tracked_from'] = Variable<String>(trackedFrom.value);
    }
    if (migratedFromFlowId.present) {
      map['migrated_from_flow_id'] = Variable<String>(migratedFromFlowId.value);
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
    return (StringBuffer('IncomeSourcesCompanion(')
          ..write('id: $id, ')
          ..write('householdId: $householdId, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('accountId: $accountId, ')
          ..write('holidayRule: $holidayRule, ')
          ..write('trackedFrom: $trackedFrom, ')
          ..write('migratedFromFlowId: $migratedFromFlowId, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('archivedAtUtc: $archivedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class IncomeScheduleParts extends Table
    with TableInfo<IncomeScheduleParts, IncomeSchedulePartRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IncomeScheduleParts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES income_sources(id)',
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(trim(label)) BETWEEN 1 AND 40)',
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
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(valid_from) = 10 AND date(valid_from) = valid_from)',
  );
  static const VerificationMeta _validToMeta = const VerificationMeta(
    'validTo',
  );
  late final GeneratedColumn<String> validTo = GeneratedColumn<String>(
    'valid_to',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (valid_to IS NULL OR(length(valid_to) = 10 AND date(valid_to) = valid_to))',
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
    sourceId,
    label,
    amountMinor,
    currency,
    cadence,
    day,
    month,
    onceOn,
    validFrom,
    validTo,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_schedule_parts';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeSchedulePartRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
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
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('valid_to')) {
      context.handle(
        _validToMeta,
        validTo.isAcceptableOrUnknown(data['valid_to']!, _validToMeta),
      );
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
  IncomeSchedulePartRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeSchedulePartRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
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
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      )!,
      validTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_to'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  IncomeScheduleParts createAlias(String alias) {
    return IncomeScheduleParts(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK(valid_to IS NULL OR valid_to >= valid_from)',
    'CHECK((cadence = \'monthly\' AND day BETWEEN 1 AND 31 AND month IS NULL AND once_on IS NULL)OR(cadence = \'weekly\' AND day BETWEEN 1 AND 7 AND month IS NULL AND once_on IS NULL)OR(cadence = \'yearly\' AND day BETWEEN 1 AND 31 AND month IS NOT NULL AND once_on IS NULL)OR(cadence = \'once\' AND day IS NULL AND month IS NULL AND once_on IS NOT NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class IncomeSchedulePartRow extends DataClass
    implements Insertable<IncomeSchedulePartRow> {
  final String id;
  final String sourceId;
  final String label;
  final int amountMinor;
  final String currency;
  final String cadence;
  final int? day;
  final int? month;
  final String? onceOn;
  final String validFrom;
  final String? validTo;
  final int createdAtUtc;
  const IncomeSchedulePartRow({
    required this.id,
    required this.sourceId,
    required this.label,
    required this.amountMinor,
    required this.currency,
    required this.cadence,
    this.day,
    this.month,
    this.onceOn,
    required this.validFrom,
    this.validTo,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    map['label'] = Variable<String>(label);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['currency'] = Variable<String>(currency);
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
    map['valid_from'] = Variable<String>(validFrom);
    if (!nullToAbsent || validTo != null) {
      map['valid_to'] = Variable<String>(validTo);
    }
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  IncomeSchedulePartsCompanion toCompanion(bool nullToAbsent) {
    return IncomeSchedulePartsCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      label: Value(label),
      amountMinor: Value(amountMinor),
      currency: Value(currency),
      cadence: Value(cadence),
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      month: month == null && nullToAbsent
          ? const Value.absent()
          : Value(month),
      onceOn: onceOn == null && nullToAbsent
          ? const Value.absent()
          : Value(onceOn),
      validFrom: Value(validFrom),
      validTo: validTo == null && nullToAbsent
          ? const Value.absent()
          : Value(validTo),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory IncomeSchedulePartRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeSchedulePartRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['source_id']),
      label: serializer.fromJson<String>(json['label']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      currency: serializer.fromJson<String>(json['currency']),
      cadence: serializer.fromJson<String>(json['cadence']),
      day: serializer.fromJson<int?>(json['day']),
      month: serializer.fromJson<int?>(json['month']),
      onceOn: serializer.fromJson<String?>(json['once_on']),
      validFrom: serializer.fromJson<String>(json['valid_from']),
      validTo: serializer.fromJson<String?>(json['valid_to']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source_id': serializer.toJson<String>(sourceId),
      'label': serializer.toJson<String>(label),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'currency': serializer.toJson<String>(currency),
      'cadence': serializer.toJson<String>(cadence),
      'day': serializer.toJson<int?>(day),
      'month': serializer.toJson<int?>(month),
      'once_on': serializer.toJson<String?>(onceOn),
      'valid_from': serializer.toJson<String>(validFrom),
      'valid_to': serializer.toJson<String?>(validTo),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
    };
  }

  IncomeSchedulePartRow copyWith({
    String? id,
    String? sourceId,
    String? label,
    int? amountMinor,
    String? currency,
    String? cadence,
    Value<int?> day = const Value.absent(),
    Value<int?> month = const Value.absent(),
    Value<String?> onceOn = const Value.absent(),
    String? validFrom,
    Value<String?> validTo = const Value.absent(),
    int? createdAtUtc,
  }) => IncomeSchedulePartRow(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    label: label ?? this.label,
    amountMinor: amountMinor ?? this.amountMinor,
    currency: currency ?? this.currency,
    cadence: cadence ?? this.cadence,
    day: day.present ? day.value : this.day,
    month: month.present ? month.value : this.month,
    onceOn: onceOn.present ? onceOn.value : this.onceOn,
    validFrom: validFrom ?? this.validFrom,
    validTo: validTo.present ? validTo.value : this.validTo,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  IncomeSchedulePartRow copyWithCompanion(IncomeSchedulePartsCompanion data) {
    return IncomeSchedulePartRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      label: data.label.present ? data.label.value : this.label,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      currency: data.currency.present ? data.currency.value : this.currency,
      cadence: data.cadence.present ? data.cadence.value : this.cadence,
      day: data.day.present ? data.day.value : this.day,
      month: data.month.present ? data.month.value : this.month,
      onceOn: data.onceOn.present ? data.onceOn.value : this.onceOn,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validTo: data.validTo.present ? data.validTo.value : this.validTo,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeSchedulePartRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('label: $label, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('cadence: $cadence, ')
          ..write('day: $day, ')
          ..write('month: $month, ')
          ..write('onceOn: $onceOn, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    label,
    amountMinor,
    currency,
    cadence,
    day,
    month,
    onceOn,
    validFrom,
    validTo,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeSchedulePartRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.label == this.label &&
          other.amountMinor == this.amountMinor &&
          other.currency == this.currency &&
          other.cadence == this.cadence &&
          other.day == this.day &&
          other.month == this.month &&
          other.onceOn == this.onceOn &&
          other.validFrom == this.validFrom &&
          other.validTo == this.validTo &&
          other.createdAtUtc == this.createdAtUtc);
}

class IncomeSchedulePartsCompanion
    extends UpdateCompanion<IncomeSchedulePartRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String> label;
  final Value<int> amountMinor;
  final Value<String> currency;
  final Value<String> cadence;
  final Value<int?> day;
  final Value<int?> month;
  final Value<String?> onceOn;
  final Value<String> validFrom;
  final Value<String?> validTo;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const IncomeSchedulePartsCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.label = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.currency = const Value.absent(),
    this.cadence = const Value.absent(),
    this.day = const Value.absent(),
    this.month = const Value.absent(),
    this.onceOn = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validTo = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeSchedulePartsCompanion.insert({
    required String id,
    required String sourceId,
    required String label,
    required int amountMinor,
    required String currency,
    required String cadence,
    this.day = const Value.absent(),
    this.month = const Value.absent(),
    this.onceOn = const Value.absent(),
    required String validFrom,
    this.validTo = const Value.absent(),
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       label = Value(label),
       amountMinor = Value(amountMinor),
       currency = Value(currency),
       cadence = Value(cadence),
       validFrom = Value(validFrom),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<IncomeSchedulePartRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? label,
    Expression<int>? amountMinor,
    Expression<String>? currency,
    Expression<String>? cadence,
    Expression<int>? day,
    Expression<int>? month,
    Expression<String>? onceOn,
    Expression<String>? validFrom,
    Expression<String>? validTo,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (label != null) 'label': label,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (currency != null) 'currency': currency,
      if (cadence != null) 'cadence': cadence,
      if (day != null) 'day': day,
      if (month != null) 'month': month,
      if (onceOn != null) 'once_on': onceOn,
      if (validFrom != null) 'valid_from': validFrom,
      if (validTo != null) 'valid_to': validTo,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeSchedulePartsCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String>? label,
    Value<int>? amountMinor,
    Value<String>? currency,
    Value<String>? cadence,
    Value<int?>? day,
    Value<int?>? month,
    Value<String?>? onceOn,
    Value<String>? validFrom,
    Value<String?>? validTo,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return IncomeSchedulePartsCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      label: label ?? this.label,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      cadence: cadence ?? this.cadence,
      day: day ?? this.day,
      month: month ?? this.month,
      onceOn: onceOn ?? this.onceOn,
      validFrom: validFrom ?? this.validFrom,
      validTo: validTo ?? this.validTo,
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
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
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
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (validTo.present) {
      map['valid_to'] = Variable<String>(validTo.value);
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
    return (StringBuffer('IncomeSchedulePartsCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('label: $label, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('currency: $currency, ')
          ..write('cadence: $cadence, ')
          ..write('day: $day, ')
          ..write('month: $month, ')
          ..write('onceOn: $onceOn, ')
          ..write('validFrom: $validFrom, ')
          ..write('validTo: $validTo, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class IncomeOccurrences extends Table
    with TableInfo<IncomeOccurrences, IncomeOccurrenceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IncomeOccurrences(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES income_sources(id)',
  );
  static const VerificationMeta _partIdMeta = const VerificationMeta('partId');
  late final GeneratedColumn<String> partId = GeneratedColumn<String>(
    'part_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES income_schedule_parts(id)',
  );
  static const VerificationMeta _plannedOnMeta = const VerificationMeta(
    'plannedOn',
  );
  late final GeneratedColumn<String> plannedOn = GeneratedColumn<String>(
    'planned_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(planned_on) = 10 AND date(planned_on) = planned_on)',
  );
  static const VerificationMeta _plannedAmountMinorMeta =
      const VerificationMeta('plannedAmountMinor');
  late final GeneratedColumn<int> plannedAmountMinor = GeneratedColumn<int>(
    'planned_amount_minor',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(planned_amount_minor) = \'integer\' AND planned_amount_minor > 0)',
  );
  static const VerificationMeta _expectedOnMeta = const VerificationMeta(
    'expectedOn',
  );
  late final GeneratedColumn<String> expectedOn = GeneratedColumn<String>(
    'expected_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (expected_on IS NULL OR(length(expected_on) = 10 AND date(expected_on) = expected_on))',
  );
  static const VerificationMeta _dateUnknownMeta = const VerificationMeta(
    'dateUnknown',
  );
  late final GeneratedColumn<int> dateUnknown = GeneratedColumn<int>(
    'date_unknown',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (date_unknown IN (0, 1))',
  );
  static const VerificationMeta _expectedAmountMinorMeta =
      const VerificationMeta('expectedAmountMinor');
  late final GeneratedColumn<int> expectedAmountMinor = GeneratedColumn<int>(
    'expected_amount_minor',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (expected_amount_minor IS NULL OR(typeof(expected_amount_minor) = \'integer\' AND expected_amount_minor > 0))',
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (state IN (\'open\', \'received\', \'legacy_mark\', \'cancelled\'))',
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (note IS NULL OR length(note) <= 200)',
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
  static const VerificationMeta _updatedAtUtcMeta = const VerificationMeta(
    'updatedAtUtc',
  );
  late final GeneratedColumn<int> updatedAtUtc = GeneratedColumn<int>(
    'updated_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (typeof(updated_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceId,
    partId,
    plannedOn,
    plannedAmountMinor,
    expectedOn,
    dateUnknown,
    expectedAmountMinor,
    state,
    note,
    createdAtUtc,
    updatedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_occurrences';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeOccurrenceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('part_id')) {
      context.handle(
        _partIdMeta,
        partId.isAcceptableOrUnknown(data['part_id']!, _partIdMeta),
      );
    }
    if (data.containsKey('planned_on')) {
      context.handle(
        _plannedOnMeta,
        plannedOn.isAcceptableOrUnknown(data['planned_on']!, _plannedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_plannedOnMeta);
    }
    if (data.containsKey('planned_amount_minor')) {
      context.handle(
        _plannedAmountMinorMeta,
        plannedAmountMinor.isAcceptableOrUnknown(
          data['planned_amount_minor']!,
          _plannedAmountMinorMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedAmountMinorMeta);
    }
    if (data.containsKey('expected_on')) {
      context.handle(
        _expectedOnMeta,
        expectedOn.isAcceptableOrUnknown(data['expected_on']!, _expectedOnMeta),
      );
    }
    if (data.containsKey('date_unknown')) {
      context.handle(
        _dateUnknownMeta,
        dateUnknown.isAcceptableOrUnknown(
          data['date_unknown']!,
          _dateUnknownMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateUnknownMeta);
    }
    if (data.containsKey('expected_amount_minor')) {
      context.handle(
        _expectedAmountMinorMeta,
        expectedAmountMinor.isAcceptableOrUnknown(
          data['expected_amount_minor']!,
          _expectedAmountMinorMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
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
    if (data.containsKey('updated_at_utc')) {
      context.handle(
        _updatedAtUtcMeta,
        updatedAtUtc.isAcceptableOrUnknown(
          data['updated_at_utc']!,
          _updatedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updatedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {partId, plannedOn},
  ];
  @override
  IncomeOccurrenceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeOccurrenceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      partId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}part_id'],
      ),
      plannedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_on'],
      )!,
      plannedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_amount_minor'],
      )!,
      expectedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expected_on'],
      ),
      dateUnknown: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_unknown'],
      )!,
      expectedAmountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_amount_minor'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
      updatedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at_utc'],
      )!,
    );
  }

  @override
  IncomeOccurrences createAlias(String alias) {
    return IncomeOccurrences(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'UNIQUE(part_id, planned_on)',
    'CHECK(date_unknown = 0 OR expected_on IS NULL)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class IncomeOccurrenceRow extends DataClass
    implements Insertable<IncomeOccurrenceRow> {
  final String id;
  final String sourceId;
  final String? partId;
  final String plannedOn;
  final int plannedAmountMinor;
  final String? expectedOn;
  final int dateUnknown;
  final int? expectedAmountMinor;
  final String state;
  final String? note;
  final int createdAtUtc;
  final int updatedAtUtc;
  const IncomeOccurrenceRow({
    required this.id,
    required this.sourceId,
    this.partId,
    required this.plannedOn,
    required this.plannedAmountMinor,
    this.expectedOn,
    required this.dateUnknown,
    this.expectedAmountMinor,
    required this.state,
    this.note,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_id'] = Variable<String>(sourceId);
    if (!nullToAbsent || partId != null) {
      map['part_id'] = Variable<String>(partId);
    }
    map['planned_on'] = Variable<String>(plannedOn);
    map['planned_amount_minor'] = Variable<int>(plannedAmountMinor);
    if (!nullToAbsent || expectedOn != null) {
      map['expected_on'] = Variable<String>(expectedOn);
    }
    map['date_unknown'] = Variable<int>(dateUnknown);
    if (!nullToAbsent || expectedAmountMinor != null) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor);
    }
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    map['updated_at_utc'] = Variable<int>(updatedAtUtc);
    return map;
  }

  IncomeOccurrencesCompanion toCompanion(bool nullToAbsent) {
    return IncomeOccurrencesCompanion(
      id: Value(id),
      sourceId: Value(sourceId),
      partId: partId == null && nullToAbsent
          ? const Value.absent()
          : Value(partId),
      plannedOn: Value(plannedOn),
      plannedAmountMinor: Value(plannedAmountMinor),
      expectedOn: expectedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedOn),
      dateUnknown: Value(dateUnknown),
      expectedAmountMinor: expectedAmountMinor == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedAmountMinor),
      state: Value(state),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAtUtc: Value(createdAtUtc),
      updatedAtUtc: Value(updatedAtUtc),
    );
  }

  factory IncomeOccurrenceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeOccurrenceRow(
      id: serializer.fromJson<String>(json['id']),
      sourceId: serializer.fromJson<String>(json['source_id']),
      partId: serializer.fromJson<String?>(json['part_id']),
      plannedOn: serializer.fromJson<String>(json['planned_on']),
      plannedAmountMinor: serializer.fromJson<int>(
        json['planned_amount_minor'],
      ),
      expectedOn: serializer.fromJson<String?>(json['expected_on']),
      dateUnknown: serializer.fromJson<int>(json['date_unknown']),
      expectedAmountMinor: serializer.fromJson<int?>(
        json['expected_amount_minor'],
      ),
      state: serializer.fromJson<String>(json['state']),
      note: serializer.fromJson<String?>(json['note']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
      updatedAtUtc: serializer.fromJson<int>(json['updated_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source_id': serializer.toJson<String>(sourceId),
      'part_id': serializer.toJson<String?>(partId),
      'planned_on': serializer.toJson<String>(plannedOn),
      'planned_amount_minor': serializer.toJson<int>(plannedAmountMinor),
      'expected_on': serializer.toJson<String?>(expectedOn),
      'date_unknown': serializer.toJson<int>(dateUnknown),
      'expected_amount_minor': serializer.toJson<int?>(expectedAmountMinor),
      'state': serializer.toJson<String>(state),
      'note': serializer.toJson<String?>(note),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
      'updated_at_utc': serializer.toJson<int>(updatedAtUtc),
    };
  }

  IncomeOccurrenceRow copyWith({
    String? id,
    String? sourceId,
    Value<String?> partId = const Value.absent(),
    String? plannedOn,
    int? plannedAmountMinor,
    Value<String?> expectedOn = const Value.absent(),
    int? dateUnknown,
    Value<int?> expectedAmountMinor = const Value.absent(),
    String? state,
    Value<String?> note = const Value.absent(),
    int? createdAtUtc,
    int? updatedAtUtc,
  }) => IncomeOccurrenceRow(
    id: id ?? this.id,
    sourceId: sourceId ?? this.sourceId,
    partId: partId.present ? partId.value : this.partId,
    plannedOn: plannedOn ?? this.plannedOn,
    plannedAmountMinor: plannedAmountMinor ?? this.plannedAmountMinor,
    expectedOn: expectedOn.present ? expectedOn.value : this.expectedOn,
    dateUnknown: dateUnknown ?? this.dateUnknown,
    expectedAmountMinor: expectedAmountMinor.present
        ? expectedAmountMinor.value
        : this.expectedAmountMinor,
    state: state ?? this.state,
    note: note.present ? note.value : this.note,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
    updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
  );
  IncomeOccurrenceRow copyWithCompanion(IncomeOccurrencesCompanion data) {
    return IncomeOccurrenceRow(
      id: data.id.present ? data.id.value : this.id,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      partId: data.partId.present ? data.partId.value : this.partId,
      plannedOn: data.plannedOn.present ? data.plannedOn.value : this.plannedOn,
      plannedAmountMinor: data.plannedAmountMinor.present
          ? data.plannedAmountMinor.value
          : this.plannedAmountMinor,
      expectedOn: data.expectedOn.present
          ? data.expectedOn.value
          : this.expectedOn,
      dateUnknown: data.dateUnknown.present
          ? data.dateUnknown.value
          : this.dateUnknown,
      expectedAmountMinor: data.expectedAmountMinor.present
          ? data.expectedAmountMinor.value
          : this.expectedAmountMinor,
      state: data.state.present ? data.state.value : this.state,
      note: data.note.present ? data.note.value : this.note,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
      updatedAtUtc: data.updatedAtUtc.present
          ? data.updatedAtUtc.value
          : this.updatedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeOccurrenceRow(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('partId: $partId, ')
          ..write('plannedOn: $plannedOn, ')
          ..write('plannedAmountMinor: $plannedAmountMinor, ')
          ..write('expectedOn: $expectedOn, ')
          ..write('dateUnknown: $dateUnknown, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('state: $state, ')
          ..write('note: $note, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceId,
    partId,
    plannedOn,
    plannedAmountMinor,
    expectedOn,
    dateUnknown,
    expectedAmountMinor,
    state,
    note,
    createdAtUtc,
    updatedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeOccurrenceRow &&
          other.id == this.id &&
          other.sourceId == this.sourceId &&
          other.partId == this.partId &&
          other.plannedOn == this.plannedOn &&
          other.plannedAmountMinor == this.plannedAmountMinor &&
          other.expectedOn == this.expectedOn &&
          other.dateUnknown == this.dateUnknown &&
          other.expectedAmountMinor == this.expectedAmountMinor &&
          other.state == this.state &&
          other.note == this.note &&
          other.createdAtUtc == this.createdAtUtc &&
          other.updatedAtUtc == this.updatedAtUtc);
}

class IncomeOccurrencesCompanion extends UpdateCompanion<IncomeOccurrenceRow> {
  final Value<String> id;
  final Value<String> sourceId;
  final Value<String?> partId;
  final Value<String> plannedOn;
  final Value<int> plannedAmountMinor;
  final Value<String?> expectedOn;
  final Value<int> dateUnknown;
  final Value<int?> expectedAmountMinor;
  final Value<String> state;
  final Value<String?> note;
  final Value<int> createdAtUtc;
  final Value<int> updatedAtUtc;
  final Value<int> rowid;
  const IncomeOccurrencesCompanion({
    this.id = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.partId = const Value.absent(),
    this.plannedOn = const Value.absent(),
    this.plannedAmountMinor = const Value.absent(),
    this.expectedOn = const Value.absent(),
    this.dateUnknown = const Value.absent(),
    this.expectedAmountMinor = const Value.absent(),
    this.state = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.updatedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeOccurrencesCompanion.insert({
    required String id,
    required String sourceId,
    this.partId = const Value.absent(),
    required String plannedOn,
    required int plannedAmountMinor,
    this.expectedOn = const Value.absent(),
    required int dateUnknown,
    this.expectedAmountMinor = const Value.absent(),
    required String state,
    this.note = const Value.absent(),
    required int createdAtUtc,
    required int updatedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceId = Value(sourceId),
       plannedOn = Value(plannedOn),
       plannedAmountMinor = Value(plannedAmountMinor),
       dateUnknown = Value(dateUnknown),
       state = Value(state),
       createdAtUtc = Value(createdAtUtc),
       updatedAtUtc = Value(updatedAtUtc);
  static Insertable<IncomeOccurrenceRow> custom({
    Expression<String>? id,
    Expression<String>? sourceId,
    Expression<String>? partId,
    Expression<String>? plannedOn,
    Expression<int>? plannedAmountMinor,
    Expression<String>? expectedOn,
    Expression<int>? dateUnknown,
    Expression<int>? expectedAmountMinor,
    Expression<String>? state,
    Expression<String>? note,
    Expression<int>? createdAtUtc,
    Expression<int>? updatedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceId != null) 'source_id': sourceId,
      if (partId != null) 'part_id': partId,
      if (plannedOn != null) 'planned_on': plannedOn,
      if (plannedAmountMinor != null)
        'planned_amount_minor': plannedAmountMinor,
      if (expectedOn != null) 'expected_on': expectedOn,
      if (dateUnknown != null) 'date_unknown': dateUnknown,
      if (expectedAmountMinor != null)
        'expected_amount_minor': expectedAmountMinor,
      if (state != null) 'state': state,
      if (note != null) 'note': note,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (updatedAtUtc != null) 'updated_at_utc': updatedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeOccurrencesCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceId,
    Value<String?>? partId,
    Value<String>? plannedOn,
    Value<int>? plannedAmountMinor,
    Value<String?>? expectedOn,
    Value<int>? dateUnknown,
    Value<int?>? expectedAmountMinor,
    Value<String>? state,
    Value<String?>? note,
    Value<int>? createdAtUtc,
    Value<int>? updatedAtUtc,
    Value<int>? rowid,
  }) {
    return IncomeOccurrencesCompanion(
      id: id ?? this.id,
      sourceId: sourceId ?? this.sourceId,
      partId: partId ?? this.partId,
      plannedOn: plannedOn ?? this.plannedOn,
      plannedAmountMinor: plannedAmountMinor ?? this.plannedAmountMinor,
      expectedOn: expectedOn ?? this.expectedOn,
      dateUnknown: dateUnknown ?? this.dateUnknown,
      expectedAmountMinor: expectedAmountMinor ?? this.expectedAmountMinor,
      state: state ?? this.state,
      note: note ?? this.note,
      createdAtUtc: createdAtUtc ?? this.createdAtUtc,
      updatedAtUtc: updatedAtUtc ?? this.updatedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (partId.present) {
      map['part_id'] = Variable<String>(partId.value);
    }
    if (plannedOn.present) {
      map['planned_on'] = Variable<String>(plannedOn.value);
    }
    if (plannedAmountMinor.present) {
      map['planned_amount_minor'] = Variable<int>(plannedAmountMinor.value);
    }
    if (expectedOn.present) {
      map['expected_on'] = Variable<String>(expectedOn.value);
    }
    if (dateUnknown.present) {
      map['date_unknown'] = Variable<int>(dateUnknown.value);
    }
    if (expectedAmountMinor.present) {
      map['expected_amount_minor'] = Variable<int>(expectedAmountMinor.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAtUtc.present) {
      map['created_at_utc'] = Variable<int>(createdAtUtc.value);
    }
    if (updatedAtUtc.present) {
      map['updated_at_utc'] = Variable<int>(updatedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeOccurrencesCompanion(')
          ..write('id: $id, ')
          ..write('sourceId: $sourceId, ')
          ..write('partId: $partId, ')
          ..write('plannedOn: $plannedOn, ')
          ..write('plannedAmountMinor: $plannedAmountMinor, ')
          ..write('expectedOn: $expectedOn, ')
          ..write('dateUnknown: $dateUnknown, ')
          ..write('expectedAmountMinor: $expectedAmountMinor, ')
          ..write('state: $state, ')
          ..write('note: $note, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('updatedAtUtc: $updatedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class IncomeReceipts extends Table
    with TableInfo<IncomeReceipts, IncomeReceiptRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  IncomeReceipts(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _occurrenceIdMeta = const VerificationMeta(
    'occurrenceId',
  );
  late final GeneratedColumn<String> occurrenceId = GeneratedColumn<String>(
    'occurrence_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES income_occurrences(id)',
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE REFERENCES journal_entries(id)',
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
  static const VerificationMeta _receivedOnMeta = const VerificationMeta(
    'receivedOn',
  );
  late final GeneratedColumn<String> receivedOn = GeneratedColumn<String>(
    'received_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(received_on) = 10 AND date(received_on) = received_on)',
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
    occurrenceId,
    entryId,
    amountMinor,
    receivedOn,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_receipts';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeReceiptRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurrence_id')) {
      context.handle(
        _occurrenceIdMeta,
        occurrenceId.isAcceptableOrUnknown(
          data['occurrence_id']!,
          _occurrenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
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
    if (data.containsKey('received_on')) {
      context.handle(
        _receivedOnMeta,
        receivedOn.isAcceptableOrUnknown(data['received_on']!, _receivedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedOnMeta);
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
  IncomeReceiptRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeReceiptRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurrenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      receivedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}received_on'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  IncomeReceipts createAlias(String alias) {
    return IncomeReceipts(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class IncomeReceiptRow extends DataClass
    implements Insertable<IncomeReceiptRow> {
  final String id;
  final String occurrenceId;
  final String entryId;
  final int amountMinor;
  final String receivedOn;
  final int createdAtUtc;
  const IncomeReceiptRow({
    required this.id,
    required this.occurrenceId,
    required this.entryId,
    required this.amountMinor,
    required this.receivedOn,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurrence_id'] = Variable<String>(occurrenceId);
    map['entry_id'] = Variable<String>(entryId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['received_on'] = Variable<String>(receivedOn);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  IncomeReceiptsCompanion toCompanion(bool nullToAbsent) {
    return IncomeReceiptsCompanion(
      id: Value(id),
      occurrenceId: Value(occurrenceId),
      entryId: Value(entryId),
      amountMinor: Value(amountMinor),
      receivedOn: Value(receivedOn),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory IncomeReceiptRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeReceiptRow(
      id: serializer.fromJson<String>(json['id']),
      occurrenceId: serializer.fromJson<String>(json['occurrence_id']),
      entryId: serializer.fromJson<String>(json['entry_id']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      receivedOn: serializer.fromJson<String>(json['received_on']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurrence_id': serializer.toJson<String>(occurrenceId),
      'entry_id': serializer.toJson<String>(entryId),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'received_on': serializer.toJson<String>(receivedOn),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
    };
  }

  IncomeReceiptRow copyWith({
    String? id,
    String? occurrenceId,
    String? entryId,
    int? amountMinor,
    String? receivedOn,
    int? createdAtUtc,
  }) => IncomeReceiptRow(
    id: id ?? this.id,
    occurrenceId: occurrenceId ?? this.occurrenceId,
    entryId: entryId ?? this.entryId,
    amountMinor: amountMinor ?? this.amountMinor,
    receivedOn: receivedOn ?? this.receivedOn,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  IncomeReceiptRow copyWithCompanion(IncomeReceiptsCompanion data) {
    return IncomeReceiptRow(
      id: data.id.present ? data.id.value : this.id,
      occurrenceId: data.occurrenceId.present
          ? data.occurrenceId.value
          : this.occurrenceId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      receivedOn: data.receivedOn.present
          ? data.receivedOn.value
          : this.receivedOn,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeReceiptRow(')
          ..write('id: $id, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('entryId: $entryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occurrenceId,
    entryId,
    amountMinor,
    receivedOn,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeReceiptRow &&
          other.id == this.id &&
          other.occurrenceId == this.occurrenceId &&
          other.entryId == this.entryId &&
          other.amountMinor == this.amountMinor &&
          other.receivedOn == this.receivedOn &&
          other.createdAtUtc == this.createdAtUtc);
}

class IncomeReceiptsCompanion extends UpdateCompanion<IncomeReceiptRow> {
  final Value<String> id;
  final Value<String> occurrenceId;
  final Value<String> entryId;
  final Value<int> amountMinor;
  final Value<String> receivedOn;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const IncomeReceiptsCompanion({
    this.id = const Value.absent(),
    this.occurrenceId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.receivedOn = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeReceiptsCompanion.insert({
    required String id,
    required String occurrenceId,
    required String entryId,
    required int amountMinor,
    required String receivedOn,
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurrenceId = Value(occurrenceId),
       entryId = Value(entryId),
       amountMinor = Value(amountMinor),
       receivedOn = Value(receivedOn),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<IncomeReceiptRow> custom({
    Expression<String>? id,
    Expression<String>? occurrenceId,
    Expression<String>? entryId,
    Expression<int>? amountMinor,
    Expression<String>? receivedOn,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurrenceId != null) 'occurrence_id': occurrenceId,
      if (entryId != null) 'entry_id': entryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (receivedOn != null) 'received_on': receivedOn,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeReceiptsCompanion copyWith({
    Value<String>? id,
    Value<String>? occurrenceId,
    Value<String>? entryId,
    Value<int>? amountMinor,
    Value<String>? receivedOn,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return IncomeReceiptsCompanion(
      id: id ?? this.id,
      occurrenceId: occurrenceId ?? this.occurrenceId,
      entryId: entryId ?? this.entryId,
      amountMinor: amountMinor ?? this.amountMinor,
      receivedOn: receivedOn ?? this.receivedOn,
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
    if (occurrenceId.present) {
      map['occurrence_id'] = Variable<String>(occurrenceId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (receivedOn.present) {
      map['received_on'] = Variable<String>(receivedOn.value);
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
    return (StringBuffer('IncomeReceiptsCompanion(')
          ..write('id: $id, ')
          ..write('occurrenceId: $occurrenceId, ')
          ..write('entryId: $entryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ForecastSettings extends Table
    with TableInfo<ForecastSettings, ForecastSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ForecastSettings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _householdIdMeta = const VerificationMeta(
    'householdId',
  );
  late final GeneratedColumn<String> householdId = GeneratedColumn<String>(
    'household_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES households(id)',
  );
  static const VerificationMeta _periodDaysMeta = const VerificationMeta(
    'periodDays',
  );
  late final GeneratedColumn<int> periodDays = GeneratedColumn<int>(
    'period_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (period_days IS NULL OR(typeof(period_days) = \'integer\' AND period_days BETWEEN 1 AND 366))',
  );
  static const VerificationMeta _periodUntilMeta = const VerificationMeta(
    'periodUntil',
  );
  late final GeneratedColumn<String> periodUntil = GeneratedColumn<String>(
    'period_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (period_until IS NULL OR(length(period_until) = 10 AND date(period_until) = period_until))',
  );
  @override
  List<GeneratedColumn> get $columns => [householdId, periodDays, periodUntil];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'forecast_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ForecastSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    if (data.containsKey('period_days')) {
      context.handle(
        _periodDaysMeta,
        periodDays.isAcceptableOrUnknown(data['period_days']!, _periodDaysMeta),
      );
    }
    if (data.containsKey('period_until')) {
      context.handle(
        _periodUntilMeta,
        periodUntil.isAcceptableOrUnknown(
          data['period_until']!,
          _periodUntilMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {householdId};
  @override
  ForecastSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ForecastSettingsRow(
      householdId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_id'],
      )!,
      periodDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_days'],
      ),
      periodUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_until'],
      ),
    );
  }

  @override
  ForecastSettings createAlias(String alias) {
    return ForecastSettings(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((period_days IS NULL)<>(period_until IS NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ForecastSettingsRow extends DataClass
    implements Insertable<ForecastSettingsRow> {
  final String householdId;
  final int? periodDays;
  final String? periodUntil;
  const ForecastSettingsRow({
    required this.householdId,
    this.periodDays,
    this.periodUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['household_id'] = Variable<String>(householdId);
    if (!nullToAbsent || periodDays != null) {
      map['period_days'] = Variable<int>(periodDays);
    }
    if (!nullToAbsent || periodUntil != null) {
      map['period_until'] = Variable<String>(periodUntil);
    }
    return map;
  }

  ForecastSettingsCompanion toCompanion(bool nullToAbsent) {
    return ForecastSettingsCompanion(
      householdId: Value(householdId),
      periodDays: periodDays == null && nullToAbsent
          ? const Value.absent()
          : Value(periodDays),
      periodUntil: periodUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(periodUntil),
    );
  }

  factory ForecastSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ForecastSettingsRow(
      householdId: serializer.fromJson<String>(json['household_id']),
      periodDays: serializer.fromJson<int?>(json['period_days']),
      periodUntil: serializer.fromJson<String?>(json['period_until']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'household_id': serializer.toJson<String>(householdId),
      'period_days': serializer.toJson<int?>(periodDays),
      'period_until': serializer.toJson<String?>(periodUntil),
    };
  }

  ForecastSettingsRow copyWith({
    String? householdId,
    Value<int?> periodDays = const Value.absent(),
    Value<String?> periodUntil = const Value.absent(),
  }) => ForecastSettingsRow(
    householdId: householdId ?? this.householdId,
    periodDays: periodDays.present ? periodDays.value : this.periodDays,
    periodUntil: periodUntil.present ? periodUntil.value : this.periodUntil,
  );
  ForecastSettingsRow copyWithCompanion(ForecastSettingsCompanion data) {
    return ForecastSettingsRow(
      householdId: data.householdId.present
          ? data.householdId.value
          : this.householdId,
      periodDays: data.periodDays.present
          ? data.periodDays.value
          : this.periodDays,
      periodUntil: data.periodUntil.present
          ? data.periodUntil.value
          : this.periodUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ForecastSettingsRow(')
          ..write('householdId: $householdId, ')
          ..write('periodDays: $periodDays, ')
          ..write('periodUntil: $periodUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(householdId, periodDays, periodUntil);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ForecastSettingsRow &&
          other.householdId == this.householdId &&
          other.periodDays == this.periodDays &&
          other.periodUntil == this.periodUntil);
}

class ForecastSettingsCompanion extends UpdateCompanion<ForecastSettingsRow> {
  final Value<String> householdId;
  final Value<int?> periodDays;
  final Value<String?> periodUntil;
  final Value<int> rowid;
  const ForecastSettingsCompanion({
    this.householdId = const Value.absent(),
    this.periodDays = const Value.absent(),
    this.periodUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ForecastSettingsCompanion.insert({
    required String householdId,
    this.periodDays = const Value.absent(),
    this.periodUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : householdId = Value(householdId);
  static Insertable<ForecastSettingsRow> custom({
    Expression<String>? householdId,
    Expression<int>? periodDays,
    Expression<String>? periodUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (householdId != null) 'household_id': householdId,
      if (periodDays != null) 'period_days': periodDays,
      if (periodUntil != null) 'period_until': periodUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ForecastSettingsCompanion copyWith({
    Value<String>? householdId,
    Value<int?>? periodDays,
    Value<String?>? periodUntil,
    Value<int>? rowid,
  }) {
    return ForecastSettingsCompanion(
      householdId: householdId ?? this.householdId,
      periodDays: periodDays ?? this.periodDays,
      periodUntil: periodUntil ?? this.periodUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (householdId.present) {
      map['household_id'] = Variable<String>(householdId.value);
    }
    if (periodDays.present) {
      map['period_days'] = Variable<int>(periodDays.value);
    }
    if (periodUntil.present) {
      map['period_until'] = Variable<String>(periodUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ForecastSettingsCompanion(')
          ..write('householdId: $householdId, ')
          ..write('periodDays: $periodDays, ')
          ..write('periodUntil: $periodUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FlowTracking extends Table with TableInfo<FlowTracking, FlowTrackingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FlowTracking(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _flowIdMeta = const VerificationMeta('flowId');
  late final GeneratedColumn<String> flowId = GeneratedColumn<String>(
    'flow_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY REFERENCES planned_flows(id)',
  );
  static const VerificationMeta _trackedFromMeta = const VerificationMeta(
    'trackedFrom',
  );
  late final GeneratedColumn<String> trackedFrom = GeneratedColumn<String>(
    'tracked_from',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (length(tracked_from) = 10 AND date(tracked_from) = tracked_from)',
  );
  @override
  List<GeneratedColumn> get $columns => [flowId, trackedFrom];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flow_tracking';
  @override
  VerificationContext validateIntegrity(
    Insertable<FlowTrackingRow> instance, {
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
    if (data.containsKey('tracked_from')) {
      context.handle(
        _trackedFromMeta,
        trackedFrom.isAcceptableOrUnknown(
          data['tracked_from']!,
          _trackedFromMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_trackedFromMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {flowId};
  @override
  FlowTrackingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlowTrackingRow(
      flowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_id'],
      )!,
      trackedFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tracked_from'],
      )!,
    );
  }

  @override
  FlowTracking createAlias(String alias) {
    return FlowTracking(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class FlowTrackingRow extends DataClass implements Insertable<FlowTrackingRow> {
  final String flowId;
  final String trackedFrom;
  const FlowTrackingRow({required this.flowId, required this.trackedFrom});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['flow_id'] = Variable<String>(flowId);
    map['tracked_from'] = Variable<String>(trackedFrom);
    return map;
  }

  FlowTrackingCompanion toCompanion(bool nullToAbsent) {
    return FlowTrackingCompanion(
      flowId: Value(flowId),
      trackedFrom: Value(trackedFrom),
    );
  }

  factory FlowTrackingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlowTrackingRow(
      flowId: serializer.fromJson<String>(json['flow_id']),
      trackedFrom: serializer.fromJson<String>(json['tracked_from']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'flow_id': serializer.toJson<String>(flowId),
      'tracked_from': serializer.toJson<String>(trackedFrom),
    };
  }

  FlowTrackingRow copyWith({String? flowId, String? trackedFrom}) =>
      FlowTrackingRow(
        flowId: flowId ?? this.flowId,
        trackedFrom: trackedFrom ?? this.trackedFrom,
      );
  FlowTrackingRow copyWithCompanion(FlowTrackingCompanion data) {
    return FlowTrackingRow(
      flowId: data.flowId.present ? data.flowId.value : this.flowId,
      trackedFrom: data.trackedFrom.present
          ? data.trackedFrom.value
          : this.trackedFrom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlowTrackingRow(')
          ..write('flowId: $flowId, ')
          ..write('trackedFrom: $trackedFrom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(flowId, trackedFrom);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlowTrackingRow &&
          other.flowId == this.flowId &&
          other.trackedFrom == this.trackedFrom);
}

class FlowTrackingCompanion extends UpdateCompanion<FlowTrackingRow> {
  final Value<String> flowId;
  final Value<String> trackedFrom;
  final Value<int> rowid;
  const FlowTrackingCompanion({
    this.flowId = const Value.absent(),
    this.trackedFrom = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlowTrackingCompanion.insert({
    required String flowId,
    required String trackedFrom,
    this.rowid = const Value.absent(),
  }) : flowId = Value(flowId),
       trackedFrom = Value(trackedFrom);
  static Insertable<FlowTrackingRow> custom({
    Expression<String>? flowId,
    Expression<String>? trackedFrom,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (flowId != null) 'flow_id': flowId,
      if (trackedFrom != null) 'tracked_from': trackedFrom,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlowTrackingCompanion copyWith({
    Value<String>? flowId,
    Value<String>? trackedFrom,
    Value<int>? rowid,
  }) {
    return FlowTrackingCompanion(
      flowId: flowId ?? this.flowId,
      trackedFrom: trackedFrom ?? this.trackedFrom,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (flowId.present) {
      map['flow_id'] = Variable<String>(flowId.value);
    }
    if (trackedFrom.present) {
      map['tracked_from'] = Variable<String>(trackedFrom.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlowTrackingCompanion(')
          ..write('flowId: $flowId, ')
          ..write('trackedFrom: $trackedFrom, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class ObligationPayments extends Table
    with TableInfo<ObligationPayments, ObligationPaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  ObligationPayments(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL PRIMARY KEY CHECK (length(id) = 36)',
  );
  static const VerificationMeta _flowIdMeta = const VerificationMeta('flowId');
  late final GeneratedColumn<String> flowId = GeneratedColumn<String>(
    'flow_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES planned_flows(id)',
  );
  static const VerificationMeta _dueOnMeta = const VerificationMeta('dueOn');
  late final GeneratedColumn<String> dueOn = GeneratedColumn<String>(
    'due_on',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'CHECK (due_on IS NULL OR(length(due_on) = 10 AND date(due_on) = due_on))',
  );
  static const VerificationMeta _cardFiguresIdMeta = const VerificationMeta(
    'cardFiguresId',
  );
  late final GeneratedColumn<String> cardFiguresId = GeneratedColumn<String>(
    'card_figures_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES card_figures(id)',
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  late final GeneratedColumn<String> entryId = GeneratedColumn<String>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL UNIQUE REFERENCES journal_entries(id)',
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
  static const VerificationMeta _paidOnMeta = const VerificationMeta('paidOn');
  late final GeneratedColumn<String> paidOn = GeneratedColumn<String>(
    'paid_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (length(paid_on) = 10 AND date(paid_on) = paid_on)',
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
    flowId,
    dueOn,
    cardFiguresId,
    entryId,
    amountMinor,
    paidOn,
    createdAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'obligation_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ObligationPaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('flow_id')) {
      context.handle(
        _flowIdMeta,
        flowId.isAcceptableOrUnknown(data['flow_id']!, _flowIdMeta),
      );
    }
    if (data.containsKey('due_on')) {
      context.handle(
        _dueOnMeta,
        dueOn.isAcceptableOrUnknown(data['due_on']!, _dueOnMeta),
      );
    }
    if (data.containsKey('card_figures_id')) {
      context.handle(
        _cardFiguresIdMeta,
        cardFiguresId.isAcceptableOrUnknown(
          data['card_figures_id']!,
          _cardFiguresIdMeta,
        ),
      );
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
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
    if (data.containsKey('paid_on')) {
      context.handle(
        _paidOnMeta,
        paidOn.isAcceptableOrUnknown(data['paid_on']!, _paidOnMeta),
      );
    } else if (isInserting) {
      context.missing(_paidOnMeta);
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
  ObligationPaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ObligationPaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      flowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flow_id'],
      ),
      dueOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}due_on'],
      ),
      cardFiguresId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_figures_id'],
      ),
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      amountMinor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_minor'],
      )!,
      paidOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}paid_on'],
      )!,
      createdAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at_utc'],
      )!,
    );
  }

  @override
  ObligationPayments createAlias(String alias) {
    return ObligationPayments(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'CHECK((flow_id IS NOT NULL AND due_on IS NOT NULL AND card_figures_id IS NULL)OR(flow_id IS NULL AND due_on IS NULL AND card_figures_id IS NOT NULL))',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class ObligationPaymentRow extends DataClass
    implements Insertable<ObligationPaymentRow> {
  final String id;
  final String? flowId;
  final String? dueOn;
  final String? cardFiguresId;
  final String entryId;
  final int amountMinor;
  final String paidOn;
  final int createdAtUtc;
  const ObligationPaymentRow({
    required this.id,
    this.flowId,
    this.dueOn,
    this.cardFiguresId,
    required this.entryId,
    required this.amountMinor,
    required this.paidOn,
    required this.createdAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || flowId != null) {
      map['flow_id'] = Variable<String>(flowId);
    }
    if (!nullToAbsent || dueOn != null) {
      map['due_on'] = Variable<String>(dueOn);
    }
    if (!nullToAbsent || cardFiguresId != null) {
      map['card_figures_id'] = Variable<String>(cardFiguresId);
    }
    map['entry_id'] = Variable<String>(entryId);
    map['amount_minor'] = Variable<int>(amountMinor);
    map['paid_on'] = Variable<String>(paidOn);
    map['created_at_utc'] = Variable<int>(createdAtUtc);
    return map;
  }

  ObligationPaymentsCompanion toCompanion(bool nullToAbsent) {
    return ObligationPaymentsCompanion(
      id: Value(id),
      flowId: flowId == null && nullToAbsent
          ? const Value.absent()
          : Value(flowId),
      dueOn: dueOn == null && nullToAbsent
          ? const Value.absent()
          : Value(dueOn),
      cardFiguresId: cardFiguresId == null && nullToAbsent
          ? const Value.absent()
          : Value(cardFiguresId),
      entryId: Value(entryId),
      amountMinor: Value(amountMinor),
      paidOn: Value(paidOn),
      createdAtUtc: Value(createdAtUtc),
    );
  }

  factory ObligationPaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ObligationPaymentRow(
      id: serializer.fromJson<String>(json['id']),
      flowId: serializer.fromJson<String?>(json['flow_id']),
      dueOn: serializer.fromJson<String?>(json['due_on']),
      cardFiguresId: serializer.fromJson<String?>(json['card_figures_id']),
      entryId: serializer.fromJson<String>(json['entry_id']),
      amountMinor: serializer.fromJson<int>(json['amount_minor']),
      paidOn: serializer.fromJson<String>(json['paid_on']),
      createdAtUtc: serializer.fromJson<int>(json['created_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'flow_id': serializer.toJson<String?>(flowId),
      'due_on': serializer.toJson<String?>(dueOn),
      'card_figures_id': serializer.toJson<String?>(cardFiguresId),
      'entry_id': serializer.toJson<String>(entryId),
      'amount_minor': serializer.toJson<int>(amountMinor),
      'paid_on': serializer.toJson<String>(paidOn),
      'created_at_utc': serializer.toJson<int>(createdAtUtc),
    };
  }

  ObligationPaymentRow copyWith({
    String? id,
    Value<String?> flowId = const Value.absent(),
    Value<String?> dueOn = const Value.absent(),
    Value<String?> cardFiguresId = const Value.absent(),
    String? entryId,
    int? amountMinor,
    String? paidOn,
    int? createdAtUtc,
  }) => ObligationPaymentRow(
    id: id ?? this.id,
    flowId: flowId.present ? flowId.value : this.flowId,
    dueOn: dueOn.present ? dueOn.value : this.dueOn,
    cardFiguresId: cardFiguresId.present
        ? cardFiguresId.value
        : this.cardFiguresId,
    entryId: entryId ?? this.entryId,
    amountMinor: amountMinor ?? this.amountMinor,
    paidOn: paidOn ?? this.paidOn,
    createdAtUtc: createdAtUtc ?? this.createdAtUtc,
  );
  ObligationPaymentRow copyWithCompanion(ObligationPaymentsCompanion data) {
    return ObligationPaymentRow(
      id: data.id.present ? data.id.value : this.id,
      flowId: data.flowId.present ? data.flowId.value : this.flowId,
      dueOn: data.dueOn.present ? data.dueOn.value : this.dueOn,
      cardFiguresId: data.cardFiguresId.present
          ? data.cardFiguresId.value
          : this.cardFiguresId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      amountMinor: data.amountMinor.present
          ? data.amountMinor.value
          : this.amountMinor,
      paidOn: data.paidOn.present ? data.paidOn.value : this.paidOn,
      createdAtUtc: data.createdAtUtc.present
          ? data.createdAtUtc.value
          : this.createdAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ObligationPaymentRow(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('dueOn: $dueOn, ')
          ..write('cardFiguresId: $cardFiguresId, ')
          ..write('entryId: $entryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidOn: $paidOn, ')
          ..write('createdAtUtc: $createdAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    flowId,
    dueOn,
    cardFiguresId,
    entryId,
    amountMinor,
    paidOn,
    createdAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ObligationPaymentRow &&
          other.id == this.id &&
          other.flowId == this.flowId &&
          other.dueOn == this.dueOn &&
          other.cardFiguresId == this.cardFiguresId &&
          other.entryId == this.entryId &&
          other.amountMinor == this.amountMinor &&
          other.paidOn == this.paidOn &&
          other.createdAtUtc == this.createdAtUtc);
}

class ObligationPaymentsCompanion
    extends UpdateCompanion<ObligationPaymentRow> {
  final Value<String> id;
  final Value<String?> flowId;
  final Value<String?> dueOn;
  final Value<String?> cardFiguresId;
  final Value<String> entryId;
  final Value<int> amountMinor;
  final Value<String> paidOn;
  final Value<int> createdAtUtc;
  final Value<int> rowid;
  const ObligationPaymentsCompanion({
    this.id = const Value.absent(),
    this.flowId = const Value.absent(),
    this.dueOn = const Value.absent(),
    this.cardFiguresId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.amountMinor = const Value.absent(),
    this.paidOn = const Value.absent(),
    this.createdAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObligationPaymentsCompanion.insert({
    required String id,
    this.flowId = const Value.absent(),
    this.dueOn = const Value.absent(),
    this.cardFiguresId = const Value.absent(),
    required String entryId,
    required int amountMinor,
    required String paidOn,
    required int createdAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryId = Value(entryId),
       amountMinor = Value(amountMinor),
       paidOn = Value(paidOn),
       createdAtUtc = Value(createdAtUtc);
  static Insertable<ObligationPaymentRow> custom({
    Expression<String>? id,
    Expression<String>? flowId,
    Expression<String>? dueOn,
    Expression<String>? cardFiguresId,
    Expression<String>? entryId,
    Expression<int>? amountMinor,
    Expression<String>? paidOn,
    Expression<int>? createdAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (flowId != null) 'flow_id': flowId,
      if (dueOn != null) 'due_on': dueOn,
      if (cardFiguresId != null) 'card_figures_id': cardFiguresId,
      if (entryId != null) 'entry_id': entryId,
      if (amountMinor != null) 'amount_minor': amountMinor,
      if (paidOn != null) 'paid_on': paidOn,
      if (createdAtUtc != null) 'created_at_utc': createdAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObligationPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String?>? flowId,
    Value<String?>? dueOn,
    Value<String?>? cardFiguresId,
    Value<String>? entryId,
    Value<int>? amountMinor,
    Value<String>? paidOn,
    Value<int>? createdAtUtc,
    Value<int>? rowid,
  }) {
    return ObligationPaymentsCompanion(
      id: id ?? this.id,
      flowId: flowId ?? this.flowId,
      dueOn: dueOn ?? this.dueOn,
      cardFiguresId: cardFiguresId ?? this.cardFiguresId,
      entryId: entryId ?? this.entryId,
      amountMinor: amountMinor ?? this.amountMinor,
      paidOn: paidOn ?? this.paidOn,
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
    if (flowId.present) {
      map['flow_id'] = Variable<String>(flowId.value);
    }
    if (dueOn.present) {
      map['due_on'] = Variable<String>(dueOn.value);
    }
    if (cardFiguresId.present) {
      map['card_figures_id'] = Variable<String>(cardFiguresId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (amountMinor.present) {
      map['amount_minor'] = Variable<int>(amountMinor.value);
    }
    if (paidOn.present) {
      map['paid_on'] = Variable<String>(paidOn.value);
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
    return (StringBuffer('ObligationPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('flowId: $flowId, ')
          ..write('dueOn: $dueOn, ')
          ..write('cardFiguresId: $cardFiguresId, ')
          ..write('entryId: $entryId, ')
          ..write('amountMinor: $amountMinor, ')
          ..write('paidOn: $paidOn, ')
          ..write('createdAtUtc: $createdAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class FiguresTransferAnswers extends Table
    with TableInfo<FiguresTransferAnswers, FiguresTransferAnswerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  FiguresTransferAnswers(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _figuresIdMeta = const VerificationMeta(
    'figuresId',
  );
  late final GeneratedColumn<String> figuresId = GeneratedColumn<String>(
    'figures_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES card_figures(id)',
  );
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
  static const VerificationMeta _includedMeta = const VerificationMeta(
    'included',
  );
  late final GeneratedColumn<int> included = GeneratedColumn<int>(
    'included',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (included IN (0, 1))',
  );
  static const VerificationMeta _answeredAtUtcMeta = const VerificationMeta(
    'answeredAtUtc',
  );
  late final GeneratedColumn<int> answeredAtUtc = GeneratedColumn<int>(
    'answered_at_utc',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints:
        'NOT NULL CHECK (typeof(answered_at_utc) = \'integer\')',
  );
  @override
  List<GeneratedColumn> get $columns => [
    figuresId,
    entryId,
    included,
    answeredAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'figures_transfer_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<FiguresTransferAnswerRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('figures_id')) {
      context.handle(
        _figuresIdMeta,
        figuresId.isAcceptableOrUnknown(data['figures_id']!, _figuresIdMeta),
      );
    } else if (isInserting) {
      context.missing(_figuresIdMeta);
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('included')) {
      context.handle(
        _includedMeta,
        included.isAcceptableOrUnknown(data['included']!, _includedMeta),
      );
    } else if (isInserting) {
      context.missing(_includedMeta);
    }
    if (data.containsKey('answered_at_utc')) {
      context.handle(
        _answeredAtUtcMeta,
        answeredAtUtc.isAcceptableOrUnknown(
          data['answered_at_utc']!,
          _answeredAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_answeredAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {figuresId, entryId};
  @override
  FiguresTransferAnswerRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FiguresTransferAnswerRow(
      figuresId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}figures_id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entry_id'],
      )!,
      included: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}included'],
      )!,
      answeredAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}answered_at_utc'],
      )!,
    );
  }

  @override
  FiguresTransferAnswers createAlias(String alias) {
    return FiguresTransferAnswers(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const [
    'PRIMARY KEY(figures_id, entry_id)',
  ];
  @override
  bool get dontWriteConstraints => true;
}

class FiguresTransferAnswerRow extends DataClass
    implements Insertable<FiguresTransferAnswerRow> {
  final String figuresId;
  final String entryId;
  final int included;
  final int answeredAtUtc;
  const FiguresTransferAnswerRow({
    required this.figuresId,
    required this.entryId,
    required this.included,
    required this.answeredAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['figures_id'] = Variable<String>(figuresId);
    map['entry_id'] = Variable<String>(entryId);
    map['included'] = Variable<int>(included);
    map['answered_at_utc'] = Variable<int>(answeredAtUtc);
    return map;
  }

  FiguresTransferAnswersCompanion toCompanion(bool nullToAbsent) {
    return FiguresTransferAnswersCompanion(
      figuresId: Value(figuresId),
      entryId: Value(entryId),
      included: Value(included),
      answeredAtUtc: Value(answeredAtUtc),
    );
  }

  factory FiguresTransferAnswerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FiguresTransferAnswerRow(
      figuresId: serializer.fromJson<String>(json['figures_id']),
      entryId: serializer.fromJson<String>(json['entry_id']),
      included: serializer.fromJson<int>(json['included']),
      answeredAtUtc: serializer.fromJson<int>(json['answered_at_utc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'figures_id': serializer.toJson<String>(figuresId),
      'entry_id': serializer.toJson<String>(entryId),
      'included': serializer.toJson<int>(included),
      'answered_at_utc': serializer.toJson<int>(answeredAtUtc),
    };
  }

  FiguresTransferAnswerRow copyWith({
    String? figuresId,
    String? entryId,
    int? included,
    int? answeredAtUtc,
  }) => FiguresTransferAnswerRow(
    figuresId: figuresId ?? this.figuresId,
    entryId: entryId ?? this.entryId,
    included: included ?? this.included,
    answeredAtUtc: answeredAtUtc ?? this.answeredAtUtc,
  );
  FiguresTransferAnswerRow copyWithCompanion(
    FiguresTransferAnswersCompanion data,
  ) {
    return FiguresTransferAnswerRow(
      figuresId: data.figuresId.present ? data.figuresId.value : this.figuresId,
      entryId: data.entryId.present ? data.entryId.value : this.entryId,
      included: data.included.present ? data.included.value : this.included,
      answeredAtUtc: data.answeredAtUtc.present
          ? data.answeredAtUtc.value
          : this.answeredAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FiguresTransferAnswerRow(')
          ..write('figuresId: $figuresId, ')
          ..write('entryId: $entryId, ')
          ..write('included: $included, ')
          ..write('answeredAtUtc: $answeredAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(figuresId, entryId, included, answeredAtUtc);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FiguresTransferAnswerRow &&
          other.figuresId == this.figuresId &&
          other.entryId == this.entryId &&
          other.included == this.included &&
          other.answeredAtUtc == this.answeredAtUtc);
}

class FiguresTransferAnswersCompanion
    extends UpdateCompanion<FiguresTransferAnswerRow> {
  final Value<String> figuresId;
  final Value<String> entryId;
  final Value<int> included;
  final Value<int> answeredAtUtc;
  final Value<int> rowid;
  const FiguresTransferAnswersCompanion({
    this.figuresId = const Value.absent(),
    this.entryId = const Value.absent(),
    this.included = const Value.absent(),
    this.answeredAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FiguresTransferAnswersCompanion.insert({
    required String figuresId,
    required String entryId,
    required int included,
    required int answeredAtUtc,
    this.rowid = const Value.absent(),
  }) : figuresId = Value(figuresId),
       entryId = Value(entryId),
       included = Value(included),
       answeredAtUtc = Value(answeredAtUtc);
  static Insertable<FiguresTransferAnswerRow> custom({
    Expression<String>? figuresId,
    Expression<String>? entryId,
    Expression<int>? included,
    Expression<int>? answeredAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (figuresId != null) 'figures_id': figuresId,
      if (entryId != null) 'entry_id': entryId,
      if (included != null) 'included': included,
      if (answeredAtUtc != null) 'answered_at_utc': answeredAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FiguresTransferAnswersCompanion copyWith({
    Value<String>? figuresId,
    Value<String>? entryId,
    Value<int>? included,
    Value<int>? answeredAtUtc,
    Value<int>? rowid,
  }) {
    return FiguresTransferAnswersCompanion(
      figuresId: figuresId ?? this.figuresId,
      entryId: entryId ?? this.entryId,
      included: included ?? this.included,
      answeredAtUtc: answeredAtUtc ?? this.answeredAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (figuresId.present) {
      map['figures_id'] = Variable<String>(figuresId.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<String>(entryId.value);
    }
    if (included.present) {
      map['included'] = Variable<int>(included.value);
    }
    if (answeredAtUtc.present) {
      map['answered_at_utc'] = Variable<int>(answeredAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FiguresTransferAnswersCompanion(')
          ..write('figuresId: $figuresId, ')
          ..write('entryId: $entryId, ')
          ..write('included: $included, ')
          ..write('answeredAtUtc: $answeredAtUtc, ')
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
  late final CategoryGroups categoryGroups = CategoryGroups(this);
  late final Categories categories = Categories(this);
  late final EntryDetails entryDetails = EntryDetails(this);
  late final Index entryDetailsByCause = Index(
    'entry_details_by_cause',
    'CREATE INDEX entry_details_by_cause ON entry_details (caused_by_entry_id)',
  );
  late final Trigger entryDetailsNoUpdate = Trigger(
    'CREATE TRIGGER entry_details_no_update BEFORE UPDATE ON entry_details BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'entry_details_no_update',
  );
  late final Trigger entryDetailsNoDelete = Trigger(
    'CREATE TRIGGER entry_details_no_delete BEFORE DELETE ON entry_details BEGIN SELECT RAISE (ABORT, \'journal is append-only\');END',
    'entry_details_no_delete',
  );
  late final IncomeSources incomeSources = IncomeSources(this);
  late final IncomeScheduleParts incomeScheduleParts = IncomeScheduleParts(
    this,
  );
  late final IncomeOccurrences incomeOccurrences = IncomeOccurrences(this);
  late final Index incomeOccurrencesBySource = Index(
    'income_occurrences_by_source',
    'CREATE INDEX income_occurrences_by_source ON income_occurrences (source_id, planned_on)',
  );
  late final IncomeReceipts incomeReceipts = IncomeReceipts(this);
  late final Index incomeReceiptsByOccurrence = Index(
    'income_receipts_by_occurrence',
    'CREATE INDEX income_receipts_by_occurrence ON income_receipts (occurrence_id)',
  );
  late final Trigger incomeReceiptsNoUpdate = Trigger(
    'CREATE TRIGGER income_receipts_no_update BEFORE UPDATE ON income_receipts BEGIN SELECT RAISE (ABORT, \'receipts are append-only\');END',
    'income_receipts_no_update',
  );
  late final Trigger incomeReceiptsNoDelete = Trigger(
    'CREATE TRIGGER income_receipts_no_delete BEFORE DELETE ON income_receipts BEGIN SELECT RAISE (ABORT, \'receipts are append-only\');END',
    'income_receipts_no_delete',
  );
  late final ForecastSettings forecastSettings = ForecastSettings(this);
  late final FlowTracking flowTracking = FlowTracking(this);
  late final ObligationPayments obligationPayments = ObligationPayments(this);
  late final Index obligationPaymentsByFlow = Index(
    'obligation_payments_by_flow',
    'CREATE INDEX obligation_payments_by_flow ON obligation_payments (flow_id, due_on)',
  );
  late final Index obligationPaymentsByCard = Index(
    'obligation_payments_by_card',
    'CREATE INDEX obligation_payments_by_card ON obligation_payments (card_figures_id)',
  );
  late final Trigger obligationPaymentsNoUpdate = Trigger(
    'CREATE TRIGGER obligation_payments_no_update BEFORE UPDATE ON obligation_payments BEGIN SELECT RAISE (ABORT, \'payments are append-only\');END',
    'obligation_payments_no_update',
  );
  late final Trigger obligationPaymentsNoDelete = Trigger(
    'CREATE TRIGGER obligation_payments_no_delete BEFORE DELETE ON obligation_payments BEGIN SELECT RAISE (ABORT, \'payments are append-only\');END',
    'obligation_payments_no_delete',
  );
  late final FiguresTransferAnswers figuresTransferAnswers =
      FiguresTransferAnswers(this);
  late final Trigger figuresTransferAnswersNoUpdate = Trigger(
    'CREATE TRIGGER figures_transfer_answers_no_update BEFORE UPDATE ON figures_transfer_answers BEGIN SELECT RAISE (ABORT, \'answers are append-only\');END',
    'figures_transfer_answers_no_update',
  );
  late final Trigger figuresTransferAnswersNoDelete = Trigger(
    'CREATE TRIGGER figures_transfer_answers_no_delete BEFORE DELETE ON figures_transfer_answers BEGIN SELECT RAISE (ABORT, \'answers are append-only\');END',
    'figures_transfer_answers_no_delete',
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
    categoryGroups,
    categories,
    entryDetails,
    entryDetailsByCause,
    entryDetailsNoUpdate,
    entryDetailsNoDelete,
    incomeSources,
    incomeScheduleParts,
    incomeOccurrences,
    incomeOccurrencesBySource,
    incomeReceipts,
    incomeReceiptsByOccurrence,
    incomeReceiptsNoUpdate,
    incomeReceiptsNoDelete,
    forecastSettings,
    flowTracking,
    obligationPayments,
    obligationPaymentsByFlow,
    obligationPaymentsByCard,
    obligationPaymentsNoUpdate,
    obligationPaymentsNoDelete,
    figuresTransferAnswers,
    figuresTransferAnswersNoUpdate,
    figuresTransferAnswersNoDelete,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entry_details',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'entry_details',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'income_receipts',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'income_receipts',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'obligation_payments',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'obligation_payments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'figures_transfer_answers',
        limitUpdateKind: UpdateKind.update,
      ),
      result: [],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'figures_transfer_answers',
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

  static MultiTypedResultKey<IncomeScheduleParts, List<IncomeSchedulePartRow>>
  _incomeSchedulePartsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incomeScheduleParts,
        aliasName: 'currencies__code__income_schedule_parts__currency',
      );

  $IncomeSchedulePartsProcessedTableManager get incomeSchedulePartsRefs {
    final manager = $IncomeSchedulePartsTableManager(
      $_db,
      $_db.incomeScheduleParts,
    ).filter((f) => f.currency.code.sqlEquals($_itemColumn<String>('code')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeSchedulePartsRefsTable($_db),
    );
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

  Expression<bool> incomeSchedulePartsRefs(
    Expression<bool> Function($IncomeSchedulePartsFilterComposer f) f,
  ) {
    final $IncomeSchedulePartsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsFilterComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
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

  Expression<T> incomeSchedulePartsRefs<T extends Object>(
    Expression<T> Function($IncomeSchedulePartsAnnotationComposer a) f,
  ) {
    final $IncomeSchedulePartsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.currency,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsAnnotationComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
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
            bool incomeSchedulePartsRefs,
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
                incomeSchedulePartsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (householdsRefs) db.households,
                    if (accountsRefs) db.accounts,
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (plannedFlowsRefs) db.plannedFlows,
                    if (incomeSchedulePartsRefs) db.incomeScheduleParts,
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
                      if (incomeSchedulePartsRefs)
                        await $_getPrefetchedDataByColumns<
                          CurrencyRow,
                          Currencies,
                          IncomeSchedulePartRow,
                          IncomeScheduleParts
                        >(
                          currentTable: table,
                          referencedTable: $CurrenciesReferences
                              ._incomeSchedulePartsRefsTable(db),
                          managerFromTypedResult: (p0) => $CurrenciesReferences(
                            db,
                            table,
                            p0,
                          ).incomeSchedulePartsRefs,
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
        bool incomeSchedulePartsRefs,
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

  static MultiTypedResultKey<CategoryGroups, List<CategoryGroupRow>>
  _categoryGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categoryGroups,
    aliasName: 'households__id__category_groups__household_id',
  );

  $CategoryGroupsProcessedTableManager get categoryGroupsRefs {
    final manager = $CategoryGroupsTableManager(
      $_db,
      $_db.categoryGroups,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoryGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<Categories, List<CategoryRow>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: 'households__id__categories__household_id',
  );

  $CategoriesProcessedTableManager get categoriesRefs {
    final manager = $CategoriesTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<IncomeSources, List<IncomeSourceRow>>
  _incomeSourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeSources,
    aliasName: 'households__id__income_sources__household_id',
  );

  $IncomeSourcesProcessedTableManager get incomeSourcesRefs {
    final manager = $IncomeSourcesTableManager(
      $_db,
      $_db.incomeSources,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeSourcesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<ForecastSettings, List<ForecastSettingsRow>>
  _forecastSettingsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.forecastSettings,
    aliasName: 'households__id__forecast_settings__household_id',
  );

  $ForecastSettingsProcessedTableManager get forecastSettingsRefs {
    final manager = $ForecastSettingsTableManager(
      $_db,
      $_db.forecastSettings,
    ).filter((f) => f.householdId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _forecastSettingsRefsTable($_db),
    );
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

  Expression<bool> categoryGroupsRefs(
    Expression<bool> Function($CategoryGroupsFilterComposer f) f,
  ) {
    final $CategoryGroupsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryGroups,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryGroupsFilterComposer(
            $db: $db,
            $table: $db.categoryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> categoriesRefs(
    Expression<bool> Function($CategoriesFilterComposer f) f,
  ) {
    final $CategoriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeSourcesRefs(
    Expression<bool> Function($IncomeSourcesFilterComposer f) f,
  ) {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> forecastSettingsRefs(
    Expression<bool> Function($ForecastSettingsFilterComposer f) f,
  ) {
    final $ForecastSettingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.forecastSettings,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ForecastSettingsFilterComposer(
            $db: $db,
            $table: $db.forecastSettings,
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

  Expression<T> categoryGroupsRefs<T extends Object>(
    Expression<T> Function($CategoryGroupsAnnotationComposer a) f,
  ) {
    final $CategoryGroupsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categoryGroups,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryGroupsAnnotationComposer(
            $db: $db,
            $table: $db.categoryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($CategoriesAnnotationComposer a) f,
  ) {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeSourcesRefs<T extends Object>(
    Expression<T> Function($IncomeSourcesAnnotationComposer a) f,
  ) {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> forecastSettingsRefs<T extends Object>(
    Expression<T> Function($ForecastSettingsAnnotationComposer a) f,
  ) {
    final $ForecastSettingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.forecastSettings,
      getReferencedColumn: (t) => t.householdId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ForecastSettingsAnnotationComposer(
            $db: $db,
            $table: $db.forecastSettings,
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
            bool categoryGroupsRefs,
            bool categoriesRefs,
            bool incomeSourcesRefs,
            bool forecastSettingsRefs,
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
                categoryGroupsRefs = false,
                categoriesRefs = false,
                incomeSourcesRefs = false,
                forecastSettingsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (membersRefs) db.members,
                    if (accountsRefs) db.accounts,
                    if (journalEntriesRefs) db.journalEntries,
                    if (plannedFlowsRefs) db.plannedFlows,
                    if (categoryGroupsRefs) db.categoryGroups,
                    if (categoriesRefs) db.categories,
                    if (incomeSourcesRefs) db.incomeSources,
                    if (forecastSettingsRefs) db.forecastSettings,
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
                      if (categoryGroupsRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          CategoryGroupRow,
                          CategoryGroups
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._categoryGroupsRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).categoryGroupsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (categoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          CategoryRow,
                          Categories
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._categoriesRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).categoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (incomeSourcesRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          IncomeSourceRow,
                          IncomeSources
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._incomeSourcesRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).incomeSourcesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'household_id',
                          typedResults: items,
                        ),
                      if (forecastSettingsRefs)
                        await $_getPrefetchedDataByColumns<
                          HouseholdRow,
                          Households,
                          ForecastSettingsRow,
                          ForecastSettings
                        >(
                          currentTable: table,
                          referencedTable: $HouseholdsReferences
                              ._forecastSettingsRefsTable(db),
                          managerFromTypedResult: (p0) => $HouseholdsReferences(
                            db,
                            table,
                            p0,
                          ).forecastSettingsRefs,
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
        bool categoryGroupsRefs,
        bool categoriesRefs,
        bool incomeSourcesRefs,
        bool forecastSettingsRefs,
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

  static MultiTypedResultKey<IncomeSources, List<IncomeSourceRow>>
  _incomeSourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeSources,
    aliasName: 'members__id__income_sources__member_id',
  );

  $IncomeSourcesProcessedTableManager get incomeSourcesRefs {
    final manager = $IncomeSourcesTableManager(
      $_db,
      $_db.incomeSources,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeSourcesRefsTable($_db));
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

  Expression<bool> incomeSourcesRefs(
    Expression<bool> Function($IncomeSourcesFilterComposer f) f,
  ) {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
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

  Expression<T> incomeSourcesRefs<T extends Object>(
    Expression<T> Function($IncomeSourcesAnnotationComposer a) f,
  ) {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
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
            bool incomeSourcesRefs,
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
                incomeSourcesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (accountsRefs) db.accounts,
                    if (journalEntriesRefs) db.journalEntries,
                    if (incomeSourcesRefs) db.incomeSources,
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
                      if (incomeSourcesRefs)
                        await $_getPrefetchedDataByColumns<
                          MemberRow,
                          Members,
                          IncomeSourceRow,
                          IncomeSources
                        >(
                          currentTable: table,
                          referencedTable: $MembersReferences
                              ._incomeSourcesRefsTable(db),
                          managerFromTypedResult: (p0) => $MembersReferences(
                            db,
                            table,
                            p0,
                          ).incomeSourcesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
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
        bool incomeSourcesRefs,
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

  static MultiTypedResultKey<Categories, List<CategoryRow>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: 'accounts__id__categories__ledger_account_id',
  );

  $CategoriesProcessedTableManager get categoriesRefs {
    final manager = $CategoriesTableManager($_db, $_db.categories).filter(
      (f) => f.ledgerAccountId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<IncomeSources, List<IncomeSourceRow>>
  _incomeSourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeSources,
    aliasName: 'accounts__id__income_sources__account_id',
  );

  $IncomeSourcesProcessedTableManager get incomeSourcesRefs {
    final manager = $IncomeSourcesTableManager(
      $_db,
      $_db.incomeSources,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeSourcesRefsTable($_db));
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

  Expression<bool> categoriesRefs(
    Expression<bool> Function($CategoriesFilterComposer f) f,
  ) {
    final $CategoriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.ledgerAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeSourcesRefs(
    Expression<bool> Function($IncomeSourcesFilterComposer f) f,
  ) {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
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

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($CategoriesAnnotationComposer a) f,
  ) {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.ledgerAccountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeSourcesRefs<T extends Object>(
    Expression<T> Function($IncomeSourcesAnnotationComposer a) f,
  ) {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
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
            bool categoriesRefs,
            bool incomeSourcesRefs,
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
                categoriesRefs = false,
                incomeSourcesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (plannedFlowsRefs) db.plannedFlows,
                    if (cardFiguresRefs) db.cardFigures,
                    if (categoriesRefs) db.categories,
                    if (incomeSourcesRefs) db.incomeSources,
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
                      if (categoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          CategoryRow,
                          Categories
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._categoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $AccountsReferences(db, table, p0).categoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'ledger_account_id',
                          typedResults: items,
                        ),
                      if (incomeSourcesRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountRow,
                          Accounts,
                          IncomeSourceRow,
                          IncomeSources
                        >(
                          currentTable: table,
                          referencedTable: $AccountsReferences
                              ._incomeSourcesRefsTable(db),
                          managerFromTypedResult: (p0) => $AccountsReferences(
                            db,
                            table,
                            p0,
                          ).incomeSourcesRefs,
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
        bool categoriesRefs,
        bool incomeSourcesRefs,
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

  static MultiTypedResultKey<IncomeReceipts, List<IncomeReceiptRow>>
  _incomeReceiptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeReceipts,
    aliasName: 'journal_entries__id__income_receipts__entry_id',
  );

  $IncomeReceiptsProcessedTableManager get incomeReceiptsRefs {
    final manager = $IncomeReceiptsTableManager(
      $_db,
      $_db.incomeReceipts,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<ObligationPayments, List<ObligationPaymentRow>>
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName: 'journal_entries__id__obligation_payments__entry_id',
      );

  $ObligationPaymentsProcessedTableManager get obligationPaymentsRefs {
    final manager = $ObligationPaymentsTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    FiguresTransferAnswers,
    List<FiguresTransferAnswerRow>
  >
  _figuresTransferAnswersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.figuresTransferAnswers,
        aliasName: 'journal_entries__id__figures_transfer_answers__entry_id',
      );

  $FiguresTransferAnswersProcessedTableManager get figuresTransferAnswersRefs {
    final manager = $FiguresTransferAnswersTableManager(
      $_db,
      $_db.figuresTransferAnswers,
    ).filter((f) => f.entryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _figuresTransferAnswersRefsTable($_db),
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

  Expression<bool> incomeReceiptsRefs(
    Expression<bool> Function($IncomeReceiptsFilterComposer f) f,
  ) {
    final $IncomeReceiptsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeReceipts,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeReceiptsFilterComposer(
            $db: $db,
            $table: $db.incomeReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($ObligationPaymentsFilterComposer f) f,
  ) {
    final $ObligationPaymentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> figuresTransferAnswersRefs(
    Expression<bool> Function($FiguresTransferAnswersFilterComposer f) f,
  ) {
    final $FiguresTransferAnswersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figuresTransferAnswers,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FiguresTransferAnswersFilterComposer(
            $db: $db,
            $table: $db.figuresTransferAnswers,
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

  Expression<T> incomeReceiptsRefs<T extends Object>(
    Expression<T> Function($IncomeReceiptsAnnotationComposer a) f,
  ) {
    final $IncomeReceiptsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeReceipts,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeReceiptsAnnotationComposer(
            $db: $db,
            $table: $db.incomeReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($ObligationPaymentsAnnotationComposer a) f,
  ) {
    final $ObligationPaymentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsAnnotationComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> figuresTransferAnswersRefs<T extends Object>(
    Expression<T> Function($FiguresTransferAnswersAnnotationComposer a) f,
  ) {
    final $FiguresTransferAnswersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figuresTransferAnswers,
      getReferencedColumn: (t) => t.entryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FiguresTransferAnswersAnnotationComposer(
            $db: $db,
            $table: $db.figuresTransferAnswers,
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
            bool incomeReceiptsRefs,
            bool obligationPaymentsRefs,
            bool figuresTransferAnswersRefs,
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
                incomeReceiptsRefs = false,
                obligationPaymentsRefs = false,
                figuresTransferAnswersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (postingsRefs) db.postings,
                    if (balanceAssertionsRefs) db.balanceAssertions,
                    if (incomeReceiptsRefs) db.incomeReceipts,
                    if (obligationPaymentsRefs) db.obligationPayments,
                    if (figuresTransferAnswersRefs) db.figuresTransferAnswers,
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
                      if (incomeReceiptsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntryRow,
                          JournalEntries,
                          IncomeReceiptRow,
                          IncomeReceipts
                        >(
                          currentTable: table,
                          referencedTable: $JournalEntriesReferences
                              ._incomeReceiptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalEntriesReferences(
                                db,
                                table,
                                p0,
                              ).incomeReceiptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntryRow,
                          JournalEntries,
                          ObligationPaymentRow,
                          ObligationPayments
                        >(
                          currentTable: table,
                          referencedTable: $JournalEntriesReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalEntriesReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'entry_id',
                          typedResults: items,
                        ),
                      if (figuresTransferAnswersRefs)
                        await $_getPrefetchedDataByColumns<
                          JournalEntryRow,
                          JournalEntries,
                          FiguresTransferAnswerRow,
                          FiguresTransferAnswers
                        >(
                          currentTable: table,
                          referencedTable: $JournalEntriesReferences
                              ._figuresTransferAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $JournalEntriesReferences(
                                db,
                                table,
                                p0,
                              ).figuresTransferAnswersRefs,
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
        bool incomeReceiptsRefs,
        bool obligationPaymentsRefs,
        bool figuresTransferAnswersRefs,
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

  static MultiTypedResultKey<IncomeSources, List<IncomeSourceRow>>
  _incomeSourcesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeSources,
    aliasName: 'planned_flows__id__income_sources__migrated_from_flow_id',
  );

  $IncomeSourcesProcessedTableManager get incomeSourcesRefs {
    final manager = $IncomeSourcesTableManager($_db, $_db.incomeSources).filter(
      (f) => f.migratedFromFlowId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_incomeSourcesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<FlowTracking, List<FlowTrackingRow>>
  _flowTrackingRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.flowTracking,
    aliasName: 'planned_flows__id__flow_tracking__flow_id',
  );

  $FlowTrackingProcessedTableManager get flowTrackingRefs {
    final manager = $FlowTrackingTableManager(
      $_db,
      $_db.flowTracking,
    ).filter((f) => f.flowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_flowTrackingRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<ObligationPayments, List<ObligationPaymentRow>>
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName: 'planned_flows__id__obligation_payments__flow_id',
      );

  $ObligationPaymentsProcessedTableManager get obligationPaymentsRefs {
    final manager = $ObligationPaymentsTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.flowId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
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

  Expression<bool> incomeSourcesRefs(
    Expression<bool> Function($IncomeSourcesFilterComposer f) f,
  ) {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.migratedFromFlowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> flowTrackingRefs(
    Expression<bool> Function($FlowTrackingFilterComposer f) f,
  ) {
    final $FlowTrackingFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flowTracking,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowTrackingFilterComposer(
            $db: $db,
            $table: $db.flowTracking,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($ObligationPaymentsFilterComposer f) f,
  ) {
    final $ObligationPaymentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
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

  Expression<T> incomeSourcesRefs<T extends Object>(
    Expression<T> Function($IncomeSourcesAnnotationComposer a) f,
  ) {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.migratedFromFlowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> flowTrackingRefs<T extends Object>(
    Expression<T> Function($FlowTrackingAnnotationComposer a) f,
  ) {
    final $FlowTrackingAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.flowTracking,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FlowTrackingAnnotationComposer(
            $db: $db,
            $table: $db.flowTracking,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($ObligationPaymentsAnnotationComposer a) f,
  ) {
    final $ObligationPaymentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.flowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsAnnotationComposer(
            $db: $db,
            $table: $db.obligationPayments,
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
            bool incomeSourcesRefs,
            bool flowTrackingRefs,
            bool obligationPaymentsRefs,
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
                incomeSourcesRefs = false,
                flowTrackingRefs = false,
                obligationPaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (flowMarksRefs) db.flowMarks,
                    if (incomeSourcesRefs) db.incomeSources,
                    if (flowTrackingRefs) db.flowTracking,
                    if (obligationPaymentsRefs) db.obligationPayments,
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
                      if (incomeSourcesRefs)
                        await $_getPrefetchedDataByColumns<
                          PlannedFlowRow,
                          PlannedFlows,
                          IncomeSourceRow,
                          IncomeSources
                        >(
                          currentTable: table,
                          referencedTable: $PlannedFlowsReferences
                              ._incomeSourcesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $PlannedFlowsReferences(
                                db,
                                table,
                                p0,
                              ).incomeSourcesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'migrated_from_flow_id',
                          typedResults: items,
                        ),
                      if (flowTrackingRefs)
                        await $_getPrefetchedDataByColumns<
                          PlannedFlowRow,
                          PlannedFlows,
                          FlowTrackingRow,
                          FlowTracking
                        >(
                          currentTable: table,
                          referencedTable: $PlannedFlowsReferences
                              ._flowTrackingRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $PlannedFlowsReferences(
                                db,
                                table,
                                p0,
                              ).flowTrackingRefs,
                          currentColumn: 'id',
                          referencedColumn: 'flow_id',
                          typedResults: items,
                        ),
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          PlannedFlowRow,
                          PlannedFlows,
                          ObligationPaymentRow,
                          ObligationPayments
                        >(
                          currentTable: table,
                          referencedTable: $PlannedFlowsReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $PlannedFlowsReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
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
        bool incomeSourcesRefs,
        bool flowTrackingRefs,
        bool obligationPaymentsRefs,
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

  static MultiTypedResultKey<ObligationPayments, List<ObligationPaymentRow>>
  _obligationPaymentsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.obligationPayments,
        aliasName: 'card_figures__id__obligation_payments__card_figures_id',
      );

  $ObligationPaymentsProcessedTableManager get obligationPaymentsRefs {
    final manager = $ObligationPaymentsTableManager(
      $_db,
      $_db.obligationPayments,
    ).filter((f) => f.cardFiguresId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _obligationPaymentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    FiguresTransferAnswers,
    List<FiguresTransferAnswerRow>
  >
  _figuresTransferAnswersRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.figuresTransferAnswers,
        aliasName: 'card_figures__id__figures_transfer_answers__figures_id',
      );

  $FiguresTransferAnswersProcessedTableManager get figuresTransferAnswersRefs {
    final manager = $FiguresTransferAnswersTableManager(
      $_db,
      $_db.figuresTransferAnswers,
    ).filter((f) => f.figuresId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _figuresTransferAnswersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
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

  Expression<bool> obligationPaymentsRefs(
    Expression<bool> Function($ObligationPaymentsFilterComposer f) f,
  ) {
    final $ObligationPaymentsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.cardFiguresId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsFilterComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> figuresTransferAnswersRefs(
    Expression<bool> Function($FiguresTransferAnswersFilterComposer f) f,
  ) {
    final $FiguresTransferAnswersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figuresTransferAnswers,
      getReferencedColumn: (t) => t.figuresId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FiguresTransferAnswersFilterComposer(
            $db: $db,
            $table: $db.figuresTransferAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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

  Expression<T> obligationPaymentsRefs<T extends Object>(
    Expression<T> Function($ObligationPaymentsAnnotationComposer a) f,
  ) {
    final $ObligationPaymentsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.obligationPayments,
      getReferencedColumn: (t) => t.cardFiguresId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $ObligationPaymentsAnnotationComposer(
            $db: $db,
            $table: $db.obligationPayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> figuresTransferAnswersRefs<T extends Object>(
    Expression<T> Function($FiguresTransferAnswersAnnotationComposer a) f,
  ) {
    final $FiguresTransferAnswersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.figuresTransferAnswers,
      getReferencedColumn: (t) => t.figuresId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $FiguresTransferAnswersAnnotationComposer(
            $db: $db,
            $table: $db.figuresTransferAnswers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
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
          PrefetchHooks Function({
            bool accountId,
            bool source,
            bool obligationPaymentsRefs,
            bool figuresTransferAnswersRefs,
          })
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
          prefetchHooksCallback:
              ({
                accountId = false,
                source = false,
                obligationPaymentsRefs = false,
                figuresTransferAnswersRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (obligationPaymentsRefs) db.obligationPayments,
                    if (figuresTransferAnswersRefs) db.figuresTransferAnswers,
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
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $CardFiguresReferences
                                ._accountIdTable(db),
                            referencedColumn: $CardFiguresReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (source) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.source,
                            referencedTable: $CardFiguresReferences
                                ._sourceTable(db),
                            referencedColumn: $CardFiguresReferences
                                ._sourceTable(db)
                                .source,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (obligationPaymentsRefs)
                        await $_getPrefetchedDataByColumns<
                          CardFiguresRow,
                          CardFigures,
                          ObligationPaymentRow,
                          ObligationPayments
                        >(
                          currentTable: table,
                          referencedTable: $CardFiguresReferences
                              ._obligationPaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CardFiguresReferences(
                                db,
                                table,
                                p0,
                              ).obligationPaymentsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'card_figures_id',
                          typedResults: items,
                        ),
                      if (figuresTransferAnswersRefs)
                        await $_getPrefetchedDataByColumns<
                          CardFiguresRow,
                          CardFigures,
                          FiguresTransferAnswerRow,
                          FiguresTransferAnswers
                        >(
                          currentTable: table,
                          referencedTable: $CardFiguresReferences
                              ._figuresTransferAnswersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CardFiguresReferences(
                                db,
                                table,
                                p0,
                              ).figuresTransferAnswersRefs,
                          currentColumn: 'id',
                          referencedColumn: 'figures_id',
                          typedResults: items,
                        ),
                    ];
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
      PrefetchHooks Function({
        bool accountId,
        bool source,
        bool obligationPaymentsRefs,
        bool figuresTransferAnswersRefs,
      })
    >;
typedef $CategoryGroupsCreateCompanionBuilder =
    CategoryGroupsCompanion Function({
      required String id,
      required String householdId,
      required String name,
      required int sortOrder,
      Value<int?> archivedAtUtc,
      Value<int> rowid,
    });
typedef $CategoryGroupsUpdateCompanionBuilder =
    CategoryGroupsCompanion Function({
      Value<String> id,
      Value<String> householdId,
      Value<String> name,
      Value<int> sortOrder,
      Value<int?> archivedAtUtc,
      Value<int> rowid,
    });

final class $CategoryGroupsReferences
    extends BaseReferences<_$AppDatabase, CategoryGroups, CategoryGroupRow> {
  $CategoryGroupsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('category_groups__household_id__households__id');

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

  static MultiTypedResultKey<Categories, List<CategoryRow>>
  _categoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.categories,
    aliasName: 'category_groups__id__categories__group_id',
  );

  $CategoriesProcessedTableManager get categoriesRefs {
    final manager = $CategoriesTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_categoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $CategoryGroupsFilterComposer
    extends Composer<_$AppDatabase, CategoryGroups> {
  $CategoryGroupsFilterComposer({
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

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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

  Expression<bool> categoriesRefs(
    Expression<bool> Function($CategoriesFilterComposer f) f,
  ) {
    final $CategoriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoryGroupsOrderingComposer
    extends Composer<_$AppDatabase, CategoryGroups> {
  $CategoryGroupsOrderingComposer({
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

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
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
}

class $CategoryGroupsAnnotationComposer
    extends Composer<_$AppDatabase, CategoryGroups> {
  $CategoryGroupsAnnotationComposer({
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

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

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

  Expression<T> categoriesRefs<T extends Object>(
    Expression<T> Function($CategoriesAnnotationComposer a) f,
  ) {
    final $CategoriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoriesAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $CategoryGroupsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          CategoryGroups,
          CategoryGroupRow,
          $CategoryGroupsFilterComposer,
          $CategoryGroupsOrderingComposer,
          $CategoryGroupsAnnotationComposer,
          $CategoryGroupsCreateCompanionBuilder,
          $CategoryGroupsUpdateCompanionBuilder,
          (CategoryGroupRow, $CategoryGroupsReferences),
          CategoryGroupRow,
          PrefetchHooks Function({bool householdId, bool categoriesRefs})
        > {
  $CategoryGroupsTableManager(_$AppDatabase db, CategoryGroups table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoryGroupsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoryGroupsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoryGroupsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryGroupsCompanion(
                id: id,
                householdId: householdId,
                name: name,
                sortOrder: sortOrder,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String name,
                required int sortOrder,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryGroupsCompanion.insert(
                id: id,
                householdId: householdId,
                name: name,
                sortOrder: sortOrder,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<CategoryGroups, CategoryGroupRow>(table),
                  $CategoryGroupsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({householdId = false, categoriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (categoriesRefs) db.categories],
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
                            referencedTable: $CategoryGroupsReferences
                                ._householdIdTable(db),
                            referencedColumn: $CategoryGroupsReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryGroupRow,
                          CategoryGroups,
                          CategoryRow,
                          Categories
                        >(
                          currentTable: table,
                          referencedTable: $CategoryGroupsReferences
                              ._categoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $CategoryGroupsReferences(
                                db,
                                table,
                                p0,
                              ).categoriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'group_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $CategoryGroupsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      CategoryGroups,
      CategoryGroupRow,
      $CategoryGroupsFilterComposer,
      $CategoryGroupsOrderingComposer,
      $CategoryGroupsAnnotationComposer,
      $CategoryGroupsCreateCompanionBuilder,
      $CategoryGroupsUpdateCompanionBuilder,
      (CategoryGroupRow, $CategoryGroupsReferences),
      CategoryGroupRow,
      PrefetchHooks Function({bool householdId, bool categoriesRefs})
    >;
typedef $CategoriesCreateCompanionBuilder = CategoriesCompanion Function({
  required String id,
  required String householdId,
  required String direction,
  required String name,
  required String icon,
  Value<String?> groupId,
  required String ledgerAccountId,
  Value<String?> systemKey,
  required int sortOrder,
  required int createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});
typedef $CategoriesUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String> direction,
  Value<String> name,
  Value<String> icon,
  Value<String?> groupId,
  Value<String> ledgerAccountId,
  Value<String?> systemKey,
  Value<int> sortOrder,
  Value<int> createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});

final class $CategoriesReferences
    extends BaseReferences<_$AppDatabase, Categories, CategoryRow> {
  $CategoriesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias('categories__household_id__households__id');

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

  static CategoryGroups _groupIdTable(_$AppDatabase db) => db.categoryGroups
      .createAlias('categories__group_id__category_groups__id');

  $CategoryGroupsProcessedTableManager? get groupId {
    final $_column = $_itemColumn<String>('group_id');
    if ($_column == null) return null;
    final manager = $CategoryGroupsTableManager(
      $_db,
      $_db.categoryGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Accounts _ledgerAccountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('categories__ledger_account_id__accounts__id');

  $AccountsProcessedTableManager get ledgerAccountId {
    final $_column = $_itemColumn<String>('ledger_account_id')!;

    final manager = $AccountsTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ledgerAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $CategoriesFilterComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesFilterComposer({
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

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get systemKey => $composableBuilder(
    column: $table.systemKey,
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

  $CategoryGroupsFilterComposer get groupId {
    final $CategoryGroupsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.categoryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryGroupsFilterComposer(
            $db: $db,
            $table: $db.categoryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsFilterComposer get ledgerAccountId {
    final $AccountsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerAccountId,
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
}

class $CategoriesOrderingComposer extends Composer<_$AppDatabase, Categories> {
  $CategoriesOrderingComposer({
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

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get systemKey => $composableBuilder(
    column: $table.systemKey,
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

  $CategoryGroupsOrderingComposer get groupId {
    final $CategoryGroupsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.categoryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryGroupsOrderingComposer(
            $db: $db,
            $table: $db.categoryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsOrderingComposer get ledgerAccountId {
    final $AccountsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerAccountId,
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

class $CategoriesAnnotationComposer
    extends Composer<_$AppDatabase, Categories> {
  $CategoriesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get systemKey =>
      $composableBuilder(column: $table.systemKey, builder: (column) => column);

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

  $CategoryGroupsAnnotationComposer get groupId {
    final $CategoryGroupsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.categoryGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CategoryGroupsAnnotationComposer(
            $db: $db,
            $table: $db.categoryGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $AccountsAnnotationComposer get ledgerAccountId {
    final $AccountsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ledgerAccountId,
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
}

class $CategoriesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Categories,
          CategoryRow,
          $CategoriesFilterComposer,
          $CategoriesOrderingComposer,
          $CategoriesAnnotationComposer,
          $CategoriesCreateCompanionBuilder,
          $CategoriesUpdateCompanionBuilder,
          (CategoryRow, $CategoriesReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool householdId,
            bool groupId,
            bool ledgerAccountId,
          })
        > {
  $CategoriesTableManager(_$AppDatabase db, Categories table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $CategoriesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $CategoriesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $CategoriesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String?> groupId = const Value.absent(),
                Value<String> ledgerAccountId = const Value.absent(),
                Value<String?> systemKey = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                householdId: householdId,
                direction: direction,
                name: name,
                icon: icon,
                groupId: groupId,
                ledgerAccountId: ledgerAccountId,
                systemKey: systemKey,
                sortOrder: sortOrder,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                required String direction,
                required String name,
                required String icon,
                Value<String?> groupId = const Value.absent(),
                required String ledgerAccountId,
                Value<String?> systemKey = const Value.absent(),
                required int sortOrder,
                required int createdAtUtc,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                householdId: householdId,
                direction: direction,
                name: name,
                icon: icon,
                groupId: groupId,
                ledgerAccountId: ledgerAccountId,
                systemKey: systemKey,
                sortOrder: sortOrder,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Categories, CategoryRow>(table),
                  $CategoriesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                groupId = false,
                ledgerAccountId = false,
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
                        if (householdId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.householdId,
                            referencedTable: $CategoriesReferences
                                ._householdIdTable(db),
                            referencedColumn: $CategoriesReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (groupId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.groupId,
                            referencedTable: $CategoriesReferences
                                ._groupIdTable(db),
                            referencedColumn: $CategoriesReferences
                                ._groupIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (ledgerAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ledgerAccountId,
                            referencedTable: $CategoriesReferences
                                ._ledgerAccountIdTable(db),
                            referencedColumn: $CategoriesReferences
                                ._ledgerAccountIdTable(db)
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

typedef $CategoriesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Categories,
      CategoryRow,
      $CategoriesFilterComposer,
      $CategoriesOrderingComposer,
      $CategoriesAnnotationComposer,
      $CategoriesCreateCompanionBuilder,
      $CategoriesUpdateCompanionBuilder,
      (CategoryRow, $CategoriesReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool householdId,
        bool groupId,
        bool ledgerAccountId,
      })
    >;
typedef $EntryDetailsCreateCompanionBuilder = EntryDetailsCompanion Function({
  required String entryId,
  required String occurredOn,
  Value<String?> description,
  Value<String?> counterparty,
  Value<String?> note,
  Value<String?> reversesEntryId,
  Value<String?> supersedesEntryId,
  Value<String?> causedByEntryId,
  Value<int> rowid,
});
typedef $EntryDetailsUpdateCompanionBuilder = EntryDetailsCompanion Function({
  Value<String> entryId,
  Value<String> occurredOn,
  Value<String?> description,
  Value<String?> counterparty,
  Value<String?> note,
  Value<String?> reversesEntryId,
  Value<String?> supersedesEntryId,
  Value<String?> causedByEntryId,
  Value<int> rowid,
});

final class $EntryDetailsReferences
    extends BaseReferences<_$AppDatabase, EntryDetails, EntryDetailsRow> {
  $EntryDetailsReferences(super.$_db, super.$_table, super.$_typedResult);

  static JournalEntries _entryIdTable(_$AppDatabase db) => db.journalEntries
      .createAlias('entry_details__entry_id__journal_entries__id');

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

  static JournalEntries _reversesEntryIdTable(_$AppDatabase db) => db
      .journalEntries
      .createAlias('entry_details__reverses_entry_id__journal_entries__id');

  $JournalEntriesProcessedTableManager? get reversesEntryId {
    final $_column = $_itemColumn<String>('reverses_entry_id');
    if ($_column == null) return null;
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reversesEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _supersedesEntryIdTable(_$AppDatabase db) => db
      .journalEntries
      .createAlias('entry_details__supersedes_entry_id__journal_entries__id');

  $JournalEntriesProcessedTableManager? get supersedesEntryId {
    final $_column = $_itemColumn<String>('supersedes_entry_id');
    if ($_column == null) return null;
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_supersedesEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _causedByEntryIdTable(_$AppDatabase db) => db
      .journalEntries
      .createAlias('entry_details__caused_by_entry_id__journal_entries__id');

  $JournalEntriesProcessedTableManager? get causedByEntryId {
    final $_column = $_itemColumn<String>('caused_by_entry_id');
    if ($_column == null) return null;
    final manager = $JournalEntriesTableManager(
      $_db,
      $_db.journalEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_causedByEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $EntryDetailsFilterComposer
    extends Composer<_$AppDatabase, EntryDetails> {
  $EntryDetailsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
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

  $JournalEntriesFilterComposer get reversesEntryId {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversesEntryId,
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

  $JournalEntriesFilterComposer get supersedesEntryId {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersedesEntryId,
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

  $JournalEntriesFilterComposer get causedByEntryId {
    final $JournalEntriesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.causedByEntryId,
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

class $EntryDetailsOrderingComposer
    extends Composer<_$AppDatabase, EntryDetails> {
  $EntryDetailsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
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

  $JournalEntriesOrderingComposer get reversesEntryId {
    final $JournalEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversesEntryId,
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

  $JournalEntriesOrderingComposer get supersedesEntryId {
    final $JournalEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersedesEntryId,
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

  $JournalEntriesOrderingComposer get causedByEntryId {
    final $JournalEntriesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.causedByEntryId,
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

class $EntryDetailsAnnotationComposer
    extends Composer<_$AppDatabase, EntryDetails> {
  $EntryDetailsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get counterparty => $composableBuilder(
    column: $table.counterparty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

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

  $JournalEntriesAnnotationComposer get reversesEntryId {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.reversesEntryId,
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

  $JournalEntriesAnnotationComposer get supersedesEntryId {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.supersedesEntryId,
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

  $JournalEntriesAnnotationComposer get causedByEntryId {
    final $JournalEntriesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.causedByEntryId,
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

class $EntryDetailsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          EntryDetails,
          EntryDetailsRow,
          $EntryDetailsFilterComposer,
          $EntryDetailsOrderingComposer,
          $EntryDetailsAnnotationComposer,
          $EntryDetailsCreateCompanionBuilder,
          $EntryDetailsUpdateCompanionBuilder,
          (EntryDetailsRow, $EntryDetailsReferences),
          EntryDetailsRow,
          PrefetchHooks Function({
            bool entryId,
            bool reversesEntryId,
            bool supersedesEntryId,
            bool causedByEntryId,
          })
        > {
  $EntryDetailsTableManager(_$AppDatabase db, EntryDetails table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EntryDetailsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EntryDetailsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EntryDetailsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> entryId = const Value.absent(),
                Value<String> occurredOn = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> counterparty = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> reversesEntryId = const Value.absent(),
                Value<String?> supersedesEntryId = const Value.absent(),
                Value<String?> causedByEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryDetailsCompanion(
                entryId: entryId,
                occurredOn: occurredOn,
                description: description,
                counterparty: counterparty,
                note: note,
                reversesEntryId: reversesEntryId,
                supersedesEntryId: supersedesEntryId,
                causedByEntryId: causedByEntryId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String entryId,
                required String occurredOn,
                Value<String?> description = const Value.absent(),
                Value<String?> counterparty = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> reversesEntryId = const Value.absent(),
                Value<String?> supersedesEntryId = const Value.absent(),
                Value<String?> causedByEntryId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EntryDetailsCompanion.insert(
                entryId: entryId,
                occurredOn: occurredOn,
                description: description,
                counterparty: counterparty,
                note: note,
                reversesEntryId: reversesEntryId,
                supersedesEntryId: supersedesEntryId,
                causedByEntryId: causedByEntryId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<EntryDetails, EntryDetailsRow>(table),
                  $EntryDetailsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                entryId = false,
                reversesEntryId = false,
                supersedesEntryId = false,
                causedByEntryId = false,
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
                        if (entryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $EntryDetailsReferences
                                ._entryIdTable(db),
                            referencedColumn: $EntryDetailsReferences
                                ._entryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (reversesEntryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.reversesEntryId,
                            referencedTable: $EntryDetailsReferences
                                ._reversesEntryIdTable(db),
                            referencedColumn: $EntryDetailsReferences
                                ._reversesEntryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (supersedesEntryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.supersedesEntryId,
                            referencedTable: $EntryDetailsReferences
                                ._supersedesEntryIdTable(db),
                            referencedColumn: $EntryDetailsReferences
                                ._supersedesEntryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (causedByEntryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.causedByEntryId,
                            referencedTable: $EntryDetailsReferences
                                ._causedByEntryIdTable(db),
                            referencedColumn: $EntryDetailsReferences
                                ._causedByEntryIdTable(db)
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

typedef $EntryDetailsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      EntryDetails,
      EntryDetailsRow,
      $EntryDetailsFilterComposer,
      $EntryDetailsOrderingComposer,
      $EntryDetailsAnnotationComposer,
      $EntryDetailsCreateCompanionBuilder,
      $EntryDetailsUpdateCompanionBuilder,
      (EntryDetailsRow, $EntryDetailsReferences),
      EntryDetailsRow,
      PrefetchHooks Function({
        bool entryId,
        bool reversesEntryId,
        bool supersedesEntryId,
        bool causedByEntryId,
      })
    >;
typedef $IncomeSourcesCreateCompanionBuilder = IncomeSourcesCompanion Function({
  required String id,
  required String householdId,
  Value<String?> memberId,
  required String name,
  required String kind,
  Value<String?> accountId,
  required String holidayRule,
  required String trackedFrom,
  Value<String?> migratedFromFlowId,
  required int createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});
typedef $IncomeSourcesUpdateCompanionBuilder = IncomeSourcesCompanion Function({
  Value<String> id,
  Value<String> householdId,
  Value<String?> memberId,
  Value<String> name,
  Value<String> kind,
  Value<String?> accountId,
  Value<String> holidayRule,
  Value<String> trackedFrom,
  Value<String?> migratedFromFlowId,
  Value<int> createdAtUtc,
  Value<int?> archivedAtUtc,
  Value<int> rowid,
});

final class $IncomeSourcesReferences
    extends BaseReferences<_$AppDatabase, IncomeSources, IncomeSourceRow> {
  $IncomeSourcesReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) =>
      db.households.createAlias('income_sources__household_id__households__id');

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

  static Members _memberIdTable(_$AppDatabase db) =>
      db.members.createAlias('income_sources__member_id__members__id');

  $MembersProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $MembersTableManager(
      $_db,
      $_db.members,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Accounts _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('income_sources__account_id__accounts__id');

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

  static PlannedFlows _migratedFromFlowIdTable(_$AppDatabase db) => db
      .plannedFlows
      .createAlias('income_sources__migrated_from_flow_id__planned_flows__id');

  $PlannedFlowsProcessedTableManager? get migratedFromFlowId {
    final $_column = $_itemColumn<String>('migrated_from_flow_id');
    if ($_column == null) return null;
    final manager = $PlannedFlowsTableManager(
      $_db,
      $_db.plannedFlows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_migratedFromFlowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<IncomeScheduleParts, List<IncomeSchedulePartRow>>
  _incomeSchedulePartsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incomeScheduleParts,
        aliasName: 'income_sources__id__income_schedule_parts__source_id',
      );

  $IncomeSchedulePartsProcessedTableManager get incomeSchedulePartsRefs {
    final manager = $IncomeSchedulePartsTableManager(
      $_db,
      $_db.incomeScheduleParts,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeSchedulePartsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<IncomeOccurrences, List<IncomeOccurrenceRow>>
  _incomeOccurrencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incomeOccurrences,
        aliasName: 'income_sources__id__income_occurrences__source_id',
      );

  $IncomeOccurrencesProcessedTableManager get incomeOccurrencesRefs {
    final manager = $IncomeOccurrencesTableManager(
      $_db,
      $_db.incomeOccurrences,
    ).filter((f) => f.sourceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $IncomeSourcesFilterComposer
    extends Composer<_$AppDatabase, IncomeSources> {
  $IncomeSourcesFilterComposer({
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

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get holidayRule => $composableBuilder(
    column: $table.holidayRule,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
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

  $MembersFilterComposer get memberId {
    final $MembersFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
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

  $PlannedFlowsFilterComposer get migratedFromFlowId {
    final $PlannedFlowsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.migratedFromFlowId,
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

  Expression<bool> incomeSchedulePartsRefs(
    Expression<bool> Function($IncomeSchedulePartsFilterComposer f) f,
  ) {
    final $IncomeSchedulePartsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsFilterComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeOccurrencesRefs(
    Expression<bool> Function($IncomeOccurrencesFilterComposer f) f,
  ) {
    final $IncomeOccurrencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesFilterComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeSourcesOrderingComposer
    extends Composer<_$AppDatabase, IncomeSources> {
  $IncomeSourcesOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get holidayRule => $composableBuilder(
    column: $table.holidayRule,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
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

  $MembersOrderingComposer get memberId {
    final $MembersOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
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

  $PlannedFlowsOrderingComposer get migratedFromFlowId {
    final $PlannedFlowsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.migratedFromFlowId,
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

class $IncomeSourcesAnnotationComposer
    extends Composer<_$AppDatabase, IncomeSources> {
  $IncomeSourcesAnnotationComposer({
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

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get holidayRule => $composableBuilder(
    column: $table.holidayRule,
    builder: (column) => column,
  );

  GeneratedColumn<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
    builder: (column) => column,
  );

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

  $MembersAnnotationComposer get memberId {
    final $MembersAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
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

  $PlannedFlowsAnnotationComposer get migratedFromFlowId {
    final $PlannedFlowsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.migratedFromFlowId,
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

  Expression<T> incomeSchedulePartsRefs<T extends Object>(
    Expression<T> Function($IncomeSchedulePartsAnnotationComposer a) f,
  ) {
    final $IncomeSchedulePartsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsAnnotationComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeOccurrencesRefs<T extends Object>(
    Expression<T> Function($IncomeOccurrencesAnnotationComposer a) f,
  ) {
    final $IncomeOccurrencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.sourceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesAnnotationComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeSourcesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          IncomeSources,
          IncomeSourceRow,
          $IncomeSourcesFilterComposer,
          $IncomeSourcesOrderingComposer,
          $IncomeSourcesAnnotationComposer,
          $IncomeSourcesCreateCompanionBuilder,
          $IncomeSourcesUpdateCompanionBuilder,
          (IncomeSourceRow, $IncomeSourcesReferences),
          IncomeSourceRow,
          PrefetchHooks Function({
            bool householdId,
            bool memberId,
            bool accountId,
            bool migratedFromFlowId,
            bool incomeSchedulePartsRefs,
            bool incomeOccurrencesRefs,
          })
        > {
  $IncomeSourcesTableManager(_$AppDatabase db, IncomeSources table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IncomeSourcesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IncomeSourcesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IncomeSourcesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> householdId = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String> holidayRule = const Value.absent(),
                Value<String> trackedFrom = const Value.absent(),
                Value<String?> migratedFromFlowId = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeSourcesCompanion(
                id: id,
                householdId: householdId,
                memberId: memberId,
                name: name,
                kind: kind,
                accountId: accountId,
                holidayRule: holidayRule,
                trackedFrom: trackedFrom,
                migratedFromFlowId: migratedFromFlowId,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String householdId,
                Value<String?> memberId = const Value.absent(),
                required String name,
                required String kind,
                Value<String?> accountId = const Value.absent(),
                required String holidayRule,
                required String trackedFrom,
                Value<String?> migratedFromFlowId = const Value.absent(),
                required int createdAtUtc,
                Value<int?> archivedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeSourcesCompanion.insert(
                id: id,
                householdId: householdId,
                memberId: memberId,
                name: name,
                kind: kind,
                accountId: accountId,
                holidayRule: holidayRule,
                trackedFrom: trackedFrom,
                migratedFromFlowId: migratedFromFlowId,
                createdAtUtc: createdAtUtc,
                archivedAtUtc: archivedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<IncomeSources, IncomeSourceRow>(table),
                  $IncomeSourcesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                householdId = false,
                memberId = false,
                accountId = false,
                migratedFromFlowId = false,
                incomeSchedulePartsRefs = false,
                incomeOccurrencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeSchedulePartsRefs) db.incomeScheduleParts,
                    if (incomeOccurrencesRefs) db.incomeOccurrences,
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
                            referencedTable: $IncomeSourcesReferences
                                ._householdIdTable(db),
                            referencedColumn: $IncomeSourcesReferences
                                ._householdIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $IncomeSourcesReferences
                                ._memberIdTable(db),
                            referencedColumn: $IncomeSourcesReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $IncomeSourcesReferences
                                ._accountIdTable(db),
                            referencedColumn: $IncomeSourcesReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (migratedFromFlowId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.migratedFromFlowId,
                            referencedTable: $IncomeSourcesReferences
                                ._migratedFromFlowIdTable(db),
                            referencedColumn: $IncomeSourcesReferences
                                ._migratedFromFlowIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeSchedulePartsRefs)
                        await $_getPrefetchedDataByColumns<
                          IncomeSourceRow,
                          IncomeSources,
                          IncomeSchedulePartRow,
                          IncomeScheduleParts
                        >(
                          currentTable: table,
                          referencedTable: $IncomeSourcesReferences
                              ._incomeSchedulePartsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $IncomeSourcesReferences(
                                db,
                                table,
                                p0,
                              ).incomeSchedulePartsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'source_id',
                          typedResults: items,
                        ),
                      if (incomeOccurrencesRefs)
                        await $_getPrefetchedDataByColumns<
                          IncomeSourceRow,
                          IncomeSources,
                          IncomeOccurrenceRow,
                          IncomeOccurrences
                        >(
                          currentTable: table,
                          referencedTable: $IncomeSourcesReferences
                              ._incomeOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $IncomeSourcesReferences(
                                db,
                                table,
                                p0,
                              ).incomeOccurrencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'source_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $IncomeSourcesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      IncomeSources,
      IncomeSourceRow,
      $IncomeSourcesFilterComposer,
      $IncomeSourcesOrderingComposer,
      $IncomeSourcesAnnotationComposer,
      $IncomeSourcesCreateCompanionBuilder,
      $IncomeSourcesUpdateCompanionBuilder,
      (IncomeSourceRow, $IncomeSourcesReferences),
      IncomeSourceRow,
      PrefetchHooks Function({
        bool householdId,
        bool memberId,
        bool accountId,
        bool migratedFromFlowId,
        bool incomeSchedulePartsRefs,
        bool incomeOccurrencesRefs,
      })
    >;
typedef $IncomeSchedulePartsCreateCompanionBuilder =
    IncomeSchedulePartsCompanion Function({
      required String id,
      required String sourceId,
      required String label,
      required int amountMinor,
      required String currency,
      required String cadence,
      Value<int?> day,
      Value<int?> month,
      Value<String?> onceOn,
      required String validFrom,
      Value<String?> validTo,
      required int createdAtUtc,
      Value<int> rowid,
    });
typedef $IncomeSchedulePartsUpdateCompanionBuilder =
    IncomeSchedulePartsCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String> label,
      Value<int> amountMinor,
      Value<String> currency,
      Value<String> cadence,
      Value<int?> day,
      Value<int?> month,
      Value<String?> onceOn,
      Value<String> validFrom,
      Value<String?> validTo,
      Value<int> createdAtUtc,
      Value<int> rowid,
    });

final class $IncomeSchedulePartsReferences
    extends
        BaseReferences<
          _$AppDatabase,
          IncomeScheduleParts,
          IncomeSchedulePartRow
        > {
  $IncomeSchedulePartsReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static IncomeSources _sourceIdTable(_$AppDatabase db) => db.incomeSources
      .createAlias('income_schedule_parts__source_id__income_sources__id');

  $IncomeSourcesProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $IncomeSourcesTableManager(
      $_db,
      $_db.incomeSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static Currencies _currencyTable(_$AppDatabase db) => db.currencies
      .createAlias('income_schedule_parts__currency__currencies__code');

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

  static MultiTypedResultKey<IncomeOccurrences, List<IncomeOccurrenceRow>>
  _incomeOccurrencesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incomeOccurrences,
        aliasName: 'income_schedule_parts__id__income_occurrences__part_id',
      );

  $IncomeOccurrencesProcessedTableManager get incomeOccurrencesRefs {
    final manager = $IncomeOccurrencesTableManager(
      $_db,
      $_db.incomeOccurrences,
    ).filter((f) => f.partId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeOccurrencesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $IncomeSchedulePartsFilterComposer
    extends Composer<_$AppDatabase, IncomeScheduleParts> {
  $IncomeSchedulePartsFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
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

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $IncomeSourcesFilterComposer get sourceId {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
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

  Expression<bool> incomeOccurrencesRefs(
    Expression<bool> Function($IncomeOccurrencesFilterComposer f) f,
  ) {
    final $IncomeOccurrencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesFilterComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeSchedulePartsOrderingComposer
    extends Composer<_$AppDatabase, IncomeScheduleParts> {
  $IncomeSchedulePartsOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
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

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validTo => $composableBuilder(
    column: $table.validTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $IncomeSourcesOrderingComposer get sourceId {
    final $IncomeSourcesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesOrderingComposer(
            $db: $db,
            $table: $db.incomeSources,
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

class $IncomeSchedulePartsAnnotationComposer
    extends Composer<_$AppDatabase, IncomeScheduleParts> {
  $IncomeSchedulePartsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

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

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get validTo =>
      $composableBuilder(column: $table.validTo, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $IncomeSourcesAnnotationComposer get sourceId {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
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

  Expression<T> incomeOccurrencesRefs<T extends Object>(
    Expression<T> Function($IncomeOccurrencesAnnotationComposer a) f,
  ) {
    final $IncomeOccurrencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.partId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesAnnotationComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeSchedulePartsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          IncomeScheduleParts,
          IncomeSchedulePartRow,
          $IncomeSchedulePartsFilterComposer,
          $IncomeSchedulePartsOrderingComposer,
          $IncomeSchedulePartsAnnotationComposer,
          $IncomeSchedulePartsCreateCompanionBuilder,
          $IncomeSchedulePartsUpdateCompanionBuilder,
          (IncomeSchedulePartRow, $IncomeSchedulePartsReferences),
          IncomeSchedulePartRow,
          PrefetchHooks Function({
            bool sourceId,
            bool currency,
            bool incomeOccurrencesRefs,
          })
        > {
  $IncomeSchedulePartsTableManager(_$AppDatabase db, IncomeScheduleParts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IncomeSchedulePartsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IncomeSchedulePartsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IncomeSchedulePartsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String> cadence = const Value.absent(),
                Value<int?> day = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<String?> onceOn = const Value.absent(),
                Value<String> validFrom = const Value.absent(),
                Value<String?> validTo = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeSchedulePartsCompanion(
                id: id,
                sourceId: sourceId,
                label: label,
                amountMinor: amountMinor,
                currency: currency,
                cadence: cadence,
                day: day,
                month: month,
                onceOn: onceOn,
                validFrom: validFrom,
                validTo: validTo,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                required String label,
                required int amountMinor,
                required String currency,
                required String cadence,
                Value<int?> day = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<String?> onceOn = const Value.absent(),
                required String validFrom,
                Value<String?> validTo = const Value.absent(),
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => IncomeSchedulePartsCompanion.insert(
                id: id,
                sourceId: sourceId,
                label: label,
                amountMinor: amountMinor,
                currency: currency,
                cadence: cadence,
                day: day,
                month: month,
                onceOn: onceOn,
                validFrom: validFrom,
                validTo: validTo,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<IncomeScheduleParts, IncomeSchedulePartRow>(
                    table,
                  ),
                  $IncomeSchedulePartsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceId = false,
                currency = false,
                incomeOccurrencesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeOccurrencesRefs) db.incomeOccurrences,
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
                        if (sourceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceId,
                            referencedTable: $IncomeSchedulePartsReferences
                                ._sourceIdTable(db),
                            referencedColumn: $IncomeSchedulePartsReferences
                                ._sourceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (currency) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.currency,
                            referencedTable: $IncomeSchedulePartsReferences
                                ._currencyTable(db),
                            referencedColumn: $IncomeSchedulePartsReferences
                                ._currencyTable(db)
                                .code,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeOccurrencesRefs)
                        await $_getPrefetchedDataByColumns<
                          IncomeSchedulePartRow,
                          IncomeScheduleParts,
                          IncomeOccurrenceRow,
                          IncomeOccurrences
                        >(
                          currentTable: table,
                          referencedTable: $IncomeSchedulePartsReferences
                              ._incomeOccurrencesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $IncomeSchedulePartsReferences(
                                db,
                                table,
                                p0,
                              ).incomeOccurrencesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'part_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $IncomeSchedulePartsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      IncomeScheduleParts,
      IncomeSchedulePartRow,
      $IncomeSchedulePartsFilterComposer,
      $IncomeSchedulePartsOrderingComposer,
      $IncomeSchedulePartsAnnotationComposer,
      $IncomeSchedulePartsCreateCompanionBuilder,
      $IncomeSchedulePartsUpdateCompanionBuilder,
      (IncomeSchedulePartRow, $IncomeSchedulePartsReferences),
      IncomeSchedulePartRow,
      PrefetchHooks Function({
        bool sourceId,
        bool currency,
        bool incomeOccurrencesRefs,
      })
    >;
typedef $IncomeOccurrencesCreateCompanionBuilder =
    IncomeOccurrencesCompanion Function({
      required String id,
      required String sourceId,
      Value<String?> partId,
      required String plannedOn,
      required int plannedAmountMinor,
      Value<String?> expectedOn,
      required int dateUnknown,
      Value<int?> expectedAmountMinor,
      required String state,
      Value<String?> note,
      required int createdAtUtc,
      required int updatedAtUtc,
      Value<int> rowid,
    });
typedef $IncomeOccurrencesUpdateCompanionBuilder =
    IncomeOccurrencesCompanion Function({
      Value<String> id,
      Value<String> sourceId,
      Value<String?> partId,
      Value<String> plannedOn,
      Value<int> plannedAmountMinor,
      Value<String?> expectedOn,
      Value<int> dateUnknown,
      Value<int?> expectedAmountMinor,
      Value<String> state,
      Value<String?> note,
      Value<int> createdAtUtc,
      Value<int> updatedAtUtc,
      Value<int> rowid,
    });

final class $IncomeOccurrencesReferences
    extends
        BaseReferences<_$AppDatabase, IncomeOccurrences, IncomeOccurrenceRow> {
  $IncomeOccurrencesReferences(super.$_db, super.$_table, super.$_typedResult);

  static IncomeSources _sourceIdTable(_$AppDatabase db) => db.incomeSources
      .createAlias('income_occurrences__source_id__income_sources__id');

  $IncomeSourcesProcessedTableManager get sourceId {
    final $_column = $_itemColumn<String>('source_id')!;

    final manager = $IncomeSourcesTableManager(
      $_db,
      $_db.incomeSources,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static IncomeScheduleParts _partIdTable(_$AppDatabase db) => db
      .incomeScheduleParts
      .createAlias('income_occurrences__part_id__income_schedule_parts__id');

  $IncomeSchedulePartsProcessedTableManager? get partId {
    final $_column = $_itemColumn<String>('part_id');
    if ($_column == null) return null;
    final manager = $IncomeSchedulePartsTableManager(
      $_db,
      $_db.incomeScheduleParts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_partIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<IncomeReceipts, List<IncomeReceiptRow>>
  _incomeReceiptsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeReceipts,
    aliasName: 'income_occurrences__id__income_receipts__occurrence_id',
  );

  $IncomeReceiptsProcessedTableManager get incomeReceiptsRefs {
    final manager = $IncomeReceiptsTableManager(
      $_db,
      $_db.incomeReceipts,
    ).filter((f) => f.occurrenceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_incomeReceiptsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $IncomeOccurrencesFilterComposer
    extends Composer<_$AppDatabase, IncomeOccurrences> {
  $IncomeOccurrencesFilterComposer({
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

  ColumnFilters<String> get plannedOn => $composableBuilder(
    column: $table.plannedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedAmountMinor => $composableBuilder(
    column: $table.plannedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectedOn => $composableBuilder(
    column: $table.expectedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateUnknown => $composableBuilder(
    column: $table.dateUnknown,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $IncomeSourcesFilterComposer get sourceId {
    final $IncomeSourcesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesFilterComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $IncomeSchedulePartsFilterComposer get partId {
    final $IncomeSchedulePartsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsFilterComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> incomeReceiptsRefs(
    Expression<bool> Function($IncomeReceiptsFilterComposer f) f,
  ) {
    final $IncomeReceiptsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeReceipts,
      getReferencedColumn: (t) => t.occurrenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeReceiptsFilterComposer(
            $db: $db,
            $table: $db.incomeReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeOccurrencesOrderingComposer
    extends Composer<_$AppDatabase, IncomeOccurrences> {
  $IncomeOccurrencesOrderingComposer({
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

  ColumnOrderings<String> get plannedOn => $composableBuilder(
    column: $table.plannedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedAmountMinor => $composableBuilder(
    column: $table.plannedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectedOn => $composableBuilder(
    column: $table.expectedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateUnknown => $composableBuilder(
    column: $table.dateUnknown,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $IncomeSourcesOrderingComposer get sourceId {
    final $IncomeSourcesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesOrderingComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $IncomeSchedulePartsOrderingComposer get partId {
    final $IncomeSchedulePartsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsOrderingComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $IncomeOccurrencesAnnotationComposer
    extends Composer<_$AppDatabase, IncomeOccurrences> {
  $IncomeOccurrencesAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plannedOn =>
      $composableBuilder(column: $table.plannedOn, builder: (column) => column);

  GeneratedColumn<int> get plannedAmountMinor => $composableBuilder(
    column: $table.plannedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectedOn => $composableBuilder(
    column: $table.expectedOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dateUnknown => $composableBuilder(
    column: $table.dateUnknown,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedAmountMinor => $composableBuilder(
    column: $table.expectedAmountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAtUtc => $composableBuilder(
    column: $table.updatedAtUtc,
    builder: (column) => column,
  );

  $IncomeSourcesAnnotationComposer get sourceId {
    final $IncomeSourcesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceId,
      referencedTable: $db.incomeSources,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSourcesAnnotationComposer(
            $db: $db,
            $table: $db.incomeSources,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $IncomeSchedulePartsAnnotationComposer get partId {
    final $IncomeSchedulePartsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.partId,
      referencedTable: $db.incomeScheduleParts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeSchedulePartsAnnotationComposer(
            $db: $db,
            $table: $db.incomeScheduleParts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> incomeReceiptsRefs<T extends Object>(
    Expression<T> Function($IncomeReceiptsAnnotationComposer a) f,
  ) {
    final $IncomeReceiptsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeReceipts,
      getReferencedColumn: (t) => t.occurrenceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeReceiptsAnnotationComposer(
            $db: $db,
            $table: $db.incomeReceipts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $IncomeOccurrencesTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          IncomeOccurrences,
          IncomeOccurrenceRow,
          $IncomeOccurrencesFilterComposer,
          $IncomeOccurrencesOrderingComposer,
          $IncomeOccurrencesAnnotationComposer,
          $IncomeOccurrencesCreateCompanionBuilder,
          $IncomeOccurrencesUpdateCompanionBuilder,
          (IncomeOccurrenceRow, $IncomeOccurrencesReferences),
          IncomeOccurrenceRow,
          PrefetchHooks Function({
            bool sourceId,
            bool partId,
            bool incomeReceiptsRefs,
          })
        > {
  $IncomeOccurrencesTableManager(_$AppDatabase db, IncomeOccurrences table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IncomeOccurrencesFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IncomeOccurrencesOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IncomeOccurrencesAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String?> partId = const Value.absent(),
                Value<String> plannedOn = const Value.absent(),
                Value<int> plannedAmountMinor = const Value.absent(),
                Value<String?> expectedOn = const Value.absent(),
                Value<int> dateUnknown = const Value.absent(),
                Value<int?> expectedAmountMinor = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> updatedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeOccurrencesCompanion(
                id: id,
                sourceId: sourceId,
                partId: partId,
                plannedOn: plannedOn,
                plannedAmountMinor: plannedAmountMinor,
                expectedOn: expectedOn,
                dateUnknown: dateUnknown,
                expectedAmountMinor: expectedAmountMinor,
                state: state,
                note: note,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceId,
                Value<String?> partId = const Value.absent(),
                required String plannedOn,
                required int plannedAmountMinor,
                Value<String?> expectedOn = const Value.absent(),
                required int dateUnknown,
                Value<int?> expectedAmountMinor = const Value.absent(),
                required String state,
                Value<String?> note = const Value.absent(),
                required int createdAtUtc,
                required int updatedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => IncomeOccurrencesCompanion.insert(
                id: id,
                sourceId: sourceId,
                partId: partId,
                plannedOn: plannedOn,
                plannedAmountMinor: plannedAmountMinor,
                expectedOn: expectedOn,
                dateUnknown: dateUnknown,
                expectedAmountMinor: expectedAmountMinor,
                state: state,
                note: note,
                createdAtUtc: createdAtUtc,
                updatedAtUtc: updatedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<IncomeOccurrences, IncomeOccurrenceRow>(table),
                  $IncomeOccurrencesReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({sourceId = false, partId = false, incomeReceiptsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeReceiptsRefs) db.incomeReceipts,
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
                        if (sourceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceId,
                            referencedTable: $IncomeOccurrencesReferences
                                ._sourceIdTable(db),
                            referencedColumn: $IncomeOccurrencesReferences
                                ._sourceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (partId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.partId,
                            referencedTable: $IncomeOccurrencesReferences
                                ._partIdTable(db),
                            referencedColumn: $IncomeOccurrencesReferences
                                ._partIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeReceiptsRefs)
                        await $_getPrefetchedDataByColumns<
                          IncomeOccurrenceRow,
                          IncomeOccurrences,
                          IncomeReceiptRow,
                          IncomeReceipts
                        >(
                          currentTable: table,
                          referencedTable: $IncomeOccurrencesReferences
                              ._incomeReceiptsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $IncomeOccurrencesReferences(
                                db,
                                table,
                                p0,
                              ).incomeReceiptsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'occurrence_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $IncomeOccurrencesProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      IncomeOccurrences,
      IncomeOccurrenceRow,
      $IncomeOccurrencesFilterComposer,
      $IncomeOccurrencesOrderingComposer,
      $IncomeOccurrencesAnnotationComposer,
      $IncomeOccurrencesCreateCompanionBuilder,
      $IncomeOccurrencesUpdateCompanionBuilder,
      (IncomeOccurrenceRow, $IncomeOccurrencesReferences),
      IncomeOccurrenceRow,
      PrefetchHooks Function({
        bool sourceId,
        bool partId,
        bool incomeReceiptsRefs,
      })
    >;
typedef $IncomeReceiptsCreateCompanionBuilder =
    IncomeReceiptsCompanion Function({
      required String id,
      required String occurrenceId,
      required String entryId,
      required int amountMinor,
      required String receivedOn,
      required int createdAtUtc,
      Value<int> rowid,
    });
typedef $IncomeReceiptsUpdateCompanionBuilder =
    IncomeReceiptsCompanion Function({
      Value<String> id,
      Value<String> occurrenceId,
      Value<String> entryId,
      Value<int> amountMinor,
      Value<String> receivedOn,
      Value<int> createdAtUtc,
      Value<int> rowid,
    });

final class $IncomeReceiptsReferences
    extends BaseReferences<_$AppDatabase, IncomeReceipts, IncomeReceiptRow> {
  $IncomeReceiptsReferences(super.$_db, super.$_table, super.$_typedResult);

  static IncomeOccurrences _occurrenceIdTable(_$AppDatabase db) => db
      .incomeOccurrences
      .createAlias('income_receipts__occurrence_id__income_occurrences__id');

  $IncomeOccurrencesProcessedTableManager get occurrenceId {
    final $_column = $_itemColumn<String>('occurrence_id')!;

    final manager = $IncomeOccurrencesTableManager(
      $_db,
      $_db.incomeOccurrences,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_occurrenceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _entryIdTable(_$AppDatabase db) => db.journalEntries
      .createAlias('income_receipts__entry_id__journal_entries__id');

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
}

class $IncomeReceiptsFilterComposer
    extends Composer<_$AppDatabase, IncomeReceipts> {
  $IncomeReceiptsFilterComposer({
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

  ColumnFilters<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $IncomeOccurrencesFilterComposer get occurrenceId {
    final $IncomeOccurrencesFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesFilterComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
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

class $IncomeReceiptsOrderingComposer
    extends Composer<_$AppDatabase, IncomeReceipts> {
  $IncomeReceiptsOrderingComposer({
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

  ColumnOrderings<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $IncomeOccurrencesOrderingComposer get occurrenceId {
    final $IncomeOccurrencesOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesOrderingComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
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

class $IncomeReceiptsAnnotationComposer
    extends Composer<_$AppDatabase, IncomeReceipts> {
  $IncomeReceiptsAnnotationComposer({
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

  GeneratedColumn<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
    builder: (column) => column,
  );

  $IncomeOccurrencesAnnotationComposer get occurrenceId {
    final $IncomeOccurrencesAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.occurrenceId,
      referencedTable: $db.incomeOccurrences,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $IncomeOccurrencesAnnotationComposer(
            $db: $db,
            $table: $db.incomeOccurrences,
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

class $IncomeReceiptsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          IncomeReceipts,
          IncomeReceiptRow,
          $IncomeReceiptsFilterComposer,
          $IncomeReceiptsOrderingComposer,
          $IncomeReceiptsAnnotationComposer,
          $IncomeReceiptsCreateCompanionBuilder,
          $IncomeReceiptsUpdateCompanionBuilder,
          (IncomeReceiptRow, $IncomeReceiptsReferences),
          IncomeReceiptRow,
          PrefetchHooks Function({bool occurrenceId, bool entryId})
        > {
  $IncomeReceiptsTableManager(_$AppDatabase db, IncomeReceipts table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $IncomeReceiptsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $IncomeReceiptsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $IncomeReceiptsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> occurrenceId = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> receivedOn = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeReceiptsCompanion(
                id: id,
                occurrenceId: occurrenceId,
                entryId: entryId,
                amountMinor: amountMinor,
                receivedOn: receivedOn,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String occurrenceId,
                required String entryId,
                required int amountMinor,
                required String receivedOn,
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => IncomeReceiptsCompanion.insert(
                id: id,
                occurrenceId: occurrenceId,
                entryId: entryId,
                amountMinor: amountMinor,
                receivedOn: receivedOn,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<IncomeReceipts, IncomeReceiptRow>(table),
                  $IncomeReceiptsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({occurrenceId = false, entryId = false}) {
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
                    if (occurrenceId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.occurrenceId,
                        referencedTable: $IncomeReceiptsReferences
                            ._occurrenceIdTable(db),
                        referencedColumn: $IncomeReceiptsReferences
                            ._occurrenceIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $IncomeReceiptsReferences
                            ._entryIdTable(db),
                        referencedColumn: $IncomeReceiptsReferences
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

typedef $IncomeReceiptsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      IncomeReceipts,
      IncomeReceiptRow,
      $IncomeReceiptsFilterComposer,
      $IncomeReceiptsOrderingComposer,
      $IncomeReceiptsAnnotationComposer,
      $IncomeReceiptsCreateCompanionBuilder,
      $IncomeReceiptsUpdateCompanionBuilder,
      (IncomeReceiptRow, $IncomeReceiptsReferences),
      IncomeReceiptRow,
      PrefetchHooks Function({bool occurrenceId, bool entryId})
    >;
typedef $ForecastSettingsCreateCompanionBuilder =
    ForecastSettingsCompanion Function({
      required String householdId,
      Value<int?> periodDays,
      Value<String?> periodUntil,
      Value<int> rowid,
    });
typedef $ForecastSettingsUpdateCompanionBuilder =
    ForecastSettingsCompanion Function({
      Value<String> householdId,
      Value<int?> periodDays,
      Value<String?> periodUntil,
      Value<int> rowid,
    });

final class $ForecastSettingsReferences
    extends
        BaseReferences<_$AppDatabase, ForecastSettings, ForecastSettingsRow> {
  $ForecastSettingsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Households _householdIdTable(_$AppDatabase db) => db.households
      .createAlias('forecast_settings__household_id__households__id');

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
}

class $ForecastSettingsFilterComposer
    extends Composer<_$AppDatabase, ForecastSettings> {
  $ForecastSettingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodUntil => $composableBuilder(
    column: $table.periodUntil,
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
}

class $ForecastSettingsOrderingComposer
    extends Composer<_$AppDatabase, ForecastSettings> {
  $ForecastSettingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodUntil => $composableBuilder(
    column: $table.periodUntil,
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

class $ForecastSettingsAnnotationComposer
    extends Composer<_$AppDatabase, ForecastSettings> {
  $ForecastSettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get periodDays => $composableBuilder(
    column: $table.periodDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get periodUntil => $composableBuilder(
    column: $table.periodUntil,
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
}

class $ForecastSettingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ForecastSettings,
          ForecastSettingsRow,
          $ForecastSettingsFilterComposer,
          $ForecastSettingsOrderingComposer,
          $ForecastSettingsAnnotationComposer,
          $ForecastSettingsCreateCompanionBuilder,
          $ForecastSettingsUpdateCompanionBuilder,
          (ForecastSettingsRow, $ForecastSettingsReferences),
          ForecastSettingsRow,
          PrefetchHooks Function({bool householdId})
        > {
  $ForecastSettingsTableManager(_$AppDatabase db, ForecastSettings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ForecastSettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ForecastSettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ForecastSettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> householdId = const Value.absent(),
                Value<int?> periodDays = const Value.absent(),
                Value<String?> periodUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForecastSettingsCompanion(
                householdId: householdId,
                periodDays: periodDays,
                periodUntil: periodUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String householdId,
                Value<int?> periodDays = const Value.absent(),
                Value<String?> periodUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ForecastSettingsCompanion.insert(
                householdId: householdId,
                periodDays: periodDays,
                periodUntil: periodUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ForecastSettings, ForecastSettingsRow>(table),
                  $ForecastSettingsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({householdId = false}) {
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
                    if (householdId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.householdId,
                        referencedTable: $ForecastSettingsReferences
                            ._householdIdTable(db),
                        referencedColumn: $ForecastSettingsReferences
                            ._householdIdTable(db)
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

typedef $ForecastSettingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ForecastSettings,
      ForecastSettingsRow,
      $ForecastSettingsFilterComposer,
      $ForecastSettingsOrderingComposer,
      $ForecastSettingsAnnotationComposer,
      $ForecastSettingsCreateCompanionBuilder,
      $ForecastSettingsUpdateCompanionBuilder,
      (ForecastSettingsRow, $ForecastSettingsReferences),
      ForecastSettingsRow,
      PrefetchHooks Function({bool householdId})
    >;
typedef $FlowTrackingCreateCompanionBuilder = FlowTrackingCompanion Function({
  required String flowId,
  required String trackedFrom,
  Value<int> rowid,
});
typedef $FlowTrackingUpdateCompanionBuilder = FlowTrackingCompanion Function({
  Value<String> flowId,
  Value<String> trackedFrom,
  Value<int> rowid,
});

final class $FlowTrackingReferences
    extends BaseReferences<_$AppDatabase, FlowTracking, FlowTrackingRow> {
  $FlowTrackingReferences(super.$_db, super.$_table, super.$_typedResult);

  static PlannedFlows _flowIdTable(_$AppDatabase db) =>
      db.plannedFlows.createAlias('flow_tracking__flow_id__planned_flows__id');

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

class $FlowTrackingFilterComposer
    extends Composer<_$AppDatabase, FlowTracking> {
  $FlowTrackingFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
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

class $FlowTrackingOrderingComposer
    extends Composer<_$AppDatabase, FlowTracking> {
  $FlowTrackingOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
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

class $FlowTrackingAnnotationComposer
    extends Composer<_$AppDatabase, FlowTracking> {
  $FlowTrackingAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get trackedFrom => $composableBuilder(
    column: $table.trackedFrom,
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

class $FlowTrackingTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FlowTracking,
          FlowTrackingRow,
          $FlowTrackingFilterComposer,
          $FlowTrackingOrderingComposer,
          $FlowTrackingAnnotationComposer,
          $FlowTrackingCreateCompanionBuilder,
          $FlowTrackingUpdateCompanionBuilder,
          (FlowTrackingRow, $FlowTrackingReferences),
          FlowTrackingRow,
          PrefetchHooks Function({bool flowId})
        > {
  $FlowTrackingTableManager(_$AppDatabase db, FlowTracking table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FlowTrackingFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FlowTrackingOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FlowTrackingAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> flowId = const Value.absent(),
                Value<String> trackedFrom = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FlowTrackingCompanion(
                flowId: flowId,
                trackedFrom: trackedFrom,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String flowId,
                required String trackedFrom,
                Value<int> rowid = const Value.absent(),
              }) => FlowTrackingCompanion.insert(
                flowId: flowId,
                trackedFrom: trackedFrom,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<FlowTracking, FlowTrackingRow>(table),
                  $FlowTrackingReferences(db, table, e),
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
                        referencedTable: $FlowTrackingReferences._flowIdTable(
                          db,
                        ),
                        referencedColumn: $FlowTrackingReferences
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

typedef $FlowTrackingProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FlowTracking,
      FlowTrackingRow,
      $FlowTrackingFilterComposer,
      $FlowTrackingOrderingComposer,
      $FlowTrackingAnnotationComposer,
      $FlowTrackingCreateCompanionBuilder,
      $FlowTrackingUpdateCompanionBuilder,
      (FlowTrackingRow, $FlowTrackingReferences),
      FlowTrackingRow,
      PrefetchHooks Function({bool flowId})
    >;
typedef $ObligationPaymentsCreateCompanionBuilder =
    ObligationPaymentsCompanion Function({
      required String id,
      Value<String?> flowId,
      Value<String?> dueOn,
      Value<String?> cardFiguresId,
      required String entryId,
      required int amountMinor,
      required String paidOn,
      required int createdAtUtc,
      Value<int> rowid,
    });
typedef $ObligationPaymentsUpdateCompanionBuilder =
    ObligationPaymentsCompanion Function({
      Value<String> id,
      Value<String?> flowId,
      Value<String?> dueOn,
      Value<String?> cardFiguresId,
      Value<String> entryId,
      Value<int> amountMinor,
      Value<String> paidOn,
      Value<int> createdAtUtc,
      Value<int> rowid,
    });

final class $ObligationPaymentsReferences
    extends
        BaseReferences<
          _$AppDatabase,
          ObligationPayments,
          ObligationPaymentRow
        > {
  $ObligationPaymentsReferences(super.$_db, super.$_table, super.$_typedResult);

  static PlannedFlows _flowIdTable(_$AppDatabase db) => db.plannedFlows
      .createAlias('obligation_payments__flow_id__planned_flows__id');

  $PlannedFlowsProcessedTableManager? get flowId {
    final $_column = $_itemColumn<String>('flow_id');
    if ($_column == null) return null;
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

  static CardFigures _cardFiguresIdTable(_$AppDatabase db) => db.cardFigures
      .createAlias('obligation_payments__card_figures_id__card_figures__id');

  $CardFiguresProcessedTableManager? get cardFiguresId {
    final $_column = $_itemColumn<String>('card_figures_id');
    if ($_column == null) return null;
    final manager = $CardFiguresTableManager(
      $_db,
      $_db.cardFigures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardFiguresIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _entryIdTable(_$AppDatabase db) => db.journalEntries
      .createAlias('obligation_payments__entry_id__journal_entries__id');

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
}

class $ObligationPaymentsFilterComposer
    extends Composer<_$AppDatabase, ObligationPayments> {
  $ObligationPaymentsFilterComposer({
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

  ColumnFilters<String> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
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

  $CardFiguresFilterComposer get cardFiguresId {
    final $CardFiguresFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardFiguresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
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

class $ObligationPaymentsOrderingComposer
    extends Composer<_$AppDatabase, ObligationPayments> {
  $ObligationPaymentsOrderingComposer({
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

  ColumnOrderings<String> get dueOn => $composableBuilder(
    column: $table.dueOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paidOn => $composableBuilder(
    column: $table.paidOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
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

  $CardFiguresOrderingComposer get cardFiguresId {
    final $CardFiguresOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardFiguresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresOrderingComposer(
            $db: $db,
            $table: $db.cardFigures,
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

class $ObligationPaymentsAnnotationComposer
    extends Composer<_$AppDatabase, ObligationPayments> {
  $ObligationPaymentsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get dueOn =>
      $composableBuilder(column: $table.dueOn, builder: (column) => column);

  GeneratedColumn<int> get amountMinor => $composableBuilder(
    column: $table.amountMinor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paidOn =>
      $composableBuilder(column: $table.paidOn, builder: (column) => column);

  GeneratedColumn<int> get createdAtUtc => $composableBuilder(
    column: $table.createdAtUtc,
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

  $CardFiguresAnnotationComposer get cardFiguresId {
    final $CardFiguresAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardFiguresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
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

class $ObligationPaymentsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          ObligationPayments,
          ObligationPaymentRow,
          $ObligationPaymentsFilterComposer,
          $ObligationPaymentsOrderingComposer,
          $ObligationPaymentsAnnotationComposer,
          $ObligationPaymentsCreateCompanionBuilder,
          $ObligationPaymentsUpdateCompanionBuilder,
          (ObligationPaymentRow, $ObligationPaymentsReferences),
          ObligationPaymentRow,
          PrefetchHooks Function({
            bool flowId,
            bool cardFiguresId,
            bool entryId,
          })
        > {
  $ObligationPaymentsTableManager(_$AppDatabase db, ObligationPayments table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $ObligationPaymentsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $ObligationPaymentsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $ObligationPaymentsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> flowId = const Value.absent(),
                Value<String?> dueOn = const Value.absent(),
                Value<String?> cardFiguresId = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<int> amountMinor = const Value.absent(),
                Value<String> paidOn = const Value.absent(),
                Value<int> createdAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObligationPaymentsCompanion(
                id: id,
                flowId: flowId,
                dueOn: dueOn,
                cardFiguresId: cardFiguresId,
                entryId: entryId,
                amountMinor: amountMinor,
                paidOn: paidOn,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> flowId = const Value.absent(),
                Value<String?> dueOn = const Value.absent(),
                Value<String?> cardFiguresId = const Value.absent(),
                required String entryId,
                required int amountMinor,
                required String paidOn,
                required int createdAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => ObligationPaymentsCompanion.insert(
                id: id,
                flowId: flowId,
                dueOn: dueOn,
                cardFiguresId: cardFiguresId,
                entryId: entryId,
                amountMinor: amountMinor,
                paidOn: paidOn,
                createdAtUtc: createdAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<ObligationPayments, ObligationPaymentRow>(table),
                  $ObligationPaymentsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({flowId = false, cardFiguresId = false, entryId = false}) {
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
                            referencedTable: $ObligationPaymentsReferences
                                ._flowIdTable(db),
                            referencedColumn: $ObligationPaymentsReferences
                                ._flowIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (cardFiguresId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.cardFiguresId,
                            referencedTable: $ObligationPaymentsReferences
                                ._cardFiguresIdTable(db),
                            referencedColumn: $ObligationPaymentsReferences
                                ._cardFiguresIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (entryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.entryId,
                            referencedTable: $ObligationPaymentsReferences
                                ._entryIdTable(db),
                            referencedColumn: $ObligationPaymentsReferences
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

typedef $ObligationPaymentsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      ObligationPayments,
      ObligationPaymentRow,
      $ObligationPaymentsFilterComposer,
      $ObligationPaymentsOrderingComposer,
      $ObligationPaymentsAnnotationComposer,
      $ObligationPaymentsCreateCompanionBuilder,
      $ObligationPaymentsUpdateCompanionBuilder,
      (ObligationPaymentRow, $ObligationPaymentsReferences),
      ObligationPaymentRow,
      PrefetchHooks Function({bool flowId, bool cardFiguresId, bool entryId})
    >;
typedef $FiguresTransferAnswersCreateCompanionBuilder =
    FiguresTransferAnswersCompanion Function({
      required String figuresId,
      required String entryId,
      required int included,
      required int answeredAtUtc,
      Value<int> rowid,
    });
typedef $FiguresTransferAnswersUpdateCompanionBuilder =
    FiguresTransferAnswersCompanion Function({
      Value<String> figuresId,
      Value<String> entryId,
      Value<int> included,
      Value<int> answeredAtUtc,
      Value<int> rowid,
    });

final class $FiguresTransferAnswersReferences
    extends
        BaseReferences<
          _$AppDatabase,
          FiguresTransferAnswers,
          FiguresTransferAnswerRow
        > {
  $FiguresTransferAnswersReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static CardFigures _figuresIdTable(_$AppDatabase db) => db.cardFigures
      .createAlias('figures_transfer_answers__figures_id__card_figures__id');

  $CardFiguresProcessedTableManager get figuresId {
    final $_column = $_itemColumn<String>('figures_id')!;

    final manager = $CardFiguresTableManager(
      $_db,
      $_db.cardFigures,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_figuresIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static JournalEntries _entryIdTable(_$AppDatabase db) => db.journalEntries
      .createAlias('figures_transfer_answers__entry_id__journal_entries__id');

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
}

class $FiguresTransferAnswersFilterComposer
    extends Composer<_$AppDatabase, FiguresTransferAnswers> {
  $FiguresTransferAnswersFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get included => $composableBuilder(
    column: $table.included,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get answeredAtUtc => $composableBuilder(
    column: $table.answeredAtUtc,
    builder: (column) => ColumnFilters(column),
  );

  $CardFiguresFilterComposer get figuresId {
    final $CardFiguresFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.figuresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
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

class $FiguresTransferAnswersOrderingComposer
    extends Composer<_$AppDatabase, FiguresTransferAnswers> {
  $FiguresTransferAnswersOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get included => $composableBuilder(
    column: $table.included,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get answeredAtUtc => $composableBuilder(
    column: $table.answeredAtUtc,
    builder: (column) => ColumnOrderings(column),
  );

  $CardFiguresOrderingComposer get figuresId {
    final $CardFiguresOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.figuresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $CardFiguresOrderingComposer(
            $db: $db,
            $table: $db.cardFigures,
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

class $FiguresTransferAnswersAnnotationComposer
    extends Composer<_$AppDatabase, FiguresTransferAnswers> {
  $FiguresTransferAnswersAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get included =>
      $composableBuilder(column: $table.included, builder: (column) => column);

  GeneratedColumn<int> get answeredAtUtc => $composableBuilder(
    column: $table.answeredAtUtc,
    builder: (column) => column,
  );

  $CardFiguresAnnotationComposer get figuresId {
    final $CardFiguresAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.figuresId,
      referencedTable: $db.cardFigures,
      getReferencedColumn: (t) => t.id,
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

class $FiguresTransferAnswersTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          FiguresTransferAnswers,
          FiguresTransferAnswerRow,
          $FiguresTransferAnswersFilterComposer,
          $FiguresTransferAnswersOrderingComposer,
          $FiguresTransferAnswersAnnotationComposer,
          $FiguresTransferAnswersCreateCompanionBuilder,
          $FiguresTransferAnswersUpdateCompanionBuilder,
          (FiguresTransferAnswerRow, $FiguresTransferAnswersReferences),
          FiguresTransferAnswerRow,
          PrefetchHooks Function({bool figuresId, bool entryId})
        > {
  $FiguresTransferAnswersTableManager(
    _$AppDatabase db,
    FiguresTransferAnswers table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $FiguresTransferAnswersFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $FiguresTransferAnswersOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $FiguresTransferAnswersAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> figuresId = const Value.absent(),
                Value<String> entryId = const Value.absent(),
                Value<int> included = const Value.absent(),
                Value<int> answeredAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FiguresTransferAnswersCompanion(
                figuresId: figuresId,
                entryId: entryId,
                included: included,
                answeredAtUtc: answeredAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String figuresId,
                required String entryId,
                required int included,
                required int answeredAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => FiguresTransferAnswersCompanion.insert(
                figuresId: figuresId,
                entryId: entryId,
                included: included,
                answeredAtUtc: answeredAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<FiguresTransferAnswers, FiguresTransferAnswerRow>(
                    table,
                  ),
                  $FiguresTransferAnswersReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({figuresId = false, entryId = false}) {
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
                    if (figuresId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.figuresId,
                        referencedTable: $FiguresTransferAnswersReferences
                            ._figuresIdTable(db),
                        referencedColumn: $FiguresTransferAnswersReferences
                            ._figuresIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (entryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.entryId,
                        referencedTable: $FiguresTransferAnswersReferences
                            ._entryIdTable(db),
                        referencedColumn: $FiguresTransferAnswersReferences
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

typedef $FiguresTransferAnswersProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      FiguresTransferAnswers,
      FiguresTransferAnswerRow,
      $FiguresTransferAnswersFilterComposer,
      $FiguresTransferAnswersOrderingComposer,
      $FiguresTransferAnswersAnnotationComposer,
      $FiguresTransferAnswersCreateCompanionBuilder,
      $FiguresTransferAnswersUpdateCompanionBuilder,
      (FiguresTransferAnswerRow, $FiguresTransferAnswersReferences),
      FiguresTransferAnswerRow,
      PrefetchHooks Function({bool figuresId, bool entryId})
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
  $CategoryGroupsTableManager get categoryGroups =>
      $CategoryGroupsTableManager(_db, _db.categoryGroups);
  $CategoriesTableManager get categories =>
      $CategoriesTableManager(_db, _db.categories);
  $EntryDetailsTableManager get entryDetails =>
      $EntryDetailsTableManager(_db, _db.entryDetails);
  $IncomeSourcesTableManager get incomeSources =>
      $IncomeSourcesTableManager(_db, _db.incomeSources);
  $IncomeSchedulePartsTableManager get incomeScheduleParts =>
      $IncomeSchedulePartsTableManager(_db, _db.incomeScheduleParts);
  $IncomeOccurrencesTableManager get incomeOccurrences =>
      $IncomeOccurrencesTableManager(_db, _db.incomeOccurrences);
  $IncomeReceiptsTableManager get incomeReceipts =>
      $IncomeReceiptsTableManager(_db, _db.incomeReceipts);
  $ForecastSettingsTableManager get forecastSettings =>
      $ForecastSettingsTableManager(_db, _db.forecastSettings);
  $FlowTrackingTableManager get flowTracking =>
      $FlowTrackingTableManager(_db, _db.flowTracking);
  $ObligationPaymentsTableManager get obligationPayments =>
      $ObligationPaymentsTableManager(_db, _db.obligationPayments);
  $FiguresTransferAnswersTableManager get figuresTransferAnswers =>
      $FiguresTransferAnswersTableManager(_db, _db.figuresTransferAnswers);
}
