import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/repositories/world_repository.dart';
import 'package:worldorganizer_app/core/services/world_sync_service.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/create_world_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/world_detail_screen.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final worldSyncProvider = FutureProvider.autoDispose<void>((ref) async {
  final syncService = ref.watch(worldSyncServiceProvider);
  await syncService.syncDirtyWorlds();
  await syncService.fetchAndMergeWorlds();
});

final worldsProvider = StreamProvider<List<WorldEntity>>((ref) {
  return ref.watch(worldRepositoryProvider).watchWorlds();
});

class WorldsScreen extends ConsumerStatefulWidget {
  const WorldsScreen({super.key});

  @override
  ConsumerState<WorldsScreen> createState() => _WorldsScreenState();
}

class _WorldsScreenState extends ConsumerState<WorldsScreen> {
  final Set<String> _selectedWorldIds = {};
  bool _isSelectionMode = false;

  void _toggleSelection(String worldId) {
    setState(() {
      if (_selectedWorldIds.contains(worldId)) {
        _selectedWorldIds.remove(worldId);
        if (_selectedWorldIds.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedWorldIds.add(worldId);
      }
    });
  }

  void _enterSelectionMode(String worldId) {
    setState(() {
      _isSelectionMode = true;
      _selectedWorldIds.add(worldId);
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedWorldIds.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _deleteSelectedWorlds(List<WorldEntity> allWorlds) async {
    final selectedWorlds = allWorlds.where((w) => _selectedWorldIds.contains(w.localId)).toList();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Worlds'),
        content: Text('Are you sure you want to delete ${selectedWorlds.length} world(s)?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      for (final world in selectedWorlds) {
        await ref.read(worldRepositoryProvider).deleteWorld(world.localId);
      }
      _clearSelection();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Worlds deleted')),
        );
      }
    }
  }

  Widget _buildCoverImage(String? imagePath, String worldName) {
    // 0. Helper for the ultimate fallback (no internet/error)
    Widget buildErrorPlaceholder() {
      return Container(
        color: Colors.grey[850],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.image_not_supported, size: 40, color: Colors.white24),
              const SizedBox(height: 4),
              Text(
                worldName.isNotEmpty ? worldName[0].toUpperCase() : '?',
                style: const TextStyle(color: Colors.white24, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    // 1. Helper for the placeholder (NOW LOCAL ONLY to prevent network crashes)
    Widget buildNetworkPlaceholder() {
      return Container(
        color: Colors.blueGrey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.public, size: 50, color: Colors.white54),
              const SizedBox(height: 8),
              Text(
                worldName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    if (imagePath == null || imagePath.isEmpty) {
      return buildNetworkPlaceholder();
    }

    // 2. Check for Backend Relative URL (starts with /uploads/)
    if (imagePath.startsWith('/uploads/')) {
      final imageUrl = 'https://writers.wild-fantasy.com$imagePath';
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return buildNetworkPlaceholder();
        },
      );
    }

    // 3. Check for Network URL (starts with http)
    if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return buildNetworkPlaceholder();
        },
      );
    }

    // 4. Check for Local File (starts with /)
    if (imagePath.startsWith('/')) {
      final file = File(imagePath);
      final exists = file.existsSync();
      int length = 0;
      if (exists) {
        try {
          length = file.lengthSync();
        } catch (e) {
          // Ignore error
        }
      }
      
      if (exists && length > 0) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
             return buildErrorPlaceholder();
          },
        );
      } else {
        return buildNetworkPlaceholder();
      }
    }

    // 5. Unknown format
    return buildNetworkPlaceholder();
  }

  @override
  Widget build(BuildContext context) {
    final worldsAsync = ref.watch(worldsProvider);
    // Trigger sync when screen is built
    ref.listen(worldSyncProvider, (_, __) {});

    return Scaffold(
      appBar: AppBar(
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSelection,
              )
            : null,
        title: _isSelectionMode
            ? Text('${_selectedWorldIds.length} Selected')
            : const Text('My Worlds'),
        actions: [
          if (_isSelectionMode) ...[
            if (_selectedWorldIds.length == 1)
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                   // Navigate to edit screen (placeholder for now as requested functionality focused on delete)
                   // You can implement navigation to CreateWorldScreen with arguments for editing later
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Edit feature coming soon')));
                },
              ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                 worldsAsync.whenData((worlds) => _deleteSelectedWorlds(worlds));
              },
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CreateWorldScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                ref.refresh(worldSyncProvider);
                ref.refresh(worldsProvider);
              },
            ),
          ],
        ],
      ),
      body: worldsAsync.when(
        data: (worlds) {
          if (worlds.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.public_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No worlds yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text('Create your first world to get started'),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.refresh(worldSyncProvider.future);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: worlds.length,
              itemBuilder: (context, index) {
                final world = worlds[index];
                final isSelected = _selectedWorldIds.contains(world.localId);

                return Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: isSelected ? 8 : 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isSelected 
                        ? BorderSide(color: Theme.of(context).primaryColor, width: 3)
                        : BorderSide.none,
                  ),
                  child: InkWell(
                    onLongPress: () => _enterSelectionMode(world.localId),
                    onTap: () {
                      if (_isSelectionMode) {
                        _toggleSelection(world.localId);
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WorldDetailScreen(localWorldId: world.localId),
                          ),
                        );
                      }
                    },
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: _buildCoverImage(world.coverImage, world.name),
                        ),
                        if (isSelected)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black26,
                              child: const Center(
                                child: Icon(Icons.check_circle, size: 48, color: Colors.white),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 120,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.9),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Text Content
                        Positioned(
                          bottom: 12,
                          left: 12,
                          right: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                world.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 2,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (world.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  world.description,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              const SizedBox(height: 8),
                              if (world.syncStatus != SyncStatus.synced)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.sync,
                                        size: 12,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        world.syncStatus.toString().split('.').last.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}