import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/races.dart';

part 'races_dao.g.dart';

@DriftAccessor(tables: [Races])
class RacesDao extends DatabaseAccessor<AppDatabase> with _$RacesDaoMixin {
  RacesDao(AppDatabase db) : super(db);

  Stream<List<RaceEntity>> watchRacesInWorld(String worldLocalId) {
    return (select(races)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<RaceEntity?> watchRaceByServerId(String serverId) {
    return (select(races)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<RaceEntity?> getRaceByServerId(String serverId) {
    return (select(races)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<RaceEntity>> getDirtyRaces() {
    return (select(races)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertRace(RacesCompanion race) {
    return into(races).insert(race, mode: InsertMode.replace);
  }

  Future<void> updateRace(RacesCompanion race) {
    return update(races).replace(race);
  }

  Future<void> deleteRace(String localId) {
    return (delete(races)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<RaceEntity?> getRaceByLocalId(String localId) {
    return (select(races)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
}