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
    
  }
}