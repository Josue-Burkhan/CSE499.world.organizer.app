import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/economies_dao.dart';
import 'package:worldorganizer_app/core/services/modules/economy_sync_service.dart';

class EconomyRepository {
  final EconomiesDao _dao;
  final EconomySyncService _syncService;

  EconomyRepository({
    required EconomiesDao dao,
    required EconomySyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<EconomyEntity>> watchEconomiesInWorld(String worldLocalId) {
    return _dao.watchEconomiesInWorld(worldLocalId);
  }
  
  Stream<EconomyEntity?> watchEconomyByServerId(String serverId) {
    return _dao.watchEconomyByServerId(serverId);
  }

  Future<EconomyEntity?> getEconomy(String localId) {
    return _dao.getEconomyByLocalId(localId);
  }

  Future<void> createEconomy(EconomiesCompanion economy) async {
    await _dao.insertEconomy(economy);
    await _syncService.syncDirtyEconomies();
  }

  Future<void> updateEconomy(EconomiesCompanion economy) async {
    final localId = economy.localId.value;
    final existing = await _dao.getEconomyByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = economy;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = economy.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = economy.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = economy.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateEconomy(updatedCompanion);
    await _syncService.syncDirtyEconomies();
  }

  Future<void> deleteEconomy(String localId) async {
    final char = await _dao.getEconomyByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteEconomy(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateEconomy(companion);
      await _syncService.syncDirtyEconomies();
    }
  }
}