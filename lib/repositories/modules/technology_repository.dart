import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/technologies_dao.dart';
import 'package:worldorganizer_app/core/services/modules/technology_sync_service.dart';

class TechnologyRepository {
  final TechnologiesDao _dao;
  final TechnologySyncService _syncService;

  TechnologyRepository({
    required TechnologiesDao dao,
    required TechnologySyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<TechnologyEntity>> watchTechnologiesInWorld(String worldLocalId) {
    return _dao.watchTechnologiesInWorld(worldLocalId);
  }
  
  Stream<TechnologyEntity?> watchTechnologyByServerId(String serverId) {
    return _dao.watchTechnologyByServerId(serverId);
  }

  Future<TechnologyEntity?> getTechnology(String localId) {
    return _dao.getTechnologyByLocalId(localId);
  }

  Future<void> createTechnology(TechnologiesCompanion technology) async {
    await _dao.insertTechnology(technology);
    await _syncService.syncDirtyTechnologies();
  }

  Future<void> updateTechnology(TechnologiesCompanion technology) async {
    final localId = technology.localId.value;
    final existing = await _dao.getTechnologyByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = technology;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = technology.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = technology.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = technology.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateTechnology(updatedCompanion);
    await _syncService.syncDirtyTechnologies();
  }

  Future<void> deleteTechnology(String localId) async {
    final char = await _dao.getTechnologyByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteTechnology(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateTechnology(companion);
      await _syncService.syncDirtyTechnologies();
    }
  }
}