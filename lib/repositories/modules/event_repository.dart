import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/events_dao.dart';

class EventRepository {
  final EventsDao _dao;

  EventRepository({required EventsDao dao}) : _dao = dao;

  Stream<List<EventEntity>> watchEventsInWorld(String worldLocalId) {
    return _dao.watchEventsInWorld(worldLocalId);
  }
  
  Stream<EventEntity?> watchEventByServerId(String serverId) {
    return _dao.watchEventByServerId(serverId);
  }

  Future<void> deleteEvent(String localId) async {
    final char = await _dao.getEventByLocalId(localId);
    if (char == null) return;

    if (char.syncStatus == SyncStatus.created) {
      await _dao.deleteEvent(localId);
    } else {
      final companion = char.toCompanion(true).copyWith(
        syncStatus: const Value(SyncStatus.deleted)
      );
      await _dao.updateEvent(companion);
    }
  }
}