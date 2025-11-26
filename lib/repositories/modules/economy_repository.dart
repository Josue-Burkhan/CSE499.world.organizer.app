import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/economies_dao.dart';

class EconomyRepository {
  final EconomiesDao _dao;

  EconomyRepository({required EconomiesDao dao}) : _dao = dao;

  Stream<List<EconomyEntity>> watchEconomiesInWorld(String worldLocalId) {
    return _dao.watchEconomiesInWorld(worldLocalId);
  }
  
  Stream<EconomyEntity?> watchEconomyByServerId(String serverId) {
    return _dao.watchEconomyByServerId(serverId);
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
    }
  }
}