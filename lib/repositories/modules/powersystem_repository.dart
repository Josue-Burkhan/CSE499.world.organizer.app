import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/powersystems_dao.dart';

class PowerSystemRepository {
  final PowerSystemsDao _dao;

  PowerSystemRepository({required PowerSystemsDao dao}) : _dao = dao;

  Stream<List<PowerSystemEntity>> watchPowerSystemsInWorld(String worldLocalId) {
    return _dao.watchPowerSystemsInWorld(worldLocalId);
  }
  
  Stream<PowerSystemEntity?> watchPowerSystemByServerId(String serverId) {
    return _dao.watchPowerSystemByServerId(serverId);
  }

  Future<void> deletePowerSystem(String localId) async {
    final char = await _dao.getPowerSystemByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deletePowerSystem(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updatePowerSystem(companion);
    }
  }
}