import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/providers/home_provider.dart';
import 'package:worldorganizer_app/providers/worlds_provider.dart';
import 'package:worldorganizer_app/views/screens/main/home/widgets/activity_tile.dart';
import 'package:worldorganizer_app/views/screens/main/home/widgets/sync_status_widget.dart';
import 'package:worldorganizer_app/views/screens/main/home/widgets/world_list_item.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/create_world_screen.dart';
import 'package:worldorganizer_app/views/screens/main/home/search_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final worldsAsync = ref.watch(worldsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Worlds'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('World Organizer'),
                  content: const Text('Version 1.0.0\n\nOrganize your fantasy worlds with ease.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(homeProvider.notifier).loadData();
          ref.refresh(worldsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              // Search Bar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(initialQuery: ''),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        'Search worlds, characters, items...',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Global Sync Status
              const SyncStatusWidget(),
              const SizedBox(height: 24),

              // Stats
              Row(
                children: [
                  _buildStatCard(
                    context,
                    'Characters',
                    homeState.stats['characterCount'] ?? 0,
                    Icons.person,
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Worlds',
                    homeState.stats['worldCount'] ?? 0,
                    Icons.public,
                    Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _buildStatCard(
                    context,
                    'Items',
                    homeState.stats['itemCount'] ?? 0,
                    Icons.backpack,
                    Colors.amber,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Worlds Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Worlds',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CreateWorldScreen()),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create New'),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Worlds List
              worldsAsync.when(
                data: (worlds) {
                  if (worlds.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No worlds yet. Create one to get started!'),
                      ),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: worlds.length,
                    itemBuilder: (context, index) {
                      return WorldListItem(world: worlds[index]);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
              ),
              const SizedBox(height: 24),

              // Recent Activity
              Text(
                'Recent Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 12),
              if (homeState.isLoading)
                const Center(child: CircularProgressIndicator())
              else if (homeState.recentActivity.isEmpty)
                const Text('No recent activity found.')
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: homeState.recentActivity.length,
                  itemBuilder: (context, index) {
                    return ActivityTile(item: homeState.recentActivity[index]);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, int value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getLimit(String type, String plan) {
    final limits = {
      'Free': {'characters': 80.0, 'worlds': 1.0, 'items': 50.0},
      'Premium': {'characters': 505.0, 'worlds': 3.0, 'items': 300.0},
      'Creator of Worlds': {'characters': double.infinity, 'worlds': double.infinity, 'items': double.infinity}
    };
    
    return limits[plan]?[type] ?? limits['Free']![type]!;
  }
}