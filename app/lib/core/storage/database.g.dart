// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AnchorPointsTable extends AnchorPoints
    with TableInfo<$AnchorPointsTable, AnchorPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnchorPointsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AnchorType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AnchorType>($AnchorPointsTable.$convertertype);
  static const VerificationMeta _tagIdentifierMeta = const VerificationMeta(
    'tagIdentifier',
  );
  @override
  late final GeneratedColumn<String> tagIdentifier = GeneratedColumn<String>(
    'tag_identifier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    type,
    tagIdentifier,
    name,
    lastSeenAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anchor_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnchorPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('tag_identifier')) {
      context.handle(
        _tagIdentifierMeta,
        tagIdentifier.isAcceptableOrUnknown(
          data['tag_identifier']!,
          _tagIdentifierMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_tagIdentifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {tagIdentifier},
  ];
  @override
  AnchorPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnchorPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      type: $AnchorPointsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      tagIdentifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_identifier'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AnchorPointsTable createAlias(String alias) {
    return $AnchorPointsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AnchorType, int, int> $convertertype =
      const EnumIndexConverter<AnchorType>(AnchorType.values);
}

class AnchorPoint extends DataClass implements Insertable<AnchorPoint> {
  final int id;
  final String? remoteId;
  final AnchorType type;

  /// BLE adresa nebo ID NFC štítku.
  final String tagIdentifier;
  final String name;
  final DateTime? lastSeenAt;
  final DateTime createdAt;
  const AnchorPoint({
    required this.id,
    this.remoteId,
    required this.type,
    required this.tagIdentifier,
    required this.name,
    this.lastSeenAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    {
      map['type'] = Variable<int>(
        $AnchorPointsTable.$convertertype.toSql(type),
      );
    }
    map['tag_identifier'] = Variable<String>(tagIdentifier);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lastSeenAt != null) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AnchorPointsCompanion toCompanion(bool nullToAbsent) {
    return AnchorPointsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      type: Value(type),
      tagIdentifier: Value(tagIdentifier),
      name: Value(name),
      lastSeenAt: lastSeenAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSeenAt),
      createdAt: Value(createdAt),
    );
  }

  factory AnchorPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnchorPoint(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      type: $AnchorPointsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      tagIdentifier: serializer.fromJson<String>(json['tagIdentifier']),
      name: serializer.fromJson<String>(json['name']),
      lastSeenAt: serializer.fromJson<DateTime?>(json['lastSeenAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'type': serializer.toJson<int>(
        $AnchorPointsTable.$convertertype.toJson(type),
      ),
      'tagIdentifier': serializer.toJson<String>(tagIdentifier),
      'name': serializer.toJson<String>(name),
      'lastSeenAt': serializer.toJson<DateTime?>(lastSeenAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AnchorPoint copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    AnchorType? type,
    String? tagIdentifier,
    String? name,
    Value<DateTime?> lastSeenAt = const Value.absent(),
    DateTime? createdAt,
  }) => AnchorPoint(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    type: type ?? this.type,
    tagIdentifier: tagIdentifier ?? this.tagIdentifier,
    name: name ?? this.name,
    lastSeenAt: lastSeenAt.present ? lastSeenAt.value : this.lastSeenAt,
    createdAt: createdAt ?? this.createdAt,
  );
  AnchorPoint copyWithCompanion(AnchorPointsCompanion data) {
    return AnchorPoint(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      type: data.type.present ? data.type.value : this.type,
      tagIdentifier: data.tagIdentifier.present
          ? data.tagIdentifier.value
          : this.tagIdentifier,
      name: data.name.present ? data.name.value : this.name,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnchorPoint(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('type: $type, ')
          ..write('tagIdentifier: $tagIdentifier, ')
          ..write('name: $name, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    type,
    tagIdentifier,
    name,
    lastSeenAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnchorPoint &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.type == this.type &&
          other.tagIdentifier == this.tagIdentifier &&
          other.name == this.name &&
          other.lastSeenAt == this.lastSeenAt &&
          other.createdAt == this.createdAt);
}

class AnchorPointsCompanion extends UpdateCompanion<AnchorPoint> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<AnchorType> type;
  final Value<String> tagIdentifier;
  final Value<String> name;
  final Value<DateTime?> lastSeenAt;
  final Value<DateTime> createdAt;
  const AnchorPointsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.type = const Value.absent(),
    this.tagIdentifier = const Value.absent(),
    this.name = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AnchorPointsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required AnchorType type,
    required String tagIdentifier,
    required String name,
    this.lastSeenAt = const Value.absent(),
    required DateTime createdAt,
  }) : type = Value(type),
       tagIdentifier = Value(tagIdentifier),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<AnchorPoint> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<int>? type,
    Expression<String>? tagIdentifier,
    Expression<String>? name,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (type != null) 'type': type,
      if (tagIdentifier != null) 'tag_identifier': tagIdentifier,
      if (name != null) 'name': name,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AnchorPointsCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<AnchorType>? type,
    Value<String>? tagIdentifier,
    Value<String>? name,
    Value<DateTime?>? lastSeenAt,
    Value<DateTime>? createdAt,
  }) {
    return AnchorPointsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      type: type ?? this.type,
      tagIdentifier: tagIdentifier ?? this.tagIdentifier,
      name: name ?? this.name,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $AnchorPointsTable.$convertertype.toSql(type.value),
      );
    }
    if (tagIdentifier.present) {
      map['tag_identifier'] = Variable<String>(tagIdentifier.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnchorPointsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('type: $type, ')
          ..write('tagIdentifier: $tagIdentifier, ')
          ..write('name: $name, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SmartDevicesTable extends SmartDevices
    with TableInfo<$SmartDevicesTable, SmartDevice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartDevicesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SmartProvider, int> provider =
      GeneratedColumn<int>(
        'provider',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SmartProvider>($SmartDevicesTable.$converterprovider);
  static const VerificationMeta _externalDeviceIdMeta = const VerificationMeta(
    'externalDeviceId',
  );
  @override
  late final GeneratedColumn<String> externalDeviceId = GeneratedColumn<String>(
    'external_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateBeforeSessionMeta =
      const VerificationMeta('stateBeforeSession');
  @override
  late final GeneratedColumn<bool> stateBeforeSession = GeneratedColumn<bool>(
    'state_before_session',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("state_before_session" IN (0, 1))',
    ),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    provider,
    externalDeviceId,
    name,
    stateBeforeSession,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_devices';
  @override
  VerificationContext validateIntegrity(
    Insertable<SmartDevice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('external_device_id')) {
      context.handle(
        _externalDeviceIdMeta,
        externalDeviceId.isAcceptableOrUnknown(
          data['external_device_id']!,
          _externalDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_externalDeviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('state_before_session')) {
      context.handle(
        _stateBeforeSessionMeta,
        stateBeforeSession.isAcceptableOrUnknown(
          data['state_before_session']!,
          _stateBeforeSessionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {provider, externalDeviceId},
  ];
  @override
  SmartDevice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartDevice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      provider: $SmartDevicesTable.$converterprovider.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}provider'],
        )!,
      ),
      externalDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}external_device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      stateBeforeSession: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}state_before_session'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SmartDevicesTable createAlias(String alias) {
    return $SmartDevicesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SmartProvider, int, int> $converterprovider =
      const EnumIndexConverter<SmartProvider>(SmartProvider.values);
}

class SmartDevice extends DataClass implements Insertable<SmartDevice> {
  final int id;
  final String? remoteId;
  final SmartProvider provider;

  /// Identifikátor v systému poskytovatele.
  final String externalDeviceId;
  final String name;

  /// Stav zásuvky před začátkem bloku. Po skončení se obnoví — když byla
  /// televize vypnutá už předtím, aplikace ji na konci nesmí zapnout.
  final bool? stateBeforeSession;
  final DateTime createdAt;
  const SmartDevice({
    required this.id,
    this.remoteId,
    required this.provider,
    required this.externalDeviceId,
    required this.name,
    this.stateBeforeSession,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    {
      map['provider'] = Variable<int>(
        $SmartDevicesTable.$converterprovider.toSql(provider),
      );
    }
    map['external_device_id'] = Variable<String>(externalDeviceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || stateBeforeSession != null) {
      map['state_before_session'] = Variable<bool>(stateBeforeSession);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SmartDevicesCompanion toCompanion(bool nullToAbsent) {
    return SmartDevicesCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      provider: Value(provider),
      externalDeviceId: Value(externalDeviceId),
      name: Value(name),
      stateBeforeSession: stateBeforeSession == null && nullToAbsent
          ? const Value.absent()
          : Value(stateBeforeSession),
      createdAt: Value(createdAt),
    );
  }

  factory SmartDevice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartDevice(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      provider: $SmartDevicesTable.$converterprovider.fromJson(
        serializer.fromJson<int>(json['provider']),
      ),
      externalDeviceId: serializer.fromJson<String>(json['externalDeviceId']),
      name: serializer.fromJson<String>(json['name']),
      stateBeforeSession: serializer.fromJson<bool?>(
        json['stateBeforeSession'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'provider': serializer.toJson<int>(
        $SmartDevicesTable.$converterprovider.toJson(provider),
      ),
      'externalDeviceId': serializer.toJson<String>(externalDeviceId),
      'name': serializer.toJson<String>(name),
      'stateBeforeSession': serializer.toJson<bool?>(stateBeforeSession),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SmartDevice copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    SmartProvider? provider,
    String? externalDeviceId,
    String? name,
    Value<bool?> stateBeforeSession = const Value.absent(),
    DateTime? createdAt,
  }) => SmartDevice(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    provider: provider ?? this.provider,
    externalDeviceId: externalDeviceId ?? this.externalDeviceId,
    name: name ?? this.name,
    stateBeforeSession: stateBeforeSession.present
        ? stateBeforeSession.value
        : this.stateBeforeSession,
    createdAt: createdAt ?? this.createdAt,
  );
  SmartDevice copyWithCompanion(SmartDevicesCompanion data) {
    return SmartDevice(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      provider: data.provider.present ? data.provider.value : this.provider,
      externalDeviceId: data.externalDeviceId.present
          ? data.externalDeviceId.value
          : this.externalDeviceId,
      name: data.name.present ? data.name.value : this.name,
      stateBeforeSession: data.stateBeforeSession.present
          ? data.stateBeforeSession.value
          : this.stateBeforeSession,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartDevice(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('provider: $provider, ')
          ..write('externalDeviceId: $externalDeviceId, ')
          ..write('name: $name, ')
          ..write('stateBeforeSession: $stateBeforeSession, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    provider,
    externalDeviceId,
    name,
    stateBeforeSession,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartDevice &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.provider == this.provider &&
          other.externalDeviceId == this.externalDeviceId &&
          other.name == this.name &&
          other.stateBeforeSession == this.stateBeforeSession &&
          other.createdAt == this.createdAt);
}

class SmartDevicesCompanion extends UpdateCompanion<SmartDevice> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<SmartProvider> provider;
  final Value<String> externalDeviceId;
  final Value<String> name;
  final Value<bool?> stateBeforeSession;
  final Value<DateTime> createdAt;
  const SmartDevicesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.provider = const Value.absent(),
    this.externalDeviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.stateBeforeSession = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SmartDevicesCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required SmartProvider provider,
    required String externalDeviceId,
    required String name,
    this.stateBeforeSession = const Value.absent(),
    required DateTime createdAt,
  }) : provider = Value(provider),
       externalDeviceId = Value(externalDeviceId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<SmartDevice> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<int>? provider,
    Expression<String>? externalDeviceId,
    Expression<String>? name,
    Expression<bool>? stateBeforeSession,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (provider != null) 'provider': provider,
      if (externalDeviceId != null) 'external_device_id': externalDeviceId,
      if (name != null) 'name': name,
      if (stateBeforeSession != null)
        'state_before_session': stateBeforeSession,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SmartDevicesCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<SmartProvider>? provider,
    Value<String>? externalDeviceId,
    Value<String>? name,
    Value<bool?>? stateBeforeSession,
    Value<DateTime>? createdAt,
  }) {
    return SmartDevicesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      provider: provider ?? this.provider,
      externalDeviceId: externalDeviceId ?? this.externalDeviceId,
      name: name ?? this.name,
      stateBeforeSession: stateBeforeSession ?? this.stateBeforeSession,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (provider.present) {
      map['provider'] = Variable<int>(
        $SmartDevicesTable.$converterprovider.toSql(provider.value),
      );
    }
    if (externalDeviceId.present) {
      map['external_device_id'] = Variable<String>(externalDeviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (stateBeforeSession.present) {
      map['state_before_session'] = Variable<bool>(stateBeforeSession.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartDevicesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('provider: $provider, ')
          ..write('externalDeviceId: $externalDeviceId, ')
          ..write('name: $name, ')
          ..write('stateBeforeSession: $stateBeforeSession, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FocusProfilesTable extends FocusProfiles
    with TableInfo<$FocusProfilesTable, FocusProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusProfilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    check: () => ComparableExpr(durationMinutes).isBetweenValues(15, 180),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTextMeta = const VerificationMeta(
    'goalText',
  );
  @override
  late final GeneratedColumn<String> goalText = GeneratedColumn<String>(
    'goal_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<StrictnessLevel, int> strictness =
      GeneratedColumn<int>(
        'strictness',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<StrictnessLevel>(
        $FocusProfilesTable.$converterstrictness,
      );
  static const VerificationMeta _anchorPointIdMeta = const VerificationMeta(
    'anchorPointId',
  );
  @override
  late final GeneratedColumn<int> anchorPointId = GeneratedColumn<int>(
    'anchor_point_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES anchor_points (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _smartDeviceIdMeta = const VerificationMeta(
    'smartDeviceId',
  );
  @override
  late final GeneratedColumn<int> smartDeviceId = GeneratedColumn<int>(
    'smart_device_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES smart_devices (id) ON DELETE SET NULL',
    ),
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    name,
    durationMinutes,
    goalText,
    strictness,
    anchorPointId,
    smartDeviceId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
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
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('goal_text')) {
      context.handle(
        _goalTextMeta,
        goalText.isAcceptableOrUnknown(data['goal_text']!, _goalTextMeta),
      );
    }
    if (data.containsKey('anchor_point_id')) {
      context.handle(
        _anchorPointIdMeta,
        anchorPointId.isAcceptableOrUnknown(
          data['anchor_point_id']!,
          _anchorPointIdMeta,
        ),
      );
    }
    if (data.containsKey('smart_device_id')) {
      context.handle(
        _smartDeviceIdMeta,
        smartDeviceId.isAcceptableOrUnknown(
          data['smart_device_id']!,
          _smartDeviceIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      goalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_text'],
      )!,
      strictness: $FocusProfilesTable.$converterstrictness.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}strictness'],
        )!,
      ),
      anchorPointId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor_point_id'],
      ),
      smartDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}smart_device_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FocusProfilesTable createAlias(String alias) {
    return $FocusProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<StrictnessLevel, int, int> $converterstrictness =
      const EnumIndexConverter<StrictnessLevel>(StrictnessLevel.values);
}

class FocusProfile extends DataClass implements Insertable<FocusProfile> {
  final int id;
  final String? remoteId;
  final String name;

  /// 15–180 minut dle docs/spec.md §5.1. Rozsah hlídá i DB, ne jen UI.
  ///
  /// Sebe-reference je záměrná idiomatika drift DSL: tělo getteru čte pouze
  /// generátor kódu a překládá ho na líný `check: () => ...` v `database.g.dart`,
  /// za běhu se getter nikdy nevolá. Analyzer to bez kontextu vidí jako rekurzi.
  final int durationMinutes;
  final String goalText;
  final StrictnessLevel strictness;

  /// Kotva, u které má blok probíhat. Nepovinná — funkce musí být volitelná
  /// a bez majáku má aplikace fungovat beze změny (docs/spec.md §8).
  final int? anchorPointId;

  /// Chytrá zásuvka, která se má během bloku vypnout. Také nepovinná —
  /// bez zařízení musí zbytek aplikace fungovat beze změny (docs/spec.md §8).
  final int? smartDeviceId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FocusProfile({
    required this.id,
    this.remoteId,
    required this.name,
    required this.durationMinutes,
    required this.goalText,
    required this.strictness,
    this.anchorPointId,
    this.smartDeviceId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['name'] = Variable<String>(name);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['goal_text'] = Variable<String>(goalText);
    {
      map['strictness'] = Variable<int>(
        $FocusProfilesTable.$converterstrictness.toSql(strictness),
      );
    }
    if (!nullToAbsent || anchorPointId != null) {
      map['anchor_point_id'] = Variable<int>(anchorPointId);
    }
    if (!nullToAbsent || smartDeviceId != null) {
      map['smart_device_id'] = Variable<int>(smartDeviceId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FocusProfilesCompanion toCompanion(bool nullToAbsent) {
    return FocusProfilesCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      name: Value(name),
      durationMinutes: Value(durationMinutes),
      goalText: Value(goalText),
      strictness: Value(strictness),
      anchorPointId: anchorPointId == null && nullToAbsent
          ? const Value.absent()
          : Value(anchorPointId),
      smartDeviceId: smartDeviceId == null && nullToAbsent
          ? const Value.absent()
          : Value(smartDeviceId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FocusProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusProfile(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      goalText: serializer.fromJson<String>(json['goalText']),
      strictness: $FocusProfilesTable.$converterstrictness.fromJson(
        serializer.fromJson<int>(json['strictness']),
      ),
      anchorPointId: serializer.fromJson<int?>(json['anchorPointId']),
      smartDeviceId: serializer.fromJson<int?>(json['smartDeviceId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'name': serializer.toJson<String>(name),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'goalText': serializer.toJson<String>(goalText),
      'strictness': serializer.toJson<int>(
        $FocusProfilesTable.$converterstrictness.toJson(strictness),
      ),
      'anchorPointId': serializer.toJson<int?>(anchorPointId),
      'smartDeviceId': serializer.toJson<int?>(smartDeviceId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FocusProfile copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    String? name,
    int? durationMinutes,
    String? goalText,
    StrictnessLevel? strictness,
    Value<int?> anchorPointId = const Value.absent(),
    Value<int?> smartDeviceId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FocusProfile(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    name: name ?? this.name,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    goalText: goalText ?? this.goalText,
    strictness: strictness ?? this.strictness,
    anchorPointId: anchorPointId.present
        ? anchorPointId.value
        : this.anchorPointId,
    smartDeviceId: smartDeviceId.present
        ? smartDeviceId.value
        : this.smartDeviceId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FocusProfile copyWithCompanion(FocusProfilesCompanion data) {
    return FocusProfile(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      name: data.name.present ? data.name.value : this.name,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      goalText: data.goalText.present ? data.goalText.value : this.goalText,
      strictness: data.strictness.present
          ? data.strictness.value
          : this.strictness,
      anchorPointId: data.anchorPointId.present
          ? data.anchorPointId.value
          : this.anchorPointId,
      smartDeviceId: data.smartDeviceId.present
          ? data.smartDeviceId.value
          : this.smartDeviceId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusProfile(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('goalText: $goalText, ')
          ..write('strictness: $strictness, ')
          ..write('anchorPointId: $anchorPointId, ')
          ..write('smartDeviceId: $smartDeviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    name,
    durationMinutes,
    goalText,
    strictness,
    anchorPointId,
    smartDeviceId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusProfile &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.durationMinutes == this.durationMinutes &&
          other.goalText == this.goalText &&
          other.strictness == this.strictness &&
          other.anchorPointId == this.anchorPointId &&
          other.smartDeviceId == this.smartDeviceId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FocusProfilesCompanion extends UpdateCompanion<FocusProfile> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> name;
  final Value<int> durationMinutes;
  final Value<String> goalText;
  final Value<StrictnessLevel> strictness;
  final Value<int?> anchorPointId;
  final Value<int?> smartDeviceId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FocusProfilesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.goalText = const Value.absent(),
    this.strictness = const Value.absent(),
    this.anchorPointId = const Value.absent(),
    this.smartDeviceId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FocusProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String name,
    required int durationMinutes,
    this.goalText = const Value.absent(),
    required StrictnessLevel strictness,
    this.anchorPointId = const Value.absent(),
    this.smartDeviceId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       durationMinutes = Value(durationMinutes),
       strictness = Value(strictness),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FocusProfile> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<int>? durationMinutes,
    Expression<String>? goalText,
    Expression<int>? strictness,
    Expression<int>? anchorPointId,
    Expression<int>? smartDeviceId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (goalText != null) 'goal_text': goalText,
      if (strictness != null) 'strictness': strictness,
      if (anchorPointId != null) 'anchor_point_id': anchorPointId,
      if (smartDeviceId != null) 'smart_device_id': smartDeviceId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FocusProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<String>? name,
    Value<int>? durationMinutes,
    Value<String>? goalText,
    Value<StrictnessLevel>? strictness,
    Value<int?>? anchorPointId,
    Value<int?>? smartDeviceId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return FocusProfilesCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      goalText: goalText ?? this.goalText,
      strictness: strictness ?? this.strictness,
      anchorPointId: anchorPointId ?? this.anchorPointId,
      smartDeviceId: smartDeviceId ?? this.smartDeviceId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (goalText.present) {
      map['goal_text'] = Variable<String>(goalText.value);
    }
    if (strictness.present) {
      map['strictness'] = Variable<int>(
        $FocusProfilesTable.$converterstrictness.toSql(strictness.value),
      );
    }
    if (anchorPointId.present) {
      map['anchor_point_id'] = Variable<int>(anchorPointId.value);
    }
    if (smartDeviceId.present) {
      map['smart_device_id'] = Variable<int>(smartDeviceId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusProfilesCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('goalText: $goalText, ')
          ..write('strictness: $strictness, ')
          ..write('anchorPointId: $anchorPointId, ')
          ..write('smartDeviceId: $smartDeviceId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedDurationMinutesMeta =
      const VerificationMeta('plannedDurationMinutes');
  @override
  late final GeneratedColumn<int> plannedDurationMinutes = GeneratedColumn<int>(
    'planned_duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalTextMeta = const VerificationMeta(
    'goalText',
  );
  @override
  late final GeneratedColumn<String> goalText = GeneratedColumn<String>(
    'goal_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<SessionStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<SessionStatus>($FocusSessionsTable.$converterstatus);
  @override
  late final GeneratedColumnWithTypeConverter<StrictnessLevel, int> strictness =
      GeneratedColumn<int>(
        'strictness',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      ).withConverter<StrictnessLevel>(
        $FocusSessionsTable.$converterstrictness,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    profileId,
    startedAt,
    endedAt,
    plannedDurationMinutes,
    goalText,
    status,
    strictness,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
      );
    }
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('planned_duration_minutes')) {
      context.handle(
        _plannedDurationMinutesMeta,
        plannedDurationMinutes.isAcceptableOrUnknown(
          data['planned_duration_minutes']!,
          _plannedDurationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_plannedDurationMinutesMeta);
    }
    if (data.containsKey('goal_text')) {
      context.handle(
        _goalTextMeta,
        goalText.isAcceptableOrUnknown(data['goal_text']!, _goalTextMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      plannedDurationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_duration_minutes'],
      )!,
      goalText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_text'],
      )!,
      status: $FocusSessionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      strictness: $FocusSessionsTable.$converterstrictness.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}strictness'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<SessionStatus, int, int> $converterstatus =
      const EnumIndexConverter<SessionStatus>(SessionStatus.values);
  static JsonTypeConverter2<StrictnessLevel, int, int> $converterstrictness =
      const EnumIndexConverter<StrictnessLevel>(StrictnessLevel.values);
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final int id;
  final String? remoteId;
  final int profileId;
  final DateTime startedAt;
  final DateTime? endedAt;

  /// Snapshot z profilu v okamžiku startu — pozdější úprava profilu nesmí
  /// zpětně přepsat historii, na které stojí statistiky (§5.6).
  final int plannedDurationMinutes;
  final String goalText;
  final SessionStatus status;

  /// Snapshot přísnosti z profilu — určuje délku zpomalení ve Friction Exit
  /// (docs/spec.md §5.5). Snapshot ze stejného důvodu jako u délky a cíle:
  /// úprava profilu uprostřed běžícího bloku nesmí měnit jeho pravidla.
  final StrictnessLevel strictness;
  final DateTime updatedAt;
  const FocusSession({
    required this.id,
    this.remoteId,
    required this.profileId,
    required this.startedAt,
    this.endedAt,
    required this.plannedDurationMinutes,
    required this.goalText,
    required this.status,
    required this.strictness,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['profile_id'] = Variable<int>(profileId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['planned_duration_minutes'] = Variable<int>(plannedDurationMinutes);
    map['goal_text'] = Variable<String>(goalText);
    {
      map['status'] = Variable<int>(
        $FocusSessionsTable.$converterstatus.toSql(status),
      );
    }
    {
      map['strictness'] = Variable<int>(
        $FocusSessionsTable.$converterstrictness.toSql(strictness),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      profileId: Value(profileId),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      plannedDurationMinutes: Value(plannedDurationMinutes),
      goalText: Value(goalText),
      status: Value(status),
      strictness: Value(strictness),
      updatedAt: Value(updatedAt),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      profileId: serializer.fromJson<int>(json['profileId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime?>(json['endedAt']),
      plannedDurationMinutes: serializer.fromJson<int>(
        json['plannedDurationMinutes'],
      ),
      goalText: serializer.fromJson<String>(json['goalText']),
      status: $FocusSessionsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      strictness: $FocusSessionsTable.$converterstrictness.fromJson(
        serializer.fromJson<int>(json['strictness']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'profileId': serializer.toJson<int>(profileId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime?>(endedAt),
      'plannedDurationMinutes': serializer.toJson<int>(plannedDurationMinutes),
      'goalText': serializer.toJson<String>(goalText),
      'status': serializer.toJson<int>(
        $FocusSessionsTable.$converterstatus.toJson(status),
      ),
      'strictness': serializer.toJson<int>(
        $FocusSessionsTable.$converterstrictness.toJson(strictness),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FocusSession copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    int? profileId,
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? plannedDurationMinutes,
    String? goalText,
    SessionStatus? status,
    StrictnessLevel? strictness,
    DateTime? updatedAt,
  }) => FocusSession(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    profileId: profileId ?? this.profileId,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    plannedDurationMinutes:
        plannedDurationMinutes ?? this.plannedDurationMinutes,
    goalText: goalText ?? this.goalText,
    status: status ?? this.status,
    strictness: strictness ?? this.strictness,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      plannedDurationMinutes: data.plannedDurationMinutes.present
          ? data.plannedDurationMinutes.value
          : this.plannedDurationMinutes,
      goalText: data.goalText.present ? data.goalText.value : this.goalText,
      status: data.status.present ? data.status.value : this.status,
      strictness: data.strictness.present
          ? data.strictness.value
          : this.strictness,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('profileId: $profileId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('goalText: $goalText, ')
          ..write('status: $status, ')
          ..write('strictness: $strictness, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    remoteId,
    profileId,
    startedAt,
    endedAt,
    plannedDurationMinutes,
    goalText,
    status,
    strictness,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.profileId == this.profileId &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.plannedDurationMinutes == this.plannedDurationMinutes &&
          other.goalText == this.goalText &&
          other.status == this.status &&
          other.strictness == this.strictness &&
          other.updatedAt == this.updatedAt);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<int> profileId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> plannedDurationMinutes;
  final Value<String> goalText;
  final Value<SessionStatus> status;
  final Value<StrictnessLevel> strictness;
  final Value<DateTime> updatedAt;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.profileId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.plannedDurationMinutes = const Value.absent(),
    this.goalText = const Value.absent(),
    this.status = const Value.absent(),
    this.strictness = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required int profileId,
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    required int plannedDurationMinutes,
    this.goalText = const Value.absent(),
    required SessionStatus status,
    this.strictness = const Value.absent(),
    required DateTime updatedAt,
  }) : profileId = Value(profileId),
       startedAt = Value(startedAt),
       plannedDurationMinutes = Value(plannedDurationMinutes),
       status = Value(status),
       updatedAt = Value(updatedAt);
  static Insertable<FocusSession> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<int>? profileId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? plannedDurationMinutes,
    Expression<String>? goalText,
    Expression<int>? status,
    Expression<int>? strictness,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (profileId != null) 'profile_id': profileId,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (plannedDurationMinutes != null)
        'planned_duration_minutes': plannedDurationMinutes,
      if (goalText != null) 'goal_text': goalText,
      if (status != null) 'status': status,
      if (strictness != null) 'strictness': strictness,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<int>? profileId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? plannedDurationMinutes,
    Value<String>? goalText,
    Value<SessionStatus>? status,
    Value<StrictnessLevel>? strictness,
    Value<DateTime>? updatedAt,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      profileId: profileId ?? this.profileId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      plannedDurationMinutes:
          plannedDurationMinutes ?? this.plannedDurationMinutes,
      goalText: goalText ?? this.goalText,
      status: status ?? this.status,
      strictness: strictness ?? this.strictness,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (plannedDurationMinutes.present) {
      map['planned_duration_minutes'] = Variable<int>(
        plannedDurationMinutes.value,
      );
    }
    if (goalText.present) {
      map['goal_text'] = Variable<String>(goalText.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $FocusSessionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (strictness.present) {
      map['strictness'] = Variable<int>(
        $FocusSessionsTable.$converterstrictness.toSql(strictness.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('profileId: $profileId, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('plannedDurationMinutes: $plannedDurationMinutes, ')
          ..write('goalText: $goalText, ')
          ..write('status: $status, ')
          ..write('strictness: $strictness, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BlockedAppListsTable extends BlockedAppLists
    with TableInfo<$BlockedAppListsTable, BlockedAppList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedAppListsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _remoteIdMeta = const VerificationMeta(
    'remoteId',
  );
  @override
  late final GeneratedColumn<String> remoteId = GeneratedColumn<String>(
    'remote_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    remoteId,
    name,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_app_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockedAppList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('remote_id')) {
      context.handle(
        _remoteIdMeta,
        remoteId.isAcceptableOrUnknown(data['remote_id']!, _remoteIdMeta),
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BlockedAppList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedAppList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      remoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_id'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BlockedAppListsTable createAlias(String alias) {
    return $BlockedAppListsTable(attachedDatabase, alias);
  }
}

class BlockedAppList extends DataClass implements Insertable<BlockedAppList> {
  final int id;
  final String? remoteId;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  const BlockedAppList({
    required this.id,
    this.remoteId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || remoteId != null) {
      map['remote_id'] = Variable<String>(remoteId);
    }
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BlockedAppListsCompanion toCompanion(bool nullToAbsent) {
    return BlockedAppListsCompanion(
      id: Value(id),
      remoteId: remoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(remoteId),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory BlockedAppList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedAppList(
      id: serializer.fromJson<int>(json['id']),
      remoteId: serializer.fromJson<String?>(json['remoteId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'remoteId': serializer.toJson<String?>(remoteId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BlockedAppList copyWith({
    int? id,
    Value<String?> remoteId = const Value.absent(),
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => BlockedAppList(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  BlockedAppList copyWithCompanion(BlockedAppListsCompanion data) {
    return BlockedAppList(
      id: data.id.present ? data.id.value : this.id,
      remoteId: data.remoteId.present ? data.remoteId.value : this.remoteId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAppList(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, remoteId, name, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedAppList &&
          other.id == this.id &&
          other.remoteId == this.remoteId &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BlockedAppListsCompanion extends UpdateCompanion<BlockedAppList> {
  final Value<int> id;
  final Value<String?> remoteId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const BlockedAppListsCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  BlockedAppListsCompanion.insert({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<BlockedAppList> custom({
    Expression<int>? id,
    Expression<String>? remoteId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (remoteId != null) 'remote_id': remoteId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  BlockedAppListsCompanion copyWith({
    Value<int>? id,
    Value<String?>? remoteId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return BlockedAppListsCompanion(
      id: id ?? this.id,
      remoteId: remoteId ?? this.remoteId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (remoteId.present) {
      map['remote_id'] = Variable<String>(remoteId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAppListsCompanion(')
          ..write('id: $id, ')
          ..write('remoteId: $remoteId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BlockedAppsTable extends BlockedApps
    with TableInfo<$BlockedAppsTable, BlockedApp> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BlockedAppsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocked_app_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appLabelMeta = const VerificationMeta(
    'appLabel',
  );
  @override
  late final GeneratedColumn<String> appLabel = GeneratedColumn<String>(
    'app_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, listId, packageName, appLabel];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'blocked_apps';
  @override
  VerificationContext validateIntegrity(
    Insertable<BlockedApp> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_label')) {
      context.handle(
        _appLabelMeta,
        appLabel.isAcceptableOrUnknown(data['app_label']!, _appLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_appLabelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {listId, packageName},
  ];
  @override
  BlockedApp map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BlockedApp(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_label'],
      )!,
    );
  }

  @override
  $BlockedAppsTable createAlias(String alias) {
    return $BlockedAppsTable(attachedDatabase, alias);
  }
}

class BlockedApp extends DataClass implements Insertable<BlockedApp> {
  final int id;
  final int listId;
  final String packageName;
  final String appLabel;
  const BlockedApp({
    required this.id,
    required this.listId,
    required this.packageName,
    required this.appLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['list_id'] = Variable<int>(listId);
    map['package_name'] = Variable<String>(packageName);
    map['app_label'] = Variable<String>(appLabel);
    return map;
  }

  BlockedAppsCompanion toCompanion(bool nullToAbsent) {
    return BlockedAppsCompanion(
      id: Value(id),
      listId: Value(listId),
      packageName: Value(packageName),
      appLabel: Value(appLabel),
    );
  }

  factory BlockedApp.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BlockedApp(
      id: serializer.fromJson<int>(json['id']),
      listId: serializer.fromJson<int>(json['listId']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appLabel: serializer.fromJson<String>(json['appLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'listId': serializer.toJson<int>(listId),
      'packageName': serializer.toJson<String>(packageName),
      'appLabel': serializer.toJson<String>(appLabel),
    };
  }

  BlockedApp copyWith({
    int? id,
    int? listId,
    String? packageName,
    String? appLabel,
  }) => BlockedApp(
    id: id ?? this.id,
    listId: listId ?? this.listId,
    packageName: packageName ?? this.packageName,
    appLabel: appLabel ?? this.appLabel,
  );
  BlockedApp copyWithCompanion(BlockedAppsCompanion data) {
    return BlockedApp(
      id: data.id.present ? data.id.value : this.id,
      listId: data.listId.present ? data.listId.value : this.listId,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appLabel: data.appLabel.present ? data.appLabel.value : this.appLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BlockedApp(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, listId, packageName, appLabel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BlockedApp &&
          other.id == this.id &&
          other.listId == this.listId &&
          other.packageName == this.packageName &&
          other.appLabel == this.appLabel);
}

class BlockedAppsCompanion extends UpdateCompanion<BlockedApp> {
  final Value<int> id;
  final Value<int> listId;
  final Value<String> packageName;
  final Value<String> appLabel;
  const BlockedAppsCompanion({
    this.id = const Value.absent(),
    this.listId = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appLabel = const Value.absent(),
  });
  BlockedAppsCompanion.insert({
    this.id = const Value.absent(),
    required int listId,
    required String packageName,
    required String appLabel,
  }) : listId = Value(listId),
       packageName = Value(packageName),
       appLabel = Value(appLabel);
  static Insertable<BlockedApp> custom({
    Expression<int>? id,
    Expression<int>? listId,
    Expression<String>? packageName,
    Expression<String>? appLabel,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (listId != null) 'list_id': listId,
      if (packageName != null) 'package_name': packageName,
      if (appLabel != null) 'app_label': appLabel,
    });
  }

  BlockedAppsCompanion copyWith({
    Value<int>? id,
    Value<int>? listId,
    Value<String>? packageName,
    Value<String>? appLabel,
  }) {
    return BlockedAppsCompanion(
      id: id ?? this.id,
      listId: listId ?? this.listId,
      packageName: packageName ?? this.packageName,
      appLabel: appLabel ?? this.appLabel,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appLabel.present) {
      map['app_label'] = Variable<String>(appLabel.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BlockedAppsCompanion(')
          ..write('id: $id, ')
          ..write('listId: $listId, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel')
          ..write(')'))
        .toString();
  }
}

class $ProfileBlockedListsTable extends ProfileBlockedLists
    with TableInfo<$ProfileBlockedListsTable, ProfileBlockedList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfileBlockedListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<int> profileId = GeneratedColumn<int>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_profiles (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES blocked_app_lists (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, listId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile_blocked_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileBlockedList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, listId};
  @override
  ProfileBlockedList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileBlockedList(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}profile_id'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
    );
  }

  @override
  $ProfileBlockedListsTable createAlias(String alias) {
    return $ProfileBlockedListsTable(attachedDatabase, alias);
  }
}

class ProfileBlockedList extends DataClass
    implements Insertable<ProfileBlockedList> {
  final int profileId;
  final int listId;
  const ProfileBlockedList({required this.profileId, required this.listId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<int>(profileId);
    map['list_id'] = Variable<int>(listId);
    return map;
  }

  ProfileBlockedListsCompanion toCompanion(bool nullToAbsent) {
    return ProfileBlockedListsCompanion(
      profileId: Value(profileId),
      listId: Value(listId),
    );
  }

  factory ProfileBlockedList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileBlockedList(
      profileId: serializer.fromJson<int>(json['profileId']),
      listId: serializer.fromJson<int>(json['listId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<int>(profileId),
      'listId': serializer.toJson<int>(listId),
    };
  }

  ProfileBlockedList copyWith({int? profileId, int? listId}) =>
      ProfileBlockedList(
        profileId: profileId ?? this.profileId,
        listId: listId ?? this.listId,
      );
  ProfileBlockedList copyWithCompanion(ProfileBlockedListsCompanion data) {
    return ProfileBlockedList(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      listId: data.listId.present ? data.listId.value : this.listId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileBlockedList(')
          ..write('profileId: $profileId, ')
          ..write('listId: $listId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, listId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileBlockedList &&
          other.profileId == this.profileId &&
          other.listId == this.listId);
}

class ProfileBlockedListsCompanion extends UpdateCompanion<ProfileBlockedList> {
  final Value<int> profileId;
  final Value<int> listId;
  final Value<int> rowid;
  const ProfileBlockedListsCompanion({
    this.profileId = const Value.absent(),
    this.listId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfileBlockedListsCompanion.insert({
    required int profileId,
    required int listId,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       listId = Value(listId);
  static Insertable<ProfileBlockedList> custom({
    Expression<int>? profileId,
    Expression<int>? listId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (listId != null) 'list_id': listId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfileBlockedListsCompanion copyWith({
    Value<int>? profileId,
    Value<int>? listId,
    Value<int>? rowid,
  }) {
    return ProfileBlockedListsCompanion(
      profileId: profileId ?? this.profileId,
      listId: listId ?? this.listId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<int>(profileId.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfileBlockedListsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('listId: $listId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FrictionExitEventsTable extends FrictionExitEvents
    with TableInfo<$FrictionExitEventsTable, FrictionExitEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FrictionExitEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _triggeredAtMeta = const VerificationMeta(
    'triggeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> triggeredAt = GeneratedColumn<DateTime>(
    'triggered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FrictionStep, int> stepType =
      GeneratedColumn<int>(
        'step_type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FrictionStep>(
        $FrictionExitEventsTable.$converterstepType,
      );
  static const VerificationMeta _reflectionTextMeta = const VerificationMeta(
    'reflectionText',
  );
  @override
  late final GeneratedColumn<String> reflectionText = GeneratedColumn<String>(
    'reflection_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<FrictionOutcome, int> outcome =
      GeneratedColumn<int>(
        'outcome',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FrictionOutcome>(
        $FrictionExitEventsTable.$converteroutcome,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    triggeredAt,
    stepType,
    reflectionText,
    outcome,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'friction_exit_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<FrictionExitEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
        _triggeredAtMeta,
        triggeredAt.isAcceptableOrUnknown(
          data['triggered_at']!,
          _triggeredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('reflection_text')) {
      context.handle(
        _reflectionTextMeta,
        reflectionText.isAcceptableOrUnknown(
          data['reflection_text']!,
          _reflectionTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FrictionExitEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FrictionExitEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      )!,
      triggeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}triggered_at'],
      )!,
      stepType: $FrictionExitEventsTable.$converterstepType.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}step_type'],
        )!,
      ),
      reflectionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_text'],
      ),
      outcome: $FrictionExitEventsTable.$converteroutcome.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}outcome'],
        )!,
      ),
    );
  }

  @override
  $FrictionExitEventsTable createAlias(String alias) {
    return $FrictionExitEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FrictionStep, int, int> $converterstepType =
      const EnumIndexConverter<FrictionStep>(FrictionStep.values);
  static JsonTypeConverter2<FrictionOutcome, int, int> $converteroutcome =
      const EnumIndexConverter<FrictionOutcome>(FrictionOutcome.values);
}

class FrictionExitEvent extends DataClass
    implements Insertable<FrictionExitEvent> {
  final int id;
  final int sessionId;
  final DateTime triggeredAt;
  final FrictionStep stepType;
  final String? reflectionText;
  final FrictionOutcome outcome;
  const FrictionExitEvent({
    required this.id,
    required this.sessionId,
    required this.triggeredAt,
    required this.stepType,
    this.reflectionText,
    required this.outcome,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['session_id'] = Variable<int>(sessionId);
    map['triggered_at'] = Variable<DateTime>(triggeredAt);
    {
      map['step_type'] = Variable<int>(
        $FrictionExitEventsTable.$converterstepType.toSql(stepType),
      );
    }
    if (!nullToAbsent || reflectionText != null) {
      map['reflection_text'] = Variable<String>(reflectionText);
    }
    {
      map['outcome'] = Variable<int>(
        $FrictionExitEventsTable.$converteroutcome.toSql(outcome),
      );
    }
    return map;
  }

  FrictionExitEventsCompanion toCompanion(bool nullToAbsent) {
    return FrictionExitEventsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      triggeredAt: Value(triggeredAt),
      stepType: Value(stepType),
      reflectionText: reflectionText == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionText),
      outcome: Value(outcome),
    );
  }

  factory FrictionExitEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FrictionExitEvent(
      id: serializer.fromJson<int>(json['id']),
      sessionId: serializer.fromJson<int>(json['sessionId']),
      triggeredAt: serializer.fromJson<DateTime>(json['triggeredAt']),
      stepType: $FrictionExitEventsTable.$converterstepType.fromJson(
        serializer.fromJson<int>(json['stepType']),
      ),
      reflectionText: serializer.fromJson<String?>(json['reflectionText']),
      outcome: $FrictionExitEventsTable.$converteroutcome.fromJson(
        serializer.fromJson<int>(json['outcome']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sessionId': serializer.toJson<int>(sessionId),
      'triggeredAt': serializer.toJson<DateTime>(triggeredAt),
      'stepType': serializer.toJson<int>(
        $FrictionExitEventsTable.$converterstepType.toJson(stepType),
      ),
      'reflectionText': serializer.toJson<String?>(reflectionText),
      'outcome': serializer.toJson<int>(
        $FrictionExitEventsTable.$converteroutcome.toJson(outcome),
      ),
    };
  }

  FrictionExitEvent copyWith({
    int? id,
    int? sessionId,
    DateTime? triggeredAt,
    FrictionStep? stepType,
    Value<String?> reflectionText = const Value.absent(),
    FrictionOutcome? outcome,
  }) => FrictionExitEvent(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    triggeredAt: triggeredAt ?? this.triggeredAt,
    stepType: stepType ?? this.stepType,
    reflectionText: reflectionText.present
        ? reflectionText.value
        : this.reflectionText,
    outcome: outcome ?? this.outcome,
  );
  FrictionExitEvent copyWithCompanion(FrictionExitEventsCompanion data) {
    return FrictionExitEvent(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      triggeredAt: data.triggeredAt.present
          ? data.triggeredAt.value
          : this.triggeredAt,
      stepType: data.stepType.present ? data.stepType.value : this.stepType,
      reflectionText: data.reflectionText.present
          ? data.reflectionText.value
          : this.reflectionText,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FrictionExitEvent(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('stepType: $stepType, ')
          ..write('reflectionText: $reflectionText, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    triggeredAt,
    stepType,
    reflectionText,
    outcome,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FrictionExitEvent &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.triggeredAt == this.triggeredAt &&
          other.stepType == this.stepType &&
          other.reflectionText == this.reflectionText &&
          other.outcome == this.outcome);
}

class FrictionExitEventsCompanion extends UpdateCompanion<FrictionExitEvent> {
  final Value<int> id;
  final Value<int> sessionId;
  final Value<DateTime> triggeredAt;
  final Value<FrictionStep> stepType;
  final Value<String?> reflectionText;
  final Value<FrictionOutcome> outcome;
  const FrictionExitEventsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.stepType = const Value.absent(),
    this.reflectionText = const Value.absent(),
    this.outcome = const Value.absent(),
  });
  FrictionExitEventsCompanion.insert({
    this.id = const Value.absent(),
    required int sessionId,
    required DateTime triggeredAt,
    required FrictionStep stepType,
    this.reflectionText = const Value.absent(),
    required FrictionOutcome outcome,
  }) : sessionId = Value(sessionId),
       triggeredAt = Value(triggeredAt),
       stepType = Value(stepType),
       outcome = Value(outcome);
  static Insertable<FrictionExitEvent> custom({
    Expression<int>? id,
    Expression<int>? sessionId,
    Expression<DateTime>? triggeredAt,
    Expression<int>? stepType,
    Expression<String>? reflectionText,
    Expression<int>? outcome,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (stepType != null) 'step_type': stepType,
      if (reflectionText != null) 'reflection_text': reflectionText,
      if (outcome != null) 'outcome': outcome,
    });
  }

  FrictionExitEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? sessionId,
    Value<DateTime>? triggeredAt,
    Value<FrictionStep>? stepType,
    Value<String?>? reflectionText,
    Value<FrictionOutcome>? outcome,
  }) {
    return FrictionExitEventsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      stepType: stepType ?? this.stepType,
      reflectionText: reflectionText ?? this.reflectionText,
      outcome: outcome ?? this.outcome,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<DateTime>(triggeredAt.value);
    }
    if (stepType.present) {
      map['step_type'] = Variable<int>(
        $FrictionExitEventsTable.$converterstepType.toSql(stepType.value),
      );
    }
    if (reflectionText.present) {
      map['reflection_text'] = Variable<String>(reflectionText.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<int>(
        $FrictionExitEventsTable.$converteroutcome.toSql(outcome.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FrictionExitEventsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('stepType: $stepType, ')
          ..write('reflectionText: $reflectionText, ')
          ..write('outcome: $outcome')
          ..write(')'))
        .toString();
  }
}

class $AppUsageLimitsTable extends AppUsageLimits
    with TableInfo<$AppUsageLimitsTable, AppUsageLimit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppUsageLimitsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appLabelMeta = const VerificationMeta(
    'appLabel',
  );
  @override
  late final GeneratedColumn<String> appLabel = GeneratedColumn<String>(
    'app_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyMinutesMeta = const VerificationMeta(
    'dailyMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyMinutes = GeneratedColumn<int>(
    'daily_minutes',
    aliasedName,
    false,
    check: () => ComparableExpr(dailyMinutes).isBiggerThanValue(0),
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<LimitIntensity, int> intensity =
      GeneratedColumn<int>(
        'intensity',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LimitIntensity>($AppUsageLimitsTable.$converterintensity);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageName,
    appLabel,
    dailyMinutes,
    intensity,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_usage_limits';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppUsageLimit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_label')) {
      context.handle(
        _appLabelMeta,
        appLabel.isAcceptableOrUnknown(data['app_label']!, _appLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_appLabelMeta);
    }
    if (data.containsKey('daily_minutes')) {
      context.handle(
        _dailyMinutesMeta,
        dailyMinutes.isAcceptableOrUnknown(
          data['daily_minutes']!,
          _dailyMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyMinutesMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {packageName},
  ];
  @override
  AppUsageLimit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppUsageLimit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_label'],
      )!,
      dailyMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_minutes'],
      )!,
      intensity: $AppUsageLimitsTable.$converterintensity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}intensity'],
        )!,
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppUsageLimitsTable createAlias(String alias) {
    return $AppUsageLimitsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LimitIntensity, int, int> $converterintensity =
      const EnumIndexConverter<LimitIntensity>(LimitIntensity.values);
}

class AppUsageLimit extends DataClass implements Insertable<AppUsageLimit> {
  final int id;
  final String packageName;
  final String appLabel;

  /// Kolik minut denně smí uživatel v aplikaci strávit.
  /// Sebe-reference je idiomatika drift DSL — viz [FocusProfiles.durationMinutes].
  final int dailyMinutes;
  final LimitIntensity intensity;
  final DateTime updatedAt;
  const AppUsageLimit({
    required this.id,
    required this.packageName,
    required this.appLabel,
    required this.dailyMinutes,
    required this.intensity,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['app_label'] = Variable<String>(appLabel);
    map['daily_minutes'] = Variable<int>(dailyMinutes);
    {
      map['intensity'] = Variable<int>(
        $AppUsageLimitsTable.$converterintensity.toSql(intensity),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppUsageLimitsCompanion toCompanion(bool nullToAbsent) {
    return AppUsageLimitsCompanion(
      id: Value(id),
      packageName: Value(packageName),
      appLabel: Value(appLabel),
      dailyMinutes: Value(dailyMinutes),
      intensity: Value(intensity),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppUsageLimit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppUsageLimit(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appLabel: serializer.fromJson<String>(json['appLabel']),
      dailyMinutes: serializer.fromJson<int>(json['dailyMinutes']),
      intensity: $AppUsageLimitsTable.$converterintensity.fromJson(
        serializer.fromJson<int>(json['intensity']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'appLabel': serializer.toJson<String>(appLabel),
      'dailyMinutes': serializer.toJson<int>(dailyMinutes),
      'intensity': serializer.toJson<int>(
        $AppUsageLimitsTable.$converterintensity.toJson(intensity),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppUsageLimit copyWith({
    int? id,
    String? packageName,
    String? appLabel,
    int? dailyMinutes,
    LimitIntensity? intensity,
    DateTime? updatedAt,
  }) => AppUsageLimit(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    appLabel: appLabel ?? this.appLabel,
    dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    intensity: intensity ?? this.intensity,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AppUsageLimit copyWithCompanion(AppUsageLimitsCompanion data) {
    return AppUsageLimit(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appLabel: data.appLabel.present ? data.appLabel.value : this.appLabel,
      dailyMinutes: data.dailyMinutes.present
          ? data.dailyMinutes.value
          : this.dailyMinutes,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppUsageLimit(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('intensity: $intensity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageName,
    appLabel,
    dailyMinutes,
    intensity,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppUsageLimit &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.appLabel == this.appLabel &&
          other.dailyMinutes == this.dailyMinutes &&
          other.intensity == this.intensity &&
          other.updatedAt == this.updatedAt);
}

class AppUsageLimitsCompanion extends UpdateCompanion<AppUsageLimit> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> appLabel;
  final Value<int> dailyMinutes;
  final Value<LimitIntensity> intensity;
  final Value<DateTime> updatedAt;
  const AppUsageLimitsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appLabel = const Value.absent(),
    this.dailyMinutes = const Value.absent(),
    this.intensity = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AppUsageLimitsCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String appLabel,
    required int dailyMinutes,
    required LimitIntensity intensity,
    required DateTime updatedAt,
  }) : packageName = Value(packageName),
       appLabel = Value(appLabel),
       dailyMinutes = Value(dailyMinutes),
       intensity = Value(intensity),
       updatedAt = Value(updatedAt);
  static Insertable<AppUsageLimit> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? appLabel,
    Expression<int>? dailyMinutes,
    Expression<int>? intensity,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (appLabel != null) 'app_label': appLabel,
      if (dailyMinutes != null) 'daily_minutes': dailyMinutes,
      if (intensity != null) 'intensity': intensity,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AppUsageLimitsCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? appLabel,
    Value<int>? dailyMinutes,
    Value<LimitIntensity>? intensity,
    Value<DateTime>? updatedAt,
  }) {
    return AppUsageLimitsCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appLabel: appLabel ?? this.appLabel,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
      intensity: intensity ?? this.intensity,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appLabel.present) {
      map['app_label'] = Variable<String>(appLabel.value);
    }
    if (dailyMinutes.present) {
      map['daily_minutes'] = Variable<int>(dailyMinutes.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(
        $AppUsageLimitsTable.$converterintensity.toSql(intensity.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppUsageLimitsCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('dailyMinutes: $dailyMinutes, ')
          ..write('intensity: $intensity, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AnchorEventsTable extends AnchorEvents
    with TableInfo<$AnchorEventsTable, AnchorEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnchorEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _anchorPointIdMeta = const VerificationMeta(
    'anchorPointId',
  );
  @override
  late final GeneratedColumn<int> anchorPointId = GeneratedColumn<int>(
    'anchor_point_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES anchor_points (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _leftAtMeta = const VerificationMeta('leftAt');
  @override
  late final GeneratedColumn<DateTime> leftAt = GeneratedColumn<DateTime>(
    'left_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnedAtMeta = const VerificationMeta(
    'returnedAt',
  );
  @override
  late final GeneratedColumn<DateTime> returnedAt = GeneratedColumn<DateTime>(
    'returned_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reflectionTextMeta = const VerificationMeta(
    'reflectionText',
  );
  @override
  late final GeneratedColumn<String> reflectionText = GeneratedColumn<String>(
    'reflection_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    anchorPointId,
    sessionId,
    leftAt,
    returnedAt,
    reflectionText,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anchor_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnchorEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anchor_point_id')) {
      context.handle(
        _anchorPointIdMeta,
        anchorPointId.isAcceptableOrUnknown(
          data['anchor_point_id']!,
          _anchorPointIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anchorPointIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('left_at')) {
      context.handle(
        _leftAtMeta,
        leftAt.isAcceptableOrUnknown(data['left_at']!, _leftAtMeta),
      );
    } else if (isInserting) {
      context.missing(_leftAtMeta);
    }
    if (data.containsKey('returned_at')) {
      context.handle(
        _returnedAtMeta,
        returnedAt.isAcceptableOrUnknown(data['returned_at']!, _returnedAtMeta),
      );
    }
    if (data.containsKey('reflection_text')) {
      context.handle(
        _reflectionTextMeta,
        reflectionText.isAcceptableOrUnknown(
          data['reflection_text']!,
          _reflectionTextMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnchorEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnchorEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      anchorPointId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anchor_point_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      leftAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}left_at'],
      )!,
      returnedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}returned_at'],
      ),
      reflectionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflection_text'],
      ),
    );
  }

  @override
  $AnchorEventsTable createAlias(String alias) {
    return $AnchorEventsTable(attachedDatabase, alias);
  }
}

class AnchorEvent extends DataClass implements Insertable<AnchorEvent> {
  final int id;
  final int anchorPointId;

  /// Nepřítomnost může nastat i mimo fokus blok, proto nepovinné.
  final int? sessionId;
  final DateTime leftAt;
  final DateTime? returnedAt;

  /// Nepovinná odpověď na otázku při návratu. Otázka se ptá **bez obviňování**
  /// — je to podklad pro reflexi, ne výslech (docs/spec.md §5.3 a §11).
  final String? reflectionText;
  const AnchorEvent({
    required this.id,
    required this.anchorPointId,
    this.sessionId,
    required this.leftAt,
    this.returnedAt,
    this.reflectionText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anchor_point_id'] = Variable<int>(anchorPointId);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    map['left_at'] = Variable<DateTime>(leftAt);
    if (!nullToAbsent || returnedAt != null) {
      map['returned_at'] = Variable<DateTime>(returnedAt);
    }
    if (!nullToAbsent || reflectionText != null) {
      map['reflection_text'] = Variable<String>(reflectionText);
    }
    return map;
  }

  AnchorEventsCompanion toCompanion(bool nullToAbsent) {
    return AnchorEventsCompanion(
      id: Value(id),
      anchorPointId: Value(anchorPointId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      leftAt: Value(leftAt),
      returnedAt: returnedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(returnedAt),
      reflectionText: reflectionText == null && nullToAbsent
          ? const Value.absent()
          : Value(reflectionText),
    );
  }

  factory AnchorEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnchorEvent(
      id: serializer.fromJson<int>(json['id']),
      anchorPointId: serializer.fromJson<int>(json['anchorPointId']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      leftAt: serializer.fromJson<DateTime>(json['leftAt']),
      returnedAt: serializer.fromJson<DateTime?>(json['returnedAt']),
      reflectionText: serializer.fromJson<String?>(json['reflectionText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'anchorPointId': serializer.toJson<int>(anchorPointId),
      'sessionId': serializer.toJson<int?>(sessionId),
      'leftAt': serializer.toJson<DateTime>(leftAt),
      'returnedAt': serializer.toJson<DateTime?>(returnedAt),
      'reflectionText': serializer.toJson<String?>(reflectionText),
    };
  }

  AnchorEvent copyWith({
    int? id,
    int? anchorPointId,
    Value<int?> sessionId = const Value.absent(),
    DateTime? leftAt,
    Value<DateTime?> returnedAt = const Value.absent(),
    Value<String?> reflectionText = const Value.absent(),
  }) => AnchorEvent(
    id: id ?? this.id,
    anchorPointId: anchorPointId ?? this.anchorPointId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    leftAt: leftAt ?? this.leftAt,
    returnedAt: returnedAt.present ? returnedAt.value : this.returnedAt,
    reflectionText: reflectionText.present
        ? reflectionText.value
        : this.reflectionText,
  );
  AnchorEvent copyWithCompanion(AnchorEventsCompanion data) {
    return AnchorEvent(
      id: data.id.present ? data.id.value : this.id,
      anchorPointId: data.anchorPointId.present
          ? data.anchorPointId.value
          : this.anchorPointId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      leftAt: data.leftAt.present ? data.leftAt.value : this.leftAt,
      returnedAt: data.returnedAt.present
          ? data.returnedAt.value
          : this.returnedAt,
      reflectionText: data.reflectionText.present
          ? data.reflectionText.value
          : this.reflectionText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnchorEvent(')
          ..write('id: $id, ')
          ..write('anchorPointId: $anchorPointId, ')
          ..write('sessionId: $sessionId, ')
          ..write('leftAt: $leftAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('reflectionText: $reflectionText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    anchorPointId,
    sessionId,
    leftAt,
    returnedAt,
    reflectionText,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnchorEvent &&
          other.id == this.id &&
          other.anchorPointId == this.anchorPointId &&
          other.sessionId == this.sessionId &&
          other.leftAt == this.leftAt &&
          other.returnedAt == this.returnedAt &&
          other.reflectionText == this.reflectionText);
}

class AnchorEventsCompanion extends UpdateCompanion<AnchorEvent> {
  final Value<int> id;
  final Value<int> anchorPointId;
  final Value<int?> sessionId;
  final Value<DateTime> leftAt;
  final Value<DateTime?> returnedAt;
  final Value<String?> reflectionText;
  const AnchorEventsCompanion({
    this.id = const Value.absent(),
    this.anchorPointId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.leftAt = const Value.absent(),
    this.returnedAt = const Value.absent(),
    this.reflectionText = const Value.absent(),
  });
  AnchorEventsCompanion.insert({
    this.id = const Value.absent(),
    required int anchorPointId,
    this.sessionId = const Value.absent(),
    required DateTime leftAt,
    this.returnedAt = const Value.absent(),
    this.reflectionText = const Value.absent(),
  }) : anchorPointId = Value(anchorPointId),
       leftAt = Value(leftAt);
  static Insertable<AnchorEvent> custom({
    Expression<int>? id,
    Expression<int>? anchorPointId,
    Expression<int>? sessionId,
    Expression<DateTime>? leftAt,
    Expression<DateTime>? returnedAt,
    Expression<String>? reflectionText,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anchorPointId != null) 'anchor_point_id': anchorPointId,
      if (sessionId != null) 'session_id': sessionId,
      if (leftAt != null) 'left_at': leftAt,
      if (returnedAt != null) 'returned_at': returnedAt,
      if (reflectionText != null) 'reflection_text': reflectionText,
    });
  }

  AnchorEventsCompanion copyWith({
    Value<int>? id,
    Value<int>? anchorPointId,
    Value<int?>? sessionId,
    Value<DateTime>? leftAt,
    Value<DateTime?>? returnedAt,
    Value<String?>? reflectionText,
  }) {
    return AnchorEventsCompanion(
      id: id ?? this.id,
      anchorPointId: anchorPointId ?? this.anchorPointId,
      sessionId: sessionId ?? this.sessionId,
      leftAt: leftAt ?? this.leftAt,
      returnedAt: returnedAt ?? this.returnedAt,
      reflectionText: reflectionText ?? this.reflectionText,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (anchorPointId.present) {
      map['anchor_point_id'] = Variable<int>(anchorPointId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (leftAt.present) {
      map['left_at'] = Variable<DateTime>(leftAt.value);
    }
    if (returnedAt.present) {
      map['returned_at'] = Variable<DateTime>(returnedAt.value);
    }
    if (reflectionText.present) {
      map['reflection_text'] = Variable<String>(reflectionText.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnchorEventsCompanion(')
          ..write('id: $id, ')
          ..write('anchorPointId: $anchorPointId, ')
          ..write('sessionId: $sessionId, ')
          ..write('leftAt: $leftAt, ')
          ..write('returnedAt: $returnedAt, ')
          ..write('reflectionText: $reflectionText')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnchorPointsTable anchorPoints = $AnchorPointsTable(this);
  late final $SmartDevicesTable smartDevices = $SmartDevicesTable(this);
  late final $FocusProfilesTable focusProfiles = $FocusProfilesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $BlockedAppListsTable blockedAppLists = $BlockedAppListsTable(
    this,
  );
  late final $BlockedAppsTable blockedApps = $BlockedAppsTable(this);
  late final $ProfileBlockedListsTable profileBlockedLists =
      $ProfileBlockedListsTable(this);
  late final $FrictionExitEventsTable frictionExitEvents =
      $FrictionExitEventsTable(this);
  late final $AppUsageLimitsTable appUsageLimits = $AppUsageLimitsTable(this);
  late final $AnchorEventsTable anchorEvents = $AnchorEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    anchorPoints,
    smartDevices,
    focusProfiles,
    focusSessions,
    blockedAppLists,
    blockedApps,
    profileBlockedLists,
    frictionExitEvents,
    appUsageLimits,
    anchorEvents,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'anchor_points',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_profiles', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'smart_devices',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_profiles', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('focus_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'blocked_app_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('blocked_apps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_profiles',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('profile_blocked_lists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'blocked_app_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('profile_blocked_lists', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('friction_exit_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'anchor_points',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('anchor_events', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'focus_sessions',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('anchor_events', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AnchorPointsTableCreateCompanionBuilder =
    AnchorPointsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required AnchorType type,
      required String tagIdentifier,
      required String name,
      Value<DateTime?> lastSeenAt,
      required DateTime createdAt,
    });
typedef $$AnchorPointsTableUpdateCompanionBuilder =
    AnchorPointsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<AnchorType> type,
      Value<String> tagIdentifier,
      Value<String> name,
      Value<DateTime?> lastSeenAt,
      Value<DateTime> createdAt,
    });

final class $$AnchorPointsTableReferences
    extends BaseReferences<_$AppDatabase, $AnchorPointsTable, AnchorPoint> {
  $$AnchorPointsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusProfilesTable, List<FocusProfile>>
  _focusProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusProfiles,
    aliasName: 'anchor_points__id__focus_profiles__anchor_point_id',
  );

  $$FocusProfilesTableProcessedTableManager get focusProfilesRefs {
    final manager = $$FocusProfilesTableTableManager(
      $_db,
      $_db.focusProfiles,
    ).filter((f) => f.anchorPointId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusProfilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnchorEventsTable, List<AnchorEvent>>
  _anchorEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.anchorEvents,
    aliasName: 'anchor_points__id__anchor_events__anchor_point_id',
  );

  $$AnchorEventsTableProcessedTableManager get anchorEventsRefs {
    final manager = $$AnchorEventsTableTableManager(
      $_db,
      $_db.anchorEvents,
    ).filter((f) => f.anchorPointId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_anchorEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AnchorPointsTableFilterComposer
    extends Composer<_$AppDatabase, $AnchorPointsTable> {
  $$AnchorPointsTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AnchorType, AnchorType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get tagIdentifier => $composableBuilder(
    column: $table.tagIdentifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focusProfilesRefs(
    Expression<bool> Function($$FocusProfilesTableFilterComposer f) f,
  ) {
    final $$FocusProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.anchorPointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableFilterComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> anchorEventsRefs(
    Expression<bool> Function($$AnchorEventsTableFilterComposer f) f,
  ) {
    final $$AnchorEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anchorEvents,
      getReferencedColumn: (t) => t.anchorPointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorEventsTableFilterComposer(
            $db: $db,
            $table: $db.anchorEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnchorPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnchorPointsTable> {
  $$AnchorPointsTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagIdentifier => $composableBuilder(
    column: $table.tagIdentifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnchorPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnchorPointsTable> {
  $$AnchorPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AnchorType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get tagIdentifier => $composableBuilder(
    column: $table.tagIdentifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> focusProfilesRefs<T extends Object>(
    Expression<T> Function($$FocusProfilesTableAnnotationComposer a) f,
  ) {
    final $$FocusProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.anchorPointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> anchorEventsRefs<T extends Object>(
    Expression<T> Function($$AnchorEventsTableAnnotationComposer a) f,
  ) {
    final $$AnchorEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anchorEvents,
      getReferencedColumn: (t) => t.anchorPointId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.anchorEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnchorPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnchorPointsTable,
          AnchorPoint,
          $$AnchorPointsTableFilterComposer,
          $$AnchorPointsTableOrderingComposer,
          $$AnchorPointsTableAnnotationComposer,
          $$AnchorPointsTableCreateCompanionBuilder,
          $$AnchorPointsTableUpdateCompanionBuilder,
          (AnchorPoint, $$AnchorPointsTableReferences),
          AnchorPoint,
          PrefetchHooks Function({
            bool focusProfilesRefs,
            bool anchorEventsRefs,
          })
        > {
  $$AnchorPointsTableTableManager(_$AppDatabase db, $AnchorPointsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnchorPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnchorPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnchorPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<AnchorType> type = const Value.absent(),
                Value<String> tagIdentifier = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime?> lastSeenAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AnchorPointsCompanion(
                id: id,
                remoteId: remoteId,
                type: type,
                tagIdentifier: tagIdentifier,
                name: name,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required AnchorType type,
                required String tagIdentifier,
                required String name,
                Value<DateTime?> lastSeenAt = const Value.absent(),
                required DateTime createdAt,
              }) => AnchorPointsCompanion.insert(
                id: id,
                remoteId: remoteId,
                type: type,
                tagIdentifier: tagIdentifier,
                name: name,
                lastSeenAt: lastSeenAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnchorPointsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({focusProfilesRefs = false, anchorEventsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusProfilesRefs) db.focusProfiles,
                    if (anchorEventsRefs) db.anchorEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusProfilesRefs)
                        await $_getPrefetchedData<
                          AnchorPoint,
                          $AnchorPointsTable,
                          FocusProfile
                        >(
                          currentTable: table,
                          referencedTable: $$AnchorPointsTableReferences
                              ._focusProfilesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnchorPointsTableReferences(
                                db,
                                table,
                                p0,
                              ).focusProfilesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.anchorPointId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (anchorEventsRefs)
                        await $_getPrefetchedData<
                          AnchorPoint,
                          $AnchorPointsTable,
                          AnchorEvent
                        >(
                          currentTable: table,
                          referencedTable: $$AnchorPointsTableReferences
                              ._anchorEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnchorPointsTableReferences(
                                db,
                                table,
                                p0,
                              ).anchorEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.anchorPointId == item.id,
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

typedef $$AnchorPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnchorPointsTable,
      AnchorPoint,
      $$AnchorPointsTableFilterComposer,
      $$AnchorPointsTableOrderingComposer,
      $$AnchorPointsTableAnnotationComposer,
      $$AnchorPointsTableCreateCompanionBuilder,
      $$AnchorPointsTableUpdateCompanionBuilder,
      (AnchorPoint, $$AnchorPointsTableReferences),
      AnchorPoint,
      PrefetchHooks Function({bool focusProfilesRefs, bool anchorEventsRefs})
    >;
typedef $$SmartDevicesTableCreateCompanionBuilder =
    SmartDevicesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required SmartProvider provider,
      required String externalDeviceId,
      required String name,
      Value<bool?> stateBeforeSession,
      required DateTime createdAt,
    });
typedef $$SmartDevicesTableUpdateCompanionBuilder =
    SmartDevicesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<SmartProvider> provider,
      Value<String> externalDeviceId,
      Value<String> name,
      Value<bool?> stateBeforeSession,
      Value<DateTime> createdAt,
    });

final class $$SmartDevicesTableReferences
    extends BaseReferences<_$AppDatabase, $SmartDevicesTable, SmartDevice> {
  $$SmartDevicesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FocusProfilesTable, List<FocusProfile>>
  _focusProfilesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusProfiles,
    aliasName: 'smart_devices__id__focus_profiles__smart_device_id',
  );

  $$FocusProfilesTableProcessedTableManager get focusProfilesRefs {
    final manager = $$FocusProfilesTableTableManager(
      $_db,
      $_db.focusProfiles,
    ).filter((f) => f.smartDeviceId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusProfilesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SmartDevicesTableFilterComposer
    extends Composer<_$AppDatabase, $SmartDevicesTable> {
  $$SmartDevicesTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SmartProvider, SmartProvider, int>
  get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get externalDeviceId => $composableBuilder(
    column: $table.externalDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get stateBeforeSession => $composableBuilder(
    column: $table.stateBeforeSession,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> focusProfilesRefs(
    Expression<bool> Function($$FocusProfilesTableFilterComposer f) f,
  ) {
    final $$FocusProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.smartDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableFilterComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmartDevicesTableOrderingComposer
    extends Composer<_$AppDatabase, $SmartDevicesTable> {
  $$SmartDevicesTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get externalDeviceId => $composableBuilder(
    column: $table.externalDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get stateBeforeSession => $composableBuilder(
    column: $table.stateBeforeSession,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SmartDevicesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SmartDevicesTable> {
  $$SmartDevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SmartProvider, int> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get externalDeviceId => $composableBuilder(
    column: $table.externalDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get stateBeforeSession => $composableBuilder(
    column: $table.stateBeforeSession,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> focusProfilesRefs<T extends Object>(
    Expression<T> Function($$FocusProfilesTableAnnotationComposer a) f,
  ) {
    final $$FocusProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.smartDeviceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SmartDevicesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmartDevicesTable,
          SmartDevice,
          $$SmartDevicesTableFilterComposer,
          $$SmartDevicesTableOrderingComposer,
          $$SmartDevicesTableAnnotationComposer,
          $$SmartDevicesTableCreateCompanionBuilder,
          $$SmartDevicesTableUpdateCompanionBuilder,
          (SmartDevice, $$SmartDevicesTableReferences),
          SmartDevice,
          PrefetchHooks Function({bool focusProfilesRefs})
        > {
  $$SmartDevicesTableTableManager(_$AppDatabase db, $SmartDevicesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SmartDevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SmartDevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SmartDevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<SmartProvider> provider = const Value.absent(),
                Value<String> externalDeviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool?> stateBeforeSession = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SmartDevicesCompanion(
                id: id,
                remoteId: remoteId,
                provider: provider,
                externalDeviceId: externalDeviceId,
                name: name,
                stateBeforeSession: stateBeforeSession,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required SmartProvider provider,
                required String externalDeviceId,
                required String name,
                Value<bool?> stateBeforeSession = const Value.absent(),
                required DateTime createdAt,
              }) => SmartDevicesCompanion.insert(
                id: id,
                remoteId: remoteId,
                provider: provider,
                externalDeviceId: externalDeviceId,
                name: name,
                stateBeforeSession: stateBeforeSession,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SmartDevicesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({focusProfilesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (focusProfilesRefs) db.focusProfiles,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (focusProfilesRefs)
                    await $_getPrefetchedData<
                      SmartDevice,
                      $SmartDevicesTable,
                      FocusProfile
                    >(
                      currentTable: table,
                      referencedTable: $$SmartDevicesTableReferences
                          ._focusProfilesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SmartDevicesTableReferences(
                            db,
                            table,
                            p0,
                          ).focusProfilesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.smartDeviceId == item.id,
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

typedef $$SmartDevicesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmartDevicesTable,
      SmartDevice,
      $$SmartDevicesTableFilterComposer,
      $$SmartDevicesTableOrderingComposer,
      $$SmartDevicesTableAnnotationComposer,
      $$SmartDevicesTableCreateCompanionBuilder,
      $$SmartDevicesTableUpdateCompanionBuilder,
      (SmartDevice, $$SmartDevicesTableReferences),
      SmartDevice,
      PrefetchHooks Function({bool focusProfilesRefs})
    >;
typedef $$FocusProfilesTableCreateCompanionBuilder =
    FocusProfilesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String name,
      required int durationMinutes,
      Value<String> goalText,
      required StrictnessLevel strictness,
      Value<int?> anchorPointId,
      Value<int?> smartDeviceId,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$FocusProfilesTableUpdateCompanionBuilder =
    FocusProfilesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<String> name,
      Value<int> durationMinutes,
      Value<String> goalText,
      Value<StrictnessLevel> strictness,
      Value<int?> anchorPointId,
      Value<int?> smartDeviceId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$FocusProfilesTableReferences
    extends BaseReferences<_$AppDatabase, $FocusProfilesTable, FocusProfile> {
  $$FocusProfilesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnchorPointsTable _anchorPointIdTable(_$AppDatabase db) => db
      .anchorPoints
      .createAlias('focus_profiles__anchor_point_id__anchor_points__id');

  $$AnchorPointsTableProcessedTableManager? get anchorPointId {
    final $_column = $_itemColumn<int>('anchor_point_id');
    if ($_column == null) return null;
    final manager = $$AnchorPointsTableTableManager(
      $_db,
      $_db.anchorPoints,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anchorPointIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SmartDevicesTable _smartDeviceIdTable(_$AppDatabase db) => db
      .smartDevices
      .createAlias('focus_profiles__smart_device_id__smart_devices__id');

  $$SmartDevicesTableProcessedTableManager? get smartDeviceId {
    final $_column = $_itemColumn<int>('smart_device_id');
    if ($_column == null) return null;
    final manager = $$SmartDevicesTableTableManager(
      $_db,
      $_db.smartDevices,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_smartDeviceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'focus_profiles__id__focus_sessions__profile_id',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProfileBlockedListsTable,
    List<ProfileBlockedList>
  >
  _profileBlockedListsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.profileBlockedLists,
        aliasName: 'focus_profiles__id__profile_blocked_lists__profile_id',
      );

  $$ProfileBlockedListsTableProcessedTableManager get profileBlockedListsRefs {
    final manager = $$ProfileBlockedListsTableTableManager(
      $_db,
      $_db.profileBlockedLists,
    ).filter((f) => f.profileId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileBlockedListsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocusProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StrictnessLevel, StrictnessLevel, int>
  get strictness => $composableBuilder(
    column: $table.strictness,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AnchorPointsTableFilterComposer get anchorPointId {
    final $$AnchorPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableFilterComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SmartDevicesTableFilterComposer get smartDeviceId {
    final $$SmartDevicesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smartDeviceId,
      referencedTable: $db.smartDevices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmartDevicesTableFilterComposer(
            $db: $db,
            $table: $db.smartDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> profileBlockedListsRefs(
    Expression<bool> Function($$ProfileBlockedListsTableFilterComposer f) f,
  ) {
    final $$ProfileBlockedListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileBlockedLists,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileBlockedListsTableFilterComposer(
            $db: $db,
            $table: $db.profileBlockedLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strictness => $composableBuilder(
    column: $table.strictness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnchorPointsTableOrderingComposer get anchorPointId {
    final $$AnchorPointsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableOrderingComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SmartDevicesTableOrderingComposer get smartDeviceId {
    final $$SmartDevicesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smartDeviceId,
      referencedTable: $db.smartDevices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmartDevicesTableOrderingComposer(
            $db: $db,
            $table: $db.smartDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusProfilesTable> {
  $$FocusProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalText =>
      $composableBuilder(column: $table.goalText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StrictnessLevel, int> get strictness =>
      $composableBuilder(
        column: $table.strictness,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AnchorPointsTableAnnotationComposer get anchorPointId {
    final $$AnchorPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SmartDevicesTableAnnotationComposer get smartDeviceId {
    final $$SmartDevicesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.smartDeviceId,
      referencedTable: $db.smartDevices,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SmartDevicesTableAnnotationComposer(
            $db: $db,
            $table: $db.smartDevices,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.profileId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> profileBlockedListsRefs<T extends Object>(
    Expression<T> Function($$ProfileBlockedListsTableAnnotationComposer a) f,
  ) {
    final $$ProfileBlockedListsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.profileBlockedLists,
          getReferencedColumn: (t) => t.profileId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProfileBlockedListsTableAnnotationComposer(
                $db: $db,
                $table: $db.profileBlockedLists,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FocusProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusProfilesTable,
          FocusProfile,
          $$FocusProfilesTableFilterComposer,
          $$FocusProfilesTableOrderingComposer,
          $$FocusProfilesTableAnnotationComposer,
          $$FocusProfilesTableCreateCompanionBuilder,
          $$FocusProfilesTableUpdateCompanionBuilder,
          (FocusProfile, $$FocusProfilesTableReferences),
          FocusProfile,
          PrefetchHooks Function({
            bool anchorPointId,
            bool smartDeviceId,
            bool focusSessionsRefs,
            bool profileBlockedListsRefs,
          })
        > {
  $$FocusProfilesTableTableManager(_$AppDatabase db, $FocusProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<String> goalText = const Value.absent(),
                Value<StrictnessLevel> strictness = const Value.absent(),
                Value<int?> anchorPointId = const Value.absent(),
                Value<int?> smartDeviceId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FocusProfilesCompanion(
                id: id,
                remoteId: remoteId,
                name: name,
                durationMinutes: durationMinutes,
                goalText: goalText,
                strictness: strictness,
                anchorPointId: anchorPointId,
                smartDeviceId: smartDeviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required String name,
                required int durationMinutes,
                Value<String> goalText = const Value.absent(),
                required StrictnessLevel strictness,
                Value<int?> anchorPointId = const Value.absent(),
                Value<int?> smartDeviceId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FocusProfilesCompanion.insert(
                id: id,
                remoteId: remoteId,
                name: name,
                durationMinutes: durationMinutes,
                goalText: goalText,
                strictness: strictness,
                anchorPointId: anchorPointId,
                smartDeviceId: smartDeviceId,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusProfilesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                anchorPointId = false,
                smartDeviceId = false,
                focusSessionsRefs = false,
                profileBlockedListsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusSessionsRefs) db.focusSessions,
                    if (profileBlockedListsRefs) db.profileBlockedLists,
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
                        if (anchorPointId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.anchorPointId,
                                    referencedTable:
                                        $$FocusProfilesTableReferences
                                            ._anchorPointIdTable(db),
                                    referencedColumn:
                                        $$FocusProfilesTableReferences
                                            ._anchorPointIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (smartDeviceId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.smartDeviceId,
                                    referencedTable:
                                        $$FocusProfilesTableReferences
                                            ._smartDeviceIdTable(db),
                                    referencedColumn:
                                        $$FocusProfilesTableReferences
                                            ._smartDeviceIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusSessionsRefs)
                        await $_getPrefetchedData<
                          FocusProfile,
                          $FocusProfilesTable,
                          FocusSession
                        >(
                          currentTable: table,
                          referencedTable: $$FocusProfilesTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (profileBlockedListsRefs)
                        await $_getPrefetchedData<
                          FocusProfile,
                          $FocusProfilesTable,
                          ProfileBlockedList
                        >(
                          currentTable: table,
                          referencedTable: $$FocusProfilesTableReferences
                              ._profileBlockedListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusProfilesTableReferences(
                                db,
                                table,
                                p0,
                              ).profileBlockedListsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.profileId == item.id,
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

typedef $$FocusProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusProfilesTable,
      FocusProfile,
      $$FocusProfilesTableFilterComposer,
      $$FocusProfilesTableOrderingComposer,
      $$FocusProfilesTableAnnotationComposer,
      $$FocusProfilesTableCreateCompanionBuilder,
      $$FocusProfilesTableUpdateCompanionBuilder,
      (FocusProfile, $$FocusProfilesTableReferences),
      FocusProfile,
      PrefetchHooks Function({
        bool anchorPointId,
        bool smartDeviceId,
        bool focusSessionsRefs,
        bool profileBlockedListsRefs,
      })
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required int profileId,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      required int plannedDurationMinutes,
      Value<String> goalText,
      required SessionStatus status,
      Value<StrictnessLevel> strictness,
      required DateTime updatedAt,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<int> profileId,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> plannedDurationMinutes,
      Value<String> goalText,
      Value<SessionStatus> status,
      Value<StrictnessLevel> strictness,
      Value<DateTime> updatedAt,
    });

final class $$FocusSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusProfilesTable _profileIdTable(_$AppDatabase db) => db
      .focusProfiles
      .createAlias('focus_sessions__profile_id__focus_profiles__id');

  $$FocusProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$FocusProfilesTableTableManager(
      $_db,
      $_db.focusProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FrictionExitEventsTable, List<FrictionExitEvent>>
  _frictionExitEventsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.frictionExitEvents,
        aliasName: 'focus_sessions__id__friction_exit_events__session_id',
      );

  $$FrictionExitEventsTableProcessedTableManager get frictionExitEventsRefs {
    final manager = $$FrictionExitEventsTableTableManager(
      $_db,
      $_db.frictionExitEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _frictionExitEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AnchorEventsTable, List<AnchorEvent>>
  _anchorEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.anchorEvents,
    aliasName: 'focus_sessions__id__anchor_events__session_id',
  );

  $$AnchorEventsTableProcessedTableManager get anchorEventsRefs {
    final manager = $$AnchorEventsTableTableManager(
      $_db,
      $_db.anchorEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_anchorEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SessionStatus, SessionStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<StrictnessLevel, StrictnessLevel, int>
  get strictness => $composableBuilder(
    column: $table.strictness,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FocusProfilesTableFilterComposer get profileId {
    final $$FocusProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableFilterComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> frictionExitEventsRefs(
    Expression<bool> Function($$FrictionExitEventsTableFilterComposer f) f,
  ) {
    final $$FrictionExitEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.frictionExitEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FrictionExitEventsTableFilterComposer(
            $db: $db,
            $table: $db.frictionExitEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> anchorEventsRefs(
    Expression<bool> Function($$AnchorEventsTableFilterComposer f) f,
  ) {
    final $$AnchorEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anchorEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorEventsTableFilterComposer(
            $db: $db,
            $table: $db.anchorEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalText => $composableBuilder(
    column: $table.goalText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get strictness => $composableBuilder(
    column: $table.strictness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocusProfilesTableOrderingComposer get profileId {
    final $$FocusProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get plannedDurationMinutes => $composableBuilder(
    column: $table.plannedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get goalText =>
      $composableBuilder(column: $table.goalText, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SessionStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumnWithTypeConverter<StrictnessLevel, int> get strictness =>
      $composableBuilder(
        column: $table.strictness,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FocusProfilesTableAnnotationComposer get profileId {
    final $$FocusProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> frictionExitEventsRefs<T extends Object>(
    Expression<T> Function($$FrictionExitEventsTableAnnotationComposer a) f,
  ) {
    final $$FrictionExitEventsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.frictionExitEvents,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FrictionExitEventsTableAnnotationComposer(
                $db: $db,
                $table: $db.frictionExitEvents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> anchorEventsRefs<T extends Object>(
    Expression<T> Function($$AnchorEventsTableAnnotationComposer a) f,
  ) {
    final $$AnchorEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.anchorEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.anchorEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({
            bool profileId,
            bool frictionExitEventsRefs,
            bool anchorEventsRefs,
          })
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<int> profileId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> plannedDurationMinutes = const Value.absent(),
                Value<String> goalText = const Value.absent(),
                Value<SessionStatus> status = const Value.absent(),
                Value<StrictnessLevel> strictness = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                remoteId: remoteId,
                profileId: profileId,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                goalText: goalText,
                status: status,
                strictness: strictness,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required int profileId,
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                required int plannedDurationMinutes,
                Value<String> goalText = const Value.absent(),
                required SessionStatus status,
                Value<StrictnessLevel> strictness = const Value.absent(),
                required DateTime updatedAt,
              }) => FocusSessionsCompanion.insert(
                id: id,
                remoteId: remoteId,
                profileId: profileId,
                startedAt: startedAt,
                endedAt: endedAt,
                plannedDurationMinutes: plannedDurationMinutes,
                goalText: goalText,
                status: status,
                strictness: strictness,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                profileId = false,
                frictionExitEventsRefs = false,
                anchorEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (frictionExitEventsRefs) db.frictionExitEvents,
                    if (anchorEventsRefs) db.anchorEvents,
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
                        if (profileId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.profileId,
                                    referencedTable:
                                        $$FocusSessionsTableReferences
                                            ._profileIdTable(db),
                                    referencedColumn:
                                        $$FocusSessionsTableReferences
                                            ._profileIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (frictionExitEventsRefs)
                        await $_getPrefetchedData<
                          FocusSession,
                          $FocusSessionsTable,
                          FrictionExitEvent
                        >(
                          currentTable: table,
                          referencedTable: $$FocusSessionsTableReferences
                              ._frictionExitEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).frictionExitEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (anchorEventsRefs)
                        await $_getPrefetchedData<
                          FocusSession,
                          $FocusSessionsTable,
                          AnchorEvent
                        >(
                          currentTable: table,
                          referencedTable: $$FocusSessionsTableReferences
                              ._anchorEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).anchorEventsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.sessionId == item.id,
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

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({
        bool profileId,
        bool frictionExitEventsRefs,
        bool anchorEventsRefs,
      })
    >;
typedef $$BlockedAppListsTableCreateCompanionBuilder =
    BlockedAppListsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$BlockedAppListsTableUpdateCompanionBuilder =
    BlockedAppListsCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$BlockedAppListsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BlockedAppListsTable, BlockedAppList> {
  $$BlockedAppListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$BlockedAppsTable, List<BlockedApp>>
  _blockedAppsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.blockedApps,
    aliasName: 'blocked_app_lists__id__blocked_apps__list_id',
  );

  $$BlockedAppsTableProcessedTableManager get blockedAppsRefs {
    final manager = $$BlockedAppsTableTableManager(
      $_db,
      $_db.blockedApps,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_blockedAppsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $ProfileBlockedListsTable,
    List<ProfileBlockedList>
  >
  _profileBlockedListsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.profileBlockedLists,
        aliasName: 'blocked_app_lists__id__profile_blocked_lists__list_id',
      );

  $$ProfileBlockedListsTableProcessedTableManager get profileBlockedListsRefs {
    final manager = $$ProfileBlockedListsTableTableManager(
      $_db,
      $_db.profileBlockedLists,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _profileBlockedListsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BlockedAppListsTableFilterComposer
    extends Composer<_$AppDatabase, $BlockedAppListsTable> {
  $$BlockedAppListsTableFilterComposer({
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

  ColumnFilters<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> blockedAppsRefs(
    Expression<bool> Function($$BlockedAppsTableFilterComposer f) f,
  ) {
    final $$BlockedAppsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedApps,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppsTableFilterComposer(
            $db: $db,
            $table: $db.blockedApps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> profileBlockedListsRefs(
    Expression<bool> Function($$ProfileBlockedListsTableFilterComposer f) f,
  ) {
    final $$ProfileBlockedListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.profileBlockedLists,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProfileBlockedListsTableFilterComposer(
            $db: $db,
            $table: $db.profileBlockedLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BlockedAppListsTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockedAppListsTable> {
  $$BlockedAppListsTableOrderingComposer({
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

  ColumnOrderings<String> get remoteId => $composableBuilder(
    column: $table.remoteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BlockedAppListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockedAppListsTable> {
  $$BlockedAppListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get remoteId =>
      $composableBuilder(column: $table.remoteId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> blockedAppsRefs<T extends Object>(
    Expression<T> Function($$BlockedAppsTableAnnotationComposer a) f,
  ) {
    final $$BlockedAppsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.blockedApps,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppsTableAnnotationComposer(
            $db: $db,
            $table: $db.blockedApps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> profileBlockedListsRefs<T extends Object>(
    Expression<T> Function($$ProfileBlockedListsTableAnnotationComposer a) f,
  ) {
    final $$ProfileBlockedListsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.profileBlockedLists,
          getReferencedColumn: (t) => t.listId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$ProfileBlockedListsTableAnnotationComposer(
                $db: $db,
                $table: $db.profileBlockedLists,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BlockedAppListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedAppListsTable,
          BlockedAppList,
          $$BlockedAppListsTableFilterComposer,
          $$BlockedAppListsTableOrderingComposer,
          $$BlockedAppListsTableAnnotationComposer,
          $$BlockedAppListsTableCreateCompanionBuilder,
          $$BlockedAppListsTableUpdateCompanionBuilder,
          (BlockedAppList, $$BlockedAppListsTableReferences),
          BlockedAppList,
          PrefetchHooks Function({
            bool blockedAppsRefs,
            bool profileBlockedListsRefs,
          })
        > {
  $$BlockedAppListsTableTableManager(
    _$AppDatabase db,
    $BlockedAppListsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockedAppListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockedAppListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockedAppListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => BlockedAppListsCompanion(
                id: id,
                remoteId: remoteId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> remoteId = const Value.absent(),
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => BlockedAppListsCompanion.insert(
                id: id,
                remoteId: remoteId,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BlockedAppListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({blockedAppsRefs = false, profileBlockedListsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (blockedAppsRefs) db.blockedApps,
                    if (profileBlockedListsRefs) db.profileBlockedLists,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (blockedAppsRefs)
                        await $_getPrefetchedData<
                          BlockedAppList,
                          $BlockedAppListsTable,
                          BlockedApp
                        >(
                          currentTable: table,
                          referencedTable: $$BlockedAppListsTableReferences
                              ._blockedAppsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlockedAppListsTableReferences(
                                db,
                                table,
                                p0,
                              ).blockedAppsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.listId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (profileBlockedListsRefs)
                        await $_getPrefetchedData<
                          BlockedAppList,
                          $BlockedAppListsTable,
                          ProfileBlockedList
                        >(
                          currentTable: table,
                          referencedTable: $$BlockedAppListsTableReferences
                              ._profileBlockedListsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BlockedAppListsTableReferences(
                                db,
                                table,
                                p0,
                              ).profileBlockedListsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.listId == item.id,
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

typedef $$BlockedAppListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedAppListsTable,
      BlockedAppList,
      $$BlockedAppListsTableFilterComposer,
      $$BlockedAppListsTableOrderingComposer,
      $$BlockedAppListsTableAnnotationComposer,
      $$BlockedAppListsTableCreateCompanionBuilder,
      $$BlockedAppListsTableUpdateCompanionBuilder,
      (BlockedAppList, $$BlockedAppListsTableReferences),
      BlockedAppList,
      PrefetchHooks Function({
        bool blockedAppsRefs,
        bool profileBlockedListsRefs,
      })
    >;
typedef $$BlockedAppsTableCreateCompanionBuilder =
    BlockedAppsCompanion Function({
      Value<int> id,
      required int listId,
      required String packageName,
      required String appLabel,
    });
typedef $$BlockedAppsTableUpdateCompanionBuilder =
    BlockedAppsCompanion Function({
      Value<int> id,
      Value<int> listId,
      Value<String> packageName,
      Value<String> appLabel,
    });

final class $$BlockedAppsTableReferences
    extends BaseReferences<_$AppDatabase, $BlockedAppsTable, BlockedApp> {
  $$BlockedAppsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BlockedAppListsTable _listIdTable(_$AppDatabase db) => db
      .blockedAppLists
      .createAlias('blocked_apps__list_id__blocked_app_lists__id');

  $$BlockedAppListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$BlockedAppListsTableTableManager(
      $_db,
      $_db.blockedAppLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BlockedAppsTableFilterComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableFilterComposer({
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

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnFilters(column),
  );

  $$BlockedAppListsTableFilterComposer get listId {
    final $$BlockedAppListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableFilterComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAppsTableOrderingComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableOrderingComposer({
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

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnOrderings(column),
  );

  $$BlockedAppListsTableOrderingComposer get listId {
    final $$BlockedAppListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableOrderingComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAppsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BlockedAppsTable> {
  $$BlockedAppsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appLabel =>
      $composableBuilder(column: $table.appLabel, builder: (column) => column);

  $$BlockedAppListsTableAnnotationComposer get listId {
    final $$BlockedAppListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableAnnotationComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BlockedAppsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BlockedAppsTable,
          BlockedApp,
          $$BlockedAppsTableFilterComposer,
          $$BlockedAppsTableOrderingComposer,
          $$BlockedAppsTableAnnotationComposer,
          $$BlockedAppsTableCreateCompanionBuilder,
          $$BlockedAppsTableUpdateCompanionBuilder,
          (BlockedApp, $$BlockedAppsTableReferences),
          BlockedApp,
          PrefetchHooks Function({bool listId})
        > {
  $$BlockedAppsTableTableManager(_$AppDatabase db, $BlockedAppsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BlockedAppsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BlockedAppsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BlockedAppsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> appLabel = const Value.absent(),
              }) => BlockedAppsCompanion(
                id: id,
                listId: listId,
                packageName: packageName,
                appLabel: appLabel,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int listId,
                required String packageName,
                required String appLabel,
              }) => BlockedAppsCompanion.insert(
                id: id,
                listId: listId,
                packageName: packageName,
                appLabel: appLabel,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BlockedAppsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false}) {
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
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable: $$BlockedAppsTableReferences
                                    ._listIdTable(db),
                                referencedColumn: $$BlockedAppsTableReferences
                                    ._listIdTable(db)
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

typedef $$BlockedAppsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BlockedAppsTable,
      BlockedApp,
      $$BlockedAppsTableFilterComposer,
      $$BlockedAppsTableOrderingComposer,
      $$BlockedAppsTableAnnotationComposer,
      $$BlockedAppsTableCreateCompanionBuilder,
      $$BlockedAppsTableUpdateCompanionBuilder,
      (BlockedApp, $$BlockedAppsTableReferences),
      BlockedApp,
      PrefetchHooks Function({bool listId})
    >;
typedef $$ProfileBlockedListsTableCreateCompanionBuilder =
    ProfileBlockedListsCompanion Function({
      required int profileId,
      required int listId,
      Value<int> rowid,
    });
typedef $$ProfileBlockedListsTableUpdateCompanionBuilder =
    ProfileBlockedListsCompanion Function({
      Value<int> profileId,
      Value<int> listId,
      Value<int> rowid,
    });

final class $$ProfileBlockedListsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ProfileBlockedListsTable,
          ProfileBlockedList
        > {
  $$ProfileBlockedListsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusProfilesTable _profileIdTable(_$AppDatabase db) => db
      .focusProfiles
      .createAlias('profile_blocked_lists__profile_id__focus_profiles__id');

  $$FocusProfilesTableProcessedTableManager get profileId {
    final $_column = $_itemColumn<int>('profile_id')!;

    final manager = $$FocusProfilesTableTableManager(
      $_db,
      $_db.focusProfiles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_profileIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BlockedAppListsTable _listIdTable(_$AppDatabase db) => db
      .blockedAppLists
      .createAlias('profile_blocked_lists__list_id__blocked_app_lists__id');

  $$BlockedAppListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$BlockedAppListsTableTableManager(
      $_db,
      $_db.blockedAppLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProfileBlockedListsTableFilterComposer
    extends Composer<_$AppDatabase, $ProfileBlockedListsTable> {
  $$ProfileBlockedListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FocusProfilesTableFilterComposer get profileId {
    final $$FocusProfilesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableFilterComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BlockedAppListsTableFilterComposer get listId {
    final $$BlockedAppListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableFilterComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileBlockedListsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfileBlockedListsTable> {
  $$ProfileBlockedListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FocusProfilesTableOrderingComposer get profileId {
    final $$FocusProfilesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableOrderingComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BlockedAppListsTableOrderingComposer get listId {
    final $$BlockedAppListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableOrderingComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileBlockedListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfileBlockedListsTable> {
  $$ProfileBlockedListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$FocusProfilesTableAnnotationComposer get profileId {
    final $$FocusProfilesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.profileId,
      referencedTable: $db.focusProfiles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusProfilesTableAnnotationComposer(
            $db: $db,
            $table: $db.focusProfiles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BlockedAppListsTableAnnotationComposer get listId {
    final $$BlockedAppListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.blockedAppLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BlockedAppListsTableAnnotationComposer(
            $db: $db,
            $table: $db.blockedAppLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProfileBlockedListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfileBlockedListsTable,
          ProfileBlockedList,
          $$ProfileBlockedListsTableFilterComposer,
          $$ProfileBlockedListsTableOrderingComposer,
          $$ProfileBlockedListsTableAnnotationComposer,
          $$ProfileBlockedListsTableCreateCompanionBuilder,
          $$ProfileBlockedListsTableUpdateCompanionBuilder,
          (ProfileBlockedList, $$ProfileBlockedListsTableReferences),
          ProfileBlockedList,
          PrefetchHooks Function({bool profileId, bool listId})
        > {
  $$ProfileBlockedListsTableTableManager(
    _$AppDatabase db,
    $ProfileBlockedListsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfileBlockedListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfileBlockedListsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$ProfileBlockedListsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> profileId = const Value.absent(),
                Value<int> listId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfileBlockedListsCompanion(
                profileId: profileId,
                listId: listId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int profileId,
                required int listId,
                Value<int> rowid = const Value.absent(),
              }) => ProfileBlockedListsCompanion.insert(
                profileId: profileId,
                listId: listId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProfileBlockedListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({profileId = false, listId = false}) {
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
                    if (profileId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.profileId,
                                referencedTable:
                                    $$ProfileBlockedListsTableReferences
                                        ._profileIdTable(db),
                                referencedColumn:
                                    $$ProfileBlockedListsTableReferences
                                        ._profileIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable:
                                    $$ProfileBlockedListsTableReferences
                                        ._listIdTable(db),
                                referencedColumn:
                                    $$ProfileBlockedListsTableReferences
                                        ._listIdTable(db)
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

typedef $$ProfileBlockedListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfileBlockedListsTable,
      ProfileBlockedList,
      $$ProfileBlockedListsTableFilterComposer,
      $$ProfileBlockedListsTableOrderingComposer,
      $$ProfileBlockedListsTableAnnotationComposer,
      $$ProfileBlockedListsTableCreateCompanionBuilder,
      $$ProfileBlockedListsTableUpdateCompanionBuilder,
      (ProfileBlockedList, $$ProfileBlockedListsTableReferences),
      ProfileBlockedList,
      PrefetchHooks Function({bool profileId, bool listId})
    >;
typedef $$FrictionExitEventsTableCreateCompanionBuilder =
    FrictionExitEventsCompanion Function({
      Value<int> id,
      required int sessionId,
      required DateTime triggeredAt,
      required FrictionStep stepType,
      Value<String?> reflectionText,
      required FrictionOutcome outcome,
    });
typedef $$FrictionExitEventsTableUpdateCompanionBuilder =
    FrictionExitEventsCompanion Function({
      Value<int> id,
      Value<int> sessionId,
      Value<DateTime> triggeredAt,
      Value<FrictionStep> stepType,
      Value<String?> reflectionText,
      Value<FrictionOutcome> outcome,
    });

final class $$FrictionExitEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FrictionExitEventsTable,
          FrictionExitEvent
        > {
  $$FrictionExitEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessions
      .createAlias('friction_exit_events__session_id__focus_sessions__id');

  $$FocusSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<int>('session_id')!;

    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FrictionExitEventsTableFilterComposer
    extends Composer<_$AppDatabase, $FrictionExitEventsTable> {
  $$FrictionExitEventsTableFilterComposer({
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

  ColumnFilters<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FrictionStep, FrictionStep, int>
  get stepType => $composableBuilder(
    column: $table.stepType,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FrictionOutcome, FrictionOutcome, int>
  get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$FocusSessionsTableFilterComposer get sessionId {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FrictionExitEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $FrictionExitEventsTable> {
  $$FrictionExitEventsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepType => $composableBuilder(
    column: $table.stepType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocusSessionsTableOrderingComposer get sessionId {
    final $$FocusSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FrictionExitEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FrictionExitEventsTable> {
  $$FrictionExitEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FrictionStep, int> get stepType =>
      $composableBuilder(column: $table.stepType, builder: (column) => column);

  GeneratedColumn<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<FrictionOutcome, int> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  $$FocusSessionsTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FrictionExitEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FrictionExitEventsTable,
          FrictionExitEvent,
          $$FrictionExitEventsTableFilterComposer,
          $$FrictionExitEventsTableOrderingComposer,
          $$FrictionExitEventsTableAnnotationComposer,
          $$FrictionExitEventsTableCreateCompanionBuilder,
          $$FrictionExitEventsTableUpdateCompanionBuilder,
          (FrictionExitEvent, $$FrictionExitEventsTableReferences),
          FrictionExitEvent,
          PrefetchHooks Function({bool sessionId})
        > {
  $$FrictionExitEventsTableTableManager(
    _$AppDatabase db,
    $FrictionExitEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FrictionExitEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FrictionExitEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FrictionExitEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> sessionId = const Value.absent(),
                Value<DateTime> triggeredAt = const Value.absent(),
                Value<FrictionStep> stepType = const Value.absent(),
                Value<String?> reflectionText = const Value.absent(),
                Value<FrictionOutcome> outcome = const Value.absent(),
              }) => FrictionExitEventsCompanion(
                id: id,
                sessionId: sessionId,
                triggeredAt: triggeredAt,
                stepType: stepType,
                reflectionText: reflectionText,
                outcome: outcome,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int sessionId,
                required DateTime triggeredAt,
                required FrictionStep stepType,
                Value<String?> reflectionText = const Value.absent(),
                required FrictionOutcome outcome,
              }) => FrictionExitEventsCompanion.insert(
                id: id,
                sessionId: sessionId,
                triggeredAt: triggeredAt,
                stepType: stepType,
                reflectionText: reflectionText,
                outcome: outcome,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FrictionExitEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
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
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable:
                                    $$FrictionExitEventsTableReferences
                                        ._sessionIdTable(db),
                                referencedColumn:
                                    $$FrictionExitEventsTableReferences
                                        ._sessionIdTable(db)
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

typedef $$FrictionExitEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FrictionExitEventsTable,
      FrictionExitEvent,
      $$FrictionExitEventsTableFilterComposer,
      $$FrictionExitEventsTableOrderingComposer,
      $$FrictionExitEventsTableAnnotationComposer,
      $$FrictionExitEventsTableCreateCompanionBuilder,
      $$FrictionExitEventsTableUpdateCompanionBuilder,
      (FrictionExitEvent, $$FrictionExitEventsTableReferences),
      FrictionExitEvent,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$AppUsageLimitsTableCreateCompanionBuilder =
    AppUsageLimitsCompanion Function({
      Value<int> id,
      required String packageName,
      required String appLabel,
      required int dailyMinutes,
      required LimitIntensity intensity,
      required DateTime updatedAt,
    });
typedef $$AppUsageLimitsTableUpdateCompanionBuilder =
    AppUsageLimitsCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<String> appLabel,
      Value<int> dailyMinutes,
      Value<LimitIntensity> intensity,
      Value<DateTime> updatedAt,
    });

class $$AppUsageLimitsTableFilterComposer
    extends Composer<_$AppDatabase, $AppUsageLimitsTable> {
  $$AppUsageLimitsTableFilterComposer({
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

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LimitIntensity, LimitIntensity, int>
  get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppUsageLimitsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppUsageLimitsTable> {
  $$AppUsageLimitsTableOrderingComposer({
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

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppUsageLimitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppUsageLimitsTable> {
  $$AppUsageLimitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appLabel =>
      $composableBuilder(column: $table.appLabel, builder: (column) => column);

  GeneratedColumn<int> get dailyMinutes => $composableBuilder(
    column: $table.dailyMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LimitIntensity, int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppUsageLimitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppUsageLimitsTable,
          AppUsageLimit,
          $$AppUsageLimitsTableFilterComposer,
          $$AppUsageLimitsTableOrderingComposer,
          $$AppUsageLimitsTableAnnotationComposer,
          $$AppUsageLimitsTableCreateCompanionBuilder,
          $$AppUsageLimitsTableUpdateCompanionBuilder,
          (
            AppUsageLimit,
            BaseReferences<_$AppDatabase, $AppUsageLimitsTable, AppUsageLimit>,
          ),
          AppUsageLimit,
          PrefetchHooks Function()
        > {
  $$AppUsageLimitsTableTableManager(
    _$AppDatabase db,
    $AppUsageLimitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppUsageLimitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppUsageLimitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppUsageLimitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> appLabel = const Value.absent(),
                Value<int> dailyMinutes = const Value.absent(),
                Value<LimitIntensity> intensity = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AppUsageLimitsCompanion(
                id: id,
                packageName: packageName,
                appLabel: appLabel,
                dailyMinutes: dailyMinutes,
                intensity: intensity,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required String appLabel,
                required int dailyMinutes,
                required LimitIntensity intensity,
                required DateTime updatedAt,
              }) => AppUsageLimitsCompanion.insert(
                id: id,
                packageName: packageName,
                appLabel: appLabel,
                dailyMinutes: dailyMinutes,
                intensity: intensity,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppUsageLimitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppUsageLimitsTable,
      AppUsageLimit,
      $$AppUsageLimitsTableFilterComposer,
      $$AppUsageLimitsTableOrderingComposer,
      $$AppUsageLimitsTableAnnotationComposer,
      $$AppUsageLimitsTableCreateCompanionBuilder,
      $$AppUsageLimitsTableUpdateCompanionBuilder,
      (
        AppUsageLimit,
        BaseReferences<_$AppDatabase, $AppUsageLimitsTable, AppUsageLimit>,
      ),
      AppUsageLimit,
      PrefetchHooks Function()
    >;
typedef $$AnchorEventsTableCreateCompanionBuilder =
    AnchorEventsCompanion Function({
      Value<int> id,
      required int anchorPointId,
      Value<int?> sessionId,
      required DateTime leftAt,
      Value<DateTime?> returnedAt,
      Value<String?> reflectionText,
    });
typedef $$AnchorEventsTableUpdateCompanionBuilder =
    AnchorEventsCompanion Function({
      Value<int> id,
      Value<int> anchorPointId,
      Value<int?> sessionId,
      Value<DateTime> leftAt,
      Value<DateTime?> returnedAt,
      Value<String?> reflectionText,
    });

final class $$AnchorEventsTableReferences
    extends BaseReferences<_$AppDatabase, $AnchorEventsTable, AnchorEvent> {
  $$AnchorEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AnchorPointsTable _anchorPointIdTable(_$AppDatabase db) => db
      .anchorPoints
      .createAlias('anchor_events__anchor_point_id__anchor_points__id');

  $$AnchorPointsTableProcessedTableManager get anchorPointId {
    final $_column = $_itemColumn<int>('anchor_point_id')!;

    final manager = $$AnchorPointsTableTableManager(
      $_db,
      $_db.anchorPoints,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_anchorPointIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FocusSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessions
      .createAlias('anchor_events__session_id__focus_sessions__id');

  $$FocusSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AnchorEventsTableFilterComposer
    extends Composer<_$AppDatabase, $AnchorEventsTable> {
  $$AnchorEventsTableFilterComposer({
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

  ColumnFilters<DateTime> get leftAt => $composableBuilder(
    column: $table.leftAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => ColumnFilters(column),
  );

  $$AnchorPointsTableFilterComposer get anchorPointId {
    final $$AnchorPointsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableFilterComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableFilterComposer get sessionId {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnchorEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnchorEventsTable> {
  $$AnchorEventsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get leftAt => $composableBuilder(
    column: $table.leftAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnchorPointsTableOrderingComposer get anchorPointId {
    final $$AnchorPointsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableOrderingComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableOrderingComposer get sessionId {
    final $$FocusSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnchorEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnchorEventsTable> {
  $$AnchorEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get leftAt =>
      $composableBuilder(column: $table.leftAt, builder: (column) => column);

  GeneratedColumn<DateTime> get returnedAt => $composableBuilder(
    column: $table.returnedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflectionText => $composableBuilder(
    column: $table.reflectionText,
    builder: (column) => column,
  );

  $$AnchorPointsTableAnnotationComposer get anchorPointId {
    final $$AnchorPointsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.anchorPointId,
      referencedTable: $db.anchorPoints,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnchorPointsTableAnnotationComposer(
            $db: $db,
            $table: $db.anchorPoints,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AnchorEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnchorEventsTable,
          AnchorEvent,
          $$AnchorEventsTableFilterComposer,
          $$AnchorEventsTableOrderingComposer,
          $$AnchorEventsTableAnnotationComposer,
          $$AnchorEventsTableCreateCompanionBuilder,
          $$AnchorEventsTableUpdateCompanionBuilder,
          (AnchorEvent, $$AnchorEventsTableReferences),
          AnchorEvent,
          PrefetchHooks Function({bool anchorPointId, bool sessionId})
        > {
  $$AnchorEventsTableTableManager(_$AppDatabase db, $AnchorEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnchorEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnchorEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnchorEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> anchorPointId = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<DateTime> leftAt = const Value.absent(),
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> reflectionText = const Value.absent(),
              }) => AnchorEventsCompanion(
                id: id,
                anchorPointId: anchorPointId,
                sessionId: sessionId,
                leftAt: leftAt,
                returnedAt: returnedAt,
                reflectionText: reflectionText,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int anchorPointId,
                Value<int?> sessionId = const Value.absent(),
                required DateTime leftAt,
                Value<DateTime?> returnedAt = const Value.absent(),
                Value<String?> reflectionText = const Value.absent(),
              }) => AnchorEventsCompanion.insert(
                id: id,
                anchorPointId: anchorPointId,
                sessionId: sessionId,
                leftAt: leftAt,
                returnedAt: returnedAt,
                reflectionText: reflectionText,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnchorEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({anchorPointId = false, sessionId = false}) {
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
                    if (anchorPointId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.anchorPointId,
                                referencedTable: $$AnchorEventsTableReferences
                                    ._anchorPointIdTable(db),
                                referencedColumn: $$AnchorEventsTableReferences
                                    ._anchorPointIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (sessionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.sessionId,
                                referencedTable: $$AnchorEventsTableReferences
                                    ._sessionIdTable(db),
                                referencedColumn: $$AnchorEventsTableReferences
                                    ._sessionIdTable(db)
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

typedef $$AnchorEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnchorEventsTable,
      AnchorEvent,
      $$AnchorEventsTableFilterComposer,
      $$AnchorEventsTableOrderingComposer,
      $$AnchorEventsTableAnnotationComposer,
      $$AnchorEventsTableCreateCompanionBuilder,
      $$AnchorEventsTableUpdateCompanionBuilder,
      (AnchorEvent, $$AnchorEventsTableReferences),
      AnchorEvent,
      PrefetchHooks Function({bool anchorPointId, bool sessionId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnchorPointsTableTableManager get anchorPoints =>
      $$AnchorPointsTableTableManager(_db, _db.anchorPoints);
  $$SmartDevicesTableTableManager get smartDevices =>
      $$SmartDevicesTableTableManager(_db, _db.smartDevices);
  $$FocusProfilesTableTableManager get focusProfiles =>
      $$FocusProfilesTableTableManager(_db, _db.focusProfiles);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$BlockedAppListsTableTableManager get blockedAppLists =>
      $$BlockedAppListsTableTableManager(_db, _db.blockedAppLists);
  $$BlockedAppsTableTableManager get blockedApps =>
      $$BlockedAppsTableTableManager(_db, _db.blockedApps);
  $$ProfileBlockedListsTableTableManager get profileBlockedLists =>
      $$ProfileBlockedListsTableTableManager(_db, _db.profileBlockedLists);
  $$FrictionExitEventsTableTableManager get frictionExitEvents =>
      $$FrictionExitEventsTableTableManager(_db, _db.frictionExitEvents);
  $$AppUsageLimitsTableTableManager get appUsageLimits =>
      $$AppUsageLimitsTableTableManager(_db, _db.appUsageLimits);
  $$AnchorEventsTableTableManager get anchorEvents =>
      $$AnchorEventsTableTableManager(_db, _db.anchorEvents);
}
