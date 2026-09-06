// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SystemsTable extends Systems with TableInfo<$SystemsTable, System> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SystemKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SystemKind>($SystemsTable.$converterkind);
  static const VerificationMeta _kindLabelMeta = const VerificationMeta(
    'kindLabel',
  );
  @override
  late final GeneratedColumn<String> kindLabel = GeneratedColumn<String>(
    'kind_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _installDateMeta = const VerificationMeta(
    'installDate',
  );
  @override
  late final GeneratedColumn<DateTime> installDate = GeneratedColumn<DateTime>(
    'install_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  specs = GeneratedColumn<String>(
    'specs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, String>>($SystemsTable.$converterspecs);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    kindLabel,
    installDate,
    specs,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'systems';
  @override
  VerificationContext validateIntegrity(
    Insertable<System> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind_label')) {
      context.handle(
        _kindLabelMeta,
        kindLabel.isAcceptableOrUnknown(data['kind_label']!, _kindLabelMeta),
      );
    }
    if (data.containsKey('install_date')) {
      context.handle(
        _installDateMeta,
        installDate.isAcceptableOrUnknown(
          data['install_date']!,
          _installDateMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  System map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return System(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $SystemsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      kindLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_label'],
      ),
      installDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}install_date'],
      ),
      specs: $SystemsTable.$converterspecs.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}specs'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $SystemsTable createAlias(String alias) {
    return $SystemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SystemKind, String, String> $converterkind =
      const EnumNameConverter<SystemKind>(SystemKind.values);
  static TypeConverter<Map<String, String>, String> $converterspecs =
      const SpecsConverter();
}

class System extends DataClass implements Insertable<System> {
  final int id;
  final String name;
  final SystemKind kind;
  final String? kindLabel;
  final DateTime? installDate;
  final Map<String, String> specs;
  final String? notes;
  const System({
    required this.id,
    required this.name,
    required this.kind,
    this.kindLabel,
    this.installDate,
    required this.specs,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>($SystemsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || kindLabel != null) {
      map['kind_label'] = Variable<String>(kindLabel);
    }
    if (!nullToAbsent || installDate != null) {
      map['install_date'] = Variable<DateTime>(installDate);
    }
    {
      map['specs'] = Variable<String>(
        $SystemsTable.$converterspecs.toSql(specs),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  SystemsCompanion toCompanion(bool nullToAbsent) {
    return SystemsCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      kindLabel: kindLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(kindLabel),
      installDate: installDate == null && nullToAbsent
          ? const Value.absent()
          : Value(installDate),
      specs: Value(specs),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory System.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return System(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $SystemsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      kindLabel: serializer.fromJson<String?>(json['kindLabel']),
      installDate: serializer.fromJson<DateTime?>(json['installDate']),
      specs: serializer.fromJson<Map<String, String>>(json['specs']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $SystemsTable.$converterkind.toJson(kind),
      ),
      'kindLabel': serializer.toJson<String?>(kindLabel),
      'installDate': serializer.toJson<DateTime?>(installDate),
      'specs': serializer.toJson<Map<String, String>>(specs),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  System copyWith({
    int? id,
    String? name,
    SystemKind? kind,
    Value<String?> kindLabel = const Value.absent(),
    Value<DateTime?> installDate = const Value.absent(),
    Map<String, String>? specs,
    Value<String?> notes = const Value.absent(),
  }) => System(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    kindLabel: kindLabel.present ? kindLabel.value : this.kindLabel,
    installDate: installDate.present ? installDate.value : this.installDate,
    specs: specs ?? this.specs,
    notes: notes.present ? notes.value : this.notes,
  );
  System copyWithCompanion(SystemsCompanion data) {
    return System(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      kindLabel: data.kindLabel.present ? data.kindLabel.value : this.kindLabel,
      installDate: data.installDate.present
          ? data.installDate.value
          : this.installDate,
      specs: data.specs.present ? data.specs.value : this.specs,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('System(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('installDate: $installDate, ')
          ..write('specs: $specs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, kind, kindLabel, installDate, specs, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is System &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.kindLabel == this.kindLabel &&
          other.installDate == this.installDate &&
          other.specs == this.specs &&
          other.notes == this.notes);
}

class SystemsCompanion extends UpdateCompanion<System> {
  final Value<int> id;
  final Value<String> name;
  final Value<SystemKind> kind;
  final Value<String?> kindLabel;
  final Value<DateTime?> installDate;
  final Value<Map<String, String>> specs;
  final Value<String?> notes;
  const SystemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.kindLabel = const Value.absent(),
    this.installDate = const Value.absent(),
    this.specs = const Value.absent(),
    this.notes = const Value.absent(),
  });
  SystemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required SystemKind kind,
    this.kindLabel = const Value.absent(),
    this.installDate = const Value.absent(),
    this.specs = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<System> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? kindLabel,
    Expression<DateTime>? installDate,
    Expression<String>? specs,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (kindLabel != null) 'kind_label': kindLabel,
      if (installDate != null) 'install_date': installDate,
      if (specs != null) 'specs': specs,
      if (notes != null) 'notes': notes,
    });
  }

  SystemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<SystemKind>? kind,
    Value<String?>? kindLabel,
    Value<DateTime?>? installDate,
    Value<Map<String, String>>? specs,
    Value<String?>? notes,
  }) {
    return SystemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      kindLabel: kindLabel ?? this.kindLabel,
      installDate: installDate ?? this.installDate,
      specs: specs ?? this.specs,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $SystemsTable.$converterkind.toSql(kind.value),
      );
    }
    if (kindLabel.present) {
      map['kind_label'] = Variable<String>(kindLabel.value);
    }
    if (installDate.present) {
      map['install_date'] = Variable<DateTime>(installDate.value);
    }
    if (specs.present) {
      map['specs'] = Variable<String>(
        $SystemsTable.$converterspecs.toSql(specs.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('installDate: $installDate, ')
          ..write('specs: $specs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $EquipmentTable extends Equipment
    with TableInfo<$EquipmentTable, EquipmentData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EquipmentTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<EquipmentKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<EquipmentKind>($EquipmentTable.$converterkind);
  static const VerificationMeta _kindLabelMeta = const VerificationMeta(
    'kindLabel',
  );
  @override
  late final GeneratedColumn<String> kindLabel = GeneratedColumn<String>(
    'kind_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  @override
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<String> serial = GeneratedColumn<String>(
    'serial',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  specs = GeneratedColumn<String>(
    'specs',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, String>>($EquipmentTable.$converterspecs);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    kind,
    kindLabel,
    year,
    model,
    serial,
    specs,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'equipment';
  @override
  VerificationContext validateIntegrity(
    Insertable<EquipmentData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('kind_label')) {
      context.handle(
        _kindLabelMeta,
        kindLabel.isAcceptableOrUnknown(data['kind_label']!, _kindLabelMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EquipmentData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EquipmentData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $EquipmentTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      kindLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_label'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial'],
      ),
      specs: $EquipmentTable.$converterspecs.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}specs'],
        )!,
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $EquipmentTable createAlias(String alias) {
    return $EquipmentTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<EquipmentKind, String, String> $converterkind =
      const EnumNameConverter<EquipmentKind>(EquipmentKind.values);
  static TypeConverter<Map<String, String>, String> $converterspecs =
      const SpecsConverter();
}

class EquipmentData extends DataClass implements Insertable<EquipmentData> {
  final int id;
  final String name;
  final EquipmentKind kind;
  final String? kindLabel;
  final int? year;
  final String? model;
  final String? serial;
  final Map<String, String> specs;
  final String? notes;
  const EquipmentData({
    required this.id,
    required this.name,
    required this.kind,
    this.kindLabel,
    this.year,
    this.model,
    this.serial,
    required this.specs,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<String>(
        $EquipmentTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || kindLabel != null) {
      map['kind_label'] = Variable<String>(kindLabel);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || serial != null) {
      map['serial'] = Variable<String>(serial);
    }
    {
      map['specs'] = Variable<String>(
        $EquipmentTable.$converterspecs.toSql(specs),
      );
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  EquipmentCompanion toCompanion(bool nullToAbsent) {
    return EquipmentCompanion(
      id: Value(id),
      name: Value(name),
      kind: Value(kind),
      kindLabel: kindLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(kindLabel),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      serial: serial == null && nullToAbsent
          ? const Value.absent()
          : Value(serial),
      specs: Value(specs),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory EquipmentData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EquipmentData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      kind: $EquipmentTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      kindLabel: serializer.fromJson<String?>(json['kindLabel']),
      year: serializer.fromJson<int?>(json['year']),
      model: serializer.fromJson<String?>(json['model']),
      serial: serializer.fromJson<String?>(json['serial']),
      specs: serializer.fromJson<Map<String, String>>(json['specs']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<String>(
        $EquipmentTable.$converterkind.toJson(kind),
      ),
      'kindLabel': serializer.toJson<String?>(kindLabel),
      'year': serializer.toJson<int?>(year),
      'model': serializer.toJson<String?>(model),
      'serial': serializer.toJson<String?>(serial),
      'specs': serializer.toJson<Map<String, String>>(specs),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  EquipmentData copyWith({
    int? id,
    String? name,
    EquipmentKind? kind,
    Value<String?> kindLabel = const Value.absent(),
    Value<int?> year = const Value.absent(),
    Value<String?> model = const Value.absent(),
    Value<String?> serial = const Value.absent(),
    Map<String, String>? specs,
    Value<String?> notes = const Value.absent(),
  }) => EquipmentData(
    id: id ?? this.id,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    kindLabel: kindLabel.present ? kindLabel.value : this.kindLabel,
    year: year.present ? year.value : this.year,
    model: model.present ? model.value : this.model,
    serial: serial.present ? serial.value : this.serial,
    specs: specs ?? this.specs,
    notes: notes.present ? notes.value : this.notes,
  );
  EquipmentData copyWithCompanion(EquipmentCompanion data) {
    return EquipmentData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      kindLabel: data.kindLabel.present ? data.kindLabel.value : this.kindLabel,
      year: data.year.present ? data.year.value : this.year,
      model: data.model.present ? data.model.value : this.model,
      serial: data.serial.present ? data.serial.value : this.serial,
      specs: data.specs.present ? data.specs.value : this.specs,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('year: $year, ')
          ..write('model: $model, ')
          ..write('serial: $serial, ')
          ..write('specs: $specs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, kind, kindLabel, year, model, serial, specs, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EquipmentData &&
          other.id == this.id &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.kindLabel == this.kindLabel &&
          other.year == this.year &&
          other.model == this.model &&
          other.serial == this.serial &&
          other.specs == this.specs &&
          other.notes == this.notes);
}

class EquipmentCompanion extends UpdateCompanion<EquipmentData> {
  final Value<int> id;
  final Value<String> name;
  final Value<EquipmentKind> kind;
  final Value<String?> kindLabel;
  final Value<int?> year;
  final Value<String?> model;
  final Value<String?> serial;
  final Value<Map<String, String>> specs;
  final Value<String?> notes;
  const EquipmentCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.kindLabel = const Value.absent(),
    this.year = const Value.absent(),
    this.model = const Value.absent(),
    this.serial = const Value.absent(),
    this.specs = const Value.absent(),
    this.notes = const Value.absent(),
  });
  EquipmentCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required EquipmentKind kind,
    this.kindLabel = const Value.absent(),
    this.year = const Value.absent(),
    this.model = const Value.absent(),
    this.serial = const Value.absent(),
    this.specs = const Value.absent(),
    this.notes = const Value.absent(),
  }) : name = Value(name),
       kind = Value(kind);
  static Insertable<EquipmentData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? kind,
    Expression<String>? kindLabel,
    Expression<int>? year,
    Expression<String>? model,
    Expression<String>? serial,
    Expression<String>? specs,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (kindLabel != null) 'kind_label': kindLabel,
      if (year != null) 'year': year,
      if (model != null) 'model': model,
      if (serial != null) 'serial': serial,
      if (specs != null) 'specs': specs,
      if (notes != null) 'notes': notes,
    });
  }

  EquipmentCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<EquipmentKind>? kind,
    Value<String?>? kindLabel,
    Value<int?>? year,
    Value<String?>? model,
    Value<String?>? serial,
    Value<Map<String, String>>? specs,
    Value<String?>? notes,
  }) {
    return EquipmentCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      kindLabel: kindLabel ?? this.kindLabel,
      year: year ?? this.year,
      model: model ?? this.model,
      serial: serial ?? this.serial,
      specs: specs ?? this.specs,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $EquipmentTable.$converterkind.toSql(kind.value),
      );
    }
    if (kindLabel.present) {
      map['kind_label'] = Variable<String>(kindLabel.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (serial.present) {
      map['serial'] = Variable<String>(serial.value);
    }
    if (specs.present) {
      map['specs'] = Variable<String>(
        $EquipmentTable.$converterspecs.toSql(specs.value),
      );
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EquipmentCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('year: $year, ')
          ..write('model: $model, ')
          ..write('serial: $serial, ')
          ..write('specs: $specs, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $AppJournalEntriesTable extends AppJournalEntries
    with TableInfo<$AppJournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, notes, rating, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppJournalEntriesTable createAlias(String alias) {
    return $AppJournalEntriesTable(attachedDatabase, alias);
  }
}

class AppJournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<int?> rating;
  final Value<DateTime> createdAt;
  const AppJournalEntriesCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppJournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? notes,
    Expression<int>? rating,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppJournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<int?>? rating,
    Value<DateTime>? createdAt,
  }) {
    return AppJournalEntriesCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ServiceEventsTable extends ServiceEvents
    with TableInfo<$ServiceEventsTable, ServiceEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServiceEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OwnerType, String> ownerType =
      GeneratedColumn<String>(
        'owner_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OwnerType>($ServiceEventsTable.$converterownerType);
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ServiceKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ServiceKind>($ServiceEventsTable.$converterkind);
  static const VerificationMeta _kindLabelMeta = const VerificationMeta(
    'kindLabel',
  );
  @override
  late final GeneratedColumn<String> kindLabel = GeneratedColumn<String>(
    'kind_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _costCentsMeta = const VerificationMeta(
    'costCents',
  );
  @override
  late final GeneratedColumn<int> costCents = GeneratedColumn<int>(
    'cost_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _partsUsedMeta = const VerificationMeta(
    'partsUsed',
  );
  @override
  late final GeneratedColumn<String> partsUsed = GeneratedColumn<String>(
    'parts_used',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerType,
    ownerId,
    date,
    kind,
    kindLabel,
    costCents,
    partsUsed,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServiceEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('kind_label')) {
      context.handle(
        _kindLabelMeta,
        kindLabel.isAcceptableOrUnknown(data['kind_label']!, _kindLabelMeta),
      );
    }
    if (data.containsKey('cost_cents')) {
      context.handle(
        _costCentsMeta,
        costCents.isAcceptableOrUnknown(data['cost_cents']!, _costCentsMeta),
      );
    }
    if (data.containsKey('parts_used')) {
      context.handle(
        _partsUsedMeta,
        partsUsed.isAcceptableOrUnknown(data['parts_used']!, _partsUsedMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServiceEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServiceEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerType: $ServiceEventsTable.$converterownerType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}owner_type'],
        )!,
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      kind: $ServiceEventsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      kindLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind_label'],
      ),
      costCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_cents'],
      ),
      partsUsed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parts_used'],
      ),
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $ServiceEventsTable createAlias(String alias) {
    return $ServiceEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OwnerType, String, String> $converterownerType =
      const EnumNameConverter<OwnerType>(OwnerType.values);
  static JsonTypeConverter2<ServiceKind, String, String> $converterkind =
      const EnumNameConverter<ServiceKind>(ServiceKind.values);
}

class ServiceEvent extends DataClass implements Insertable<ServiceEvent> {
  final int id;
  final OwnerType ownerType;
  final int ownerId;
  final DateTime date;
  final ServiceKind kind;
  final String? kindLabel;
  final int? costCents;
  final String? partsUsed;
  final int? journalEntryId;
  const ServiceEvent({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.date,
    required this.kind,
    this.kindLabel,
    this.costCents,
    this.partsUsed,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['owner_type'] = Variable<String>(
        $ServiceEventsTable.$converterownerType.toSql(ownerType),
      );
    }
    map['owner_id'] = Variable<int>(ownerId);
    map['date'] = Variable<DateTime>(date);
    {
      map['kind'] = Variable<String>(
        $ServiceEventsTable.$converterkind.toSql(kind),
      );
    }
    if (!nullToAbsent || kindLabel != null) {
      map['kind_label'] = Variable<String>(kindLabel);
    }
    if (!nullToAbsent || costCents != null) {
      map['cost_cents'] = Variable<int>(costCents);
    }
    if (!nullToAbsent || partsUsed != null) {
      map['parts_used'] = Variable<String>(partsUsed);
    }
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  ServiceEventsCompanion toCompanion(bool nullToAbsent) {
    return ServiceEventsCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: Value(ownerId),
      date: Value(date),
      kind: Value(kind),
      kindLabel: kindLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(kindLabel),
      costCents: costCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costCents),
      partsUsed: partsUsed == null && nullToAbsent
          ? const Value.absent()
          : Value(partsUsed),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory ServiceEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServiceEvent(
      id: serializer.fromJson<int>(json['id']),
      ownerType: $ServiceEventsTable.$converterownerType.fromJson(
        serializer.fromJson<String>(json['ownerType']),
      ),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      date: serializer.fromJson<DateTime>(json['date']),
      kind: $ServiceEventsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      kindLabel: serializer.fromJson<String?>(json['kindLabel']),
      costCents: serializer.fromJson<int?>(json['costCents']),
      partsUsed: serializer.fromJson<String?>(json['partsUsed']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerType': serializer.toJson<String>(
        $ServiceEventsTable.$converterownerType.toJson(ownerType),
      ),
      'ownerId': serializer.toJson<int>(ownerId),
      'date': serializer.toJson<DateTime>(date),
      'kind': serializer.toJson<String>(
        $ServiceEventsTable.$converterkind.toJson(kind),
      ),
      'kindLabel': serializer.toJson<String?>(kindLabel),
      'costCents': serializer.toJson<int?>(costCents),
      'partsUsed': serializer.toJson<String?>(partsUsed),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  ServiceEvent copyWith({
    int? id,
    OwnerType? ownerType,
    int? ownerId,
    DateTime? date,
    ServiceKind? kind,
    Value<String?> kindLabel = const Value.absent(),
    Value<int?> costCents = const Value.absent(),
    Value<String?> partsUsed = const Value.absent(),
    Value<int?> journalEntryId = const Value.absent(),
  }) => ServiceEvent(
    id: id ?? this.id,
    ownerType: ownerType ?? this.ownerType,
    ownerId: ownerId ?? this.ownerId,
    date: date ?? this.date,
    kind: kind ?? this.kind,
    kindLabel: kindLabel.present ? kindLabel.value : this.kindLabel,
    costCents: costCents.present ? costCents.value : this.costCents,
    partsUsed: partsUsed.present ? partsUsed.value : this.partsUsed,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  ServiceEvent copyWithCompanion(ServiceEventsCompanion data) {
    return ServiceEvent(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      date: data.date.present ? data.date.value : this.date,
      kind: data.kind.present ? data.kind.value : this.kind,
      kindLabel: data.kindLabel.present ? data.kindLabel.value : this.kindLabel,
      costCents: data.costCents.present ? data.costCents.value : this.costCents,
      partsUsed: data.partsUsed.present ? data.partsUsed.value : this.partsUsed,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEvent(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('costCents: $costCents, ')
          ..write('partsUsed: $partsUsed, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerType,
    ownerId,
    date,
    kind,
    kindLabel,
    costCents,
    partsUsed,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServiceEvent &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.date == this.date &&
          other.kind == this.kind &&
          other.kindLabel == this.kindLabel &&
          other.costCents == this.costCents &&
          other.partsUsed == this.partsUsed &&
          other.journalEntryId == this.journalEntryId);
}

class ServiceEventsCompanion extends UpdateCompanion<ServiceEvent> {
  final Value<int> id;
  final Value<OwnerType> ownerType;
  final Value<int> ownerId;
  final Value<DateTime> date;
  final Value<ServiceKind> kind;
  final Value<String?> kindLabel;
  final Value<int?> costCents;
  final Value<String?> partsUsed;
  final Value<int?> journalEntryId;
  const ServiceEventsCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.date = const Value.absent(),
    this.kind = const Value.absent(),
    this.kindLabel = const Value.absent(),
    this.costCents = const Value.absent(),
    this.partsUsed = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  ServiceEventsCompanion.insert({
    this.id = const Value.absent(),
    required OwnerType ownerType,
    required int ownerId,
    required DateTime date,
    required ServiceKind kind,
    this.kindLabel = const Value.absent(),
    this.costCents = const Value.absent(),
    this.partsUsed = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : ownerType = Value(ownerType),
       ownerId = Value(ownerId),
       date = Value(date),
       kind = Value(kind);
  static Insertable<ServiceEvent> custom({
    Expression<int>? id,
    Expression<String>? ownerType,
    Expression<int>? ownerId,
    Expression<DateTime>? date,
    Expression<String>? kind,
    Expression<String>? kindLabel,
    Expression<int>? costCents,
    Expression<String>? partsUsed,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (date != null) 'date': date,
      if (kind != null) 'kind': kind,
      if (kindLabel != null) 'kind_label': kindLabel,
      if (costCents != null) 'cost_cents': costCents,
      if (partsUsed != null) 'parts_used': partsUsed,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  ServiceEventsCompanion copyWith({
    Value<int>? id,
    Value<OwnerType>? ownerType,
    Value<int>? ownerId,
    Value<DateTime>? date,
    Value<ServiceKind>? kind,
    Value<String?>? kindLabel,
    Value<int?>? costCents,
    Value<String?>? partsUsed,
    Value<int?>? journalEntryId,
  }) {
    return ServiceEventsCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      date: date ?? this.date,
      kind: kind ?? this.kind,
      kindLabel: kindLabel ?? this.kindLabel,
      costCents: costCents ?? this.costCents,
      partsUsed: partsUsed ?? this.partsUsed,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(
        $ServiceEventsTable.$converterownerType.toSql(ownerType.value),
      );
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ServiceEventsTable.$converterkind.toSql(kind.value),
      );
    }
    if (kindLabel.present) {
      map['kind_label'] = Variable<String>(kindLabel.value);
    }
    if (costCents.present) {
      map['cost_cents'] = Variable<int>(costCents.value);
    }
    if (partsUsed.present) {
      map['parts_used'] = Variable<String>(partsUsed.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServiceEventsCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('date: $date, ')
          ..write('kind: $kind, ')
          ..write('kindLabel: $kindLabel, ')
          ..write('costCents: $costCents, ')
          ..write('partsUsed: $partsUsed, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $IntervalsTable extends Intervals
    with TableInfo<$IntervalsTable, Interval> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IntervalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OwnerType, String> ownerType =
      GeneratedColumn<String>(
        'owner_type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<OwnerType>($IntervalsTable.$converterownerType);
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<int> ownerId = GeneratedColumn<int>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _everyDaysMeta = const VerificationMeta(
    'everyDays',
  );
  @override
  late final GeneratedColumn<int> everyDays = GeneratedColumn<int>(
    'every_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<IntervalSeason?, String> season =
      GeneratedColumn<String>(
        'season',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<IntervalSeason?>($IntervalsTable.$converterseasonn);
  static const VerificationMeta _lastDoneMeta = const VerificationMeta(
    'lastDone',
  );
  @override
  late final GeneratedColumn<DateTime> lastDone = GeneratedColumn<DateTime>(
    'last_done',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerType,
    ownerId,
    label,
    everyDays,
    season,
    lastDone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'intervals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Interval> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('every_days')) {
      context.handle(
        _everyDaysMeta,
        everyDays.isAcceptableOrUnknown(data['every_days']!, _everyDaysMeta),
      );
    }
    if (data.containsKey('last_done')) {
      context.handle(
        _lastDoneMeta,
        lastDone.isAcceptableOrUnknown(data['last_done']!, _lastDoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Interval map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Interval(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ownerType: $IntervalsTable.$converterownerType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}owner_type'],
        )!,
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}owner_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      everyDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}every_days'],
      ),
      season: $IntervalsTable.$converterseasonn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}season'],
        ),
      ),
      lastDone: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_done'],
      ),
    );
  }

  @override
  $IntervalsTable createAlias(String alias) {
    return $IntervalsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OwnerType, String, String> $converterownerType =
      const EnumNameConverter<OwnerType>(OwnerType.values);
  static JsonTypeConverter2<IntervalSeason, String, String> $converterseason =
      const EnumNameConverter<IntervalSeason>(IntervalSeason.values);
  static JsonTypeConverter2<IntervalSeason?, String?, String?>
  $converterseasonn = JsonTypeConverter2.asNullable($converterseason);
}

class Interval extends DataClass implements Insertable<Interval> {
  final int id;
  final OwnerType ownerType;
  final int ownerId;
  final String label;
  final int? everyDays;
  final IntervalSeason? season;
  final DateTime? lastDone;
  const Interval({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.label,
    this.everyDays,
    this.season,
    this.lastDone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['owner_type'] = Variable<String>(
        $IntervalsTable.$converterownerType.toSql(ownerType),
      );
    }
    map['owner_id'] = Variable<int>(ownerId);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || everyDays != null) {
      map['every_days'] = Variable<int>(everyDays);
    }
    if (!nullToAbsent || season != null) {
      map['season'] = Variable<String>(
        $IntervalsTable.$converterseasonn.toSql(season),
      );
    }
    if (!nullToAbsent || lastDone != null) {
      map['last_done'] = Variable<DateTime>(lastDone);
    }
    return map;
  }

  IntervalsCompanion toCompanion(bool nullToAbsent) {
    return IntervalsCompanion(
      id: Value(id),
      ownerType: Value(ownerType),
      ownerId: Value(ownerId),
      label: Value(label),
      everyDays: everyDays == null && nullToAbsent
          ? const Value.absent()
          : Value(everyDays),
      season: season == null && nullToAbsent
          ? const Value.absent()
          : Value(season),
      lastDone: lastDone == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDone),
    );
  }

  factory Interval.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Interval(
      id: serializer.fromJson<int>(json['id']),
      ownerType: $IntervalsTable.$converterownerType.fromJson(
        serializer.fromJson<String>(json['ownerType']),
      ),
      ownerId: serializer.fromJson<int>(json['ownerId']),
      label: serializer.fromJson<String>(json['label']),
      everyDays: serializer.fromJson<int?>(json['everyDays']),
      season: $IntervalsTable.$converterseasonn.fromJson(
        serializer.fromJson<String?>(json['season']),
      ),
      lastDone: serializer.fromJson<DateTime?>(json['lastDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ownerType': serializer.toJson<String>(
        $IntervalsTable.$converterownerType.toJson(ownerType),
      ),
      'ownerId': serializer.toJson<int>(ownerId),
      'label': serializer.toJson<String>(label),
      'everyDays': serializer.toJson<int?>(everyDays),
      'season': serializer.toJson<String?>(
        $IntervalsTable.$converterseasonn.toJson(season),
      ),
      'lastDone': serializer.toJson<DateTime?>(lastDone),
    };
  }

  Interval copyWith({
    int? id,
    OwnerType? ownerType,
    int? ownerId,
    String? label,
    Value<int?> everyDays = const Value.absent(),
    Value<IntervalSeason?> season = const Value.absent(),
    Value<DateTime?> lastDone = const Value.absent(),
  }) => Interval(
    id: id ?? this.id,
    ownerType: ownerType ?? this.ownerType,
    ownerId: ownerId ?? this.ownerId,
    label: label ?? this.label,
    everyDays: everyDays.present ? everyDays.value : this.everyDays,
    season: season.present ? season.value : this.season,
    lastDone: lastDone.present ? lastDone.value : this.lastDone,
  );
  Interval copyWithCompanion(IntervalsCompanion data) {
    return Interval(
      id: data.id.present ? data.id.value : this.id,
      ownerType: data.ownerType.present ? data.ownerType.value : this.ownerType,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      label: data.label.present ? data.label.value : this.label,
      everyDays: data.everyDays.present ? data.everyDays.value : this.everyDays,
      season: data.season.present ? data.season.value : this.season,
      lastDone: data.lastDone.present ? data.lastDone.value : this.lastDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Interval(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('label: $label, ')
          ..write('everyDays: $everyDays, ')
          ..write('season: $season, ')
          ..write('lastDone: $lastDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerType, ownerId, label, everyDays, season, lastDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Interval &&
          other.id == this.id &&
          other.ownerType == this.ownerType &&
          other.ownerId == this.ownerId &&
          other.label == this.label &&
          other.everyDays == this.everyDays &&
          other.season == this.season &&
          other.lastDone == this.lastDone);
}

class IntervalsCompanion extends UpdateCompanion<Interval> {
  final Value<int> id;
  final Value<OwnerType> ownerType;
  final Value<int> ownerId;
  final Value<String> label;
  final Value<int?> everyDays;
  final Value<IntervalSeason?> season;
  final Value<DateTime?> lastDone;
  const IntervalsCompanion({
    this.id = const Value.absent(),
    this.ownerType = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.label = const Value.absent(),
    this.everyDays = const Value.absent(),
    this.season = const Value.absent(),
    this.lastDone = const Value.absent(),
  });
  IntervalsCompanion.insert({
    this.id = const Value.absent(),
    required OwnerType ownerType,
    required int ownerId,
    required String label,
    this.everyDays = const Value.absent(),
    this.season = const Value.absent(),
    this.lastDone = const Value.absent(),
  }) : ownerType = Value(ownerType),
       ownerId = Value(ownerId),
       label = Value(label);
  static Insertable<Interval> custom({
    Expression<int>? id,
    Expression<String>? ownerType,
    Expression<int>? ownerId,
    Expression<String>? label,
    Expression<int>? everyDays,
    Expression<String>? season,
    Expression<DateTime>? lastDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerType != null) 'owner_type': ownerType,
      if (ownerId != null) 'owner_id': ownerId,
      if (label != null) 'label': label,
      if (everyDays != null) 'every_days': everyDays,
      if (season != null) 'season': season,
      if (lastDone != null) 'last_done': lastDone,
    });
  }

  IntervalsCompanion copyWith({
    Value<int>? id,
    Value<OwnerType>? ownerType,
    Value<int>? ownerId,
    Value<String>? label,
    Value<int?>? everyDays,
    Value<IntervalSeason?>? season,
    Value<DateTime?>? lastDone,
  }) {
    return IntervalsCompanion(
      id: id ?? this.id,
      ownerType: ownerType ?? this.ownerType,
      ownerId: ownerId ?? this.ownerId,
      label: label ?? this.label,
      everyDays: everyDays ?? this.everyDays,
      season: season ?? this.season,
      lastDone: lastDone ?? this.lastDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ownerType.present) {
      map['owner_type'] = Variable<String>(
        $IntervalsTable.$converterownerType.toSql(ownerType.value),
      );
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<int>(ownerId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (everyDays.present) {
      map['every_days'] = Variable<int>(everyDays.value);
    }
    if (season.present) {
      map['season'] = Variable<String>(
        $IntervalsTable.$converterseasonn.toSql(season.value),
      );
    }
    if (lastDone.present) {
      map['last_done'] = Variable<DateTime>(lastDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IntervalsCompanion(')
          ..write('id: $id, ')
          ..write('ownerType: $ownerType, ')
          ..write('ownerId: $ownerId, ')
          ..write('label: $label, ')
          ..write('everyDays: $everyDays, ')
          ..write('season: $season, ')
          ..write('lastDone: $lastDone')
          ..write(')'))
        .toString();
  }
}

class $ChecklistsTable extends Checklists
    with TableInfo<$ChecklistsTable, Checklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _equipmentIdMeta = const VerificationMeta(
    'equipmentId',
  );
  @override
  late final GeneratedColumn<int> equipmentId = GeneratedColumn<int>(
    'equipment_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES equipment (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ChecklistSeason, String> season =
      GeneratedColumn<String>(
        'season',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ChecklistSeason>($ChecklistsTable.$converterseason);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<ChecklistStep>, String>
  steps = GeneratedColumn<String>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<ChecklistStep>>($ChecklistsTable.$convertersteps);
  @override
  List<GeneratedColumn> get $columns => [id, equipmentId, season, year, steps];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklists';
  @override
  VerificationContext validateIntegrity(
    Insertable<Checklist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('equipment_id')) {
      context.handle(
        _equipmentIdMeta,
        equipmentId.isAcceptableOrUnknown(
          data['equipment_id']!,
          _equipmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_equipmentIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {equipmentId, season, year},
  ];
  @override
  Checklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Checklist(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      equipmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_id'],
      )!,
      season: $ChecklistsTable.$converterseason.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}season'],
        )!,
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      steps: $ChecklistsTable.$convertersteps.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}steps'],
        )!,
      ),
    );
  }

  @override
  $ChecklistsTable createAlias(String alias) {
    return $ChecklistsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ChecklistSeason, String, String> $converterseason =
      const EnumNameConverter<ChecklistSeason>(ChecklistSeason.values);
  static TypeConverter<List<ChecklistStep>, String> $convertersteps =
      const ChecklistStepsConverter();
}

class Checklist extends DataClass implements Insertable<Checklist> {
  final int id;
  final int equipmentId;
  final ChecklistSeason season;
  final int year;
  final List<ChecklistStep> steps;
  const Checklist({
    required this.id,
    required this.equipmentId,
    required this.season,
    required this.year,
    required this.steps,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['equipment_id'] = Variable<int>(equipmentId);
    {
      map['season'] = Variable<String>(
        $ChecklistsTable.$converterseason.toSql(season),
      );
    }
    map['year'] = Variable<int>(year);
    {
      map['steps'] = Variable<String>(
        $ChecklistsTable.$convertersteps.toSql(steps),
      );
    }
    return map;
  }

  ChecklistsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistsCompanion(
      id: Value(id),
      equipmentId: Value(equipmentId),
      season: Value(season),
      year: Value(year),
      steps: Value(steps),
    );
  }

  factory Checklist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Checklist(
      id: serializer.fromJson<int>(json['id']),
      equipmentId: serializer.fromJson<int>(json['equipmentId']),
      season: $ChecklistsTable.$converterseason.fromJson(
        serializer.fromJson<String>(json['season']),
      ),
      year: serializer.fromJson<int>(json['year']),
      steps: serializer.fromJson<List<ChecklistStep>>(json['steps']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'equipmentId': serializer.toJson<int>(equipmentId),
      'season': serializer.toJson<String>(
        $ChecklistsTable.$converterseason.toJson(season),
      ),
      'year': serializer.toJson<int>(year),
      'steps': serializer.toJson<List<ChecklistStep>>(steps),
    };
  }

  Checklist copyWith({
    int? id,
    int? equipmentId,
    ChecklistSeason? season,
    int? year,
    List<ChecklistStep>? steps,
  }) => Checklist(
    id: id ?? this.id,
    equipmentId: equipmentId ?? this.equipmentId,
    season: season ?? this.season,
    year: year ?? this.year,
    steps: steps ?? this.steps,
  );
  Checklist copyWithCompanion(ChecklistsCompanion data) {
    return Checklist(
      id: data.id.present ? data.id.value : this.id,
      equipmentId: data.equipmentId.present
          ? data.equipmentId.value
          : this.equipmentId,
      season: data.season.present ? data.season.value : this.season,
      year: data.year.present ? data.year.value : this.year,
      steps: data.steps.present ? data.steps.value : this.steps,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Checklist(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('season: $season, ')
          ..write('year: $year, ')
          ..write('steps: $steps')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, equipmentId, season, year, steps);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Checklist &&
          other.id == this.id &&
          other.equipmentId == this.equipmentId &&
          other.season == this.season &&
          other.year == this.year &&
          other.steps == this.steps);
}

class ChecklistsCompanion extends UpdateCompanion<Checklist> {
  final Value<int> id;
  final Value<int> equipmentId;
  final Value<ChecklistSeason> season;
  final Value<int> year;
  final Value<List<ChecklistStep>> steps;
  const ChecklistsCompanion({
    this.id = const Value.absent(),
    this.equipmentId = const Value.absent(),
    this.season = const Value.absent(),
    this.year = const Value.absent(),
    this.steps = const Value.absent(),
  });
  ChecklistsCompanion.insert({
    this.id = const Value.absent(),
    required int equipmentId,
    required ChecklistSeason season,
    required int year,
    this.steps = const Value.absent(),
  }) : equipmentId = Value(equipmentId),
       season = Value(season),
       year = Value(year);
  static Insertable<Checklist> custom({
    Expression<int>? id,
    Expression<int>? equipmentId,
    Expression<String>? season,
    Expression<int>? year,
    Expression<String>? steps,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (equipmentId != null) 'equipment_id': equipmentId,
      if (season != null) 'season': season,
      if (year != null) 'year': year,
      if (steps != null) 'steps': steps,
    });
  }

  ChecklistsCompanion copyWith({
    Value<int>? id,
    Value<int>? equipmentId,
    Value<ChecklistSeason>? season,
    Value<int>? year,
    Value<List<ChecklistStep>>? steps,
  }) {
    return ChecklistsCompanion(
      id: id ?? this.id,
      equipmentId: equipmentId ?? this.equipmentId,
      season: season ?? this.season,
      year: year ?? this.year,
      steps: steps ?? this.steps,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (equipmentId.present) {
      map['equipment_id'] = Variable<int>(equipmentId.value);
    }
    if (season.present) {
      map['season'] = Variable<String>(
        $ChecklistsTable.$converterseason.toSql(season.value),
      );
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(
        $ChecklistsTable.$convertersteps.toSql(steps.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('equipmentId: $equipmentId, ')
          ..write('season: $season, ')
          ..write('year: $year, ')
          ..write('steps: $steps')
          ..write(')'))
        .toString();
  }
}

class $AppJournalPhotosTable extends AppJournalPhotos
    with TableInfo<$AppJournalPhotosTable, JournalPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, path, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $AppJournalPhotosTable createAlias(String alias) {
    return $AppJournalPhotosTable(attachedDatabase, alias);
  }
}

class AppJournalPhotosCompanion extends UpdateCompanion<JournalPhoto> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> path;
  final Value<String?> caption;
  const AppJournalPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.path = const Value.absent(),
    this.caption = const Value.absent(),
  });
  AppJournalPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String path,
    this.caption = const Value.absent(),
  }) : entryId = Value(entryId),
       path = Value(path);
  static Insertable<JournalPhoto> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? path,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (path != null) 'path': path,
      if (caption != null) 'caption': caption,
    });
  }

  AppJournalPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? path,
    Value<String?>? caption,
  }) {
    return AppJournalPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $AppJournalTagsTable extends AppJournalTags
    with TableInfo<$AppJournalTagsTable, JournalTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId, tag},
  ];
  @override
  JournalTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $AppJournalTagsTable createAlias(String alias) {
    return $AppJournalTagsTable(attachedDatabase, alias);
  }
}

class AppJournalTagsCompanion extends UpdateCompanion<JournalTag> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> tag;
  const AppJournalTagsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tag = const Value.absent(),
  });
  AppJournalTagsCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String tag,
  }) : entryId = Value(entryId),
       tag = Value(tag);
  static Insertable<JournalTag> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tag != null) 'tag': tag,
    });
  }

  AppJournalTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? tag,
  }) {
    return AppJournalTagsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalTagsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SystemsTable systems = $SystemsTable(this);
  late final $EquipmentTable equipment = $EquipmentTable(this);
  late final $AppJournalEntriesTable appJournalEntries =
      $AppJournalEntriesTable(this);
  late final $ServiceEventsTable serviceEvents = $ServiceEventsTable(this);
  late final $IntervalsTable intervals = $IntervalsTable(this);
  late final $ChecklistsTable checklists = $ChecklistsTable(this);
  late final $AppJournalPhotosTable appJournalPhotos = $AppJournalPhotosTable(
    this,
  );
  late final $AppJournalTagsTable appJournalTags = $AppJournalTagsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    systems,
    equipment,
    appJournalEntries,
    serviceEvents,
    intervals,
    checklists,
    appJournalPhotos,
    appJournalTags,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'equipment',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('checklists', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SystemsTableCreateCompanionBuilder =
    SystemsCompanion Function({
      Value<int> id,
      required String name,
      required SystemKind kind,
      Value<String?> kindLabel,
      Value<DateTime?> installDate,
      Value<Map<String, String>> specs,
      Value<String?> notes,
    });
typedef $$SystemsTableUpdateCompanionBuilder =
    SystemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<SystemKind> kind,
      Value<String?> kindLabel,
      Value<DateTime?> installDate,
      Value<Map<String, String>> specs,
      Value<String?> notes,
    });

class $$SystemsTableFilterComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SystemKind, SystemKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get installDate => $composableBuilder(
    column: $table.installDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemsTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
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

  ColumnOrderings<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get installDate => $composableBuilder(
    column: $table.installDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemsTable> {
  $$SystemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SystemKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get kindLabel =>
      $composableBuilder(column: $table.kindLabel, builder: (column) => column);

  GeneratedColumn<DateTime> get installDate => $composableBuilder(
    column: $table.installDate,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, String>, String> get specs =>
      $composableBuilder(column: $table.specs, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);
}

class $$SystemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemsTable,
          System,
          $$SystemsTableFilterComposer,
          $$SystemsTableOrderingComposer,
          $$SystemsTableAnnotationComposer,
          $$SystemsTableCreateCompanionBuilder,
          $$SystemsTableUpdateCompanionBuilder,
          (System, BaseReferences<_$AppDatabase, $SystemsTable, System>),
          System,
          PrefetchHooks Function()
        > {
  $$SystemsTableTableManager(_$AppDatabase db, $SystemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SystemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<SystemKind> kind = const Value.absent(),
                Value<String?> kindLabel = const Value.absent(),
                Value<DateTime?> installDate = const Value.absent(),
                Value<Map<String, String>> specs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SystemsCompanion(
                id: id,
                name: name,
                kind: kind,
                kindLabel: kindLabel,
                installDate: installDate,
                specs: specs,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required SystemKind kind,
                Value<String?> kindLabel = const Value.absent(),
                Value<DateTime?> installDate = const Value.absent(),
                Value<Map<String, String>> specs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => SystemsCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                kindLabel: kindLabel,
                installDate: installDate,
                specs: specs,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SystemsTable, System>(table),
                  BaseReferences<_$AppDatabase, $SystemsTable, System>(
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

typedef $$SystemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemsTable,
      System,
      $$SystemsTableFilterComposer,
      $$SystemsTableOrderingComposer,
      $$SystemsTableAnnotationComposer,
      $$SystemsTableCreateCompanionBuilder,
      $$SystemsTableUpdateCompanionBuilder,
      (System, BaseReferences<_$AppDatabase, $SystemsTable, System>),
      System,
      PrefetchHooks Function()
    >;
typedef $$EquipmentTableCreateCompanionBuilder =
    EquipmentCompanion Function({
      Value<int> id,
      required String name,
      required EquipmentKind kind,
      Value<String?> kindLabel,
      Value<int?> year,
      Value<String?> model,
      Value<String?> serial,
      Value<Map<String, String>> specs,
      Value<String?> notes,
    });
typedef $$EquipmentTableUpdateCompanionBuilder =
    EquipmentCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<EquipmentKind> kind,
      Value<String?> kindLabel,
      Value<int?> year,
      Value<String?> model,
      Value<String?> serial,
      Value<Map<String, String>> specs,
      Value<String?> notes,
    });

final class $$EquipmentTableReferences
    extends BaseReferences<_$AppDatabase, $EquipmentTable, EquipmentData> {
  $$EquipmentTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChecklistsTable, List<Checklist>>
  _checklistsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.checklists,
    aliasName: 'equipment__id__checklists__equipment_id',
  );

  $$ChecklistsTableProcessedTableManager get checklistsRefs {
    final manager = $$ChecklistsTableTableManager(
      $_db,
      $_db.checklists,
    ).filter((f) => f.equipmentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_checklistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EquipmentTableFilterComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<EquipmentKind, EquipmentKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> checklistsRefs(
    Expression<bool> Function($$ChecklistsTableFilterComposer f) f,
  ) {
    final $$ChecklistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklists,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistsTableFilterComposer(
            $db: $db,
            $table: $db.checklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableOrderingComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
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

  ColumnOrderings<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get specs => $composableBuilder(
    column: $table.specs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EquipmentTableAnnotationComposer
    extends Composer<_$AppDatabase, $EquipmentTable> {
  $$EquipmentTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<EquipmentKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get kindLabel =>
      $composableBuilder(column: $table.kindLabel, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<String> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String> get specs =>
      $composableBuilder(column: $table.specs, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> checklistsRefs<T extends Object>(
    Expression<T> Function($$ChecklistsTableAnnotationComposer a) f,
  ) {
    final $$ChecklistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.checklists,
      getReferencedColumn: (t) => t.equipmentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChecklistsTableAnnotationComposer(
            $db: $db,
            $table: $db.checklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EquipmentTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EquipmentTable,
          EquipmentData,
          $$EquipmentTableFilterComposer,
          $$EquipmentTableOrderingComposer,
          $$EquipmentTableAnnotationComposer,
          $$EquipmentTableCreateCompanionBuilder,
          $$EquipmentTableUpdateCompanionBuilder,
          (EquipmentData, $$EquipmentTableReferences),
          EquipmentData,
          PrefetchHooks Function({bool checklistsRefs})
        > {
  $$EquipmentTableTableManager(_$AppDatabase db, $EquipmentTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EquipmentTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EquipmentTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EquipmentTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<EquipmentKind> kind = const Value.absent(),
                Value<String?> kindLabel = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> serial = const Value.absent(),
                Value<Map<String, String>> specs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => EquipmentCompanion(
                id: id,
                name: name,
                kind: kind,
                kindLabel: kindLabel,
                year: year,
                model: model,
                serial: serial,
                specs: specs,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required EquipmentKind kind,
                Value<String?> kindLabel = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<String?> serial = const Value.absent(),
                Value<Map<String, String>> specs = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => EquipmentCompanion.insert(
                id: id,
                name: name,
                kind: kind,
                kindLabel: kindLabel,
                year: year,
                model: model,
                serial: serial,
                specs: specs,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EquipmentTable, EquipmentData>(table),
                  $$EquipmentTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checklistsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (checklistsRefs) db.checklists],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (checklistsRefs)
                    await $_getPrefetchedData<
                      EquipmentData,
                      $EquipmentTable,
                      Checklist
                    >(
                      currentTable: table,
                      referencedTable: $$EquipmentTableReferences
                          ._checklistsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EquipmentTableReferences(
                            db,
                            table,
                            p0,
                          ).checklistsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.equipmentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EquipmentTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EquipmentTable,
      EquipmentData,
      $$EquipmentTableFilterComposer,
      $$EquipmentTableOrderingComposer,
      $$EquipmentTableAnnotationComposer,
      $$EquipmentTableCreateCompanionBuilder,
      $$EquipmentTableUpdateCompanionBuilder,
      (EquipmentData, $$EquipmentTableReferences),
      EquipmentData,
      PrefetchHooks Function({bool checklistsRefs})
    >;
typedef $$AppJournalEntriesTableCreateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });
typedef $$AppJournalEntriesTableUpdateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });

class $$AppJournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppJournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalEntriesTable,
          JournalEntry,
          $$AppJournalEntriesTableFilterComposer,
          $$AppJournalEntriesTableOrderingComposer,
          $$AppJournalEntriesTableAnnotationComposer,
          $$AppJournalEntriesTableCreateCompanionBuilder,
          $$AppJournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<
              _$AppDatabase,
              $AppJournalEntriesTable,
              JournalEntry
            >,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$AppJournalEntriesTableTableManager(
    _$AppDatabase db,
    $AppJournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion.insert(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalEntriesTable,
      JournalEntry,
      $$AppJournalEntriesTableFilterComposer,
      $$AppJournalEntriesTableOrderingComposer,
      $$AppJournalEntriesTableAnnotationComposer,
      $$AppJournalEntriesTableCreateCompanionBuilder,
      $$AppJournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $AppJournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$ServiceEventsTableCreateCompanionBuilder =
    ServiceEventsCompanion Function({
      Value<int> id,
      required OwnerType ownerType,
      required int ownerId,
      required DateTime date,
      required ServiceKind kind,
      Value<String?> kindLabel,
      Value<int?> costCents,
      Value<String?> partsUsed,
      Value<int?> journalEntryId,
    });
typedef $$ServiceEventsTableUpdateCompanionBuilder =
    ServiceEventsCompanion Function({
      Value<int> id,
      Value<OwnerType> ownerType,
      Value<int> ownerId,
      Value<DateTime> date,
      Value<ServiceKind> kind,
      Value<String?> kindLabel,
      Value<int?> costCents,
      Value<String?> partsUsed,
      Value<int?> journalEntryId,
    });

class $$ServiceEventsTableFilterComposer
    extends Composer<_$AppDatabase, $ServiceEventsTable> {
  $$ServiceEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OwnerType, OwnerType, String> get ownerType =>
      $composableBuilder(
        column: $table.ownerType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServiceKind, ServiceKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get partsUsed => $composableBuilder(
    column: $table.partsUsed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ServiceEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServiceEventsTable> {
  $$ServiceEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kindLabel => $composableBuilder(
    column: $table.kindLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costCents => $composableBuilder(
    column: $table.costCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get partsUsed => $composableBuilder(
    column: $table.partsUsed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ServiceEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServiceEventsTable> {
  $$ServiceEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OwnerType, String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ServiceKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get kindLabel =>
      $composableBuilder(column: $table.kindLabel, builder: (column) => column);

  GeneratedColumn<int> get costCents =>
      $composableBuilder(column: $table.costCents, builder: (column) => column);

  GeneratedColumn<String> get partsUsed =>
      $composableBuilder(column: $table.partsUsed, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );
}

class $$ServiceEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServiceEventsTable,
          ServiceEvent,
          $$ServiceEventsTableFilterComposer,
          $$ServiceEventsTableOrderingComposer,
          $$ServiceEventsTableAnnotationComposer,
          $$ServiceEventsTableCreateCompanionBuilder,
          $$ServiceEventsTableUpdateCompanionBuilder,
          (
            ServiceEvent,
            BaseReferences<_$AppDatabase, $ServiceEventsTable, ServiceEvent>,
          ),
          ServiceEvent,
          PrefetchHooks Function()
        > {
  $$ServiceEventsTableTableManager(_$AppDatabase db, $ServiceEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServiceEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServiceEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServiceEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OwnerType> ownerType = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<ServiceKind> kind = const Value.absent(),
                Value<String?> kindLabel = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<String?> partsUsed = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => ServiceEventsCompanion(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                date: date,
                kind: kind,
                kindLabel: kindLabel,
                costCents: costCents,
                partsUsed: partsUsed,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required OwnerType ownerType,
                required int ownerId,
                required DateTime date,
                required ServiceKind kind,
                Value<String?> kindLabel = const Value.absent(),
                Value<int?> costCents = const Value.absent(),
                Value<String?> partsUsed = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => ServiceEventsCompanion.insert(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                date: date,
                kind: kind,
                kindLabel: kindLabel,
                costCents: costCents,
                partsUsed: partsUsed,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ServiceEventsTable, ServiceEvent>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ServiceEventsTable,
                    ServiceEvent
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ServiceEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServiceEventsTable,
      ServiceEvent,
      $$ServiceEventsTableFilterComposer,
      $$ServiceEventsTableOrderingComposer,
      $$ServiceEventsTableAnnotationComposer,
      $$ServiceEventsTableCreateCompanionBuilder,
      $$ServiceEventsTableUpdateCompanionBuilder,
      (
        ServiceEvent,
        BaseReferences<_$AppDatabase, $ServiceEventsTable, ServiceEvent>,
      ),
      ServiceEvent,
      PrefetchHooks Function()
    >;
typedef $$IntervalsTableCreateCompanionBuilder =
    IntervalsCompanion Function({
      Value<int> id,
      required OwnerType ownerType,
      required int ownerId,
      required String label,
      Value<int?> everyDays,
      Value<IntervalSeason?> season,
      Value<DateTime?> lastDone,
    });
typedef $$IntervalsTableUpdateCompanionBuilder =
    IntervalsCompanion Function({
      Value<int> id,
      Value<OwnerType> ownerType,
      Value<int> ownerId,
      Value<String> label,
      Value<int?> everyDays,
      Value<IntervalSeason?> season,
      Value<DateTime?> lastDone,
    });

class $$IntervalsTableFilterComposer
    extends Composer<_$AppDatabase, $IntervalsTable> {
  $$IntervalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OwnerType, OwnerType, String> get ownerType =>
      $composableBuilder(
        column: $table.ownerType,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get everyDays => $composableBuilder(
    column: $table.everyDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<IntervalSeason?, IntervalSeason, String>
  get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get lastDone => $composableBuilder(
    column: $table.lastDone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$IntervalsTableOrderingComposer
    extends Composer<_$AppDatabase, $IntervalsTable> {
  $$IntervalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerType => $composableBuilder(
    column: $table.ownerType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get everyDays => $composableBuilder(
    column: $table.everyDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastDone => $composableBuilder(
    column: $table.lastDone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IntervalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IntervalsTable> {
  $$IntervalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OwnerType, String> get ownerType =>
      $composableBuilder(column: $table.ownerType, builder: (column) => column);

  GeneratedColumn<int> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get everyDays =>
      $composableBuilder(column: $table.everyDays, builder: (column) => column);

  GeneratedColumnWithTypeConverter<IntervalSeason?, String> get season =>
      $composableBuilder(column: $table.season, builder: (column) => column);

  GeneratedColumn<DateTime> get lastDone =>
      $composableBuilder(column: $table.lastDone, builder: (column) => column);
}

class $$IntervalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IntervalsTable,
          Interval,
          $$IntervalsTableFilterComposer,
          $$IntervalsTableOrderingComposer,
          $$IntervalsTableAnnotationComposer,
          $$IntervalsTableCreateCompanionBuilder,
          $$IntervalsTableUpdateCompanionBuilder,
          (Interval, BaseReferences<_$AppDatabase, $IntervalsTable, Interval>),
          Interval,
          PrefetchHooks Function()
        > {
  $$IntervalsTableTableManager(_$AppDatabase db, $IntervalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IntervalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IntervalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IntervalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<OwnerType> ownerType = const Value.absent(),
                Value<int> ownerId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int?> everyDays = const Value.absent(),
                Value<IntervalSeason?> season = const Value.absent(),
                Value<DateTime?> lastDone = const Value.absent(),
              }) => IntervalsCompanion(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                label: label,
                everyDays: everyDays,
                season: season,
                lastDone: lastDone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required OwnerType ownerType,
                required int ownerId,
                required String label,
                Value<int?> everyDays = const Value.absent(),
                Value<IntervalSeason?> season = const Value.absent(),
                Value<DateTime?> lastDone = const Value.absent(),
              }) => IntervalsCompanion.insert(
                id: id,
                ownerType: ownerType,
                ownerId: ownerId,
                label: label,
                everyDays: everyDays,
                season: season,
                lastDone: lastDone,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$IntervalsTable, Interval>(table),
                  BaseReferences<_$AppDatabase, $IntervalsTable, Interval>(
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

typedef $$IntervalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IntervalsTable,
      Interval,
      $$IntervalsTableFilterComposer,
      $$IntervalsTableOrderingComposer,
      $$IntervalsTableAnnotationComposer,
      $$IntervalsTableCreateCompanionBuilder,
      $$IntervalsTableUpdateCompanionBuilder,
      (Interval, BaseReferences<_$AppDatabase, $IntervalsTable, Interval>),
      Interval,
      PrefetchHooks Function()
    >;
typedef $$ChecklistsTableCreateCompanionBuilder =
    ChecklistsCompanion Function({
      Value<int> id,
      required int equipmentId,
      required ChecklistSeason season,
      required int year,
      Value<List<ChecklistStep>> steps,
    });
typedef $$ChecklistsTableUpdateCompanionBuilder =
    ChecklistsCompanion Function({
      Value<int> id,
      Value<int> equipmentId,
      Value<ChecklistSeason> season,
      Value<int> year,
      Value<List<ChecklistStep>> steps,
    });

final class $$ChecklistsTableReferences
    extends BaseReferences<_$AppDatabase, $ChecklistsTable, Checklist> {
  $$ChecklistsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EquipmentTable _equipmentIdTable(_$AppDatabase db) =>
      db.equipment.createAlias('checklists__equipment_id__equipment__id');

  $$EquipmentTableProcessedTableManager get equipmentId {
    final $_column = $_itemColumn<int>('equipment_id')!;

    final manager = $$EquipmentTableTableManager(
      $_db,
      $_db.equipment,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_equipmentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ChecklistsTableFilterComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ChecklistSeason, ChecklistSeason, String>
  get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    List<ChecklistStep>,
    List<ChecklistStep>,
    String
  >
  get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$EquipmentTableFilterComposer get equipmentId {
    final $$EquipmentTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableFilterComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get season => $composableBuilder(
    column: $table.season,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  $$EquipmentTableOrderingComposer get equipmentId {
    final $$EquipmentTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableOrderingComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChecklistsTable> {
  $$ChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ChecklistSeason, String> get season =>
      $composableBuilder(column: $table.season, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<ChecklistStep>, String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  $$EquipmentTableAnnotationComposer get equipmentId {
    final $$EquipmentTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.equipmentId,
      referencedTable: $db.equipment,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EquipmentTableAnnotationComposer(
            $db: $db,
            $table: $db.equipment,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ChecklistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChecklistsTable,
          Checklist,
          $$ChecklistsTableFilterComposer,
          $$ChecklistsTableOrderingComposer,
          $$ChecklistsTableAnnotationComposer,
          $$ChecklistsTableCreateCompanionBuilder,
          $$ChecklistsTableUpdateCompanionBuilder,
          (Checklist, $$ChecklistsTableReferences),
          Checklist,
          PrefetchHooks Function({bool equipmentId})
        > {
  $$ChecklistsTableTableManager(_$AppDatabase db, $ChecklistsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> equipmentId = const Value.absent(),
                Value<ChecklistSeason> season = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<List<ChecklistStep>> steps = const Value.absent(),
              }) => ChecklistsCompanion(
                id: id,
                equipmentId: equipmentId,
                season: season,
                year: year,
                steps: steps,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int equipmentId,
                required ChecklistSeason season,
                required int year,
                Value<List<ChecklistStep>> steps = const Value.absent(),
              }) => ChecklistsCompanion.insert(
                id: id,
                equipmentId: equipmentId,
                season: season,
                year: year,
                steps: steps,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChecklistsTable, Checklist>(table),
                  $$ChecklistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({equipmentId = false}) {
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
                    if (equipmentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.equipmentId,
                                referencedTable: $$ChecklistsTableReferences
                                    ._equipmentIdTable(db),
                                referencedColumn: $$ChecklistsTableReferences
                                    ._equipmentIdTable(db)
                                    .id,
                              )
                              as T;
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

typedef $$ChecklistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChecklistsTable,
      Checklist,
      $$ChecklistsTableFilterComposer,
      $$ChecklistsTableOrderingComposer,
      $$ChecklistsTableAnnotationComposer,
      $$ChecklistsTableCreateCompanionBuilder,
      $$ChecklistsTableUpdateCompanionBuilder,
      (Checklist, $$ChecklistsTableReferences),
      Checklist,
      PrefetchHooks Function({bool equipmentId})
    >;
typedef $$AppJournalPhotosTableCreateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      required int entryId,
      required String path,
      Value<String?> caption,
    });
typedef $$AppJournalPhotosTableUpdateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> path,
      Value<String?> caption,
    });

class $$AppJournalPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);
}

class $$AppJournalPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalPhotosTable,
          JournalPhoto,
          $$AppJournalPhotosTableFilterComposer,
          $$AppJournalPhotosTableOrderingComposer,
          $$AppJournalPhotosTableAnnotationComposer,
          $$AppJournalPhotosTableCreateCompanionBuilder,
          $$AppJournalPhotosTableUpdateCompanionBuilder,
          (
            JournalPhoto,
            BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
          ),
          JournalPhoto,
          PrefetchHooks Function()
        > {
  $$AppJournalPhotosTableTableManager(
    _$AppDatabase db,
    $AppJournalPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String path,
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion.insert(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalPhotosTable, JournalPhoto>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalPhotosTable,
                    JournalPhoto
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalPhotosTable,
      JournalPhoto,
      $$AppJournalPhotosTableFilterComposer,
      $$AppJournalPhotosTableOrderingComposer,
      $$AppJournalPhotosTableAnnotationComposer,
      $$AppJournalPhotosTableCreateCompanionBuilder,
      $$AppJournalPhotosTableUpdateCompanionBuilder,
      (
        JournalPhoto,
        BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
      ),
      JournalPhoto,
      PrefetchHooks Function()
    >;
typedef $$AppJournalTagsTableCreateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      required int entryId,
      required String tag,
    });
typedef $$AppJournalTagsTableUpdateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> tag,
    });

class $$AppJournalTagsTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$AppJournalTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalTagsTable,
          JournalTag,
          $$AppJournalTagsTableFilterComposer,
          $$AppJournalTagsTableOrderingComposer,
          $$AppJournalTagsTableAnnotationComposer,
          $$AppJournalTagsTableCreateCompanionBuilder,
          $$AppJournalTagsTableUpdateCompanionBuilder,
          (
            JournalTag,
            BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
          ),
          JournalTag,
          PrefetchHooks Function()
        > {
  $$AppJournalTagsTableTableManager(
    _$AppDatabase db,
    $AppJournalTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> tag = const Value.absent(),
              }) => AppJournalTagsCompanion(id: id, entryId: entryId, tag: tag),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String tag,
              }) => AppJournalTagsCompanion.insert(
                id: id,
                entryId: entryId,
                tag: tag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalTagsTable, JournalTag>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalTagsTable,
                    JournalTag
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalTagsTable,
      JournalTag,
      $$AppJournalTagsTableFilterComposer,
      $$AppJournalTagsTableOrderingComposer,
      $$AppJournalTagsTableAnnotationComposer,
      $$AppJournalTagsTableCreateCompanionBuilder,
      $$AppJournalTagsTableUpdateCompanionBuilder,
      (
        JournalTag,
        BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
      ),
      JournalTag,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SystemsTableTableManager get systems =>
      $$SystemsTableTableManager(_db, _db.systems);
  $$EquipmentTableTableManager get equipment =>
      $$EquipmentTableTableManager(_db, _db.equipment);
  $$AppJournalEntriesTableTableManager get appJournalEntries =>
      $$AppJournalEntriesTableTableManager(_db, _db.appJournalEntries);
  $$ServiceEventsTableTableManager get serviceEvents =>
      $$ServiceEventsTableTableManager(_db, _db.serviceEvents);
  $$IntervalsTableTableManager get intervals =>
      $$IntervalsTableTableManager(_db, _db.intervals);
  $$ChecklistsTableTableManager get checklists =>
      $$ChecklistsTableTableManager(_db, _db.checklists);
  $$AppJournalPhotosTableTableManager get appJournalPhotos =>
      $$AppJournalPhotosTableTableManager(_db, _db.appJournalPhotos);
  $$AppJournalTagsTableTableManager get appJournalTags =>
      $$AppJournalTagsTableTableManager(_db, _db.appJournalTags);
}
