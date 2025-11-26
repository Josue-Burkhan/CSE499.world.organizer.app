import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/locations_dao.dart';

class LocationRepository {
  final LocationsDao _dao;

  LocationRepository({required LocationsDao dao}) : _dao = dao;

  Stream<List<LocationEntity>> watchLocationsInWorld(String worldLocalId) {
    return _dao.watchLocationsInWorld(worldLocalId);
  }
  
  Stream<LocationEntity?> watchLocationByServerId(String serverId) {
    return _dao.watchLocationByServerId(serverId);
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
    }
  }
}