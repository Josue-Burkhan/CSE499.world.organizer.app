import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/technologies.dart';

part 'technologies_dao.g.dart';

@DriftAccessor(tables: [Technologies])
class TechnologiesDao extends DatabaseAccessor<AppDatabase> with _$TechnologiesDaoMixin {
  TechnologiesDao(AppDatabase db) : super(db);

  Stream<List<TechnologyEntity>> watchTechnologiesInWorld(String worldLocalId) {
    return (select(technologies)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<TechnologyEntity?> watchTechnologyByServerId(String serverId) {
    return (select(technologies)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<TechnologyEntity?> getTechnologyByServerId(String serverId) {
    return (select(technologies)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<TechnologyEntity>> getDirtyTechnologies() {
    return (select(technologies)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertTechnology(TechnologiesCompanion technology) {
    return into(technologies).insert(technology, mode: InsertMode.replace);
  }

  Future<void> updateTechnology(TechnologiesCompanion technology) {
    return update(technologies).replace(technology);
  }

  Future<void> deleteTechnology(String localId) {
    return (delete(technologies)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<TechnologyEntity?> getTechnologyByLocalId(String localId) {
    return (select(technologies)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
}