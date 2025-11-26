import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/items_dao.dart';

class ItemRepository {
  final ItemsDao _dao;

  ItemRepository({required ItemsDao dao}) : _dao = dao;

  Stream<List<ItemEntity>> watchItemsInWorld(String worldLocalId) {
    return _dao.watchItemsInWorld(worldLocalId);
  }
  
  Stream<ItemEntity?> watchItemByServerId(String serverId) {
    return _dao.watchItemByServerId(serverId);
  }

  Future<void> deleteItem(String localId) async {
    final char = await _dao.getItemByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteItem(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateItem(companion);
    }
  }
}