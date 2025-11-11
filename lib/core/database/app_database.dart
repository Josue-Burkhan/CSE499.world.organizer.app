import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'app_database.g.dart';

enum SyncStatus { synced, created, edited, deleted }

class SyncStatusConverter extends TypeConverter<SyncStatus, String> {
  const SyncStatusConverter();

  @override
  SyncStatus fromSql(String fromDb) {
    return SyncStatus.values.firstWhere(
      (e) => e.toString().split('.').last == fromDb,
      orElse: () => SyncStatus.synced,
    );
  }

  @override
  String toSql(SyncStatus value) {
    return value.toString().split('.').last;
  }
}

@DataClassName('UserProfileEntity')
class UserProfile extends Table {
  
  IntColumn get id => integer().withDefault(const Constant(1))();
  
  TextColumn get serverId => text().named('server_id')();
  TextColumn get firstName => text().named('first_name')();
  TextColumn get email => text().named('email')();
  TextColumn get pictureUrl => text().named('picture_url').nullable()();
  TextColumn get lang => text().named('lang')();

  TextColumn get plan => text().named('plan').nullable()();
  DateTimeColumn get planExpiresAt => dateTime().named('plan_expires_at').nullable()();
  BoolColumn get autoRenew => boolean().named('auto_renew').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorldEntity')
class Worlds extends Table {
  TextColumn get localId => text()
      .clientDefault(() => const Uuid().v4())();
      
  TextColumn get serverId => text().nullable()();

  TextColumn get syncStatus =>
      text().map(const SyncStatusConverter())
      .clientDefault(() => 'created')();
      
  TextColumn get name => text()();
  TextColumn get description => text()();
  
  TextColumn get modules => text().nullable()();
  TextColumn get coverImage => text().named('cover_image').nullable()();
  TextColumn get customImage => text().named('custom_image').nullable()();

  @override
  Set<Column> get primaryKey => {localId};
}

@DriftAccessor(tables: [Worlds])
class WorldsDao extends DatabaseAccessor<AppDatabase> with _$WorldsDaoMixin {
  WorldsDao(AppDatabase db) : super(db);

  Stream<List<WorldEntity>> watchAllWorlds() {
    return (select(worlds)
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<WorldEntity?> watchWorld(String localId) {
    return (select(worlds)
          ..where((t) => t.localId.equals(localId)))
          .watchSingleOrNull();
  }

  Future<WorldEntity?> getWorldByLocalId(String localId) {
    return (select(worlds)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
  
  Future<WorldEntity?> getWorldByServerId(String serverId) {
    return (select(worlds)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<void> insertWorld(WorldsCompanion world) {
    return into(worlds).insert(world, mode: InsertMode.replace);
  }

  Future<void> updateWorld(WorldsCompanion world) {
    return update(worlds).replace(world);
  }

  Future<void> deleteWorld(String localId) {
    return (delete(worlds)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<List<WorldEntity>> getDirtyWorlds() {
    return (select(worlds)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }
}

@DriftDatabase(tables: [UserProfile, Worlds], daos: [WorldsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> deleteAllData() {
    return transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}