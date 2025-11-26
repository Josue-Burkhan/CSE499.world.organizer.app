import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/powersystems.dart';

part 'powersystems_dao.g.dart';

@DriftAccessor(tables: [PowerSystems])
class PowerSystemsDao extends DatabaseAccessor<AppDatabase> with _$PowerSystemsDaoMixin {
  PowerSystemsDao(AppDatabase db) : super(db);

  Stream<List<PowerSystemEntity>> watchPowerSystemsInWorld(String worldLocalId) {
    return (select(powerSystems)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<PowerSystemEntity?> watchPowerSystemByServerId(String serverId) {
    return (select(powerSystems)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<PowerSystemEntity?> getPowerSystemByServerId(String serverId) {
    return (select(powerSystems)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<PowerSystemEntity>> getDirtyPowerSystems() {
    return (select(powerSystems)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertPowerSystem(PowerSystemsCompanion powerSystem) {
    return into(powerSystems).insert(powerSystem, mode: InsertMode.replace);
  }

  Future<void> updatePowerSystem(PowerSystemsCompanion powerSystem) {
    return update(powerSystems).replace(powerSystem);
  }

  Future<void> deletePowerSystem(String localId) {
    return (delete(powerSystems)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<PowerSystemEntity?> getPowerSystemByLocalId(String localId) {
    return (select(powerSystems)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
}