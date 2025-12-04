import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/create_world_screen.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final worldsProvider = StreamProvider<List<WorldEntity>>((ref) {
  return ref.watch(worldRepositoryProvider).watchWorlds();
});

class SelectWorldScreen extends ConsumerWidget {
  final Function(String worldLocalId) onWorldSelected;
  final String title;

  const SelectWorldScreen({
    super.key,
    required this.onWorldSelected,
    this.title = 'Select World',
  });

  Widget _buildCoverImage(String? imagePath, String worldName) {
    Widget buildPlaceholder() {
      return Container(
        color: Colors.blueGrey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.public, size: 40, color: Colors.white54),
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

    if (imagePath == null || imagePath.isEmpty) {
      return buildPlaceholder();
    }

    if (imagePath.startsWith('/uploads/') || imagePath.startsWith('http')) {
      final imageUrl = imagePath.startsWith('/uploads/') 
          ? 'https://writers.wild-fantasy.com$imagePath' 
          : imagePath;
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
      );
    }

    if (imagePath.startsWith('/')) {
      final file = File(imagePath);
      if (file.existsSync()) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) => buildPlaceholder(),
        );
      }
    }

    return buildPlaceholder();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final worldsAsync = ref.watch(worldsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                    'No worlds found',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const CreateWorldScreen(),
                        ),
                      );
                    },
                    child: const Text('Create a World'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: worlds.length,
            itemBuilder: (context, index) {
              final world = worlds[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () => onWorldSelected(world.localId),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: _buildCoverImage(world.coverImage, world.name),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.8),
                              ],
                            ),
                          ),
                          child: Text(
                            world.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
