import 'package:drift/drift.dart';
import 'dart:io';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart' as api;
import 'package:uuid/uuid.dart';

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
    File? coverImage,
  }) async {
    final localId = const Uuid().v4();
    
    if (coverImage != null) {
      // Save pending upload
      final pendingUpload = PendingUploadsCompanion(
        worldLocalId: Value(localId),
        filePath: Value(coverImage.path),
        storagePath: Value('worlds/covers/$localId'),
      );
      await _worldsDao.addPendingUpload(pendingUpload);
    }

    final companion = WorldsCompanion(
      localId: Value(localId),
      name: Value(name),
      description: Value(description),
      modules: Value(modules?.toJson()),
      syncStatus: const Value(SyncStatus.created),
    );
    await _worldsDao.insertWorld(companion);
    return (await _worldsDao.getWorldByLocalId(localId))!;
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