import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/races_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/race_model.dart';

class RaceSyncService {
  final RacesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/races';

  RaceSyncService({
    required RacesDao dao,
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

  Future<void> fetchAndMergeRaces(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch races: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> raceList = body['races'];
      final apiRaces = raceList.map((j) => Race.fromJson(j)).toList();

      for (final apiRace in apiRaces) {
        final existing = await _dao.getRaceByServerId(apiRace.id);
        
        final companion = RacesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiRace.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiRace.name),
          description: d.Value(apiRace.description),
          traits: d.Value(apiRace.traits),
          lifespan: d.Value(apiRace.lifespan),
          averageHeight: d.Value(apiRace.averageHeight),
          averageWeight: d.Value(apiRace.averageWeight),
          culture: d.Value(apiRace.culture),
          isExtinct: d.Value(apiRace.isExtinct),
          tagColor: d.Value(apiRace.tagColor),
          images: d.Value(apiRace.images),
          rawLanguages: d.Value(apiRace.rawLanguages),
          rawCharacters: d.Value(apiRace.rawCharacters),
          rawLocations: d.Value(apiRace.rawLocations),
          rawReligions: d.Value(apiRace.rawReligions),
          rawStories: d.Value(apiRace.rawStories),
          rawEvents: d.Value(apiRace.rawEvents),
          rawPowerSystems: d.Value(apiRace.rawPowerSystems),
          rawTechnologies: d.Value(apiRace.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertRace(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge races: $e');
    }
  }

  Future<void> fetchAndMergeSingleRace(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch race $serverId: ${response.statusCode}');
      }

      final apiRace = Race.fromJson(jsonDecode(response.body));
      if (apiRace.worldId == null) {
        throw Exception('Race from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiRace.worldId!);
      if (world == null) {
        throw Exception('Race\'s world is not synced locally');
      }

      final existing = await _dao.getRaceByServerId(apiRace.id);
      
      final companion = RacesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiRace.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiRace.name),
        description: d.Value(apiRace.description),
        traits: d.Value(apiRace.traits),
        lifespan: d.Value(apiRace.lifespan),
        averageHeight: d.Value(apiRace.averageHeight),
        averageWeight: d.Value(apiRace.averageWeight),
        culture: d.Value(apiRace.culture),
        isExtinct: d.Value(apiRace.isExtinct),
        tagColor: d.Value(apiRace.tagColor),
        images: d.Value(apiRace.images),
        rawLanguages: d.Value(apiRace.rawLanguages),
        rawCharacters: d.Value(apiRace.rawCharacters),
        rawLocations: d.Value(apiRace.rawLocations),
        rawReligions: d.Value(apiRace.rawReligions),
        rawStories: d.Value(apiRace.rawStories),
        rawEvents: d.Value(apiRace.rawEvents),
        rawPowerSystems: d.Value(apiRace.rawPowerSystems),
        rawTechnologies: d.Value(apiRace.rawTechnologies),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertRace(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single race: $e');
    }
  }

  Future<void> syncDirtyRaces() async {
    final dirtyRaces = await _dao.getDirtyRaces();
    if (dirtyRaces.isEmpty) return;
    
  }
}