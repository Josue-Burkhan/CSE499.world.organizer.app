import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/creatures_dao.dart';

class CreatureRepository {
  final CreaturesDao _dao;

  CreatureRepository({required CreaturesDao dao}) : _dao = dao;

  Stream<List<CreatureEntity>> watchCreaturesInWorld(String worldLocalId) {
    return _dao.watchCreaturesInWorld(worldLocalId);
  }
  
  Stream<CreatureEntity?> watchCreatureByServerId(String serverId) {
    return _dao.watchCreatureByServerId(serverId);
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
    }
  }
}