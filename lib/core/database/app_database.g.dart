// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
mixin _$WorldsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorldsTable get worlds => attachedDatabase.worlds;
}

class $UserProfileTable extends UserProfile
    with TableInfo<$UserProfileTable, UserProfileEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pictureUrlMeta = const VerificationMeta(
    'pictureUrl',
  );
  @override
  late final GeneratedColumn<String> pictureUrl = GeneratedColumn<String>(
    'picture_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _planMeta = const VerificationMeta('plan');
  @override
  late final GeneratedColumn<String> plan = GeneratedColumn<String>(
    'plan',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _planExpiresAtMeta = const VerificationMeta(
    'planExpiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> planExpiresAt =
      GeneratedColumn<DateTime>(
        'plan_expires_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _autoRenewMeta = const VerificationMeta(
    'autoRenew',
  );
  @override
  late final GeneratedColumn<bool> autoRenew = GeneratedColumn<bool>(
    'auto_renew',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_renew" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    serverId,
    firstName,
    email,
    pictureUrl,
    lang,
    plan,
    planExpiresAt,
    autoRenew,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    } else if (isInserting) {
      context.missing(_serverIdMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('picture_url')) {
      context.handle(
        _pictureUrlMeta,
        pictureUrl.isAcceptableOrUnknown(data['picture_url']!, _pictureUrlMeta),
      );
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('plan')) {
      context.handle(
        _planMeta,
        plan.isAcceptableOrUnknown(data['plan']!, _planMeta),
      );
    }
    if (data.containsKey('plan_expires_at')) {
      context.handle(
        _planExpiresAtMeta,
        planExpiresAt.isAcceptableOrUnknown(
          data['plan_expires_at']!,
          _planExpiresAtMeta,
        ),
      );
    }
    if (data.containsKey('auto_renew')) {
      context.handle(
        _autoRenewMeta,
        autoRenew.isAcceptableOrUnknown(data['auto_renew']!, _autoRenewMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      pictureUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}picture_url'],
      ),
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      plan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan'],
      ),
      planExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}plan_expires_at'],
      ),
      autoRenew: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_renew'],
      ),
    );
  }

  @override
  $UserProfileTable createAlias(String alias) {
    return $UserProfileTable(attachedDatabase, alias);
  }
}

class UserProfileEntity extends DataClass
    implements Insertable<UserProfileEntity> {
  final int id;
  final String serverId;
  final String firstName;
  final String email;
  final String? pictureUrl;
  final String lang;
  final String? plan;
  final DateTime? planExpiresAt;
  final bool? autoRenew;
  const UserProfileEntity({
    required this.id,
    required this.serverId,
    required this.firstName,
    required this.email,
    this.pictureUrl,
    required this.lang,
    this.plan,
    this.planExpiresAt,
    this.autoRenew,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['server_id'] = Variable<String>(serverId);
    map['first_name'] = Variable<String>(firstName);
    map['email'] = Variable<String>(email);
    if (!nullToAbsent || pictureUrl != null) {
      map['picture_url'] = Variable<String>(pictureUrl);
    }
    map['lang'] = Variable<String>(lang);
    if (!nullToAbsent || plan != null) {
      map['plan'] = Variable<String>(plan);
    }
    if (!nullToAbsent || planExpiresAt != null) {
      map['plan_expires_at'] = Variable<DateTime>(planExpiresAt);
    }
    if (!nullToAbsent || autoRenew != null) {
      map['auto_renew'] = Variable<bool>(autoRenew);
    }
    return map;
  }

  UserProfileCompanion toCompanion(bool nullToAbsent) {
    return UserProfileCompanion(
      id: Value(id),
      serverId: Value(serverId),
      firstName: Value(firstName),
      email: Value(email),
      pictureUrl: pictureUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(pictureUrl),
      lang: Value(lang),
      plan: plan == null && nullToAbsent ? const Value.absent() : Value(plan),
      planExpiresAt: planExpiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(planExpiresAt),
      autoRenew: autoRenew == null && nullToAbsent
          ? const Value.absent()
          : Value(autoRenew),
    );
  }

  factory UserProfileEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntity(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String>(json['serverId']),
      firstName: serializer.fromJson<String>(json['firstName']),
      email: serializer.fromJson<String>(json['email']),
      pictureUrl: serializer.fromJson<String?>(json['pictureUrl']),
      lang: serializer.fromJson<String>(json['lang']),
      plan: serializer.fromJson<String?>(json['plan']),
      planExpiresAt: serializer.fromJson<DateTime?>(json['planExpiresAt']),
      autoRenew: serializer.fromJson<bool?>(json['autoRenew']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String>(serverId),
      'firstName': serializer.toJson<String>(firstName),
      'email': serializer.toJson<String>(email),
      'pictureUrl': serializer.toJson<String?>(pictureUrl),
      'lang': serializer.toJson<String>(lang),
      'plan': serializer.toJson<String?>(plan),
      'planExpiresAt': serializer.toJson<DateTime?>(planExpiresAt),
      'autoRenew': serializer.toJson<bool?>(autoRenew),
    };
  }

  UserProfileEntity copyWith({
    int? id,
    String? serverId,
    String? firstName,
    String? email,
    Value<String?> pictureUrl = const Value.absent(),
    String? lang,
    Value<String?> plan = const Value.absent(),
    Value<DateTime?> planExpiresAt = const Value.absent(),
    Value<bool?> autoRenew = const Value.absent(),
  }) => UserProfileEntity(
    id: id ?? this.id,
    serverId: serverId ?? this.serverId,
    firstName: firstName ?? this.firstName,
    email: email ?? this.email,
    pictureUrl: pictureUrl.present ? pictureUrl.value : this.pictureUrl,
    lang: lang ?? this.lang,
    plan: plan.present ? plan.value : this.plan,
    planExpiresAt: planExpiresAt.present
        ? planExpiresAt.value
        : this.planExpiresAt,
    autoRenew: autoRenew.present ? autoRenew.value : this.autoRenew,
  );
  UserProfileEntity copyWithCompanion(UserProfileCompanion data) {
    return UserProfileEntity(
      id: data.id.present ? data.id.value : this.id,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      email: data.email.present ? data.email.value : this.email,
      pictureUrl: data.pictureUrl.present
          ? data.pictureUrl.value
          : this.pictureUrl,
      lang: data.lang.present ? data.lang.value : this.lang,
      plan: data.plan.present ? data.plan.value : this.plan,
      planExpiresAt: data.planExpiresAt.present
          ? data.planExpiresAt.value
          : this.planExpiresAt,
      autoRenew: data.autoRenew.present ? data.autoRenew.value : this.autoRenew,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntity(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('firstName: $firstName, ')
          ..write('email: $email, ')
          ..write('pictureUrl: $pictureUrl, ')
          ..write('lang: $lang, ')
          ..write('plan: $plan, ')
          ..write('planExpiresAt: $planExpiresAt, ')
          ..write('autoRenew: $autoRenew')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    serverId,
    firstName,
    email,
    pictureUrl,
    lang,
    plan,
    planExpiresAt,
    autoRenew,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntity &&
          other.id == this.id &&
          other.serverId == this.serverId &&
          other.firstName == this.firstName &&
          other.email == this.email &&
          other.pictureUrl == this.pictureUrl &&
          other.lang == this.lang &&
          other.plan == this.plan &&
          other.planExpiresAt == this.planExpiresAt &&
          other.autoRenew == this.autoRenew);
}

class UserProfileCompanion extends UpdateCompanion<UserProfileEntity> {
  final Value<int> id;
  final Value<String> serverId;
  final Value<String> firstName;
  final Value<String> email;
  final Value<String?> pictureUrl;
  final Value<String> lang;
  final Value<String?> plan;
  final Value<DateTime?> planExpiresAt;
  final Value<bool?> autoRenew;
  const UserProfileCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.firstName = const Value.absent(),
    this.email = const Value.absent(),
    this.pictureUrl = const Value.absent(),
    this.lang = const Value.absent(),
    this.plan = const Value.absent(),
    this.planExpiresAt = const Value.absent(),
    this.autoRenew = const Value.absent(),
  });
  UserProfileCompanion.insert({
    this.id = const Value.absent(),
    required String serverId,
    required String firstName,
    required String email,
    this.pictureUrl = const Value.absent(),
    required String lang,
    this.plan = const Value.absent(),
    this.planExpiresAt = const Value.absent(),
    this.autoRenew = const Value.absent(),
  }) : serverId = Value(serverId),
       firstName = Value(firstName),
       email = Value(email),
       lang = Value(lang);
  static Insertable<UserProfileEntity> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? firstName,
    Expression<String>? email,
    Expression<String>? pictureUrl,
    Expression<String>? lang,
    Expression<String>? plan,
    Expression<DateTime>? planExpiresAt,
    Expression<bool>? autoRenew,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (firstName != null) 'first_name': firstName,
      if (email != null) 'email': email,
      if (pictureUrl != null) 'picture_url': pictureUrl,
      if (lang != null) 'lang': lang,
      if (plan != null) 'plan': plan,
      if (planExpiresAt != null) 'plan_expires_at': planExpiresAt,
      if (autoRenew != null) 'auto_renew': autoRenew,
    });
  }

  UserProfileCompanion copyWith({
    Value<int>? id,
    Value<String>? serverId,
    Value<String>? firstName,
    Value<String>? email,
    Value<String?>? pictureUrl,
    Value<String>? lang,
    Value<String?>? plan,
    Value<DateTime?>? planExpiresAt,
    Value<bool?>? autoRenew,
  }) {
    return UserProfileCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      firstName: firstName ?? this.firstName,
      email: email ?? this.email,
      pictureUrl: pictureUrl ?? this.pictureUrl,
      lang: lang ?? this.lang,
      plan: plan ?? this.plan,
      planExpiresAt: planExpiresAt ?? this.planExpiresAt,
      autoRenew: autoRenew ?? this.autoRenew,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (pictureUrl.present) {
      map['picture_url'] = Variable<String>(pictureUrl.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (plan.present) {
      map['plan'] = Variable<String>(plan.value);
    }
    if (planExpiresAt.present) {
      map['plan_expires_at'] = Variable<DateTime>(planExpiresAt.value);
    }
    if (autoRenew.present) {
      map['auto_renew'] = Variable<bool>(autoRenew.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('firstName: $firstName, ')
          ..write('email: $email, ')
          ..write('pictureUrl: $pictureUrl, ')
          ..write('lang: $lang, ')
          ..write('plan: $plan, ')
          ..write('planExpiresAt: $planExpiresAt, ')
          ..write('autoRenew: $autoRenew')
          ..write(')'))
        .toString();
  }
}

class $WorldsTable extends Worlds with TableInfo<$WorldsTable, WorldEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorldsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _localIdMeta = const VerificationMeta(
    'localId',
  );
  @override
  late final GeneratedColumn<String> localId = GeneratedColumn<String>(
    'local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => const Uuid().v4(),
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SyncStatus, String> syncStatus =
      GeneratedColumn<String>(
        'sync_status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        clientDefault: () => 'created',
      ).withConverter<SyncStatus>($WorldsTable.$convertersyncStatus);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modulesMeta = const VerificationMeta(
    'modules',
  );
  @override
  late final GeneratedColumn<String> modules = GeneratedColumn<String>(
    'modules',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverImageMeta = const VerificationMeta(
    'coverImage',
  );
  @override
  late final GeneratedColumn<String> coverImage = GeneratedColumn<String>(
    'cover_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customImageMeta = const VerificationMeta(
    'customImage',
  );
  @override
  late final GeneratedColumn<String> customImage = GeneratedColumn<String>(
    'custom_image',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    syncStatus,
    name,
    description,
    modules,
    coverImage,
    customImage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worlds';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorldEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('local_id')) {
      context.handle(
        _localIdMeta,
        localId.isAcceptableOrUnknown(data['local_id']!, _localIdMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('modules')) {
      context.handle(
        _modulesMeta,
        modules.isAcceptableOrUnknown(data['modules']!, _modulesMeta),
      );
    }
    if (data.containsKey('cover_image')) {
      context.handle(
        _coverImageMeta,
        coverImage.isAcceptableOrUnknown(data['cover_image']!, _coverImageMeta),
      );
    }
    if (data.containsKey('custom_image')) {
      context.handle(
        _customImageMeta,
        customImage.isAcceptableOrUnknown(
          data['custom_image']!,
          _customImageMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  WorldEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorldEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      syncStatus: $WorldsTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      modules: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}modules'],
      ),
      coverImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image'],
      ),
      customImage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_image'],
      ),
    );
  }

  @override
  $WorldsTable createAlias(String alias) {
    return $WorldsTable(attachedDatabase, alias);
  }

  static TypeConverter<SyncStatus, String> $convertersyncStatus =
      const SyncStatusConverter();
}

class WorldEntity extends DataClass implements Insertable<WorldEntity> {
  final String localId;
  final String? serverId;
  final SyncStatus syncStatus;
  final String name;
  final String description;
  final String? modules;
  final String? coverImage;
  final String? customImage;
  const WorldEntity({
    required this.localId,
    this.serverId,
    required this.syncStatus,
    required this.name,
    required this.description,
    this.modules,
    this.coverImage,
    this.customImage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String>(serverId);
    }
    {
      map['sync_status'] = Variable<String>(
        $WorldsTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || modules != null) {
      map['modules'] = Variable<String>(modules);
    }
    if (!nullToAbsent || coverImage != null) {
      map['cover_image'] = Variable<String>(coverImage);
    }
    if (!nullToAbsent || customImage != null) {
      map['custom_image'] = Variable<String>(customImage);
    }
    return map;
  }

  WorldsCompanion toCompanion(bool nullToAbsent) {
    return WorldsCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      syncStatus: Value(syncStatus),
      name: Value(name),
      description: Value(description),
      modules: modules == null && nullToAbsent
          ? const Value.absent()
          : Value(modules),
      coverImage: coverImage == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImage),
      customImage: customImage == null && nullToAbsent
          ? const Value.absent()
          : Value(customImage),
    );
  }

  factory WorldEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorldEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      syncStatus: serializer.fromJson<SyncStatus>(json['syncStatus']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      modules: serializer.fromJson<String?>(json['modules']),
      coverImage: serializer.fromJson<String?>(json['coverImage']),
      customImage: serializer.fromJson<String?>(json['customImage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'syncStatus': serializer.toJson<SyncStatus>(syncStatus),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'modules': serializer.toJson<String?>(modules),
      'coverImage': serializer.toJson<String?>(coverImage),
      'customImage': serializer.toJson<String?>(customImage),
    };
  }

  WorldEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    SyncStatus? syncStatus,
    String? name,
    String? description,
    Value<String?> modules = const Value.absent(),
    Value<String?> coverImage = const Value.absent(),
    Value<String?> customImage = const Value.absent(),
  }) => WorldEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    syncStatus: syncStatus ?? this.syncStatus,
    name: name ?? this.name,
    description: description ?? this.description,
    modules: modules.present ? modules.value : this.modules,
    coverImage: coverImage.present ? coverImage.value : this.coverImage,
    customImage: customImage.present ? customImage.value : this.customImage,
  );
  WorldEntity copyWithCompanion(WorldsCompanion data) {
    return WorldEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      modules: data.modules.present ? data.modules.value : this.modules,
      coverImage: data.coverImage.present
          ? data.coverImage.value
          : this.coverImage,
      customImage: data.customImage.present
          ? data.customImage.value
          : this.customImage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorldEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('modules: $modules, ')
          ..write('coverImage: $coverImage, ')
          ..write('customImage: $customImage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    localId,
    serverId,
    syncStatus,
    name,
    description,
    modules,
    coverImage,
    customImage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorldEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.syncStatus == this.syncStatus &&
          other.name == this.name &&
          other.description == this.description &&
          other.modules == this.modules &&
          other.coverImage == this.coverImage &&
          other.customImage == this.customImage);
}

class WorldsCompanion extends UpdateCompanion<WorldEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<SyncStatus> syncStatus;
  final Value<String> name;
  final Value<String> description;
  final Value<String?> modules;
  final Value<String?> coverImage;
  final Value<String?> customImage;
  final Value<int> rowid;
  const WorldsCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.modules = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.customImage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorldsCompanion.insert({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String name,
    required String description,
    this.modules = const Value.absent(),
    this.coverImage = const Value.absent(),
    this.customImage = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       description = Value(description);
  static Insertable<WorldEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? syncStatus,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? modules,
    Expression<String>? coverImage,
    Expression<String>? customImage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (modules != null) 'modules': modules,
      if (coverImage != null) 'cover_image': coverImage,
      if (customImage != null) 'custom_image': customImage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorldsCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<SyncStatus>? syncStatus,
    Value<String>? name,
    Value<String>? description,
    Value<String?>? modules,
    Value<String?>? coverImage,
    Value<String?>? customImage,
    Value<int>? rowid,
  }) {
    return WorldsCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      syncStatus: syncStatus ?? this.syncStatus,
      name: name ?? this.name,
      description: description ?? this.description,
      modules: modules ?? this.modules,
      coverImage: coverImage ?? this.coverImage,
      customImage: customImage ?? this.customImage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String>(serverId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(
        $WorldsTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (modules.present) {
      map['modules'] = Variable<String>(modules.value);
    }
    if (coverImage.present) {
      map['cover_image'] = Variable<String>(coverImage.value);
    }
    if (customImage.present) {
      map['custom_image'] = Variable<String>(customImage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorldsCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('modules: $modules, ')
          ..write('coverImage: $coverImage, ')
          ..write('customImage: $customImage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfileTable userProfile = $UserProfileTable(this);
  late final $WorldsTable worlds = $WorldsTable(this);
  late final WorldsDao worldsDao = WorldsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [userProfile, worlds];
}

typedef $$UserProfileTableCreateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      required String serverId,
      required String firstName,
      required String email,
      Value<String?> pictureUrl,
      required String lang,
      Value<String?> plan,
      Value<DateTime?> planExpiresAt,
      Value<bool?> autoRenew,
    });
typedef $$UserProfileTableUpdateCompanionBuilder =
    UserProfileCompanion Function({
      Value<int> id,
      Value<String> serverId,
      Value<String> firstName,
      Value<String> email,
      Value<String?> pictureUrl,
      Value<String> lang,
      Value<String?> plan,
      Value<DateTime?> planExpiresAt,
      Value<bool?> autoRenew,
    });

class $$UserProfileTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableFilterComposer({
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

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pictureUrl => $composableBuilder(
    column: $table.pictureUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get planExpiresAt => $composableBuilder(
    column: $table.planExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableOrderingComposer({
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

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pictureUrl => $composableBuilder(
    column: $table.pictureUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plan => $composableBuilder(
    column: $table.plan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get planExpiresAt => $composableBuilder(
    column: $table.planExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoRenew => $composableBuilder(
    column: $table.autoRenew,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTable> {
  $$UserProfileTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get pictureUrl => $composableBuilder(
    column: $table.pictureUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get plan =>
      $composableBuilder(column: $table.plan, builder: (column) => column);

  GeneratedColumn<DateTime> get planExpiresAt => $composableBuilder(
    column: $table.planExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoRenew =>
      $composableBuilder(column: $table.autoRenew, builder: (column) => column);
}

class $$UserProfileTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTable,
          UserProfileEntity,
          $$UserProfileTableFilterComposer,
          $$UserProfileTableOrderingComposer,
          $$UserProfileTableAnnotationComposer,
          $$UserProfileTableCreateCompanionBuilder,
          $$UserProfileTableUpdateCompanionBuilder,
          (
            UserProfileEntity,
            BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileEntity>,
          ),
          UserProfileEntity,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableManager(_$AppDatabase db, $UserProfileTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> serverId = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String?> pictureUrl = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String?> plan = const Value.absent(),
                Value<DateTime?> planExpiresAt = const Value.absent(),
                Value<bool?> autoRenew = const Value.absent(),
              }) => UserProfileCompanion(
                id: id,
                serverId: serverId,
                firstName: firstName,
                email: email,
                pictureUrl: pictureUrl,
                lang: lang,
                plan: plan,
                planExpiresAt: planExpiresAt,
                autoRenew: autoRenew,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String serverId,
                required String firstName,
                required String email,
                Value<String?> pictureUrl = const Value.absent(),
                required String lang,
                Value<String?> plan = const Value.absent(),
                Value<DateTime?> planExpiresAt = const Value.absent(),
                Value<bool?> autoRenew = const Value.absent(),
              }) => UserProfileCompanion.insert(
                id: id,
                serverId: serverId,
                firstName: firstName,
                email: email,
                pictureUrl: pictureUrl,
                lang: lang,
                plan: plan,
                planExpiresAt: planExpiresAt,
                autoRenew: autoRenew,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTable,
      UserProfileEntity,
      $$UserProfileTableFilterComposer,
      $$UserProfileTableOrderingComposer,
      $$UserProfileTableAnnotationComposer,
      $$UserProfileTableCreateCompanionBuilder,
      $$UserProfileTableUpdateCompanionBuilder,
      (
        UserProfileEntity,
        BaseReferences<_$AppDatabase, $UserProfileTable, UserProfileEntity>,
      ),
      UserProfileEntity,
      PrefetchHooks Function()
    >;
typedef $$WorldsTableCreateCompanionBuilder =
    WorldsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<SyncStatus> syncStatus,
      required String name,
      required String description,
      Value<String?> modules,
      Value<String?> coverImage,
      Value<String?> customImage,
      Value<int> rowid,
    });
typedef $$WorldsTableUpdateCompanionBuilder =
    WorldsCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<SyncStatus> syncStatus,
      Value<String> name,
      Value<String> description,
      Value<String?> modules,
      Value<String?> coverImage,
      Value<String?> customImage,
      Value<int> rowid,
    });

class $$WorldsTableFilterComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SyncStatus, SyncStatus, String>
  get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modules => $composableBuilder(
    column: $table.modules,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customImage => $composableBuilder(
    column: $table.customImage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorldsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get localId => $composableBuilder(
    column: $table.localId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modules => $composableBuilder(
    column: $table.modules,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customImage => $composableBuilder(
    column: $table.customImage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorldsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorldsTable> {
  $$WorldsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumnWithTypeConverter<SyncStatus, String> get syncStatus =>
      $composableBuilder(
        column: $table.syncStatus,
        builder: (column) => column,
      );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get modules =>
      $composableBuilder(column: $table.modules, builder: (column) => column);

  GeneratedColumn<String> get coverImage => $composableBuilder(
    column: $table.coverImage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customImage => $composableBuilder(
    column: $table.customImage,
    builder: (column) => column,
  );
}

class $$WorldsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorldsTable,
          WorldEntity,
          $$WorldsTableFilterComposer,
          $$WorldsTableOrderingComposer,
          $$WorldsTableAnnotationComposer,
          $$WorldsTableCreateCompanionBuilder,
          $$WorldsTableUpdateCompanionBuilder,
          (
            WorldEntity,
            BaseReferences<_$AppDatabase, $WorldsTable, WorldEntity>,
          ),
          WorldEntity,
          PrefetchHooks Function()
        > {
  $$WorldsTableTableManager(_$AppDatabase db, $WorldsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorldsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorldsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorldsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> modules = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<String?> customImage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion(
                localId: localId,
                serverId: serverId,
                syncStatus: syncStatus,
                name: name,
                description: description,
                modules: modules,
                coverImage: coverImage,
                customImage: customImage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String name,
                required String description,
                Value<String?> modules = const Value.absent(),
                Value<String?> coverImage = const Value.absent(),
                Value<String?> customImage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorldsCompanion.insert(
                localId: localId,
                serverId: serverId,
                syncStatus: syncStatus,
                name: name,
                description: description,
                modules: modules,
                coverImage: coverImage,
                customImage: customImage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorldsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorldsTable,
      WorldEntity,
      $$WorldsTableFilterComposer,
      $$WorldsTableOrderingComposer,
      $$WorldsTableAnnotationComposer,
      $$WorldsTableCreateCompanionBuilder,
      $$WorldsTableUpdateCompanionBuilder,
      (WorldEntity, BaseReferences<_$AppDatabase, $WorldsTable, WorldEntity>),
      WorldEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$WorldsTableTableManager get worlds =>
      $$WorldsTableTableManager(_db, _db.worlds);
}
