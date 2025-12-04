import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/characters_dao.dart';
import 'package:worldorganizer_app/core/database/daos/items_dao.dart';
import 'package:worldorganizer_app/core/database/daos/locations_dao.dart';
import 'package:worldorganizer_app/core/services/api_service.dart';

class HomeService {
  final CharactersDao charactersDao;
  final ItemsDao itemsDao;
  final LocationsDao locationsDao;
  final ApiService apiService;

  HomeService({
    required this.charactersDao,
    required this.itemsDao,
    required this.locationsDao,
    required this.apiService,
  });

  Future<List<RecentActivityItem>> getRecentActivity() async {
    // Fetch recent items from different tables
    // This is a simplified version. In a real app, you might want a more complex query
    // or a dedicated "Activity" table. For now, we'll just get the latest 3 from each
    // and sort them.
    
    final characters = await charactersDao.getAllCharacters(); // Ideally use a limit query
    final items = await itemsDao.getAllItems();
    final locations = await locationsDao.getAllLocations();

    final List<RecentActivityItem> activity = [];

    for (var char in characters) {
      activity.add(RecentActivityItem(
        id: char.localId,
        name: char.name,
        type: 'Character',
        worldId: char.worldLocalId,
        updatedAt: char.updatedAt ?? DateTime.now(),
      ));
    }

    for (var item in items) {
      activity.add(RecentActivityItem(
        id: item.localId,
        name: item.name,
        type: 'Item',
        worldId: item.worldLocalId,
        updatedAt: item.updatedAt ?? DateTime.now(),
      ));
    }

    for (var loc in locations) {
      activity.add(RecentActivityItem(
        id: loc.localId,
        name: loc.name,
        type: 'Location',
        worldId: loc.worldLocalId,
        updatedAt: loc.updatedAt ?? DateTime.now(),
      ));
    }

    // Sort by updatedAt descending
    activity.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    // Return top 10
    return activity.take(10).toList();
  }

  Future<Map<String, int>> getGlobalStats() async {
    return await apiService.getUserCounts();
  }
}

class RecentActivityItem {
  final String id;
  final String name;
  final String type;
  final String worldId;
  final DateTime updatedAt;

  RecentActivityItem({
    required this.id,
    required this.name,
    required this.type,
    required this.worldId,
    required this.updatedAt,
  });
}
