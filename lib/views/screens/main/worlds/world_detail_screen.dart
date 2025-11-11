import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/models/api_models/world_stats_model.dart';
import 'package:worldorganizer_app/models/api_models/world_timeline_model.dart';
import 'package:worldorganizer_app/repositories/world_repository.dart';
import 'package:worldorganizer_app/core/services/world_sync_service.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/world_modules_widget.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/world_stats_widget.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/world_timeline_widget.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final worldDetailStreamProvider =
    StreamProvider.family<WorldEntity?, String>((ref, localWorldId) {
  return ref.watch(worldRepositoryProvider).watchWorld(localWorldId);
});

final worldTimelineProvider =
    FutureProvider.family<List<Activity>, String>((ref, serverWorldId) {
  return ref.watch(worldSyncServiceProvider).getTimeline(serverWorldId);
});

final worldStatsProvider =
    FutureProvider.family<WorldStats, String>((ref, serverWorldId) {
  return ref.watch(worldSyncServiceProvider).getStats(serverWorldId);
});

class WorldDetailScreen extends ConsumerWidget {
  final String localWorldId;

  const WorldDetailScreen({super.key, required this.localWorldId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldAsyncValue = ref.watch(worldDetailStreamProvider(localWorldId));

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
                WorldModulesWidget(modules: modules),
                
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
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
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