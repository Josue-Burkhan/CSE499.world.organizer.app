import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import 'tables/user_profile.dart';
import 'tables/worlds.dart';
import 'tables/characters.dart';
import 'tables/pending_uploads.dart';
import 'daos/worlds_dao.dart';
import 'daos/characters_dao.dart';
import 'converters/list_string_converter.dart';

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

@DriftDatabase(
  tables: [UserProfile, Worlds, Characters, PendingUploads],
  daos: [WorldsDao, CharactersDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(pendingUploads);
        }
      },
    );
  }

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