import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart' as api;

class WorldRepository {
  final WorldsDao _worldsDao;

  WorldRepository({required WorldsDao worldsDao}) : _worldsDao = worldsDao;

  Stream<List<WorldEntity>> watchWorlds() {
    return _worldsDao.watchAllWorlds();
  }

  Stream<WorldEntity?> watchWorld(String localId) {
    return _worldsDao.watchWorld(localId);
  }

  Future<WorldEntity> createWorld({
    required String name,
    required String description,
    required api.Modules? modules,
  }) async {
    final companion = WorldsCompanion(
      name: Value(name),
      description: Value(description),
      modules: Value(modules?.toJson()),
      syncStatus: const Value(SyncStatus.created),
    );
    await _worldsDao.insertWorld(companion);
    return (await _worldsDao.getWorldByLocalId(companion.localId.value))!;
  }

  Future<void> updateWorld({
    required String localId,
    required String name,
    required String description,
    required api.Modules? modules,
  }) async {
    final localWorld = await _worldsDao.getWorldByLocalId(localId);
    if (localWorld == null) {
      throw Exception('World not found locally');
    }

    SyncStatus newStatus = SyncStatus.edited;
    if (localWorld.syncStatus == SyncStatus.created) {
      newStatus = SyncStatus.created;
    }

    final companion = WorldsCompanion(
      localId: Value(localId),
      serverId: Value(localWorld.serverId),
      name: Value(name),
      description: Value(description),
      modules: Value(modules?.toJson()),
      syncStatus: Value(newStatus),
    );
    
    await _worldsDao.updateWorld(companion);
  }

  Future<void> deleteWorld(String localId) async {
    final localWorld = await _worldsDao.getWorldByLocalId(localId);
    if (localWorld == null) return;

    if (localWorld.syncStatus == SyncStatus.created) {
      await _worldsDao.deleteWorld(localId);
    } else {
      final companion = localWorld.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _worldsDao.updateWorld(companion);
    }
  }
}