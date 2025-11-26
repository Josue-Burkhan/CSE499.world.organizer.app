import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/models/api_models/world_stats_model.dart';
import 'package:worldorganizer_app/models/api_models/world_timeline_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_list/character_list_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/world_stats_widget.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/world_timeline_widget.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_search_screen.dart';

final worldDetailStreamProvider = StreamProvider.family<WorldEntity?, String>((
  ref,
  localWorldId,
) {
  return ref.watch(worldRepositoryProvider).watchWorld(localWorldId);
});

final worldTimelineProvider = FutureProvider.family<List<Activity>, String>((
  ref,
  serverWorldId,
) {
  return ref.watch(worldSyncServiceProvider).getTimeline(serverWorldId);
});

final worldStatsProvider = FutureProvider.family<WorldStats, String>((
  ref,
  serverWorldId,
) {
  return ref.watch(worldSyncServiceProvider).getStats(serverWorldId);
});

  final worldDetailSyncProvider = 
    FutureProvider.family<void, String?>((ref, serverId) async {
      if (serverId == null) {
        return;
      }
      final syncService = ref.watch(worldSyncServiceProvider);
      await syncService.fetchAndMergeSingleWorld(serverId);
    });

class WorldDetailScreen extends ConsumerWidget {
  final String localWorldId;

  const WorldDetailScreen({super.key, required this.localWorldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final worldAsyncValue = ref.watch(worldDetailStreamProvider(localWorldId));
    final worldData = worldAsyncValue.value;

    ref.listen(worldDetailSyncProvider(worldData?.serverId), (prev, next) {
      if (prev is AsyncLoading && next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to sync. Check connection.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    });

    return worldAsyncValue.when(
      data: (world) {
        if (world == null) {
          return const Scaffold(
            body: Center(child: Text('World not found or has been deleted.'))
          );
        }
        
        final serverId = world.serverId;
        final modules = world.modules != null 
          ? Modules.fromJson(jsonDecode(world.modules!)) 
          : null;

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(world.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (world.serverId != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => WorldSearchScreen(
                            worldServerId: world.serverId!,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Search is unavailable for unsynced worlds.'),
                          backgroundColor: Colors.orange,
                        )
                      );
                    }
                  },
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Timeline'),
                  Tab(text: 'Stats'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _buildModulesList(context, world, modules),
                
                if (serverId != null)
                  WorldTimelineWidget(worldId: serverId)
                else
                  _buildOfflineOnlyTab('Timeline'),

                if (serverId != null)
                  WorldStatsWidget(worldId: serverId)
                else
                  _buildOfflineOnlyTab('Stats'),
              ],
            ),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error reading local DB: $err'))),
    );
  }

  Widget _buildModulesList(
    BuildContext context,
    WorldEntity world,
    Modules? modules,
  ) {
    if (modules == null) {
      return const Center(child: Text('No modules enabled for this world.'));
    }

    final Map<String, dynamic> moduleMap = modules.toMap();
    final List<String> enabledModules = moduleMap.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();

    if (enabledModules.isEmpty) {
      return const Center(child: Text('No modules enabled for this world.'));
    }

    return ListView.builder(
      itemCount: enabledModules.length,
      itemBuilder: (context, index) {
        final moduleName = enabledModules[index];
        IconData moduleIcon = _getModuleIcon(moduleName);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: Icon(
              moduleIcon,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(_getModuleDisplayName(moduleName)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _navigateToModule(context, moduleName, world);
            },
          ),
        );
      },
    );
  }

  IconData _getModuleIcon(String moduleName) {
    switch (moduleName) {
      case 'characters':
        return Icons.people;
      case 'locations':
        return Icons.map;
      case 'factions':
        return Icons.group_work;
      case 'items':
        return Icons.shield;
      case 'events':
        return Icons.event;
      case 'languages':
        return Icons.language;
      case 'abilities':
        return Icons.star;
      case 'technology':
        return Icons.memory;
      case 'powerSystem':
        return Icons.flash_on;
      case 'creatures':
        return Icons.adb;
      case 'religion':
        return Icons.book;
      case 'story':
        return Icons.auto_stories;
      case 'races':
        return Icons.face;
      case 'economy':
        return Icons.monetization_on;
      default:
        return Icons.category;
    }
  }

  String _getModuleDisplayName(String moduleName) {
    switch (moduleName) {
      case 'characters': return 'Characters';
      case 'locations': return 'Locations';
      case 'factions': return 'Factions';
      case 'items': return 'Items';
      case 'events': return 'Events';
      case 'languages': return 'Languages';
      case 'abilities': return 'Abilities';
      case 'technology': return 'Technology';
      case 'powerSystem': return 'Power System';
      case 'creatures': return 'Creatures';
      case 'religion': return 'Religion';
      case 'story': return 'Story';
      case 'races': return 'Races';
      case 'economy': return 'Economy';
      default: return 'Other';
    }
  }

  void _navigateToModule(BuildContext context, String moduleName, WorldEntity world) {
    if (moduleName == 'characters') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CharacterListScreen(
            worldLocalId: world.localId,
            worldServerId: world.serverId,
            worldName: world.name,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$moduleName module is not implemented yet.')),
      );
    }
  }

  Widget _buildOfflineOnlyTab(String tabName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.sync_problem, size: 60, color: Colors.grey[600]),
          const SizedBox(height: 16),
          Text(
            '$tabName is unavailable',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'This world has not been synced to the server yet.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
