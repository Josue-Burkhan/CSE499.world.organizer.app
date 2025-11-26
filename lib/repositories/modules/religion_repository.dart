import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/religions_dao.dart';

class ReligionRepository {
  final ReligionsDao _dao;

  ReligionRepository({required ReligionsDao dao}) : _dao = dao;

  Stream<List<ReligionEntity>> watchReligionsInWorld(String worldLocalId) {
    return _dao.watchReligionsInWorld(worldLocalId);
  }
  
  Stream<ReligionEntity?> watchReligionByServerId(String serverId) {
    return _dao.watchReligionByServerId(serverId);
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
    }
  }
}