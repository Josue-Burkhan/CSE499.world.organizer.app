import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/economies_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/economy_model.dart';

class EconomySyncService {
  final EconomiesDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/economies';

  EconomySyncService({
    required EconomiesDao dao,
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

  Future<void> fetchAndMergeEconomies(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch economies: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> economyList = body['economies'];
      final apiEconomies = economyList.map((j) => Economy.fromJson(j)).toList();

      for (final apiEconomy in apiEconomies) {
        final existing = await _dao.getEconomyByServerId(apiEconomy.id);
        
        final companion = EconomiesCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiEconomy.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiEconomy.name),
          description: d.Value(apiEconomy.description),
          currencyJson: apiEconomy.currency != null
              ? d.Value(jsonEncode(apiEconomy.currency!.toJson()))
              : const d.Value(null),
          tradeGoods: d.Value(apiEconomy.tradeGoods),
          keyIndustries: d.Value(apiEconomy.keyIndustries),
          economicSystem: d.Value(apiEconomy.economicSystem),
          tagColor: d.Value(apiEconomy.tagColor),
          images: d.Value(apiEconomy.images),
          rawCharacters: d.Value(apiEconomy.rawCharacters),
          rawFactions: d.Value(apiEconomy.rawFactions),
          rawLocations: d.Value(apiEconomy.rawLocations),
          rawItems: d.Value(apiEconomy.rawItems),
          rawRaces: d.Value(apiEconomy.rawRaces),
          rawStories: d.Value(apiEconomy.rawStories),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertEconomy(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge economies: $e');
    }
  }

  Future<void> fetchAndMergeSingleEconomy(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch economy $serverId: ${response.statusCode}');
      }

      final apiEconomy = Economy.fromJson(jsonDecode(response.body));
      if (apiEconomy.worldId == null) {
        throw Exception('Economy from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiEconomy.worldId!);
      if (world == null) {
        throw Exception('Economy\'s world is not synced locally');
      }

      final existing = await _dao.getEconomyByServerId(apiEconomy.id);
      
      final companion = EconomiesCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiEconomy.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiEconomy.name),
        description: d.Value(apiEconomy.description),
        currencyJson: apiEconomy.currency != null
            ? d.Value(jsonEncode(apiEconomy.currency!.toJson()))
            : const d.Value(null),
        tradeGoods: d.Value(apiEconomy.tradeGoods),
        keyIndustries: d.Value(apiEconomy.keyIndustries),
        economicSystem: d.Value(apiEconomy.economicSystem),
        tagColor: d.Value(apiEconomy.tagColor),
        images: d.Value(apiEconomy.images),
        rawCharacters: d.Value(apiEconomy.rawCharacters),
        rawFactions: d.Value(apiEconomy.rawFactions),
        rawLocations: d.Value(apiEconomy.rawLocations),
        rawItems: d.Value(apiEconomy.rawItems),
        rawRaces: d.Value(apiEconomy.rawRaces),
        rawStories: d.Value(apiEconomy.rawStories),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertEconomy(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single economy: $e');
    }
  }

  Future<void> syncDirtyEconomies() async {
    final dirtyEconomies = await _dao.getDirtyEconomies();
    if (dirtyEconomies.isEmpty) return;
    
  }
}