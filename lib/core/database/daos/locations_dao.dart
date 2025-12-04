import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/locations.dart';

part 'locations_dao.g.dart';

@DriftAccessor(tables: [Locations])
class LocationsDao extends DatabaseAccessor<AppDatabase> with _$LocationsDaoMixin {
  LocationsDao(AppDatabase db) : super(db);

  Stream<List<LocationEntity>> watchLocationsInWorld(String worldLocalId) {
    return (select(locations)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
        .watch();
  }

  Stream<LocationEntity?> watchLocationByServerId(String serverId) {
    return (select(locations)
          ..where((t) => t.serverId.equals(serverId)))
        .watchSingleOrNull();
  }

  Future<LocationEntity?> getLocationByServerId(String serverId) {
    return (select(locations)
          ..where((t) => t.serverId.equals(serverId)))
        .getSingleOrNull();
  }

  Future<List<LocationEntity>> getDirtyLocations() {
    return (select(locations)
          ..where((t) => t.syncStatus.equals('synced').not()))
        .get();
  }

  Future<void> insertLocation(LocationsCompanion location) {
    return into(locations).insert(location, mode: InsertMode.replace);
  }

  Future<void> updateLocation(LocationsCompanion location) {
    return update(locations).replace(location);
  }

  Future<void> deleteLocation(String localId) {
    return (delete(locations)
          ..where((t) => t.localId.equals(localId)))
        .go();
  }

  Future<LocationEntity?> getLocationByLocalId(String localId) {
    return (select(locations)
          ..where((t) => t.localId.equals(localId)))
        .getSingleOrNull();
  }
  Future<List<LocationEntity>> getAllLocations() {
    return select(locations).get();
  }
}