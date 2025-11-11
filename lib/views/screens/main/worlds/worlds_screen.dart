import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/repositories/world_repository.dart';
import 'package:worldorganizer_app/core/services/world_sync_service.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/create_world_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final worldSyncProvider = FutureProvider<void>((ref) async {
  final syncService = ref.watch(worldSyncServiceProvider);
  await syncService.syncDirtyWorlds();
  await syncService.fetchAndMergeWorlds();
});

final worldsStreamProvider = StreamProvider<List<WorldEntity>>((ref) {
  return ref.watch(worldRepositoryProvider).watchWorlds();
});

class WorldsScreen extends ConsumerWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(worldSyncProvider);
    final worldsAsync = ref.watch(worldsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Worlds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateWorldScreen()),
              );
            },
          ),
        ],
      ),
      body: worldsAsync.when(
        data: (worlds) => worlds.isEmpty
            ? _buildEmptyView(context)
            : _buildWorldList(context, ref, worlds),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildWorldList(BuildContext context, WidgetRef ref, List<WorldEntity> worlds) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.refresh(worldSyncProvider.future);
      },
      child: ListView.builder(
        itemCount: worlds.length,
        itemBuilder: (context, index) {
          final world = worlds[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              title: Text(world.name),
              subtitle: Text(
                world.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => WorldDetailScreen(localWorldId: world.localId),
                  ),
                );
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade400),
                    onPressed: () => _showDeleteConfirmation(context, ref, world),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.public_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'No worlds yet.',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Create your first one to start organizing your universe!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Create a World'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateWorldScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              textStyle: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, WorldEntity world) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete World'),
        content: Text('Are you sure you want to delete "${world.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              try {
                await ref.read(worldRepositoryProvider).deleteWorld(world.localId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('"${world.name}" was deleted.')),
                );
              } catch (e) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting world: $e')),
                );
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}