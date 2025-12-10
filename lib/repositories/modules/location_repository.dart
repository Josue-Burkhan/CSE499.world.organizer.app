import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/locations_dao.dart';
import 'package:worldorganizer_app/core/services/modules/location_sync_service.dart';

class LocationRepository {
  final LocationsDao _dao;
  final LocationSyncService _syncService;

  LocationRepository({
    required LocationsDao dao,
    required LocationSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<LocationEntity>> watchLocationsInWorld(String worldLocalId) {
    return _dao.watchLocationsInWorld(worldLocalId);
  }
  
  Stream<LocationEntity?> watchLocationByServerId(String serverId) {
    return _dao.watchLocationByServerId(serverId);
  }

  Future<LocationEntity?> getLocation(String localId) {
    return _dao.getLocationByLocalId(localId);
  }

  Future<void> createLocation(LocationsCompanion location) async {
    await _dao.insertLocation(location);
    await _syncService.syncDirtyLocations();
  }

  Future<void> updateLocation(LocationsCompanion location) async {
    final localId = location.localId.value;
    final existing = await _dao.getLocationByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = location;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = location.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = location.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = location.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateLocation(updatedCompanion);
    await _syncService.syncDirtyLocations();
  }

  Future<void> deleteLocation(String localId) async {
    final char = await _dao.getLocationByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteLocation(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateLocation(companion);
      await _syncService.syncDirtyLocations();
    }
  }
}