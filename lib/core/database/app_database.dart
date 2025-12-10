import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';
import '../../models/api_models/module_link.dart';

import 'tables/user_profile.dart';
import 'tables/worlds.dart';
import 'tables/abilities.dart';
import 'tables/characters.dart';
import 'tables/creatures.dart';
import 'tables/economies.dart';
import 'tables/events.dart';
import 'tables/factions.dart';
import 'tables/items.dart';
import 'tables/languages.dart';
import 'tables/locations.dart';
import 'tables/powersystems.dart';
import 'tables/races.dart';
import 'tables/religions.dart';
import 'tables/stories.dart';
import 'tables/technologies.dart';
import 'tables/pending_uploads.dart';
import 'daos/worlds_dao.dart';
import 'daos/abilities_dao.dart';
import 'daos/characters_dao.dart';
import 'daos/creatures_dao.dart';
import 'daos/economies_dao.dart';
import 'daos/events_dao.dart';
import 'daos/factions_dao.dart';
import 'daos/items_dao.dart';
import 'daos/languages_dao.dart';
import 'daos/locations_dao.dart';
import 'daos/powersystems_dao.dart';
import 'daos/races_dao.dart';
import 'daos/religions_dao.dart';
import 'daos/stories_dao.dart';
import 'daos/technologies_dao.dart';
import 'converters/list_string_converter.dart';
import 'converters/module_link_list_converter.dart';

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
  tables: [UserProfile, Worlds, Abilities, Characters, Creatures, Economies, Events, Factions, Items, Languages, Locations, PowerSystems, Races, Religions, Stories, Technologies, PendingUploads],
  daos: [WorldsDao, AbilitiesDao, CharactersDao, CreaturesDao,  EconomiesDao, EventsDao, FactionsDao, ItemsDao, LanguagesDao, LocationsDao, PowerSystemsDao, RacesDao, ReligionsDao, StoriesDao, TechnologiesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

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
        if (from < 3) {
          await m.addColumn(worlds, worlds.updatedAt);
          await m.addColumn(characters, characters.updatedAt);
          await m.addColumn(items, items.updatedAt);
          await m.addColumn(locations, locations.updatedAt);
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