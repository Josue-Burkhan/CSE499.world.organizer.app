import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/creatures.dart';

part 'creatures_dao.g.dart';

@DriftAccessor(tables: [Creatures])
class CreaturesDao extends DatabaseAccessor<AppDatabase> with _$CreaturesDaoMixin {
  CreaturesDao(AppDatabase db) : super(db);

  Stream<List<CreatureEntity>> watchCreaturesInWorld(String worldLocalId) {
    return (select(creatures)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<CreatureEntity?> watchCreatureByServerId(String serverId) {
    return (select(creatures)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<CreatureEntity?> getCreatureByServerId(String serverId) {
    return (select(creatures)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<CreatureEntity>> getDirtyCreatures() {
    return (select(creatures)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertCreature(CreaturesCompanion creature) {
    return into(creatures).insert(creature, mode: InsertMode.replace);
  }

  Future<void> updateCreature(CreaturesCompanion creature) {
    return update(creatures).replace(creature);
  }

  Future<void> deleteCreature(String localId) {
    return (delete(creatures)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<CreatureEntity?> getCreatureByLocalId(String localId) {
    return (select(creatures)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}