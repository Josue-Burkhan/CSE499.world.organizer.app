import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/items_dao.dart';
import 'package:worldorganizer_app/core/services/modules/item_sync_service.dart';

class ItemRepository {
  final ItemsDao _dao;
  final ItemSyncService _syncService;

  ItemRepository({
    required ItemsDao dao,
    required ItemSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<ItemEntity>> watchItemsInWorld(String worldLocalId) {
    return _dao.watchItemsInWorld(worldLocalId);
  }
  
  Stream<ItemEntity?> watchItemByServerId(String serverId) {
    return _dao.watchItemByServerId(serverId);
  }

  Future<ItemEntity?> getItem(String localId) {
    return _dao.getItemByLocalId(localId);
  }

  Future<void> createItem(ItemsCompanion item) async {
    await _dao.insertItem(item);
    await _syncService.syncDirtyItems();
  }

  Future<void> updateItem(ItemsCompanion item) async {
    final localId = item.localId.value;
    final existing = await _dao.getItemByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = item;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = item.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = item.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = item.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateItem(updatedCompanion);
    await _syncService.syncDirtyItems();
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
      await _syncService.syncDirtyItems();
    }
  }
}