import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/economies.dart';

part 'economies_dao.g.dart';

@DriftAccessor(tables: [Economies])
class EconomiesDao extends DatabaseAccessor<AppDatabase> with _$EconomiesDaoMixin {
  EconomiesDao(AppDatabase db) : super(db);

  Stream<List<EconomyEntity>> watchEconomiesInWorld(String worldLocalId) {
    return (select(economies)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<EconomyEntity?> watchEconomyByServerId(String serverId) {
    return (select(economies)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<EconomyEntity?> getEconomyByServerId(String serverId) {
    return (select(economies)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<EconomyEntity>> getDirtyEconomies() {
    return (select(economies)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertEconomy(EconomiesCompanion economy) {
    return into(economies).insert(economy, mode: InsertMode.replace);
  }

  Future<void> updateEconomy(EconomiesCompanion economy) {
    return update(economies).replace(economy);
  }

  Future<void> deleteEconomy(String localId) {
    return (delete(economies)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<EconomyEntity?> getEconomyByLocalId(String localId) {
    return (select(economies)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}