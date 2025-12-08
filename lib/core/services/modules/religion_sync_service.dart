import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/religions_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/religion_model.dart';

class ReligionSyncService {
  final ReligionsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/religions';

  ReligionSyncService({
    required ReligionsDao dao,
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

  Future<void> fetchAndMergeReligions(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch religions: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> religionList = body['religions'];
      final apiReligions = religionList.map((j) => Religion.fromJson(j)).toList();

      for (final apiReligion in apiReligions) {
        final existing = await _dao.getReligionByServerId(apiReligion.id);
        
        final companion = ReligionsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiReligion.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiReligion.name),
          description: d.Value(apiReligion.description),
          deityNames: d.Value(apiReligion.deityNames),
          originStory: d.Value(apiReligion.originStory),
          practices: d.Value(apiReligion.practices),
          taboos: d.Value(apiReligion.taboos),
          sacredTexts: d.Value(apiReligion.sacredTexts),
          festivals: d.Value(apiReligion.festivals),
          symbols: d.Value(apiReligion.symbols),
          customNotes: d.Value(apiReligion.customNotes),
          tagColor: d.Value(apiReligion.tagColor),
          images: d.Value(apiReligion.images),
          rawCharacters: d.Value(apiReligion.rawCharacters),
          rawFactions: d.Value(apiReligion.rawFactions),
          rawLocations: d.Value(apiReligion.rawLocations),
          rawCreatures: d.Value(apiReligion.rawCreatures),
          rawEvents: d.Value(apiReligion.rawEvents),
          rawPowerSystems: d.Value(apiReligion.rawPowerSystems),
          rawStories: d.Value(apiReligion.rawStories),
          rawTechnologies: d.Value(apiReligion.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertReligion(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge religions: $e');
    }
  }

  Future<void> fetchAndMergeSingleReligion(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch religion $serverId: ${response.statusCode}');
      }

      final apiReligion = Religion.fromJson(jsonDecode(response.body));
      if (apiReligion.worldId == null) {
        throw Exception('Religion from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiReligion.worldId!);
      if (world == null) {
        throw Exception('Religion\'s world is not synced locally');
      }

      final existing = await _dao.getReligionByServerId(apiReligion.id);
      
      final companion = ReligionsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiReligion.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiReligion.name),
        description: d.Value(apiReligion.description),
        deityNames: d.Value(apiReligion.deityNames),
        originStory: d.Value(apiReligion.originStory),
        practices: d.Value(apiReligion.practices),
        taboos: d.Value(apiReligion.taboos),
        sacredTexts: d.Value(apiReligion.sacredTexts),
        festivals: d.Value(apiReligion.festivals),
        symbols: d.Value(apiReligion.symbols),
        customNotes: d.Value(apiReligion.customNotes),
        tagColor: d.Value(apiReligion.tagColor),
        images: d.Value(apiReligion.images),
        rawCharacters: d.Value(apiReligion.rawCharacters),
        rawFactions: d.Value(apiReligion.rawFactions),
        rawLocations: d.Value(apiReligion.rawLocations),
        rawCreatures: d.Value(apiReligion.rawCreatures),
        rawEvents: d.Value(apiReligion.rawEvents),
        rawPowerSystems: d.Value(apiReligion.rawPowerSystems),
        rawStories: d.Value(apiReligion.rawStories),
        rawTechnologies: d.Value(apiReligion.rawTechnologies),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertReligion(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single religion: $e');
    }
  }

  Future<void> syncDirtyReligions() async {
    final dirtyReligions = await _dao.getDirtyReligions();
    if (dirtyReligions.isEmpty) return;
    for (final religion in dirtyReligions) {
      try {
        if (religion.syncStatus == SyncStatus.created) {
          await _syncCreatedReligion(religion);
        } else if (religion.syncStatus == SyncStatus.edited) {
          await _syncEditedReligion(religion);
        } else if (religion.syncStatus == SyncStatus.deleted) {
          await _syncDeletedReligion(religion);
        }
      } catch (e) {
        print('Error syncing religion ${religion.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedReligion(ReligionEntity religion) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(religion.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync religion for unsynced world');
    }

    final body = _createBodyFromEntity(religion, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiReligion = Religion.fromJson(jsonDecode(response.body));
      final companion = religion.toCompanion(true).copyWith(
        serverId: d.Value(apiReligion.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateReligion(companion);
    } else {
      throw Exception('Failed to create religion: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedReligion(ReligionEntity religion) async {
    if (religion.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(religion.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(religion, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${religion.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = religion.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updateReligion(companion);
    } else {
      throw Exception('Failed to update religion: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedReligion(ReligionEntity religion) async {
    if (religion.serverId == null) {
      await _dao.deleteReligion(religion.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${religion.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deleteReligion(religion.localId);
    } else {
      throw Exception('Failed to delete religion: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(ReligionEntity religion, String worldServerId) {
    return {
      'world': worldServerId,
      'name': religion.name,
      'description': religion.description,
      'deityNames': religion.deityNames,
      'originStory': religion.originStory,
      'practices': religion.practices,
      'taboos': religion.taboos,
      'sacredTexts': religion.sacredTexts,
      'festivals': religion.festivals,
      'symbols': religion.symbols,
      'customNotes': religion.customNotes,
      'tagColor': religion.tagColor,
      'images': religion.images,
      
      'rawCharacters': religion.rawCharacters,
      'rawFactions': religion.rawFactions,
      'rawLocations': religion.rawLocations,
      'rawCreatures': religion.rawCreatures,
      'rawEvents': religion.rawEvents,
      'rawPowerSystems': religion.rawPowerSystems,
      'rawStories': religion.rawStories,
      'rawTechnologies': religion.rawTechnologies,
    };
  }
}