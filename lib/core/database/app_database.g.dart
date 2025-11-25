// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
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
    clientDefault: () => Uuid().v4(),
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

class $CharactersTable extends Characters
    with TableInfo<$CharactersTable, CharacterEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CharactersTable(this.attachedDatabase, [this._alias]);
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
    clientDefault: () => Uuid().v4(),
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
      ).withConverter<SyncStatus>($CharactersTable.$convertersyncStatus);
  static const VerificationMeta _worldLocalIdMeta = const VerificationMeta(
    'worldLocalId',
  );
  @override
  late final GeneratedColumn<String> worldLocalId = GeneratedColumn<String>(
    'world_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (local_id)',
    ),
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
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nicknameMeta = const VerificationMeta(
    'nickname',
  );
  @override
  late final GeneratedColumn<String> nickname = GeneratedColumn<String>(
    'nickname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customNotesMeta = const VerificationMeta(
    'customNotes',
  );
  @override
  late final GeneratedColumn<String> customNotes = GeneratedColumn<String>(
    'custom_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagColorMeta = const VerificationMeta(
    'tagColor',
  );
  @override
  late final GeneratedColumn<String> tagColor = GeneratedColumn<String>(
    'tag_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('neutral'),
  );
  static const VerificationMeta _appearanceJsonMeta = const VerificationMeta(
    'appearanceJson',
  );
  @override
  late final GeneratedColumn<String> appearanceJson = GeneratedColumn<String>(
    'appearance_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personalityJsonMeta = const VerificationMeta(
    'personalityJson',
  );
  @override
  late final GeneratedColumn<String> personalityJson = GeneratedColumn<String>(
    'personality_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _historyJsonMeta = const VerificationMeta(
    'historyJson',
  );
  @override
  late final GeneratedColumn<String> historyJson = GeneratedColumn<String>(
    'history_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _familyJsonMeta = const VerificationMeta(
    'familyJson',
  );
  @override
  late final GeneratedColumn<String> familyJson = GeneratedColumn<String>(
    'family_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _friendsJsonMeta = const VerificationMeta(
    'friendsJson',
  );
  @override
  late final GeneratedColumn<String> friendsJson = GeneratedColumn<String>(
    'friends_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _enemiesJsonMeta = const VerificationMeta(
    'enemiesJson',
  );
  @override
  late final GeneratedColumn<String> enemiesJson = GeneratedColumn<String>(
    'enemies_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _romanceJsonMeta = const VerificationMeta(
    'romanceJson',
  );
  @override
  late final GeneratedColumn<String> romanceJson = GeneratedColumn<String>(
    'romance_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> images =
      GeneratedColumn<String>(
        'images',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterimages);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawFamily =
      GeneratedColumn<String>(
        'raw_family',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawFamily);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawFriends =
      GeneratedColumn<String>(
        'raw_friends',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawFriends);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawEnemies =
      GeneratedColumn<String>(
        'raw_enemies',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawEnemies);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawRomance =
      GeneratedColumn<String>(
        'raw_romance',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawRomance);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawAbilities = GeneratedColumn<String>(
    'raw_abilities',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawAbilities);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawItems =
      GeneratedColumn<String>(
        'raw_items',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawItems);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawLanguages = GeneratedColumn<String>(
    'raw_languages',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawLanguages);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawRaces =
      GeneratedColumn<String>(
        'raw_races',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawRaces);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawFactions = GeneratedColumn<String>(
    'raw_factions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawFactions);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawLocations = GeneratedColumn<String>(
    'raw_locations',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawLocations);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawPowerSystems = GeneratedColumn<String>(
    'raw_power_systems',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawPowerSystems);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawReligions = GeneratedColumn<String>(
    'raw_religions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawReligions);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawCreatures = GeneratedColumn<String>(
    'raw_creatures',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawCreatures);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawEconomies = GeneratedColumn<String>(
    'raw_economies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawEconomies);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> rawStories =
      GeneratedColumn<String>(
        'raw_stories',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<String>>($CharactersTable.$converterrawStories);
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  rawTechnologies = GeneratedColumn<String>(
    'raw_technologies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($CharactersTable.$converterrawTechnologies);
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    serverId,
    syncStatus,
    worldLocalId,
    name,
    age,
    gender,
    nickname,
    customNotes,
    tagColor,
    appearanceJson,
    personalityJson,
    historyJson,
    familyJson,
    friendsJson,
    enemiesJson,
    romanceJson,
    images,
    rawFamily,
    rawFriends,
    rawEnemies,
    rawRomance,
    rawAbilities,
    rawItems,
    rawLanguages,
    rawRaces,
    rawFactions,
    rawLocations,
    rawPowerSystems,
    rawReligions,
    rawCreatures,
    rawEconomies,
    rawStories,
    rawTechnologies,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'characters';
  @override
  VerificationContext validateIntegrity(
    Insertable<CharacterEntity> instance, {
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
    if (data.containsKey('world_local_id')) {
      context.handle(
        _worldLocalIdMeta,
        worldLocalId.isAcceptableOrUnknown(
          data['world_local_id']!,
          _worldLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldLocalIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('nickname')) {
      context.handle(
        _nicknameMeta,
        nickname.isAcceptableOrUnknown(data['nickname']!, _nicknameMeta),
      );
    }
    if (data.containsKey('custom_notes')) {
      context.handle(
        _customNotesMeta,
        customNotes.isAcceptableOrUnknown(
          data['custom_notes']!,
          _customNotesMeta,
        ),
      );
    }
    if (data.containsKey('tag_color')) {
      context.handle(
        _tagColorMeta,
        tagColor.isAcceptableOrUnknown(data['tag_color']!, _tagColorMeta),
      );
    }
    if (data.containsKey('appearance_json')) {
      context.handle(
        _appearanceJsonMeta,
        appearanceJson.isAcceptableOrUnknown(
          data['appearance_json']!,
          _appearanceJsonMeta,
        ),
      );
    }
    if (data.containsKey('personality_json')) {
      context.handle(
        _personalityJsonMeta,
        personalityJson.isAcceptableOrUnknown(
          data['personality_json']!,
          _personalityJsonMeta,
        ),
      );
    }
    if (data.containsKey('history_json')) {
      context.handle(
        _historyJsonMeta,
        historyJson.isAcceptableOrUnknown(
          data['history_json']!,
          _historyJsonMeta,
        ),
      );
    }
    if (data.containsKey('family_json')) {
      context.handle(
        _familyJsonMeta,
        familyJson.isAcceptableOrUnknown(data['family_json']!, _familyJsonMeta),
      );
    }
    if (data.containsKey('friends_json')) {
      context.handle(
        _friendsJsonMeta,
        friendsJson.isAcceptableOrUnknown(
          data['friends_json']!,
          _friendsJsonMeta,
        ),
      );
    }
    if (data.containsKey('enemies_json')) {
      context.handle(
        _enemiesJsonMeta,
        enemiesJson.isAcceptableOrUnknown(
          data['enemies_json']!,
          _enemiesJsonMeta,
        ),
      );
    }
    if (data.containsKey('romance_json')) {
      context.handle(
        _romanceJsonMeta,
        romanceJson.isAcceptableOrUnknown(
          data['romance_json']!,
          _romanceJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  CharacterEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CharacterEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_id'],
      ),
      syncStatus: $CharactersTable.$convertersyncStatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}sync_status'],
        )!,
      ),
      worldLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_local_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      nickname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nickname'],
      ),
      customNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_notes'],
      ),
      tagColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_color'],
      )!,
      appearanceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}appearance_json'],
      ),
      personalityJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personality_json'],
      ),
      historyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}history_json'],
      ),
      familyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}family_json'],
      ),
      friendsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}friends_json'],
      ),
      enemiesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enemies_json'],
      ),
      romanceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}romance_json'],
      ),
      images: $CharactersTable.$converterimages.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}images'],
        )!,
      ),
      rawFamily: $CharactersTable.$converterrawFamily.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_family'],
        )!,
      ),
      rawFriends: $CharactersTable.$converterrawFriends.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_friends'],
        )!,
      ),
      rawEnemies: $CharactersTable.$converterrawEnemies.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_enemies'],
        )!,
      ),
      rawRomance: $CharactersTable.$converterrawRomance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_romance'],
        )!,
      ),
      rawAbilities: $CharactersTable.$converterrawAbilities.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_abilities'],
        )!,
      ),
      rawItems: $CharactersTable.$converterrawItems.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_items'],
        )!,
      ),
      rawLanguages: $CharactersTable.$converterrawLanguages.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_languages'],
        )!,
      ),
      rawRaces: $CharactersTable.$converterrawRaces.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_races'],
        )!,
      ),
      rawFactions: $CharactersTable.$converterrawFactions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_factions'],
        )!,
      ),
      rawLocations: $CharactersTable.$converterrawLocations.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_locations'],
        )!,
      ),
      rawPowerSystems: $CharactersTable.$converterrawPowerSystems.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_power_systems'],
        )!,
      ),
      rawReligions: $CharactersTable.$converterrawReligions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_religions'],
        )!,
      ),
      rawCreatures: $CharactersTable.$converterrawCreatures.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_creatures'],
        )!,
      ),
      rawEconomies: $CharactersTable.$converterrawEconomies.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_economies'],
        )!,
      ),
      rawStories: $CharactersTable.$converterrawStories.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_stories'],
        )!,
      ),
      rawTechnologies: $CharactersTable.$converterrawTechnologies.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}raw_technologies'],
        )!,
      ),
    );
  }

  @override
  $CharactersTable createAlias(String alias) {
    return $CharactersTable(attachedDatabase, alias);
  }

  static TypeConverter<SyncStatus, String> $convertersyncStatus =
      const SyncStatusConverter();
  static TypeConverter<List<String>, String> $converterimages =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawFamily =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawFriends =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawEnemies =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawRomance =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawAbilities =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawItems =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawLanguages =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawRaces =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawFactions =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawLocations =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawPowerSystems =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawReligions =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawCreatures =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawEconomies =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawStories =
      const ListStringConverter();
  static TypeConverter<List<String>, String> $converterrawTechnologies =
      const ListStringConverter();
}

class CharacterEntity extends DataClass implements Insertable<CharacterEntity> {
  final String localId;
  final String? serverId;
  final SyncStatus syncStatus;
  final String worldLocalId;
  final String name;
  final int? age;
  final String? gender;
  final String? nickname;
  final String? customNotes;
  final String tagColor;
  final String? appearanceJson;
  final String? personalityJson;
  final String? historyJson;
  final String? familyJson;
  final String? friendsJson;
  final String? enemiesJson;
  final String? romanceJson;
  final List<String> images;
  final List<String> rawFamily;
  final List<String> rawFriends;
  final List<String> rawEnemies;
  final List<String> rawRomance;
  final List<String> rawAbilities;
  final List<String> rawItems;
  final List<String> rawLanguages;
  final List<String> rawRaces;
  final List<String> rawFactions;
  final List<String> rawLocations;
  final List<String> rawPowerSystems;
  final List<String> rawReligions;
  final List<String> rawCreatures;
  final List<String> rawEconomies;
  final List<String> rawStories;
  final List<String> rawTechnologies;
  const CharacterEntity({
    required this.localId,
    this.serverId,
    required this.syncStatus,
    required this.worldLocalId,
    required this.name,
    this.age,
    this.gender,
    this.nickname,
    this.customNotes,
    required this.tagColor,
    this.appearanceJson,
    this.personalityJson,
    this.historyJson,
    this.familyJson,
    this.friendsJson,
    this.enemiesJson,
    this.romanceJson,
    required this.images,
    required this.rawFamily,
    required this.rawFriends,
    required this.rawEnemies,
    required this.rawRomance,
    required this.rawAbilities,
    required this.rawItems,
    required this.rawLanguages,
    required this.rawRaces,
    required this.rawFactions,
    required this.rawLocations,
    required this.rawPowerSystems,
    required this.rawReligions,
    required this.rawCreatures,
    required this.rawEconomies,
    required this.rawStories,
    required this.rawTechnologies,
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
        $CharactersTable.$convertersyncStatus.toSql(syncStatus),
      );
    }
    map['world_local_id'] = Variable<String>(worldLocalId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || nickname != null) {
      map['nickname'] = Variable<String>(nickname);
    }
    if (!nullToAbsent || customNotes != null) {
      map['custom_notes'] = Variable<String>(customNotes);
    }
    map['tag_color'] = Variable<String>(tagColor);
    if (!nullToAbsent || appearanceJson != null) {
      map['appearance_json'] = Variable<String>(appearanceJson);
    }
    if (!nullToAbsent || personalityJson != null) {
      map['personality_json'] = Variable<String>(personalityJson);
    }
    if (!nullToAbsent || historyJson != null) {
      map['history_json'] = Variable<String>(historyJson);
    }
    if (!nullToAbsent || familyJson != null) {
      map['family_json'] = Variable<String>(familyJson);
    }
    if (!nullToAbsent || friendsJson != null) {
      map['friends_json'] = Variable<String>(friendsJson);
    }
    if (!nullToAbsent || enemiesJson != null) {
      map['enemies_json'] = Variable<String>(enemiesJson);
    }
    if (!nullToAbsent || romanceJson != null) {
      map['romance_json'] = Variable<String>(romanceJson);
    }
    {
      map['images'] = Variable<String>(
        $CharactersTable.$converterimages.toSql(images),
      );
    }
    {
      map['raw_family'] = Variable<String>(
        $CharactersTable.$converterrawFamily.toSql(rawFamily),
      );
    }
    {
      map['raw_friends'] = Variable<String>(
        $CharactersTable.$converterrawFriends.toSql(rawFriends),
      );
    }
    {
      map['raw_enemies'] = Variable<String>(
        $CharactersTable.$converterrawEnemies.toSql(rawEnemies),
      );
    }
    {
      map['raw_romance'] = Variable<String>(
        $CharactersTable.$converterrawRomance.toSql(rawRomance),
      );
    }
    {
      map['raw_abilities'] = Variable<String>(
        $CharactersTable.$converterrawAbilities.toSql(rawAbilities),
      );
    }
    {
      map['raw_items'] = Variable<String>(
        $CharactersTable.$converterrawItems.toSql(rawItems),
      );
    }
    {
      map['raw_languages'] = Variable<String>(
        $CharactersTable.$converterrawLanguages.toSql(rawLanguages),
      );
    }
    {
      map['raw_races'] = Variable<String>(
        $CharactersTable.$converterrawRaces.toSql(rawRaces),
      );
    }
    {
      map['raw_factions'] = Variable<String>(
        $CharactersTable.$converterrawFactions.toSql(rawFactions),
      );
    }
    {
      map['raw_locations'] = Variable<String>(
        $CharactersTable.$converterrawLocations.toSql(rawLocations),
      );
    }
    {
      map['raw_power_systems'] = Variable<String>(
        $CharactersTable.$converterrawPowerSystems.toSql(rawPowerSystems),
      );
    }
    {
      map['raw_religions'] = Variable<String>(
        $CharactersTable.$converterrawReligions.toSql(rawReligions),
      );
    }
    {
      map['raw_creatures'] = Variable<String>(
        $CharactersTable.$converterrawCreatures.toSql(rawCreatures),
      );
    }
    {
      map['raw_economies'] = Variable<String>(
        $CharactersTable.$converterrawEconomies.toSql(rawEconomies),
      );
    }
    {
      map['raw_stories'] = Variable<String>(
        $CharactersTable.$converterrawStories.toSql(rawStories),
      );
    }
    {
      map['raw_technologies'] = Variable<String>(
        $CharactersTable.$converterrawTechnologies.toSql(rawTechnologies),
      );
    }
    return map;
  }

  CharactersCompanion toCompanion(bool nullToAbsent) {
    return CharactersCompanion(
      localId: Value(localId),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      syncStatus: Value(syncStatus),
      worldLocalId: Value(worldLocalId),
      name: Value(name),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      nickname: nickname == null && nullToAbsent
          ? const Value.absent()
          : Value(nickname),
      customNotes: customNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(customNotes),
      tagColor: Value(tagColor),
      appearanceJson: appearanceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(appearanceJson),
      personalityJson: personalityJson == null && nullToAbsent
          ? const Value.absent()
          : Value(personalityJson),
      historyJson: historyJson == null && nullToAbsent
          ? const Value.absent()
          : Value(historyJson),
      familyJson: familyJson == null && nullToAbsent
          ? const Value.absent()
          : Value(familyJson),
      friendsJson: friendsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(friendsJson),
      enemiesJson: enemiesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(enemiesJson),
      romanceJson: romanceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(romanceJson),
      images: Value(images),
      rawFamily: Value(rawFamily),
      rawFriends: Value(rawFriends),
      rawEnemies: Value(rawEnemies),
      rawRomance: Value(rawRomance),
      rawAbilities: Value(rawAbilities),
      rawItems: Value(rawItems),
      rawLanguages: Value(rawLanguages),
      rawRaces: Value(rawRaces),
      rawFactions: Value(rawFactions),
      rawLocations: Value(rawLocations),
      rawPowerSystems: Value(rawPowerSystems),
      rawReligions: Value(rawReligions),
      rawCreatures: Value(rawCreatures),
      rawEconomies: Value(rawEconomies),
      rawStories: Value(rawStories),
      rawTechnologies: Value(rawTechnologies),
    );
  }

  factory CharacterEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CharacterEntity(
      localId: serializer.fromJson<String>(json['localId']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      syncStatus: serializer.fromJson<SyncStatus>(json['syncStatus']),
      worldLocalId: serializer.fromJson<String>(json['worldLocalId']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int?>(json['age']),
      gender: serializer.fromJson<String?>(json['gender']),
      nickname: serializer.fromJson<String?>(json['nickname']),
      customNotes: serializer.fromJson<String?>(json['customNotes']),
      tagColor: serializer.fromJson<String>(json['tagColor']),
      appearanceJson: serializer.fromJson<String?>(json['appearanceJson']),
      personalityJson: serializer.fromJson<String?>(json['personalityJson']),
      historyJson: serializer.fromJson<String?>(json['historyJson']),
      familyJson: serializer.fromJson<String?>(json['familyJson']),
      friendsJson: serializer.fromJson<String?>(json['friendsJson']),
      enemiesJson: serializer.fromJson<String?>(json['enemiesJson']),
      romanceJson: serializer.fromJson<String?>(json['romanceJson']),
      images: serializer.fromJson<List<String>>(json['images']),
      rawFamily: serializer.fromJson<List<String>>(json['rawFamily']),
      rawFriends: serializer.fromJson<List<String>>(json['rawFriends']),
      rawEnemies: serializer.fromJson<List<String>>(json['rawEnemies']),
      rawRomance: serializer.fromJson<List<String>>(json['rawRomance']),
      rawAbilities: serializer.fromJson<List<String>>(json['rawAbilities']),
      rawItems: serializer.fromJson<List<String>>(json['rawItems']),
      rawLanguages: serializer.fromJson<List<String>>(json['rawLanguages']),
      rawRaces: serializer.fromJson<List<String>>(json['rawRaces']),
      rawFactions: serializer.fromJson<List<String>>(json['rawFactions']),
      rawLocations: serializer.fromJson<List<String>>(json['rawLocations']),
      rawPowerSystems: serializer.fromJson<List<String>>(
        json['rawPowerSystems'],
      ),
      rawReligions: serializer.fromJson<List<String>>(json['rawReligions']),
      rawCreatures: serializer.fromJson<List<String>>(json['rawCreatures']),
      rawEconomies: serializer.fromJson<List<String>>(json['rawEconomies']),
      rawStories: serializer.fromJson<List<String>>(json['rawStories']),
      rawTechnologies: serializer.fromJson<List<String>>(
        json['rawTechnologies'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'serverId': serializer.toJson<String?>(serverId),
      'syncStatus': serializer.toJson<SyncStatus>(syncStatus),
      'worldLocalId': serializer.toJson<String>(worldLocalId),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int?>(age),
      'gender': serializer.toJson<String?>(gender),
      'nickname': serializer.toJson<String?>(nickname),
      'customNotes': serializer.toJson<String?>(customNotes),
      'tagColor': serializer.toJson<String>(tagColor),
      'appearanceJson': serializer.toJson<String?>(appearanceJson),
      'personalityJson': serializer.toJson<String?>(personalityJson),
      'historyJson': serializer.toJson<String?>(historyJson),
      'familyJson': serializer.toJson<String?>(familyJson),
      'friendsJson': serializer.toJson<String?>(friendsJson),
      'enemiesJson': serializer.toJson<String?>(enemiesJson),
      'romanceJson': serializer.toJson<String?>(romanceJson),
      'images': serializer.toJson<List<String>>(images),
      'rawFamily': serializer.toJson<List<String>>(rawFamily),
      'rawFriends': serializer.toJson<List<String>>(rawFriends),
      'rawEnemies': serializer.toJson<List<String>>(rawEnemies),
      'rawRomance': serializer.toJson<List<String>>(rawRomance),
      'rawAbilities': serializer.toJson<List<String>>(rawAbilities),
      'rawItems': serializer.toJson<List<String>>(rawItems),
      'rawLanguages': serializer.toJson<List<String>>(rawLanguages),
      'rawRaces': serializer.toJson<List<String>>(rawRaces),
      'rawFactions': serializer.toJson<List<String>>(rawFactions),
      'rawLocations': serializer.toJson<List<String>>(rawLocations),
      'rawPowerSystems': serializer.toJson<List<String>>(rawPowerSystems),
      'rawReligions': serializer.toJson<List<String>>(rawReligions),
      'rawCreatures': serializer.toJson<List<String>>(rawCreatures),
      'rawEconomies': serializer.toJson<List<String>>(rawEconomies),
      'rawStories': serializer.toJson<List<String>>(rawStories),
      'rawTechnologies': serializer.toJson<List<String>>(rawTechnologies),
    };
  }

  CharacterEntity copyWith({
    String? localId,
    Value<String?> serverId = const Value.absent(),
    SyncStatus? syncStatus,
    String? worldLocalId,
    String? name,
    Value<int?> age = const Value.absent(),
    Value<String?> gender = const Value.absent(),
    Value<String?> nickname = const Value.absent(),
    Value<String?> customNotes = const Value.absent(),
    String? tagColor,
    Value<String?> appearanceJson = const Value.absent(),
    Value<String?> personalityJson = const Value.absent(),
    Value<String?> historyJson = const Value.absent(),
    Value<String?> familyJson = const Value.absent(),
    Value<String?> friendsJson = const Value.absent(),
    Value<String?> enemiesJson = const Value.absent(),
    Value<String?> romanceJson = const Value.absent(),
    List<String>? images,
    List<String>? rawFamily,
    List<String>? rawFriends,
    List<String>? rawEnemies,
    List<String>? rawRomance,
    List<String>? rawAbilities,
    List<String>? rawItems,
    List<String>? rawLanguages,
    List<String>? rawRaces,
    List<String>? rawFactions,
    List<String>? rawLocations,
    List<String>? rawPowerSystems,
    List<String>? rawReligions,
    List<String>? rawCreatures,
    List<String>? rawEconomies,
    List<String>? rawStories,
    List<String>? rawTechnologies,
  }) => CharacterEntity(
    localId: localId ?? this.localId,
    serverId: serverId.present ? serverId.value : this.serverId,
    syncStatus: syncStatus ?? this.syncStatus,
    worldLocalId: worldLocalId ?? this.worldLocalId,
    name: name ?? this.name,
    age: age.present ? age.value : this.age,
    gender: gender.present ? gender.value : this.gender,
    nickname: nickname.present ? nickname.value : this.nickname,
    customNotes: customNotes.present ? customNotes.value : this.customNotes,
    tagColor: tagColor ?? this.tagColor,
    appearanceJson: appearanceJson.present
        ? appearanceJson.value
        : this.appearanceJson,
    personalityJson: personalityJson.present
        ? personalityJson.value
        : this.personalityJson,
    historyJson: historyJson.present ? historyJson.value : this.historyJson,
    familyJson: familyJson.present ? familyJson.value : this.familyJson,
    friendsJson: friendsJson.present ? friendsJson.value : this.friendsJson,
    enemiesJson: enemiesJson.present ? enemiesJson.value : this.enemiesJson,
    romanceJson: romanceJson.present ? romanceJson.value : this.romanceJson,
    images: images ?? this.images,
    rawFamily: rawFamily ?? this.rawFamily,
    rawFriends: rawFriends ?? this.rawFriends,
    rawEnemies: rawEnemies ?? this.rawEnemies,
    rawRomance: rawRomance ?? this.rawRomance,
    rawAbilities: rawAbilities ?? this.rawAbilities,
    rawItems: rawItems ?? this.rawItems,
    rawLanguages: rawLanguages ?? this.rawLanguages,
    rawRaces: rawRaces ?? this.rawRaces,
    rawFactions: rawFactions ?? this.rawFactions,
    rawLocations: rawLocations ?? this.rawLocations,
    rawPowerSystems: rawPowerSystems ?? this.rawPowerSystems,
    rawReligions: rawReligions ?? this.rawReligions,
    rawCreatures: rawCreatures ?? this.rawCreatures,
    rawEconomies: rawEconomies ?? this.rawEconomies,
    rawStories: rawStories ?? this.rawStories,
    rawTechnologies: rawTechnologies ?? this.rawTechnologies,
  );
  CharacterEntity copyWithCompanion(CharactersCompanion data) {
    return CharacterEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
      worldLocalId: data.worldLocalId.present
          ? data.worldLocalId.value
          : this.worldLocalId,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      gender: data.gender.present ? data.gender.value : this.gender,
      nickname: data.nickname.present ? data.nickname.value : this.nickname,
      customNotes: data.customNotes.present
          ? data.customNotes.value
          : this.customNotes,
      tagColor: data.tagColor.present ? data.tagColor.value : this.tagColor,
      appearanceJson: data.appearanceJson.present
          ? data.appearanceJson.value
          : this.appearanceJson,
      personalityJson: data.personalityJson.present
          ? data.personalityJson.value
          : this.personalityJson,
      historyJson: data.historyJson.present
          ? data.historyJson.value
          : this.historyJson,
      familyJson: data.familyJson.present
          ? data.familyJson.value
          : this.familyJson,
      friendsJson: data.friendsJson.present
          ? data.friendsJson.value
          : this.friendsJson,
      enemiesJson: data.enemiesJson.present
          ? data.enemiesJson.value
          : this.enemiesJson,
      romanceJson: data.romanceJson.present
          ? data.romanceJson.value
          : this.romanceJson,
      images: data.images.present ? data.images.value : this.images,
      rawFamily: data.rawFamily.present ? data.rawFamily.value : this.rawFamily,
      rawFriends: data.rawFriends.present
          ? data.rawFriends.value
          : this.rawFriends,
      rawEnemies: data.rawEnemies.present
          ? data.rawEnemies.value
          : this.rawEnemies,
      rawRomance: data.rawRomance.present
          ? data.rawRomance.value
          : this.rawRomance,
      rawAbilities: data.rawAbilities.present
          ? data.rawAbilities.value
          : this.rawAbilities,
      rawItems: data.rawItems.present ? data.rawItems.value : this.rawItems,
      rawLanguages: data.rawLanguages.present
          ? data.rawLanguages.value
          : this.rawLanguages,
      rawRaces: data.rawRaces.present ? data.rawRaces.value : this.rawRaces,
      rawFactions: data.rawFactions.present
          ? data.rawFactions.value
          : this.rawFactions,
      rawLocations: data.rawLocations.present
          ? data.rawLocations.value
          : this.rawLocations,
      rawPowerSystems: data.rawPowerSystems.present
          ? data.rawPowerSystems.value
          : this.rawPowerSystems,
      rawReligions: data.rawReligions.present
          ? data.rawReligions.value
          : this.rawReligions,
      rawCreatures: data.rawCreatures.present
          ? data.rawCreatures.value
          : this.rawCreatures,
      rawEconomies: data.rawEconomies.present
          ? data.rawEconomies.value
          : this.rawEconomies,
      rawStories: data.rawStories.present
          ? data.rawStories.value
          : this.rawStories,
      rawTechnologies: data.rawTechnologies.present
          ? data.rawTechnologies.value
          : this.rawTechnologies,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CharacterEntity(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('worldLocalId: $worldLocalId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('nickname: $nickname, ')
          ..write('customNotes: $customNotes, ')
          ..write('tagColor: $tagColor, ')
          ..write('appearanceJson: $appearanceJson, ')
          ..write('personalityJson: $personalityJson, ')
          ..write('historyJson: $historyJson, ')
          ..write('familyJson: $familyJson, ')
          ..write('friendsJson: $friendsJson, ')
          ..write('enemiesJson: $enemiesJson, ')
          ..write('romanceJson: $romanceJson, ')
          ..write('images: $images, ')
          ..write('rawFamily: $rawFamily, ')
          ..write('rawFriends: $rawFriends, ')
          ..write('rawEnemies: $rawEnemies, ')
          ..write('rawRomance: $rawRomance, ')
          ..write('rawAbilities: $rawAbilities, ')
          ..write('rawItems: $rawItems, ')
          ..write('rawLanguages: $rawLanguages, ')
          ..write('rawRaces: $rawRaces, ')
          ..write('rawFactions: $rawFactions, ')
          ..write('rawLocations: $rawLocations, ')
          ..write('rawPowerSystems: $rawPowerSystems, ')
          ..write('rawReligions: $rawReligions, ')
          ..write('rawCreatures: $rawCreatures, ')
          ..write('rawEconomies: $rawEconomies, ')
          ..write('rawStories: $rawStories, ')
          ..write('rawTechnologies: $rawTechnologies')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    localId,
    serverId,
    syncStatus,
    worldLocalId,
    name,
    age,
    gender,
    nickname,
    customNotes,
    tagColor,
    appearanceJson,
    personalityJson,
    historyJson,
    familyJson,
    friendsJson,
    enemiesJson,
    romanceJson,
    images,
    rawFamily,
    rawFriends,
    rawEnemies,
    rawRomance,
    rawAbilities,
    rawItems,
    rawLanguages,
    rawRaces,
    rawFactions,
    rawLocations,
    rawPowerSystems,
    rawReligions,
    rawCreatures,
    rawEconomies,
    rawStories,
    rawTechnologies,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CharacterEntity &&
          other.localId == this.localId &&
          other.serverId == this.serverId &&
          other.syncStatus == this.syncStatus &&
          other.worldLocalId == this.worldLocalId &&
          other.name == this.name &&
          other.age == this.age &&
          other.gender == this.gender &&
          other.nickname == this.nickname &&
          other.customNotes == this.customNotes &&
          other.tagColor == this.tagColor &&
          other.appearanceJson == this.appearanceJson &&
          other.personalityJson == this.personalityJson &&
          other.historyJson == this.historyJson &&
          other.familyJson == this.familyJson &&
          other.friendsJson == this.friendsJson &&
          other.enemiesJson == this.enemiesJson &&
          other.romanceJson == this.romanceJson &&
          other.images == this.images &&
          other.rawFamily == this.rawFamily &&
          other.rawFriends == this.rawFriends &&
          other.rawEnemies == this.rawEnemies &&
          other.rawRomance == this.rawRomance &&
          other.rawAbilities == this.rawAbilities &&
          other.rawItems == this.rawItems &&
          other.rawLanguages == this.rawLanguages &&
          other.rawRaces == this.rawRaces &&
          other.rawFactions == this.rawFactions &&
          other.rawLocations == this.rawLocations &&
          other.rawPowerSystems == this.rawPowerSystems &&
          other.rawReligions == this.rawReligions &&
          other.rawCreatures == this.rawCreatures &&
          other.rawEconomies == this.rawEconomies &&
          other.rawStories == this.rawStories &&
          other.rawTechnologies == this.rawTechnologies);
}

class CharactersCompanion extends UpdateCompanion<CharacterEntity> {
  final Value<String> localId;
  final Value<String?> serverId;
  final Value<SyncStatus> syncStatus;
  final Value<String> worldLocalId;
  final Value<String> name;
  final Value<int?> age;
  final Value<String?> gender;
  final Value<String?> nickname;
  final Value<String?> customNotes;
  final Value<String> tagColor;
  final Value<String?> appearanceJson;
  final Value<String?> personalityJson;
  final Value<String?> historyJson;
  final Value<String?> familyJson;
  final Value<String?> friendsJson;
  final Value<String?> enemiesJson;
  final Value<String?> romanceJson;
  final Value<List<String>> images;
  final Value<List<String>> rawFamily;
  final Value<List<String>> rawFriends;
  final Value<List<String>> rawEnemies;
  final Value<List<String>> rawRomance;
  final Value<List<String>> rawAbilities;
  final Value<List<String>> rawItems;
  final Value<List<String>> rawLanguages;
  final Value<List<String>> rawRaces;
  final Value<List<String>> rawFactions;
  final Value<List<String>> rawLocations;
  final Value<List<String>> rawPowerSystems;
  final Value<List<String>> rawReligions;
  final Value<List<String>> rawCreatures;
  final Value<List<String>> rawEconomies;
  final Value<List<String>> rawStories;
  final Value<List<String>> rawTechnologies;
  final Value<int> rowid;
  const CharactersCompanion({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.worldLocalId = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.nickname = const Value.absent(),
    this.customNotes = const Value.absent(),
    this.tagColor = const Value.absent(),
    this.appearanceJson = const Value.absent(),
    this.personalityJson = const Value.absent(),
    this.historyJson = const Value.absent(),
    this.familyJson = const Value.absent(),
    this.friendsJson = const Value.absent(),
    this.enemiesJson = const Value.absent(),
    this.romanceJson = const Value.absent(),
    this.images = const Value.absent(),
    this.rawFamily = const Value.absent(),
    this.rawFriends = const Value.absent(),
    this.rawEnemies = const Value.absent(),
    this.rawRomance = const Value.absent(),
    this.rawAbilities = const Value.absent(),
    this.rawItems = const Value.absent(),
    this.rawLanguages = const Value.absent(),
    this.rawRaces = const Value.absent(),
    this.rawFactions = const Value.absent(),
    this.rawLocations = const Value.absent(),
    this.rawPowerSystems = const Value.absent(),
    this.rawReligions = const Value.absent(),
    this.rawCreatures = const Value.absent(),
    this.rawEconomies = const Value.absent(),
    this.rawStories = const Value.absent(),
    this.rawTechnologies = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CharactersCompanion.insert({
    this.localId = const Value.absent(),
    this.serverId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    required String worldLocalId,
    required String name,
    this.age = const Value.absent(),
    this.gender = const Value.absent(),
    this.nickname = const Value.absent(),
    this.customNotes = const Value.absent(),
    this.tagColor = const Value.absent(),
    this.appearanceJson = const Value.absent(),
    this.personalityJson = const Value.absent(),
    this.historyJson = const Value.absent(),
    this.familyJson = const Value.absent(),
    this.friendsJson = const Value.absent(),
    this.enemiesJson = const Value.absent(),
    this.romanceJson = const Value.absent(),
    this.images = const Value.absent(),
    this.rawFamily = const Value.absent(),
    this.rawFriends = const Value.absent(),
    this.rawEnemies = const Value.absent(),
    this.rawRomance = const Value.absent(),
    this.rawAbilities = const Value.absent(),
    this.rawItems = const Value.absent(),
    this.rawLanguages = const Value.absent(),
    this.rawRaces = const Value.absent(),
    this.rawFactions = const Value.absent(),
    this.rawLocations = const Value.absent(),
    this.rawPowerSystems = const Value.absent(),
    this.rawReligions = const Value.absent(),
    this.rawCreatures = const Value.absent(),
    this.rawEconomies = const Value.absent(),
    this.rawStories = const Value.absent(),
    this.rawTechnologies = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : worldLocalId = Value(worldLocalId),
       name = Value(name);
  static Insertable<CharacterEntity> custom({
    Expression<String>? localId,
    Expression<String>? serverId,
    Expression<String>? syncStatus,
    Expression<String>? worldLocalId,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? gender,
    Expression<String>? nickname,
    Expression<String>? customNotes,
    Expression<String>? tagColor,
    Expression<String>? appearanceJson,
    Expression<String>? personalityJson,
    Expression<String>? historyJson,
    Expression<String>? familyJson,
    Expression<String>? friendsJson,
    Expression<String>? enemiesJson,
    Expression<String>? romanceJson,
    Expression<String>? images,
    Expression<String>? rawFamily,
    Expression<String>? rawFriends,
    Expression<String>? rawEnemies,
    Expression<String>? rawRomance,
    Expression<String>? rawAbilities,
    Expression<String>? rawItems,
    Expression<String>? rawLanguages,
    Expression<String>? rawRaces,
    Expression<String>? rawFactions,
    Expression<String>? rawLocations,
    Expression<String>? rawPowerSystems,
    Expression<String>? rawReligions,
    Expression<String>? rawCreatures,
    Expression<String>? rawEconomies,
    Expression<String>? rawStories,
    Expression<String>? rawTechnologies,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (serverId != null) 'server_id': serverId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (worldLocalId != null) 'world_local_id': worldLocalId,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (gender != null) 'gender': gender,
      if (nickname != null) 'nickname': nickname,
      if (customNotes != null) 'custom_notes': customNotes,
      if (tagColor != null) 'tag_color': tagColor,
      if (appearanceJson != null) 'appearance_json': appearanceJson,
      if (personalityJson != null) 'personality_json': personalityJson,
      if (historyJson != null) 'history_json': historyJson,
      if (familyJson != null) 'family_json': familyJson,
      if (friendsJson != null) 'friends_json': friendsJson,
      if (enemiesJson != null) 'enemies_json': enemiesJson,
      if (romanceJson != null) 'romance_json': romanceJson,
      if (images != null) 'images': images,
      if (rawFamily != null) 'raw_family': rawFamily,
      if (rawFriends != null) 'raw_friends': rawFriends,
      if (rawEnemies != null) 'raw_enemies': rawEnemies,
      if (rawRomance != null) 'raw_romance': rawRomance,
      if (rawAbilities != null) 'raw_abilities': rawAbilities,
      if (rawItems != null) 'raw_items': rawItems,
      if (rawLanguages != null) 'raw_languages': rawLanguages,
      if (rawRaces != null) 'raw_races': rawRaces,
      if (rawFactions != null) 'raw_factions': rawFactions,
      if (rawLocations != null) 'raw_locations': rawLocations,
      if (rawPowerSystems != null) 'raw_power_systems': rawPowerSystems,
      if (rawReligions != null) 'raw_religions': rawReligions,
      if (rawCreatures != null) 'raw_creatures': rawCreatures,
      if (rawEconomies != null) 'raw_economies': rawEconomies,
      if (rawStories != null) 'raw_stories': rawStories,
      if (rawTechnologies != null) 'raw_technologies': rawTechnologies,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CharactersCompanion copyWith({
    Value<String>? localId,
    Value<String?>? serverId,
    Value<SyncStatus>? syncStatus,
    Value<String>? worldLocalId,
    Value<String>? name,
    Value<int?>? age,
    Value<String?>? gender,
    Value<String?>? nickname,
    Value<String?>? customNotes,
    Value<String>? tagColor,
    Value<String?>? appearanceJson,
    Value<String?>? personalityJson,
    Value<String?>? historyJson,
    Value<String?>? familyJson,
    Value<String?>? friendsJson,
    Value<String?>? enemiesJson,
    Value<String?>? romanceJson,
    Value<List<String>>? images,
    Value<List<String>>? rawFamily,
    Value<List<String>>? rawFriends,
    Value<List<String>>? rawEnemies,
    Value<List<String>>? rawRomance,
    Value<List<String>>? rawAbilities,
    Value<List<String>>? rawItems,
    Value<List<String>>? rawLanguages,
    Value<List<String>>? rawRaces,
    Value<List<String>>? rawFactions,
    Value<List<String>>? rawLocations,
    Value<List<String>>? rawPowerSystems,
    Value<List<String>>? rawReligions,
    Value<List<String>>? rawCreatures,
    Value<List<String>>? rawEconomies,
    Value<List<String>>? rawStories,
    Value<List<String>>? rawTechnologies,
    Value<int>? rowid,
  }) {
    return CharactersCompanion(
      localId: localId ?? this.localId,
      serverId: serverId ?? this.serverId,
      syncStatus: syncStatus ?? this.syncStatus,
      worldLocalId: worldLocalId ?? this.worldLocalId,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      nickname: nickname ?? this.nickname,
      customNotes: customNotes ?? this.customNotes,
      tagColor: tagColor ?? this.tagColor,
      appearanceJson: appearanceJson ?? this.appearanceJson,
      personalityJson: personalityJson ?? this.personalityJson,
      historyJson: historyJson ?? this.historyJson,
      familyJson: familyJson ?? this.familyJson,
      friendsJson: friendsJson ?? this.friendsJson,
      enemiesJson: enemiesJson ?? this.enemiesJson,
      romanceJson: romanceJson ?? this.romanceJson,
      images: images ?? this.images,
      rawFamily: rawFamily ?? this.rawFamily,
      rawFriends: rawFriends ?? this.rawFriends,
      rawEnemies: rawEnemies ?? this.rawEnemies,
      rawRomance: rawRomance ?? this.rawRomance,
      rawAbilities: rawAbilities ?? this.rawAbilities,
      rawItems: rawItems ?? this.rawItems,
      rawLanguages: rawLanguages ?? this.rawLanguages,
      rawRaces: rawRaces ?? this.rawRaces,
      rawFactions: rawFactions ?? this.rawFactions,
      rawLocations: rawLocations ?? this.rawLocations,
      rawPowerSystems: rawPowerSystems ?? this.rawPowerSystems,
      rawReligions: rawReligions ?? this.rawReligions,
      rawCreatures: rawCreatures ?? this.rawCreatures,
      rawEconomies: rawEconomies ?? this.rawEconomies,
      rawStories: rawStories ?? this.rawStories,
      rawTechnologies: rawTechnologies ?? this.rawTechnologies,
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
        $CharactersTable.$convertersyncStatus.toSql(syncStatus.value),
      );
    }
    if (worldLocalId.present) {
      map['world_local_id'] = Variable<String>(worldLocalId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (nickname.present) {
      map['nickname'] = Variable<String>(nickname.value);
    }
    if (customNotes.present) {
      map['custom_notes'] = Variable<String>(customNotes.value);
    }
    if (tagColor.present) {
      map['tag_color'] = Variable<String>(tagColor.value);
    }
    if (appearanceJson.present) {
      map['appearance_json'] = Variable<String>(appearanceJson.value);
    }
    if (personalityJson.present) {
      map['personality_json'] = Variable<String>(personalityJson.value);
    }
    if (historyJson.present) {
      map['history_json'] = Variable<String>(historyJson.value);
    }
    if (familyJson.present) {
      map['family_json'] = Variable<String>(familyJson.value);
    }
    if (friendsJson.present) {
      map['friends_json'] = Variable<String>(friendsJson.value);
    }
    if (enemiesJson.present) {
      map['enemies_json'] = Variable<String>(enemiesJson.value);
    }
    if (romanceJson.present) {
      map['romance_json'] = Variable<String>(romanceJson.value);
    }
    if (images.present) {
      map['images'] = Variable<String>(
        $CharactersTable.$converterimages.toSql(images.value),
      );
    }
    if (rawFamily.present) {
      map['raw_family'] = Variable<String>(
        $CharactersTable.$converterrawFamily.toSql(rawFamily.value),
      );
    }
    if (rawFriends.present) {
      map['raw_friends'] = Variable<String>(
        $CharactersTable.$converterrawFriends.toSql(rawFriends.value),
      );
    }
    if (rawEnemies.present) {
      map['raw_enemies'] = Variable<String>(
        $CharactersTable.$converterrawEnemies.toSql(rawEnemies.value),
      );
    }
    if (rawRomance.present) {
      map['raw_romance'] = Variable<String>(
        $CharactersTable.$converterrawRomance.toSql(rawRomance.value),
      );
    }
    if (rawAbilities.present) {
      map['raw_abilities'] = Variable<String>(
        $CharactersTable.$converterrawAbilities.toSql(rawAbilities.value),
      );
    }
    if (rawItems.present) {
      map['raw_items'] = Variable<String>(
        $CharactersTable.$converterrawItems.toSql(rawItems.value),
      );
    }
    if (rawLanguages.present) {
      map['raw_languages'] = Variable<String>(
        $CharactersTable.$converterrawLanguages.toSql(rawLanguages.value),
      );
    }
    if (rawRaces.present) {
      map['raw_races'] = Variable<String>(
        $CharactersTable.$converterrawRaces.toSql(rawRaces.value),
      );
    }
    if (rawFactions.present) {
      map['raw_factions'] = Variable<String>(
        $CharactersTable.$converterrawFactions.toSql(rawFactions.value),
      );
    }
    if (rawLocations.present) {
      map['raw_locations'] = Variable<String>(
        $CharactersTable.$converterrawLocations.toSql(rawLocations.value),
      );
    }
    if (rawPowerSystems.present) {
      map['raw_power_systems'] = Variable<String>(
        $CharactersTable.$converterrawPowerSystems.toSql(rawPowerSystems.value),
      );
    }
    if (rawReligions.present) {
      map['raw_religions'] = Variable<String>(
        $CharactersTable.$converterrawReligions.toSql(rawReligions.value),
      );
    }
    if (rawCreatures.present) {
      map['raw_creatures'] = Variable<String>(
        $CharactersTable.$converterrawCreatures.toSql(rawCreatures.value),
      );
    }
    if (rawEconomies.present) {
      map['raw_economies'] = Variable<String>(
        $CharactersTable.$converterrawEconomies.toSql(rawEconomies.value),
      );
    }
    if (rawStories.present) {
      map['raw_stories'] = Variable<String>(
        $CharactersTable.$converterrawStories.toSql(rawStories.value),
      );
    }
    if (rawTechnologies.present) {
      map['raw_technologies'] = Variable<String>(
        $CharactersTable.$converterrawTechnologies.toSql(rawTechnologies.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CharactersCompanion(')
          ..write('localId: $localId, ')
          ..write('serverId: $serverId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('worldLocalId: $worldLocalId, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('gender: $gender, ')
          ..write('nickname: $nickname, ')
          ..write('customNotes: $customNotes, ')
          ..write('tagColor: $tagColor, ')
          ..write('appearanceJson: $appearanceJson, ')
          ..write('personalityJson: $personalityJson, ')
          ..write('historyJson: $historyJson, ')
          ..write('familyJson: $familyJson, ')
          ..write('friendsJson: $friendsJson, ')
          ..write('enemiesJson: $enemiesJson, ')
          ..write('romanceJson: $romanceJson, ')
          ..write('images: $images, ')
          ..write('rawFamily: $rawFamily, ')
          ..write('rawFriends: $rawFriends, ')
          ..write('rawEnemies: $rawEnemies, ')
          ..write('rawRomance: $rawRomance, ')
          ..write('rawAbilities: $rawAbilities, ')
          ..write('rawItems: $rawItems, ')
          ..write('rawLanguages: $rawLanguages, ')
          ..write('rawRaces: $rawRaces, ')
          ..write('rawFactions: $rawFactions, ')
          ..write('rawLocations: $rawLocations, ')
          ..write('rawPowerSystems: $rawPowerSystems, ')
          ..write('rawReligions: $rawReligions, ')
          ..write('rawCreatures: $rawCreatures, ')
          ..write('rawEconomies: $rawEconomies, ')
          ..write('rawStories: $rawStories, ')
          ..write('rawTechnologies: $rawTechnologies, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingUploadsTable extends PendingUploads
    with TableInfo<$PendingUploadsTable, PendingUploadEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingUploadsTable(this.attachedDatabase, [this._alias]);
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
    clientDefault: () => Uuid().v4(),
  );
  static const VerificationMeta _worldLocalIdMeta = const VerificationMeta(
    'worldLocalId',
  );
  @override
  late final GeneratedColumn<String> worldLocalId = GeneratedColumn<String>(
    'world_local_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES worlds (local_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storagePathMeta = const VerificationMeta(
    'storagePath',
  );
  @override
  late final GeneratedColumn<String> storagePath = GeneratedColumn<String>(
    'storage_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    localId,
    worldLocalId,
    filePath,
    storagePath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_uploads';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingUploadEntity> instance, {
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
    if (data.containsKey('world_local_id')) {
      context.handle(
        _worldLocalIdMeta,
        worldLocalId.isAcceptableOrUnknown(
          data['world_local_id']!,
          _worldLocalIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_worldLocalIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('storage_path')) {
      context.handle(
        _storagePathMeta,
        storagePath.isAcceptableOrUnknown(
          data['storage_path']!,
          _storagePathMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_storagePathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {localId};
  @override
  PendingUploadEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingUploadEntity(
      localId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_id'],
      )!,
      worldLocalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}world_local_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      storagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}storage_path'],
      )!,
    );
  }

  @override
  $PendingUploadsTable createAlias(String alias) {
    return $PendingUploadsTable(attachedDatabase, alias);
  }
}

class PendingUploadEntity extends DataClass
    implements Insertable<PendingUploadEntity> {
  final String localId;
  final String worldLocalId;
  final String filePath;
  final String storagePath;
  const PendingUploadEntity({
    required this.localId,
    required this.worldLocalId,
    required this.filePath,
    required this.storagePath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['local_id'] = Variable<String>(localId);
    map['world_local_id'] = Variable<String>(worldLocalId);
    map['file_path'] = Variable<String>(filePath);
    map['storage_path'] = Variable<String>(storagePath);
    return map;
  }

  PendingUploadsCompanion toCompanion(bool nullToAbsent) {
    return PendingUploadsCompanion(
      localId: Value(localId),
      worldLocalId: Value(worldLocalId),
      filePath: Value(filePath),
      storagePath: Value(storagePath),
    );
  }

  factory PendingUploadEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingUploadEntity(
      localId: serializer.fromJson<String>(json['localId']),
      worldLocalId: serializer.fromJson<String>(json['worldLocalId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      storagePath: serializer.fromJson<String>(json['storagePath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'localId': serializer.toJson<String>(localId),
      'worldLocalId': serializer.toJson<String>(worldLocalId),
      'filePath': serializer.toJson<String>(filePath),
      'storagePath': serializer.toJson<String>(storagePath),
    };
  }

  PendingUploadEntity copyWith({
    String? localId,
    String? worldLocalId,
    String? filePath,
    String? storagePath,
  }) => PendingUploadEntity(
    localId: localId ?? this.localId,
    worldLocalId: worldLocalId ?? this.worldLocalId,
    filePath: filePath ?? this.filePath,
    storagePath: storagePath ?? this.storagePath,
  );
  PendingUploadEntity copyWithCompanion(PendingUploadsCompanion data) {
    return PendingUploadEntity(
      localId: data.localId.present ? data.localId.value : this.localId,
      worldLocalId: data.worldLocalId.present
          ? data.worldLocalId.value
          : this.worldLocalId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      storagePath: data.storagePath.present
          ? data.storagePath.value
          : this.storagePath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingUploadEntity(')
          ..write('localId: $localId, ')
          ..write('worldLocalId: $worldLocalId, ')
          ..write('filePath: $filePath, ')
          ..write('storagePath: $storagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(localId, worldLocalId, filePath, storagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingUploadEntity &&
          other.localId == this.localId &&
          other.worldLocalId == this.worldLocalId &&
          other.filePath == this.filePath &&
          other.storagePath == this.storagePath);
}

class PendingUploadsCompanion extends UpdateCompanion<PendingUploadEntity> {
  final Value<String> localId;
  final Value<String> worldLocalId;
  final Value<String> filePath;
  final Value<String> storagePath;
  final Value<int> rowid;
  const PendingUploadsCompanion({
    this.localId = const Value.absent(),
    this.worldLocalId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.storagePath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingUploadsCompanion.insert({
    this.localId = const Value.absent(),
    required String worldLocalId,
    required String filePath,
    required String storagePath,
    this.rowid = const Value.absent(),
  }) : worldLocalId = Value(worldLocalId),
       filePath = Value(filePath),
       storagePath = Value(storagePath);
  static Insertable<PendingUploadEntity> custom({
    Expression<String>? localId,
    Expression<String>? worldLocalId,
    Expression<String>? filePath,
    Expression<String>? storagePath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (localId != null) 'local_id': localId,
      if (worldLocalId != null) 'world_local_id': worldLocalId,
      if (filePath != null) 'file_path': filePath,
      if (storagePath != null) 'storage_path': storagePath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingUploadsCompanion copyWith({
    Value<String>? localId,
    Value<String>? worldLocalId,
    Value<String>? filePath,
    Value<String>? storagePath,
    Value<int>? rowid,
  }) {
    return PendingUploadsCompanion(
      localId: localId ?? this.localId,
      worldLocalId: worldLocalId ?? this.worldLocalId,
      filePath: filePath ?? this.filePath,
      storagePath: storagePath ?? this.storagePath,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (localId.present) {
      map['local_id'] = Variable<String>(localId.value);
    }
    if (worldLocalId.present) {
      map['world_local_id'] = Variable<String>(worldLocalId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (storagePath.present) {
      map['storage_path'] = Variable<String>(storagePath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingUploadsCompanion(')
          ..write('localId: $localId, ')
          ..write('worldLocalId: $worldLocalId, ')
          ..write('filePath: $filePath, ')
          ..write('storagePath: $storagePath, ')
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
  late final $CharactersTable characters = $CharactersTable(this);
  late final $PendingUploadsTable pendingUploads = $PendingUploadsTable(this);
  late final WorldsDao worldsDao = WorldsDao(this as AppDatabase);
  late final CharactersDao charactersDao = CharactersDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfile,
    worlds,
    characters,
    pendingUploads,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'worlds',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('pending_uploads', kind: UpdateKind.delete)],
    ),
  ]);
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

final class $$WorldsTableReferences
    extends BaseReferences<_$AppDatabase, $WorldsTable, WorldEntity> {
  $$WorldsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CharactersTable, List<CharacterEntity>>
  _charactersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.characters,
    aliasName: $_aliasNameGenerator(
      db.worlds.localId,
      db.characters.worldLocalId,
    ),
  );

  $$CharactersTableProcessedTableManager get charactersRefs {
    final manager = $$CharactersTableTableManager($_db, $_db.characters).filter(
      (f) =>
          f.worldLocalId.localId.sqlEquals($_itemColumn<String>('local_id')!),
    );

    final cache = $_typedResult.readTableOrNull(_charactersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PendingUploadsTable, List<PendingUploadEntity>>
  _pendingUploadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pendingUploads,
    aliasName: $_aliasNameGenerator(
      db.worlds.localId,
      db.pendingUploads.worldLocalId,
    ),
  );

  $$PendingUploadsTableProcessedTableManager get pendingUploadsRefs {
    final manager = $$PendingUploadsTableTableManager($_db, $_db.pendingUploads)
        .filter(
          (f) => f.worldLocalId.localId.sqlEquals(
            $_itemColumn<String>('local_id')!,
          ),
        );

    final cache = $_typedResult.readTableOrNull(_pendingUploadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> charactersRefs(
    Expression<bool> Function($$CharactersTableFilterComposer f) f,
  ) {
    final $$CharactersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.worldLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableFilterComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pendingUploadsRefs(
    Expression<bool> Function($$PendingUploadsTableFilterComposer f) f,
  ) {
    final $$PendingUploadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.pendingUploads,
      getReferencedColumn: (t) => t.worldLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingUploadsTableFilterComposer(
            $db: $db,
            $table: $db.pendingUploads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> charactersRefs<T extends Object>(
    Expression<T> Function($$CharactersTableAnnotationComposer a) f,
  ) {
    final $$CharactersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.characters,
      getReferencedColumn: (t) => t.worldLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CharactersTableAnnotationComposer(
            $db: $db,
            $table: $db.characters,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pendingUploadsRefs<T extends Object>(
    Expression<T> Function($$PendingUploadsTableAnnotationComposer a) f,
  ) {
    final $$PendingUploadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.localId,
      referencedTable: $db.pendingUploads,
      getReferencedColumn: (t) => t.worldLocalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PendingUploadsTableAnnotationComposer(
            $db: $db,
            $table: $db.pendingUploads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (WorldEntity, $$WorldsTableReferences),
          WorldEntity,
          PrefetchHooks Function({bool charactersRefs, bool pendingUploadsRefs})
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
              .map(
                (e) =>
                    (e.readTable(table), $$WorldsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({charactersRefs = false, pendingUploadsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (charactersRefs) db.characters,
                    if (pendingUploadsRefs) db.pendingUploads,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (charactersRefs)
                        await $_getPrefetchedData<
                          WorldEntity,
                          $WorldsTable,
                          CharacterEntity
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._charactersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).charactersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldLocalId == item.localId,
                              ),
                          typedResults: items,
                        ),
                      if (pendingUploadsRefs)
                        await $_getPrefetchedData<
                          WorldEntity,
                          $WorldsTable,
                          PendingUploadEntity
                        >(
                          currentTable: table,
                          referencedTable: $$WorldsTableReferences
                              ._pendingUploadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WorldsTableReferences(
                                db,
                                table,
                                p0,
                              ).pendingUploadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.worldLocalId == item.localId,
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
      (WorldEntity, $$WorldsTableReferences),
      WorldEntity,
      PrefetchHooks Function({bool charactersRefs, bool pendingUploadsRefs})
    >;
typedef $$CharactersTableCreateCompanionBuilder =
    CharactersCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<SyncStatus> syncStatus,
      required String worldLocalId,
      required String name,
      Value<int?> age,
      Value<String?> gender,
      Value<String?> nickname,
      Value<String?> customNotes,
      Value<String> tagColor,
      Value<String?> appearanceJson,
      Value<String?> personalityJson,
      Value<String?> historyJson,
      Value<String?> familyJson,
      Value<String?> friendsJson,
      Value<String?> enemiesJson,
      Value<String?> romanceJson,
      Value<List<String>> images,
      Value<List<String>> rawFamily,
      Value<List<String>> rawFriends,
      Value<List<String>> rawEnemies,
      Value<List<String>> rawRomance,
      Value<List<String>> rawAbilities,
      Value<List<String>> rawItems,
      Value<List<String>> rawLanguages,
      Value<List<String>> rawRaces,
      Value<List<String>> rawFactions,
      Value<List<String>> rawLocations,
      Value<List<String>> rawPowerSystems,
      Value<List<String>> rawReligions,
      Value<List<String>> rawCreatures,
      Value<List<String>> rawEconomies,
      Value<List<String>> rawStories,
      Value<List<String>> rawTechnologies,
      Value<int> rowid,
    });
typedef $$CharactersTableUpdateCompanionBuilder =
    CharactersCompanion Function({
      Value<String> localId,
      Value<String?> serverId,
      Value<SyncStatus> syncStatus,
      Value<String> worldLocalId,
      Value<String> name,
      Value<int?> age,
      Value<String?> gender,
      Value<String?> nickname,
      Value<String?> customNotes,
      Value<String> tagColor,
      Value<String?> appearanceJson,
      Value<String?> personalityJson,
      Value<String?> historyJson,
      Value<String?> familyJson,
      Value<String?> friendsJson,
      Value<String?> enemiesJson,
      Value<String?> romanceJson,
      Value<List<String>> images,
      Value<List<String>> rawFamily,
      Value<List<String>> rawFriends,
      Value<List<String>> rawEnemies,
      Value<List<String>> rawRomance,
      Value<List<String>> rawAbilities,
      Value<List<String>> rawItems,
      Value<List<String>> rawLanguages,
      Value<List<String>> rawRaces,
      Value<List<String>> rawFactions,
      Value<List<String>> rawLocations,
      Value<List<String>> rawPowerSystems,
      Value<List<String>> rawReligions,
      Value<List<String>> rawCreatures,
      Value<List<String>> rawEconomies,
      Value<List<String>> rawStories,
      Value<List<String>> rawTechnologies,
      Value<int> rowid,
    });

final class $$CharactersTableReferences
    extends BaseReferences<_$AppDatabase, $CharactersTable, CharacterEntity> {
  $$CharactersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorldsTable _worldLocalIdTable(_$AppDatabase db) =>
      db.worlds.createAlias(
        $_aliasNameGenerator(db.characters.worldLocalId, db.worlds.localId),
      );

  $$WorldsTableProcessedTableManager get worldLocalId {
    final $_column = $_itemColumn<String>('world_local_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CharactersTableFilterComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableFilterComposer({
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

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagColor => $composableBuilder(
    column: $table.tagColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appearanceJson => $composableBuilder(
    column: $table.appearanceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get personalityJson => $composableBuilder(
    column: $table.personalityJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get historyJson => $composableBuilder(
    column: $table.historyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get friendsJson => $composableBuilder(
    column: $table.friendsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enemiesJson => $composableBuilder(
    column: $table.enemiesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get romanceJson => $composableBuilder(
    column: $table.romanceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawFamily => $composableBuilder(
    column: $table.rawFamily,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawFriends => $composableBuilder(
    column: $table.rawFriends,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawEnemies => $composableBuilder(
    column: $table.rawEnemies,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawRomance => $composableBuilder(
    column: $table.rawRomance,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawAbilities => $composableBuilder(
    column: $table.rawAbilities,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawItems => $composableBuilder(
    column: $table.rawItems,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawLanguages => $composableBuilder(
    column: $table.rawLanguages,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawRaces => $composableBuilder(
    column: $table.rawRaces,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawFactions => $composableBuilder(
    column: $table.rawFactions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawLocations => $composableBuilder(
    column: $table.rawLocations,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawPowerSystems => $composableBuilder(
    column: $table.rawPowerSystems,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawReligions => $composableBuilder(
    column: $table.rawReligions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawCreatures => $composableBuilder(
    column: $table.rawCreatures,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawEconomies => $composableBuilder(
    column: $table.rawEconomies,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawStories => $composableBuilder(
    column: $table.rawStories,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get rawTechnologies => $composableBuilder(
    column: $table.rawTechnologies,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$WorldsTableFilterComposer get worldLocalId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableOrderingComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableOrderingComposer({
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

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nickname => $composableBuilder(
    column: $table.nickname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagColor => $composableBuilder(
    column: $table.tagColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appearanceJson => $composableBuilder(
    column: $table.appearanceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalityJson => $composableBuilder(
    column: $table.personalityJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get historyJson => $composableBuilder(
    column: $table.historyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get friendsJson => $composableBuilder(
    column: $table.friendsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enemiesJson => $composableBuilder(
    column: $table.enemiesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get romanceJson => $composableBuilder(
    column: $table.romanceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get images => $composableBuilder(
    column: $table.images,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawFamily => $composableBuilder(
    column: $table.rawFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawFriends => $composableBuilder(
    column: $table.rawFriends,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawEnemies => $composableBuilder(
    column: $table.rawEnemies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawRomance => $composableBuilder(
    column: $table.rawRomance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawAbilities => $composableBuilder(
    column: $table.rawAbilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawItems => $composableBuilder(
    column: $table.rawItems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawLanguages => $composableBuilder(
    column: $table.rawLanguages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawRaces => $composableBuilder(
    column: $table.rawRaces,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawFactions => $composableBuilder(
    column: $table.rawFactions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawLocations => $composableBuilder(
    column: $table.rawLocations,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawPowerSystems => $composableBuilder(
    column: $table.rawPowerSystems,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawReligions => $composableBuilder(
    column: $table.rawReligions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawCreatures => $composableBuilder(
    column: $table.rawCreatures,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawEconomies => $composableBuilder(
    column: $table.rawEconomies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawStories => $composableBuilder(
    column: $table.rawStories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rawTechnologies => $composableBuilder(
    column: $table.rawTechnologies,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldLocalId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CharactersTable> {
  $$CharactersTableAnnotationComposer({
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

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get nickname =>
      $composableBuilder(column: $table.nickname, builder: (column) => column);

  GeneratedColumn<String> get customNotes => $composableBuilder(
    column: $table.customNotes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagColor =>
      $composableBuilder(column: $table.tagColor, builder: (column) => column);

  GeneratedColumn<String> get appearanceJson => $composableBuilder(
    column: $table.appearanceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get personalityJson => $composableBuilder(
    column: $table.personalityJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get historyJson => $composableBuilder(
    column: $table.historyJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get familyJson => $composableBuilder(
    column: $table.familyJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get friendsJson => $composableBuilder(
    column: $table.friendsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enemiesJson => $composableBuilder(
    column: $table.enemiesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get romanceJson => $composableBuilder(
    column: $table.romanceJson,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get images =>
      $composableBuilder(column: $table.images, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get rawFamily =>
      $composableBuilder(column: $table.rawFamily, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get rawFriends =>
      $composableBuilder(
        column: $table.rawFriends,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawEnemies =>
      $composableBuilder(
        column: $table.rawEnemies,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawRomance =>
      $composableBuilder(
        column: $table.rawRomance,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawAbilities =>
      $composableBuilder(
        column: $table.rawAbilities,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawItems =>
      $composableBuilder(column: $table.rawItems, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get rawLanguages =>
      $composableBuilder(
        column: $table.rawLanguages,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawRaces =>
      $composableBuilder(column: $table.rawRaces, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get rawFactions =>
      $composableBuilder(
        column: $table.rawFactions,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawLocations =>
      $composableBuilder(
        column: $table.rawLocations,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawPowerSystems =>
      $composableBuilder(
        column: $table.rawPowerSystems,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawReligions =>
      $composableBuilder(
        column: $table.rawReligions,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawCreatures =>
      $composableBuilder(
        column: $table.rawCreatures,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawEconomies =>
      $composableBuilder(
        column: $table.rawEconomies,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawStories =>
      $composableBuilder(
        column: $table.rawStories,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<List<String>, String> get rawTechnologies =>
      $composableBuilder(
        column: $table.rawTechnologies,
        builder: (column) => column,
      );

  $$WorldsTableAnnotationComposer get worldLocalId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CharactersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CharactersTable,
          CharacterEntity,
          $$CharactersTableFilterComposer,
          $$CharactersTableOrderingComposer,
          $$CharactersTableAnnotationComposer,
          $$CharactersTableCreateCompanionBuilder,
          $$CharactersTableUpdateCompanionBuilder,
          (CharacterEntity, $$CharactersTableReferences),
          CharacterEntity,
          PrefetchHooks Function({bool worldLocalId})
        > {
  $$CharactersTableTableManager(_$AppDatabase db, $CharactersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CharactersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CharactersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CharactersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                Value<String> worldLocalId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String?> customNotes = const Value.absent(),
                Value<String> tagColor = const Value.absent(),
                Value<String?> appearanceJson = const Value.absent(),
                Value<String?> personalityJson = const Value.absent(),
                Value<String?> historyJson = const Value.absent(),
                Value<String?> familyJson = const Value.absent(),
                Value<String?> friendsJson = const Value.absent(),
                Value<String?> enemiesJson = const Value.absent(),
                Value<String?> romanceJson = const Value.absent(),
                Value<List<String>> images = const Value.absent(),
                Value<List<String>> rawFamily = const Value.absent(),
                Value<List<String>> rawFriends = const Value.absent(),
                Value<List<String>> rawEnemies = const Value.absent(),
                Value<List<String>> rawRomance = const Value.absent(),
                Value<List<String>> rawAbilities = const Value.absent(),
                Value<List<String>> rawItems = const Value.absent(),
                Value<List<String>> rawLanguages = const Value.absent(),
                Value<List<String>> rawRaces = const Value.absent(),
                Value<List<String>> rawFactions = const Value.absent(),
                Value<List<String>> rawLocations = const Value.absent(),
                Value<List<String>> rawPowerSystems = const Value.absent(),
                Value<List<String>> rawReligions = const Value.absent(),
                Value<List<String>> rawCreatures = const Value.absent(),
                Value<List<String>> rawEconomies = const Value.absent(),
                Value<List<String>> rawStories = const Value.absent(),
                Value<List<String>> rawTechnologies = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion(
                localId: localId,
                serverId: serverId,
                syncStatus: syncStatus,
                worldLocalId: worldLocalId,
                name: name,
                age: age,
                gender: gender,
                nickname: nickname,
                customNotes: customNotes,
                tagColor: tagColor,
                appearanceJson: appearanceJson,
                personalityJson: personalityJson,
                historyJson: historyJson,
                familyJson: familyJson,
                friendsJson: friendsJson,
                enemiesJson: enemiesJson,
                romanceJson: romanceJson,
                images: images,
                rawFamily: rawFamily,
                rawFriends: rawFriends,
                rawEnemies: rawEnemies,
                rawRomance: rawRomance,
                rawAbilities: rawAbilities,
                rawItems: rawItems,
                rawLanguages: rawLanguages,
                rawRaces: rawRaces,
                rawFactions: rawFactions,
                rawLocations: rawLocations,
                rawPowerSystems: rawPowerSystems,
                rawReligions: rawReligions,
                rawCreatures: rawCreatures,
                rawEconomies: rawEconomies,
                rawStories: rawStories,
                rawTechnologies: rawTechnologies,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String?> serverId = const Value.absent(),
                Value<SyncStatus> syncStatus = const Value.absent(),
                required String worldLocalId,
                required String name,
                Value<int?> age = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> nickname = const Value.absent(),
                Value<String?> customNotes = const Value.absent(),
                Value<String> tagColor = const Value.absent(),
                Value<String?> appearanceJson = const Value.absent(),
                Value<String?> personalityJson = const Value.absent(),
                Value<String?> historyJson = const Value.absent(),
                Value<String?> familyJson = const Value.absent(),
                Value<String?> friendsJson = const Value.absent(),
                Value<String?> enemiesJson = const Value.absent(),
                Value<String?> romanceJson = const Value.absent(),
                Value<List<String>> images = const Value.absent(),
                Value<List<String>> rawFamily = const Value.absent(),
                Value<List<String>> rawFriends = const Value.absent(),
                Value<List<String>> rawEnemies = const Value.absent(),
                Value<List<String>> rawRomance = const Value.absent(),
                Value<List<String>> rawAbilities = const Value.absent(),
                Value<List<String>> rawItems = const Value.absent(),
                Value<List<String>> rawLanguages = const Value.absent(),
                Value<List<String>> rawRaces = const Value.absent(),
                Value<List<String>> rawFactions = const Value.absent(),
                Value<List<String>> rawLocations = const Value.absent(),
                Value<List<String>> rawPowerSystems = const Value.absent(),
                Value<List<String>> rawReligions = const Value.absent(),
                Value<List<String>> rawCreatures = const Value.absent(),
                Value<List<String>> rawEconomies = const Value.absent(),
                Value<List<String>> rawStories = const Value.absent(),
                Value<List<String>> rawTechnologies = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CharactersCompanion.insert(
                localId: localId,
                serverId: serverId,
                syncStatus: syncStatus,
                worldLocalId: worldLocalId,
                name: name,
                age: age,
                gender: gender,
                nickname: nickname,
                customNotes: customNotes,
                tagColor: tagColor,
                appearanceJson: appearanceJson,
                personalityJson: personalityJson,
                historyJson: historyJson,
                familyJson: familyJson,
                friendsJson: friendsJson,
                enemiesJson: enemiesJson,
                romanceJson: romanceJson,
                images: images,
                rawFamily: rawFamily,
                rawFriends: rawFriends,
                rawEnemies: rawEnemies,
                rawRomance: rawRomance,
                rawAbilities: rawAbilities,
                rawItems: rawItems,
                rawLanguages: rawLanguages,
                rawRaces: rawRaces,
                rawFactions: rawFactions,
                rawLocations: rawLocations,
                rawPowerSystems: rawPowerSystems,
                rawReligions: rawReligions,
                rawCreatures: rawCreatures,
                rawEconomies: rawEconomies,
                rawStories: rawStories,
                rawTechnologies: rawTechnologies,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CharactersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldLocalId = false}) {
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
                    if (worldLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.worldLocalId,
                                referencedTable: $$CharactersTableReferences
                                    ._worldLocalIdTable(db),
                                referencedColumn: $$CharactersTableReferences
                                    ._worldLocalIdTable(db)
                                    .localId,
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

typedef $$CharactersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CharactersTable,
      CharacterEntity,
      $$CharactersTableFilterComposer,
      $$CharactersTableOrderingComposer,
      $$CharactersTableAnnotationComposer,
      $$CharactersTableCreateCompanionBuilder,
      $$CharactersTableUpdateCompanionBuilder,
      (CharacterEntity, $$CharactersTableReferences),
      CharacterEntity,
      PrefetchHooks Function({bool worldLocalId})
    >;
typedef $$PendingUploadsTableCreateCompanionBuilder =
    PendingUploadsCompanion Function({
      Value<String> localId,
      required String worldLocalId,
      required String filePath,
      required String storagePath,
      Value<int> rowid,
    });
typedef $$PendingUploadsTableUpdateCompanionBuilder =
    PendingUploadsCompanion Function({
      Value<String> localId,
      Value<String> worldLocalId,
      Value<String> filePath,
      Value<String> storagePath,
      Value<int> rowid,
    });

final class $$PendingUploadsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PendingUploadsTable,
          PendingUploadEntity
        > {
  $$PendingUploadsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorldsTable _worldLocalIdTable(_$AppDatabase db) =>
      db.worlds.createAlias(
        $_aliasNameGenerator(db.pendingUploads.worldLocalId, db.worlds.localId),
      );

  $$WorldsTableProcessedTableManager get worldLocalId {
    final $_column = $_itemColumn<String>('world_local_id')!;

    final manager = $$WorldsTableTableManager(
      $_db,
      $_db.worlds,
    ).filter((f) => f.localId.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_worldLocalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PendingUploadsTableFilterComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnFilters(column),
  );

  $$WorldsTableFilterComposer get worldLocalId {
    final $$WorldsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableFilterComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingUploadsTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorldsTableOrderingComposer get worldLocalId {
    final $$WorldsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableOrderingComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingUploadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingUploadsTable> {
  $$PendingUploadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get localId =>
      $composableBuilder(column: $table.localId, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get storagePath => $composableBuilder(
    column: $table.storagePath,
    builder: (column) => column,
  );

  $$WorldsTableAnnotationComposer get worldLocalId {
    final $$WorldsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.worldLocalId,
      referencedTable: $db.worlds,
      getReferencedColumn: (t) => t.localId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorldsTableAnnotationComposer(
            $db: $db,
            $table: $db.worlds,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PendingUploadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingUploadsTable,
          PendingUploadEntity,
          $$PendingUploadsTableFilterComposer,
          $$PendingUploadsTableOrderingComposer,
          $$PendingUploadsTableAnnotationComposer,
          $$PendingUploadsTableCreateCompanionBuilder,
          $$PendingUploadsTableUpdateCompanionBuilder,
          (PendingUploadEntity, $$PendingUploadsTableReferences),
          PendingUploadEntity,
          PrefetchHooks Function({bool worldLocalId})
        > {
  $$PendingUploadsTableTableManager(
    _$AppDatabase db,
    $PendingUploadsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingUploadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingUploadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingUploadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                Value<String> worldLocalId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> storagePath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingUploadsCompanion(
                localId: localId,
                worldLocalId: worldLocalId,
                filePath: filePath,
                storagePath: storagePath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> localId = const Value.absent(),
                required String worldLocalId,
                required String filePath,
                required String storagePath,
                Value<int> rowid = const Value.absent(),
              }) => PendingUploadsCompanion.insert(
                localId: localId,
                worldLocalId: worldLocalId,
                filePath: filePath,
                storagePath: storagePath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PendingUploadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({worldLocalId = false}) {
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
                    if (worldLocalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.worldLocalId,
                                referencedTable: $$PendingUploadsTableReferences
                                    ._worldLocalIdTable(db),
                                referencedColumn:
                                    $$PendingUploadsTableReferences
                                        ._worldLocalIdTable(db)
                                        .localId,
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

typedef $$PendingUploadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingUploadsTable,
      PendingUploadEntity,
      $$PendingUploadsTableFilterComposer,
      $$PendingUploadsTableOrderingComposer,
      $$PendingUploadsTableAnnotationComposer,
      $$PendingUploadsTableCreateCompanionBuilder,
      $$PendingUploadsTableUpdateCompanionBuilder,
      (PendingUploadEntity, $$PendingUploadsTableReferences),
      PendingUploadEntity,
      PrefetchHooks Function({bool worldLocalId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfileTableTableManager get userProfile =>
      $$UserProfileTableTableManager(_db, _db.userProfile);
  $$WorldsTableTableManager get worlds =>
      $$WorldsTableTableManager(_db, _db.worlds);
  $$CharactersTableTableManager get characters =>
      $$CharactersTableTableManager(_db, _db.characters);
  $$PendingUploadsTableTableManager get pendingUploads =>
      $$PendingUploadsTableTableManager(_db, _db.pendingUploads);
}
