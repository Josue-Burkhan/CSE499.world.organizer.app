import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/races_dao.dart';

class RaceRepository {
  final RacesDao _dao;

  RaceRepository({required RacesDao dao}) : _dao = dao;

  Stream<List<RaceEntity>> watchRacesInWorld(String worldLocalId) {
    return _dao.watchRacesInWorld(worldLocalId);
  }
  
  Stream<RaceEntity?> watchRaceByServerId(String serverId) {
    return _dao.watchRaceByServerId(serverId);
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
    }
  }
}