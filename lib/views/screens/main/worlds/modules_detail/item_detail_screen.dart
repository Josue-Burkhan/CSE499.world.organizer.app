import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final itemDetailStreamProvider =
    StreamProvider.family.autoDispose<ItemEntity?, String>((ref, serverId) {
  return ref.watch(itemRepositoryProvider).watchItemByServerId(serverId);
});

final itemDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(itemSyncServiceProvider);
  await syncService.fetchAndMergeSingleItem(serverId);
});

class ItemDetailScreen extends ConsumerWidget {
  final String itemServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const ItemDetailScreen({
    super.key,
    required this.itemServerId,
  });

  String? _getImageUrl(ItemEntity item) {
    if (item.images.isEmpty) return null;
    String path = item.images.first;
    if (path.startsWith('/')) {
      return '$_imageBaseUrl$path';
    }
    return path;
  }

  Color _getTagColor(String tagColor) {
    switch (tagColor) {
      case 'blue': return Colors.blue.shade400;
      case 'purple': return Colors.purple.shade400;
      case 'green': return Colors.green.shade400;
      case 'red': return Colors.red.shade400;
      case 'amber': return Colors.amber.shade400;
      case 'lime': return Colors.lime.shade400;
      case 'black': return Colors.black87;
      case 'neutral': default: return Colors.grey.shade400;
    }
  }

  void _openFullScreenImage(BuildContext context, String imageUrl) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncItem = ref.watch(itemDetailStreamProvider(itemServerId));

    ref.listen(itemDetailSyncProvider(itemServerId), (prev, next) {
      if (prev is AsyncLoading && next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sync details: ${next.error}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });

    return asyncItem.when(
      data: (item) {
        if (item == null) {
          return ref.watch(itemDetailSyncProvider(itemServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load item: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Item not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, item);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error reading local DB: $e')),
      ),
    );
  }

  Widget _buildDetailScaffold(BuildContext context, ItemEntity item) {
    final imageUrl = _getImageUrl(item);
    final tagColor = _getTagColor(item.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(item.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(item),
              _buildDescription(item),
              _buildStatusInfo(item),
              _buildRawList('Magical Properties', item.magicalProperties),
              _buildRawList('Technological Features', item.technologicalFeatures),
              _buildRawList('Custom Effects', item.customEffects),
              _buildCustomNotes(item),
              _buildRawList('Created By', item.rawCreatedBy),
              _buildRawList('Used By', item.rawUsedBy),
              _buildRawList('Current Owner', item.rawCurrentOwnerCharacter),
              _buildRawList('Factions', item.rawFactions),
              _buildRawList('Events', item.rawEvents),
              _buildRawList('Stories', item.rawStories),
              _buildRawList('Locations', item.rawLocations),
              _buildRawList('Religions', item.rawReligions),
              _buildRawList('Technologies', item.rawTechnologies),
              _buildRawList('Power Systems', item.rawPowerSystems),
              _buildRawList('Languages', item.rawLanguages),
              _buildRawList('Abilities', item.rawAbilities),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(ItemEntity item) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(item.type?.isEmpty == true ? 'Unknown' : item.type ?? 'Unknown'),
            subtitle: const Text('Type'),
          ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(item.rarity?.isEmpty == true ? 'Unknown' : item.rarity ?? 'Unknown'),
            subtitle: const Text('Rarity'),
          ),
          ListTile(
            leading: const Icon(Icons.texture_outlined),
            title: Text(item.material?.isEmpty == true ? 'Unknown' : item.material ?? 'Unknown'),
            subtitle: const Text('Material'),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(item.origin?.isEmpty == true ? 'Unknown' : item.origin ?? 'Unknown'),
            subtitle: const Text('Origin'),
          ),
          ListTile(
            leading: const Icon(Icons.fitness_center_outlined),
            title: Text(item.weight == null ? 'Unknown' : '${item.weight}'),
            subtitle: const Text('Weight'),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(item.value?.isEmpty == true ? 'Unknown' : item.value ?? 'Unknown'),
            subtitle: const Text('Value'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(ItemEntity item) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(item.description?.isEmpty == true ? 'No description available.' : item.description ?? 'No description available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusInfo(ItemEntity item) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              item.isUnique ? Icons.verified : Icons.content_copy,
              color: item.isUnique ? Colors.amber : Colors.grey,
            ),
            title: Text(item.isUnique ? 'Unique' : 'Not Unique'),
            subtitle: const Text('Uniqueness'),
          ),
          ListTile(
            leading: Icon(
              item.isDestroyed ? Icons.broken_image : Icons.check_circle_outline,
              color: item.isDestroyed ? Colors.red : Colors.green,
            ),
            title: Text(item.isDestroyed ? 'Destroyed' : 'Intact'),
            subtitle: const Text('Status'),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomNotes(ItemEntity item) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Custom Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(item.customNotes?.isEmpty == true ? 'No custom notes.' : item.customNotes ?? 'No custom notes.'),
          ],
        ),
      ),
    );
  }

  Widget _buildRawList(String title, List<String> rawList) {
    if (rawList.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: rawList.map((item) => Chip(label: Text(item))).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;
  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          minScale: 1.0,
          maxScale: 4.0,
          child: Image.network(imageUrl),
        ),
      ),
    );
    Widget _buildEmptyStateCard(String title, IconData icon) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      elevation: 0,
      color: Colors.grey.withOpacity(0.05),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.withOpacity(0.1))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.grey, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "No information available.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
}