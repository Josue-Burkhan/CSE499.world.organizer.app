import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/events.dart';

part 'events_dao.g.dart';

@DriftAccessor(tables: [Events])
class EventsDao extends DatabaseAccessor<AppDatabase> with _$EventsDaoMixin {
  EventsDao(AppDatabase db) : super(db);

  Stream<List<EventEntity>> watchEventsInWorld(String worldLocalId) {
    return (select(events)
          ..where((t) => t.worldLocalId.equals(worldLocalId))
          ..where((t) => t.syncStatus.equals('deleted').not()))
          .watch();
  }

  Stream<EventEntity?> watchEventByServerId(String serverId) {
    return (select(events)
          ..where((t) => t.serverId.equals(serverId)))
          .watchSingleOrNull();
  }

  Future<EventEntity?> getEventByServerId(String serverId) {
    return (select(events)
          ..where((t) => t.serverId.equals(serverId)))
          .getSingleOrNull();
  }

  Future<List<EventEntity>> getDirtyEvents() {
    return (select(events)
          ..where((t) => t.syncStatus.equals('synced').not()))
          .get();
  }

  Future<void> insertEvent(EventsCompanion event) {
    return into(events).insert(event, mode: InsertMode.replace);
  }

  Future<void> updateEvent(EventsCompanion event) {
    return update(events).replace(event);
  }

  Future<void> deleteEvent(String localId) {
    return (delete(events)
          ..where((t) => t.localId.equals(localId)))
          .go();
  }

  Future<EventEntity?> getEventByLocalId(String localId) {
    return (select(events)
          ..where((t) => t.localId.equals(localId)))
          .getSingleOrNull();
  }
}