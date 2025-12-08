import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/technologies_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/technology_model.dart';

class TechnologySyncService {
  final TechnologiesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/technologies';

  TechnologySyncService({
    required TechnologiesDao dao,
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

  Future<void> fetchAndMergeTechnologies(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch technologies: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> techList = body['technologies'];
      final apiTechnologies = techList.map((j) => Technology.fromJson(j)).toList();

      for (final apiTech in apiTechnologies) {
        final existing = await _dao.getTechnologyByServerId(apiTech.id);
        
        final companion = TechnologiesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiTech.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiTech.name),
          description: d.Value(apiTech.description),
          techType: d.Value(apiTech.techType),
          origin: d.Value(apiTech.origin),
          yearCreated: d.Value(apiTech.yearCreated?.toDouble()),
          currentUse: d.Value(apiTech.currentUse),
          limitations: d.Value(apiTech.limitations),
          energySource: d.Value(apiTech.energySource),
          customNotes: d.Value(apiTech.customNotes),
          tagColor: d.Value(apiTech.tagColor),
          images: d.Value(apiTech.images),
          rawCreators: d.Value(apiTech.rawCreators),
          rawCharacters: d.Value(apiTech.rawCharacters),
          rawFactions: d.Value(apiTech.rawFactions),
          rawItems: d.Value(apiTech.rawItems),
          rawEvents: d.Value(apiTech.rawEvents),
          rawStories: d.Value(apiTech.rawStories),
          rawLocations: d.Value(apiTech.rawLocations),
          rawPowerSystems: d.Value(apiTech.rawPowerSystems),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertTechnology(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge technologies: $e');
    }
  }

  Future<void> fetchAndMergeSingleTechnology(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch technology $serverId: ${response.statusCode}');
      }

      final apiTech = Technology.fromJson(jsonDecode(response.body));
      if (apiTech.worldId == null) {
        throw Exception('Technology from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiTech.worldId!);
      if (world == null) {
        throw Exception('Technology\'s world is not synced locally');
      }

      final existing = await _dao.getTechnologyByServerId(apiTech.id);
      
      final companion = TechnologiesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiTech.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiTech.name),
        description: d.Value(apiTech.description),
        techType: d.Value(apiTech.techType),
        origin: d.Value(apiTech.origin),
        yearCreated: d.Value(apiTech.yearCreated?.toDouble()),
        currentUse: d.Value(apiTech.currentUse),
        limitations: d.Value(apiTech.limitations),
        energySource: d.Value(apiTech.energySource),
        customNotes: d.Value(apiTech.customNotes),
        tagColor: d.Value(apiTech.tagColor),
        images: d.Value(apiTech.images),
        rawCreators: d.Value(apiTech.rawCreators),
        rawCharacters: d.Value(apiTech.rawCharacters),
        rawFactions: d.Value(apiTech.rawFactions),
        rawItems: d.Value(apiTech.rawItems),
        rawEvents: d.Value(apiTech.rawEvents),
        rawStories: d.Value(apiTech.rawStories),
        rawLocations: d.Value(apiTech.rawLocations),
        rawPowerSystems: d.Value(apiTech.rawPowerSystems),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertTechnology(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single technology: $e');
    }
  }

  Future<void> syncDirtyTechnologies() async {
    final dirtyTechnologies = await _dao.getDirtyTechnologies();
    if (dirtyTechnologies.isEmpty) return;
    for (final tech in dirtyTechnologies) {
      try {
        if (tech.syncStatus == SyncStatus.created) {
          await _syncCreatedTechnology(tech);
        } else if (tech.syncStatus == SyncStatus.edited) {
          await _syncEditedTechnology(tech);
        } else if (tech.syncStatus == SyncStatus.deleted) {
          await _syncDeletedTechnology(tech);
        }
      } catch (e) {
        print('Error syncing technology ${tech.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedTechnology(TechnologyEntity tech) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(tech.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync technology for unsynced world');
    }

    final body = _createBodyFromEntity(tech, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiTech = Technology.fromJson(jsonDecode(response.body));
      final companion = tech.toCompanion(true).copyWith(
        serverId: d.Value(apiTech.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateTechnology(companion);
    } else {
      throw Exception('Failed to create technology: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedTechnology(TechnologyEntity tech) async {
    if (tech.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(tech.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(tech, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${tech.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = tech.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateTechnology(companion);
    } else {
      throw Exception('Failed to update technology: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedTechnology(TechnologyEntity tech) async {
    if (tech.serverId == null) {
      await _dao.deleteTechnology(tech.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${tech.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteTechnology(tech.localId);
    } else {
      throw Exception('Failed to delete technology: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(TechnologyEntity tech, String worldServerId) {
    return {
      'world': worldServerId,
      'name': tech.name,
      'description': tech.description,
      'techType': tech.techType,
      'origin': tech.origin,
      'yearCreated': tech.yearCreated,
      'currentUse': tech.currentUse,
      'limitations': tech.limitations,
      'energySource': tech.energySource,
      'customNotes': tech.customNotes,
      'tagColor': tech.tagColor,
      'images': tech.images,
      
      'rawCreators': tech.rawCreators,
      'rawCharacters': tech.rawCharacters,
      'rawFactions': tech.rawFactions,
      'rawItems': tech.rawItems,
      'rawEvents': tech.rawEvents,
      'rawStories': tech.rawStories,
      'rawLocations': tech.rawLocations,
      'rawPowerSystems': tech.rawPowerSystems,
    };
  }
}