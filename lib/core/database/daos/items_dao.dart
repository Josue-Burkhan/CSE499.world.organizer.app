import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/items.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [Items])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(AppDatabase db) : super(db);

  Stream<List<ItemEntity>> watchItemsInWorld(String worldLocalId) {
    return (select(items)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<ItemEntity?> watchItemByServerId(String serverId) {
    return (select(items)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<ItemEntity?> getItemByServerId(String serverId) {
    return (select(items)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<ItemEntity>> getDirtyItems() {
    return (select(items)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertItem(ItemsCompanion item) {
    return into(items).insert(item, mode: InsertMode.replace);
  }

  Future<void> updateItem(ItemsCompanion item) {
    return update(items).replace(item);
  }

  Future<void> deleteItem(String localId) {
    return (delete(items)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<ItemEntity?> getItemByLocalId(String localId) {
    return (select(items)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
  Future<List<ItemEntity>> getAllItems() {
    return select(items).get();
  }
}