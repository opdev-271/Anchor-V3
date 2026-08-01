// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
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
  final DateTime createdAt;
  final DateTime updatedAt;
  const FocusProfile({
    required this.id,
    this.remoteId,
    required this.name,
    required this.durationMinutes,
    required this.goalText,
    required this.strictness,
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
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FocusProfile(
    id: id ?? this.id,
    remoteId: remoteId.present ? remoteId.value : this.remoteId,
    name: name ?? this.name,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    goalText: goalText ?? this.goalText,
    strictness: strictness ?? this.strictness,
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
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const FocusProfilesCompanion({
    this.id = const Value.absent(),
    this.remoteId = const Value.absent(),
    this.name = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.goalText = const Value.absent(),
    this.strictness = const Value.absent(),
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FocusProfilesTable focusProfiles = $FocusProfilesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $BlockedAppListsTable blockedAppLists = $BlockedAppListsTable(
    this,
  );
  late final $BlockedAppsTable blockedApps = $BlockedAppsTable(this);
  late final $ProfileBlockedListsTable profileBlockedLists =
      $ProfileBlockedListsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    focusProfiles,
    focusSessions,
    blockedAppLists,
    blockedApps,
    profileBlockedLists,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
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
  ]);
}

typedef $$FocusProfilesTableCreateCompanionBuilder =
    FocusProfilesCompanion Function({
      Value<int> id,
      Value<String?> remoteId,
      required String name,
      required int durationMinutes,
      Value<String> goalText,
      required StrictnessLevel strictness,
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
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => FocusProfilesCompanion(
                id: id,
                remoteId: remoteId,
                name: name,
                durationMinutes: durationMinutes,
                goalText: goalText,
                strictness: strictness,
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
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => FocusProfilesCompanion.insert(
                id: id,
                remoteId: remoteId,
                name: name,
                durationMinutes: durationMinutes,
                goalText: goalText,
                strictness: strictness,
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
              ({focusSessionsRefs = false, profileBlockedListsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusSessionsRefs) db.focusSessions,
                    if (profileBlockedListsRefs) db.profileBlockedLists,
                  ],
                  addJoins: null,
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
          PrefetchHooks Function({bool profileId})
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
          prefetchHooksCallback: ({profileId = false}) {
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
                                referencedTable: $$FocusSessionsTableReferences
                                    ._profileIdTable(db),
                                referencedColumn: $$FocusSessionsTableReferences
                                    ._profileIdTable(db)
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
      PrefetchHooks Function({bool profileId})
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
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
}
