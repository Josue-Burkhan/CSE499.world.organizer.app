import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/technologies_dao.dart';

class TechnologyRepository {
  final TechnologiesDao _dao;

  TechnologyRepository({required TechnologiesDao dao}) : _dao = dao;

  Stream<List<TechnologyEntity>> watchTechnologiesInWorld(String worldLocalId) {
    return _dao.watchTechnologiesInWorld(worldLocalId);
  }
  
  Stream<TechnologyEntity?> watchTechnologyByServerId(String serverId) {
    return _dao.watchTechnologyByServerId(serverId);
  }

  Future<void> deleteTechnology(String localId) async {
    final char = await _dao.getTechnologyByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteTechnology(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateTechnology(companion);
    }
  }
}