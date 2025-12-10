import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/powersystems_dao.dart';
import 'package:worldorganizer_app/core/services/modules/powersystem_sync_service.dart';

class PowerSystemRepository {
  final PowerSystemsDao _dao;
  final PowerSystemSyncService _syncService;

  PowerSystemRepository({
    required PowerSystemsDao dao,
    required PowerSystemSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<PowerSystemEntity>> watchPowerSystemsInWorld(String worldLocalId) {
    return _dao.watchPowerSystemsInWorld(worldLocalId);
  }
  
  Stream<PowerSystemEntity?> watchPowerSystemByServerId(String serverId) {
    return _dao.watchPowerSystemByServerId(serverId);
  }

  Future<PowerSystemEntity?> getPowerSystem(String localId) {
    return _dao.getPowerSystemByLocalId(localId);
  }

  Future<void> createPowerSystem(PowerSystemsCompanion powerSystem) async {
    await _dao.insertPowerSystem(powerSystem);
    await _syncService.syncDirtyPowerSystems();
  }

  Future<void> updatePowerSystem(PowerSystemsCompanion powerSystem) async {
    final localId = powerSystem.localId.value;
    final existing = await _dao.getPowerSystemByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = powerSystem;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = powerSystem.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = powerSystem.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = powerSystem.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updatePowerSystem(updatedCompanion);
    await _syncService.syncDirtyPowerSystems();
  }

  Future<void> deletePowerSystem(String localId) async {
    final char = await _dao.getPowerSystemByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deletePowerSystem(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updatePowerSystem(companion);
      await _syncService.syncDirtyPowerSystems();
    }
  }
}
