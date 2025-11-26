import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/items_dao.dart';
import 'package:drift/drift.dart' as d;
import 'package:worldorganizer_app/models/api_models/modules/item_model.dart';

class ItemSyncService {
  final ItemsDao _dao;
  final WorldsDao _worldsDao;
  final FlutterSecureStorage _storage;
  final String _baseUrl = 'https://login.wild-fantasy.com/api/newworld/items';

  ItemSyncService({
    required ItemsDao dao,
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

  Future<void> fetchAndMergeItems(String worldLocalId, String worldServerId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl?Id=$worldServerId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch items: ${response.statusCode}');
      }

      final body = jsonDecode(response.body);
      final List<dynamic> itemList = body['items'];
      final apiItems = itemList.map((j) => Item.fromJson(j)).toList();

      for (final apiItem in apiItems) {
        final existing = await _dao.getItemByServerId(apiItem.id);
        
        final companion = ItemsCompanion(
          localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
          serverId: d.Value(apiItem.id),
          worldLocalId: d.Value(worldLocalId),
          name: d.Value(apiItem.name),
          description: d.Value(apiItem.description),
          type: d.Value(apiItem.type),
          origin: d.Value(apiItem.origin),
          material: d.Value(apiItem.material),
          weight: d.Value(apiItem.weight?.toDouble()),
          value: d.Value(apiItem.value),
          rarity: d.Value(apiItem.rarity),
          magicalProperties: d.Value(apiItem.magicalProperties),
          technologicalFeatures: d.Value(apiItem.technologicalFeatures),
          customEffects: d.Value(apiItem.customEffects),
          isUnique: d.Value(apiItem.isUnique),
          isDestroyed: d.Value(apiItem.isDestroyed),
          customNotes: d.Value(apiItem.customNotes),
          tagColor: d.Value(apiItem.tagColor),
          images: d.Value(apiItem.images),
          rawCreatedBy: d.Value(apiItem.rawCreatedBy),
          rawUsedBy: d.Value(apiItem.rawUsedBy),
          rawCurrentOwnerCharacter: d.Value(apiItem.rawCurrentOwnerCharacter),
          rawFactions: d.Value(apiItem.rawFactions),
          rawEvents: d.Value(apiItem.rawEvents),
          rawStories: d.Value(apiItem.rawStories),
          rawLocations: d.Value(apiItem.rawLocations),
          rawReligions: d.Value(apiItem.rawReligions),
          rawTechnologies: d.Value(apiItem.rawTechnologies),
          rawPowerSystems: d.Value(apiItem.rawPowerSystems),
          rawLanguages: d.Value(apiItem.rawLanguages),
          rawAbilities: d.Value(apiItem.rawAbilities),
          syncStatus: const d.Value(SyncStatus.synced),
        );
        await _dao.insertItem(companion);
      }
    } catch (e) {
      throw Exception('Failed to fetch/merge items: $e');
    }
  }

  Future<void> fetchAndMergeSingleItem(String serverId) async {
    final token = await _getToken();
    if (token == null) return;

    final headers = await _getHeaders();
    final uri = Uri.parse('$_baseUrl/$serverId');

    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch item $serverId: ${response.statusCode}');
      }

      final apiItem = Item.fromJson(jsonDecode(response.body));
      if (apiItem.worldId == null) {
        throw Exception('Item from API is missing worldId');
      }
      
      final world = await _worldsDao.getWorldByServerId(apiItem.worldId!);
      if (world == null) {
        throw Exception('Item\'s world is not synced locally');
      }

      final existing = await _dao.getItemByServerId(apiItem.id);
      
      final companion = ItemsCompanion(
        localId: existing != null ? d.Value(existing.localId) : const d.Value.absent(),
        serverId: d.Value(apiItem.id),
        worldLocalId: d.Value(world.localId),
        name: d.Value(apiItem.name),
        description: d.Value(apiItem.description),
        type: d.Value(apiItem.type),
        origin: d.Value(apiItem.origin),
        material: d.Value(apiItem.material),
        weight: d.Value(apiItem.weight?.toDouble()),
        value: d.Value(apiItem.value),
        rarity: d.Value(apiItem.rarity),
        magicalProperties: d.Value(apiItem.magicalProperties),
        technologicalFeatures: d.Value(apiItem.technologicalFeatures),
        customEffects: d.Value(apiItem.customEffects),
        isUnique: d.Value(apiItem.isUnique),
        isDestroyed: d.Value(apiItem.isDestroyed),
        customNotes: d.Value(apiItem.customNotes),
        tagColor: d.Value(apiItem.tagColor),
        images: d.Value(apiItem.images),
        rawCreatedBy: d.Value(apiItem.rawCreatedBy),
        rawUsedBy: d.Value(apiItem.rawUsedBy),
        rawCurrentOwnerCharacter: d.Value(apiItem.rawCurrentOwnerCharacter),
        rawFactions: d.Value(apiItem.rawFactions),
        rawEvents: d.Value(apiItem.rawEvents),
        rawStories: d.Value(apiItem.rawStories),
        rawLocations: d.Value(apiItem.rawLocations),
        rawReligions: d.Value(apiItem.rawReligions),
        rawTechnologies: d.Value(apiItem.rawTechnologies),
        rawPowerSystems: d.Value(apiItem.rawPowerSystems),
        rawLanguages: d.Value(apiItem.rawLanguages),
        rawAbilities: d.Value(apiItem.rawAbilities),
        syncStatus: const d.Value(SyncStatus.synced),
      );
      await _dao.insertItem(companion);

    } catch (e) {
      throw Exception('Failed to fetch/merge single item: $e');
    }
  }

  Future<void> syncDirtyItems() async {
    final dirtyItems = await _dao.getDirtyItems();
    if (dirtyItems.isEmpty) return;
    
  }
}