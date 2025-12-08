import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/events_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/event_model.dart';

class EventSyncService {
  final EventsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/events';

  EventSyncService({
    required EventsDao dao,
    required WorldsDao worldsDao,
    required FlutterSecureStorage storage,
  })  : _dao = dao,
        _worldsDao = worldsDao,
        _storage = storage;

  Future<String?> _getToken() => _storage.read(key: 'token');

  Future<Map<String, String>> _getHeaders() async {
    final token = await _getToken();
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  Future<void> fetchAndMergeEvents(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch events: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> eventList = body['events'];
      final apiEvents = eventList.map((j) => Event.fromJson(j)).toList();

      for (final apiEvent in apiEvents) {
        final existing = await _dao.getEventByServerId(apiEvent.id);
        
        final companion = EventsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiEvent.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiEvent.name),
          date: d.Value(apiEvent.date),
          description: d.Value(apiEvent.description),
          customNotes: d.Value(apiEvent.customNotes),
          tagColor: d.Value(apiEvent.tagColor),
          images: d.Value(apiEvent.images),
          rawCharacters: d.Value(apiEvent.rawCharacters),
          rawFactions: d.Value(apiEvent.rawFactions),
          rawLocations: d.Value(apiEvent.rawLocations),
          rawItems: d.Value(apiEvent.rawItems),
          rawAbilities: d.Value(apiEvent.rawAbilities),
          rawStories: d.Value(apiEvent.rawStories),
          rawPowerSystems: d.Value(apiEvent.rawPowerSystems),
          rawCreatures: d.Value(apiEvent.rawCreatures),
          rawReligions: d.Value(apiEvent.rawReligions),
          rawTechnologies: d.Value(apiEvent.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertEvent(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge events: $e');
    }
  }

  Future<void> fetchAndMergeSingleEvent(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch event $serverId: ${response.statusCode}');
      }

      final apiEvent = Event.fromJson(jsonDecode(response.body));
      if (apiEvent.worldId == null) {
        throw Exception('Event from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiEvent.worldId!);
      if (world == null) {
        throw Exception('Event\'s world is not synced locally');
      }

      final existing = await _dao.getEventByServerId(apiEvent.id);
      
      final companion = EventsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiEvent.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiEvent.name),
        date: d.Value(apiEvent.date),
        description: d.Value(apiEvent.description),
        customNotes: d.Value(apiEvent.customNotes),
        tagColor: d.Value(apiEvent.tagColor),
        images: d.Value(apiEvent.images),
        rawCharacters: d.Value(apiEvent.rawCharacters),
        rawFactions: d.Value(apiEvent.rawFactions),
        rawLocations: d.Value(apiEvent.rawLocations),
        rawItems: d.Value(apiEvent.rawItems),
        rawAbilities: d.Value(apiEvent.rawAbilities),
        rawStories: d.Value(apiEvent.rawStories),
        rawPowerSystems: d.Value(apiEvent.rawPowerSystems),
        rawCreatures: d.Value(apiEvent.rawCreatures),
        rawReligions: d.Value(apiEvent.rawReligions),
        rawTechnologies: d.Value(apiEvent.rawTechnologies),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertEvent(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single event: $e');
    }
  }

  Future<void> syncDirtyEvents() async {
    final dirtyEvents = await _dao.getDirtyEvents();
    if (dirtyEvents.isEmpty) return;
    
    for (final event in dirtyEvents) {
      try {
        if (event.syncStatus == SyncStatus.created) {
          await _syncCreatedEvent(event);
        } else if (event.syncStatus == SyncStatus.edited) {
          await _syncEditedEvent(event);
        } else if (event.syncStatus == SyncStatus.deleted) {
          await _syncDeletedEvent(event);
        }
      } catch (e) {
        print('Error syncing event ${event.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedEvent(EventEntity event) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(event.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync event for unsynced world');
    }

    final body = _createBodyFromEntity(event, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiEvent = Event.fromJson(jsonDecode(response.body));
      final companion = event.toCompanion(true).copyWith(
        serverId: d.Value(apiEvent.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateEvent(companion);
    } else {
      throw Exception('Failed to create event: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedEvent(EventEntity event) async {
    if (event.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(event.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(event, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${event.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = event.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateEvent(companion);
    } else {
      throw Exception('Failed to update event: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedEvent(EventEntity event) async {
    if (event.serverId == null) {
      await _dao.deleteEvent(event.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${event.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteEvent(event.localId);
    } else {
      throw Exception('Failed to delete event: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(EventEntity event, String worldServerId) {
    return {
      'world': worldServerId,
      'name': event.name,
      'date': event.date,
      'description': event.description,
      'customNotes': event.customNotes,
      'tagColor': event.tagColor,
      'images': event.images,
      
      'rawCharacters': event.rawCharacters,
      'rawFactions': event.rawFactions,
      'rawLocations': event.rawLocations,
      'rawItems': event.rawItems,
      'rawAbilities': event.rawAbilities,
      'rawStories': event.rawStories,
      'rawPowerSystems': event.rawPowerSystems,
      'rawCreatures': event.rawCreatures,
      'rawReligions': event.rawReligions,
      'rawTechnologies': event.rawTechnologies,
    };
  }
}