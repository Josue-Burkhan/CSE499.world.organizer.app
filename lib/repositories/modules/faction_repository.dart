import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/factions_dao.dart';
import 'package:worldorganizer_app/core/services/modules/faction_sync_service.dart';

class FactionRepository {
  final FactionsDao _dao;
  final FactionSyncService _syncService;

  FactionRepository({
    required FactionsDao dao,
    required FactionSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<FactionEntity>> watchFactionsInWorld(String worldLocalId) {
    return _dao.watchFactionsInWorld(worldLocalId);
  }
  
  Stream<FactionEntity?> watchFactionByServerId(String serverId) {
    return _dao.watchFactionByServerId(serverId);
  }

  Future<FactionEntity?> getFaction(String localId) {
    return _dao.getFactionByLocalId(localId);
  }

  Future<void> createFaction(FactionsCompanion faction) async {
    await _dao.insertFaction(faction);
    await _syncService.syncDirtyFactions();
  }

  Future<void> updateFaction(FactionsCompanion faction) async {
    final localId = faction.localId.value;
    final existing = await _dao.getFactionByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = faction;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = faction.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = faction.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = faction.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateFaction(updatedCompanion);
    await _syncService.syncDirtyFactions();
  }

  Future<void> deleteFaction(String localId) async {
    final char = await _dao.getFactionByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteFaction(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateFaction(companion);
      await _syncService.syncDirtyFactions();
    }
  }
}