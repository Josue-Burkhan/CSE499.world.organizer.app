import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/factions.dart';

part 'factions_dao.g.dart';

@DriftAccessor(tables: [Factions])
class FactionsDao extends DatabaseAccessor<AppDatabase> with _$FactionsDaoMixin {
  FactionsDao(AppDatabase db) : super(db);

  Stream<List<FactionEntity>> watchFactionsInWorld(String worldLocalId) {
    return (select(factions)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<FactionEntity?> watchFactionByServerId(String serverId) {
    return (select(factions)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<FactionEntity?> getFactionByServerId(String serverId) {
    return (select(factions)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<FactionEntity>> getDirtyFactions() {
    return (select(factions)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertFaction(FactionsCompanion char) {
    return into(factions).insert(char, mode: InsertMode.replace);
  }

  Future<void> updateFaction(FactionsCompanion char) {
    return update(factions).replace(char);
  }

  Future<void> deleteFaction(String localId) {
    return (delete(factions)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<FactionEntity?> getFactionByLocalId(String localId) {
    return (select(factions)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}
