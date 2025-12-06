import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/creatures_dao.dart';
import 'package:worldorganizer_app/core/services/modules/creature_sync_service.dart';

class CreatureRepository {
  final CreaturesDao _dao;
  final CreatureSyncService _syncService;

  CreatureRepository({
    required CreaturesDao dao,
    required CreatureSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<CreatureEntity>> watchCreaturesInWorld(String worldLocalId) {
    return _dao.watchCreaturesInWorld(worldLocalId);
  }
  
  Stream<CreatureEntity?> watchCreatureByServerId(String serverId) {
    return _dao.watchCreatureByServerId(serverId);
  }

  Future<CreatureEntity?> getCreature(String localId) {
    return _dao.getCreatureByLocalId(localId);
  }

  Future<void> createCreature(CreaturesCompanion creature) async {
    await _dao.insertCreature(creature);
    await _syncService.syncDirtyCreatures();
  }

  Future<void> updateCreature(CreaturesCompanion creature) async {
    final localId = creature.localId.value;
    final existing = await _dao.getCreatureByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = creature;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = creature.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = creature.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = creature.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateCreature(updatedCompanion);
    await _syncService.syncDirtyCreatures();
  }

  Future<void> deleteCreature(String localId) async {
    final char = await _dao.getCreatureByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteCreature(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateCreature(companion);
      await _syncService.syncDirtyCreatures();
    }
  }
}