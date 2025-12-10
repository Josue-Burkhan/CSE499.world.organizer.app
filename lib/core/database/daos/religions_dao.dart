import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/religions.dart';

part 'religions_dao.g.dart';

@DriftAccessor(tables: [Religions])
class ReligionsDao extends DatabaseAccessor<AppDatabase> with _$ReligionsDaoMixin {
  ReligionsDao(AppDatabase db) : super(db);

  Stream<List<ReligionEntity>> watchReligionsInWorld(String worldLocalId) {
    return (select(religions)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<ReligionEntity?> watchReligionByServerId(String serverId) {
    return (select(religions)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<ReligionEntity?> getReligionByServerId(String serverId) {
    return (select(religions)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<ReligionEntity>> getDirtyReligions() {
    return (select(religions)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertReligion(ReligionsCompanion religion) {
    return into(religions).insert(religion, mode: InsertMode.replace);
  }

  Future<void> updateReligion(ReligionsCompanion religion) {
    return update(religions).replace(religion);
  }

  Future<void> deleteReligion(String localId) {
    return (delete(religions)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<ReligionEntity?> getReligionByLocalId(String localId) {
    return (select(religions)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
}