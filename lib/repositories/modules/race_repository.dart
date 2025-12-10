import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/races_dao.dart';
import 'package:worldorganizer_app/core/services/modules/race_sync_service.dart';

class RaceRepository {
  final RacesDao _dao;
  final RaceSyncService _syncService;

  RaceRepository({
    required RacesDao dao,
    required RaceSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<RaceEntity>> watchRacesInWorld(String worldLocalId) {
    return _dao.watchRacesInWorld(worldLocalId);
  }
  
  Stream<RaceEntity?> watchRaceByServerId(String serverId) {
    return _dao.watchRaceByServerId(serverId);
  }

  Future<RaceEntity?> getRace(String localId) {
    return _dao.getRaceByLocalId(localId);
  }

  Future<void> createRace(RacesCompanion race) async {
    await _dao.insertRace(race);
    await _syncService.syncDirtyRaces();
  }

  Future<void> updateRace(RacesCompanion race) async {
    final localId = race.localId.value;
    final existing = await _dao.getRaceByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = race;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = race.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = race.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = race.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateRace(updatedCompanion);
    await _syncService.syncDirtyRaces();
  }

  Future<void> deleteRace(String localId) async {
    final char = await _dao.getRaceByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteRace(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateRace(companion);
      await _syncService.syncDirtyRaces();
    }
  }
}