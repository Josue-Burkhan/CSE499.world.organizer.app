import 'package:drift/drift.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/events_dao.dart';
import 'package:worldorganizer_app/core/services/modules/event_sync_service.dart';

class EventRepository {
  final EventsDao _dao;
  final EventSyncService _syncService;

  EventRepository({
    required EventsDao dao,
    required EventSyncService syncService,
  }) : _dao = dao,
       _syncService = syncService;

  Stream<List<EventEntity>> watchEventsInWorld(String worldLocalId) {
    return _dao.watchEventsInWorld(worldLocalId);
  }
  
  Stream<EventEntity?> watchEventByServerId(String serverId) {
    return _dao.watchEventByServerId(serverId);
  }

  Future<EventEntity?> getEvent(String localId) {
    return _dao.getEventByLocalId(localId);
  }

  Future<void> createEvent(EventsCompanion event) async {
    await _dao.insertEvent(event);
    await _syncService.syncDirtyEvents();
  }

  Future<void> updateEvent(EventsCompanion event) async {
    final localId = event.localId.value;
    final existing = await _dao.getEventByLocalId(localId);

    if (existing == null) return;

    var updatedCompanion = event;

    // Logic for syncStatus
    if (existing.syncStatus == SyncStatus.synced) {
      updatedCompanion = event.copyWith(syncStatus: const Value(SyncStatus.edited));
    } else if (existing.syncStatus == SyncStatus.created) {
      updatedCompanion = event.copyWith(syncStatus: const Value(SyncStatus.created));
    } else if (existing.syncStatus == SyncStatus.edited) {
      updatedCompanion = event.copyWith(syncStatus: const Value(SyncStatus.edited));
    }

    await _dao.updateEvent(updatedCompanion);
    await _syncService.syncDirtyEvents();
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
      await _syncService.syncDirtyEvents();
    }
  }
}