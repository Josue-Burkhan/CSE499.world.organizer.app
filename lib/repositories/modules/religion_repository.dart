import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/religions_dao.dart';
import 'package:worldorganizer_app/core/services/modules/religion_sync_service.dart';

class ReligionRepository {
  final ReligionsDao _dao;
  final ReligionSyncService _syncService;

  ReligionRepository({
    required ReligionsDao dao,
    required ReligionSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<ReligionEntity>> watchReligionsInWorld(String worldLocalId) {
    return _dao.watchReligionsInWorld(worldLocalId);
  }
  
  Stream<ReligionEntity?> watchReligionByServerId(String serverId) {
    return _dao.watchReligionByServerId(serverId);
  }

  Future<ReligionEntity?> getReligion(String localId) {
    return _dao.getReligionByLocalId(localId);
  }

  Future<void> createReligion(ReligionsCompanion religion) async {
    await _dao.insertReligion(religion);
    await _syncService.syncDirtyReligions();
  }

  Future<void> updateReligion(ReligionsCompanion religion) async {
    final localId = religion.localId.value;
    final existing = await _dao.getReligionByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = religion;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = religion.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = religion.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = religion.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateReligion(updatedCompanion);
    await _syncService.syncDirtyReligions();
  }

  Future<void> deleteReligion(String localId) async {
    final char = await _dao.getReligionByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteReligion(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateReligion(companion);
      await _syncService.syncDirtyReligions();
    }
  }
}