import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/worlds.dart';
import '../tables/pending_uploads.dart';

part 'worlds_dao.g.dart';

@DriftAccessor(tables: [Worlds, PendingUploads])
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

  Future<List<WorldEntity>> getAllWorlds() {
    return select(worlds).get();
  }

  Future<void> addPendingUpload(PendingUploadsCompanion upload) {
    return into(pendingUploads).insert(upload, mode: InsertMode.replace);
  }

  Future<PendingUploadEntity?> getPendingUploadForWorld(String worldLocalId) {
    return (select(pendingUploads)
          ..where((t) => t.worldLocalId.equals(worldLocalId)))
          .getSingleOrNull();
  }

  Future<void> deletePendingUpload(String worldLocalId) {
    return (delete(pendingUploads)
          ..where((t) => t.worldLocalId.equals(worldLocalId)))
          .go();
  }
}
