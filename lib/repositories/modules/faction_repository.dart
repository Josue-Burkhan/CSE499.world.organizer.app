import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/factions_dao.dart';

class FactionRepository {
  final FactionsDao _dao;

  FactionRepository({required FactionsDao dao}) : _dao = dao;

  Stream<List<FactionEntity>> watchFactionsInWorld(String worldLocalId) {
    return _dao.watchFactionsInWorld(worldLocalId);
  }
  
  Stream<FactionEntity?> watchFactionByServerId(String serverId) {
    return _dao.watchFactionByServerId(serverId);
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
    }
  }
}