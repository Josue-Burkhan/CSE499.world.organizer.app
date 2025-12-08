import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/powersystems_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/powersystem_model.dart';

class PowerSystemSyncService {
  final PowerSystemsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/powersystems';

  PowerSystemSyncService({
    required PowerSystemsDao dao,
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

  Future<void> fetchAndMergePowerSystems(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch power systems: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> psList = body['powerSystems'];
      final apiPowerSystems = psList.map((j) => PowerSystem.fromJson(j)).toList();

      for (final apiPS in apiPowerSystems) {
        final existing = await _dao.getPowerSystemByServerId(apiPS.id);
        
        final companion = PowerSystemsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiPS.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiPS.name),
          description: d.Value(apiPS.description),
          sourceOfPower: d.Value(apiPS.sourceOfPower),
          rules: d.Value(apiPS.rules),
          limitations: d.Value(apiPS.limitations),
          classificationTypes: d.Value(apiPS.classificationTypes),
          symbolsOrMarks: d.Value(apiPS.symbolsOrMarks),
          customNotes: d.Value(apiPS.customNotes),
          tagColor: d.Value(apiPS.tagColor),
          images: d.Value(apiPS.images),
          rawCharacters: d.Value(apiPS.rawCharacters),
          rawAbilities: d.Value(apiPS.rawAbilities),
          rawFactions: d.Value(apiPS.rawFactions),
          rawEvents: d.Value(apiPS.rawEvents),
          rawStories: d.Value(apiPS.rawStories),
          rawCreatures: d.Value(apiPS.rawCreatures),
          rawReligions: d.Value(apiPS.rawReligions),
          rawTechnologies: d.Value(apiPS.rawTechnologies),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertPowerSystem(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge power systems: $e');
    }
  }

  Future<void> fetchAndMergeSinglePowerSystem(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch power system $serverId: ${response.statusCode}');
      }

      final apiPS = PowerSystem.fromJson(jsonDecode(response.body));
      if (apiPS.worldId == null) {
        throw Exception('PowerSystem from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiPS.worldId!);
      if (world == null) {
        throw Exception('PowerSystem\'s world is not synced locally');
      }

      final existing = await _dao.getPowerSystemByServerId(apiPS.id);
      
      final companion = PowerSystemsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiPS.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiPS.name),
        description: d.Value(apiPS.description),
        sourceOfPower: d.Value(apiPS.sourceOfPower),
        rules: d.Value(apiPS.rules),
        limitations: d.Value(apiPS.limitations),
        classificationTypes: d.Value(apiPS.classificationTypes),
        symbolsOrMarks: d.Value(apiPS.symbolsOrMarks),
        customNotes: d.Value(apiPS.customNotes),
        tagColor: d.Value(apiPS.tagColor),
        images: d.Value(apiPS.images),
        rawCharacters: d.Value(apiPS.rawCharacters),
        rawAbilities: d.Value(apiPS.rawAbilities),
        rawFactions: d.Value(apiPS.rawFactions),
        rawEvents: d.Value(apiPS.rawEvents),
        rawStories: d.Value(apiPS.rawStories),
        rawCreatures: d.Value(apiPS.rawCreatures),
        rawReligions: d.Value(apiPS.rawReligions),
        rawTechnologies: d.Value(apiPS.rawTechnologies),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertPowerSystem(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single power system: $e');
    }
  }

  Future<void> syncDirtyPowerSystems() async {
    final dirtyPowerSystems = await _dao.getDirtyPowerSystems();
    if (dirtyPowerSystems.isEmpty) return;
    for (final ps in dirtyPowerSystems) {
      try {
        if (ps.syncStatus == SyncStatus.created) {
          await _syncCreatedPowerSystem(ps);
        } else if (ps.syncStatus == SyncStatus.edited) {
          await _syncEditedPowerSystem(ps);
        } else if (ps.syncStatus == SyncStatus.deleted) {
          await _syncDeletedPowerSystem(ps);
        }
      } catch (e) {
        print('Error syncing power system ${ps.name}: $e');
      }
    }
  }

  Future<void> _syncCreatedPowerSystem(PowerSystemEntity ps) async {
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(ps.worldLocalId);
    if (world == null || world.serverId == null) {
      throw Exception('Cannot sync power system for unsynced world');
    }

    final body = _createBodyFromEntity(ps, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      final apiPS = PowerSystem.fromJson(jsonDecode(response.body));
      final companion = ps.toCompanion(true).copyWith(
        serverId: d.Value(apiPS.id),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updatePowerSystem(companion);
    } else {
      throw Exception('Failed to create power system: ${response.statusCode} ${response.body}');
    }
  }

  Future<void> _syncEditedPowerSystem(PowerSystemEntity ps) async {
    if (ps.serverId == null) return;
    final token = await _getToken();
    if (token == null) return;

    final world = await _worldsDao.getWorldByLocalId(ps.worldLocalId);
    if (world == null || world.serverId == null) return;

    final body = _createBodyFromEntity(ps, world.serverId!);
    final headers = await _getHeaders();

    final response = await http.put(
      Uri.parse('$_baseUrl/${ps.serverId}'),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final companion = ps.toCompanion(true).copyWith(
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.updatePowerSystem(companion);
    } else {
      throw Exception('Failed to update power system: ${response.statusCode}');
    }
  }

  Future<void> _syncDeletedPowerSystem(PowerSystemEntity ps) async {
    if (ps.serverId == null) {
      await _dao.deletePowerSystem(ps.localId);
      return;
    }

    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('$_baseUrl/${ps.serverId}'),
      headers: headers,
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      await _dao.deletePowerSystem(ps.localId);
    } else {
      throw Exception('Failed to delete power system: ${response.statusCode}');
    }
  }

  Map<String, dynamic> _createBodyFromEntity(PowerSystemEntity ps, String worldServerId) {
    return {
      'world': worldServerId,
      'name': ps.name,
      'description': ps.description,
      'sourceOfPower': ps.sourceOfPower,
      'rules': ps.rules,
      'limitations': ps.limitations,
      'classificationTypes': ps.classificationTypes,
      'symbolsOrMarks': ps.symbolsOrMarks,
      'customNotes': ps.customNotes,
      'tagColor': ps.tagColor,
      'images': ps.images,
      
      'rawCharacters': ps.rawCharacters,
      'rawAbilities': ps.rawAbilities,
      'rawFactions': ps.rawFactions,
      'rawEvents': ps.rawEvents,
      'rawStories': ps.rawStories,
      'rawCreatures': ps.rawCreatures,
      'rawReligions': ps.rawReligions,
      'rawTechnologies': ps.rawTechnologies,
    };
  }
}