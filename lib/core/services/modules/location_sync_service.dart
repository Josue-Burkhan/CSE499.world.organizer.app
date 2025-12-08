import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/locations_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/location_model.dart';

class LocationSyncService {
  final LocationsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/locations';

  LocationSyncService({
    required LocationsDao dao,
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

  Future<void> fetchAndMergeLocations(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch locations: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> locList = body['locations'];
      final apiLocs = locList.map((j) => Location.fromJson(j)).toList();

      for (final apiLoc in apiLocs) {
        final existing = await _dao.getLocationByServerId(apiLoc.id);
        
        final companion = LocationsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiLoc.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiLoc.name),
          description: d.Value(apiLoc.description),
          climate: d.Value(apiLoc.climate),
          terrain: d.Value(apiLoc.terrain),
          population: d.Value(apiLoc.population?.toDouble()),
          economy: d.Value(apiLoc.economy),
          customNotes: d.Value(apiLoc.customNotes),
          tagColor: d.Value(apiLoc.tagColor),
          images: d.Value(apiLoc.images),
          rawLocations: d.Value(apiLoc.rawLocations),
          rawFactions: d.Value(apiLoc.rawFactions),
          rawEvents: d.Value(apiLoc.rawEvents),
          rawCharacters: d.Value(apiLoc.rawCharacters),
          rawItems: d.Value(apiLoc.rawItems),
          rawCreatures: d.Value(apiLoc.rawCreatures),
          rawStories: d.Value(apiLoc.rawStories),
          rawLanguages: d.Value(apiLoc.rawLanguages),
          rawReligions: d.Value(apiLoc.rawReligions),
          rawTechnologies: d.Value(apiLoc.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertLocation(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge locations: $e');
    }
  }

  Future<void> fetchAndMergeSingleLocation(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch location $serverId: ${response.statusCode}');
      }

      final apiLoc = Location.fromJson(jsonDecode(response.body));
      if (apiLoc.worldId == null) {
        throw Exception('Location from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiLoc.worldId!);
      if (world == null) {
        throw Exception('Location\'s world is not synced locally');
      }

      final existing = await _dao.getLocationByServerId(apiLoc.id);
      
      final companion = LocationsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiLoc.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiLoc.name),
        description: d.Value(apiLoc.description),
        climate: d.Value(apiLoc.climate),
        terrain: d.Value(apiLoc.terrain),
        population: d.Value(apiLoc.population?.toDouble()),
        economy: d.Value(apiLoc.economy),
        customNotes: d.Value(apiLoc.customNotes),
        tagColor: d.Value(apiLoc.tagColor),
        images: d.Value(apiLoc.images),
        rawLocations: d.Value(apiLoc.rawLocations),
        rawFactions: d.Value(apiLoc.rawFactions),
        rawEvents: d.Value(apiLoc.rawEvents),
        rawCharacters: d.Value(apiLoc.rawCharacters),
        rawItems: d.Value(apiLoc.rawItems),
        rawCreatures: d.Value(apiLoc.rawCreatures),
        rawStories: d.Value(apiLoc.rawStories),
        rawLanguages: d.Value(apiLoc.rawLanguages),
        rawReligions: d.Value(apiLoc.rawReligions),
        rawTechnologies: d.Value(apiLoc.rawTechnologies),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertLocation(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single location: $e');
    }
  }

  Future<void> syncDirtyLocations() async {
    final dirtyLocs = await _dao.getDirtyLocations();
    if (dirtyLocs.isEmpty) return;
    for (final loc in dirtyLocs) {
      try {
        if (loc.syncStatus == SyncStatus.created) {
          await _syncCreatedLocation(loc);
        } else if (loc.syncStatus == SyncStatus.edited) {
          await _syncEditedLocation(loc);
        } else if (loc.syncStatus == SyncStatus.deleted) {
          await _syncDeletedLocation(loc);
        }
      } catch (e) {
        print('Error syncing location ${loc.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedLocation(LocationEntity loc) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(loc.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync location for unsynced world');
    }

    final body = _createBodyFromEntity(loc, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiLoc = Location.fromJson(jsonDecode(response.body));
      final companion = loc.toCompanion(true).copyWith(
        serverId: d.Value(apiLoc.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateLocation(companion);
    } else {
      throw Exception('Failed to create location: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedLocation(LocationEntity loc) async {
    if (loc.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(loc.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(loc, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${loc.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = loc.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateLocation(companion);
    } else {
      throw Exception('Failed to update location: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedLocation(LocationEntity loc) async {
    if (loc.serverId == null) {
      await _dao.deleteLocation(loc.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${loc.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteLocation(loc.localId);
    } else {
      throw Exception('Failed to delete location: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(LocationEntity loc, String worldServerId) {
    return {
      'world': worldServerId,
      'name': loc.name,
      'description': loc.description,
      'climate': loc.climate,
      'terrain': loc.terrain,
      'population': loc.population,
      'economy': loc.economy,
      'customNotes': loc.customNotes,
      'tagColor': loc.tagColor,
      'images': loc.images,
      
      'rawLocations': loc.rawLocations,
      'rawFactions': loc.rawFactions,
      'rawEvents': loc.rawEvents,
      'rawCharacters': loc.rawCharacters,
      'rawItems': loc.rawItems,
      'rawCreatures': loc.rawCreatures,
      'rawStories': loc.rawStories,
      'rawLanguages': loc.rawLanguages,
      'rawReligions': loc.rawReligions,
      'rawTechnologies': loc.rawTechnologies,
    };
  }
}