import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final locationDetailStreamProvider =
    StreamProvider.family.autoDispose<LocationEntity?, String>((ref, serverId) {
  return ref.watch(locationRepositoryProvider).watchLocationByServerId(serverId);
});

final locationDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(locationSyncServiceProvider);
  await syncService.fetchAndMergeSingleLocation(serverId);
});

class LocationDetailScreen extends ConsumerWidget {
  final String locationServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const LocationDetailScreen({
    super.key,
    required this.locationServerId,
  });

  String? _getImageUrl(LocationEntity loc) {
    if (loc.images.isEmpty) return null;
    String path = loc.images.first;
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
    final asyncLocation = ref.watch(locationDetailStreamProvider(locationServerId));

    ref.listen(locationDetailSyncProvider(locationServerId), (prev, next) {
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

    return asyncLocation.when(
      data: (location) {
        if (location == null) {
          return ref.watch(locationDetailSyncProvider(locationServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load location: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Location not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, location);
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

  Widget _buildDetailScaffold(BuildContext context, LocationEntity location) {
    final imageUrl = _getImageUrl(location);
    final tagColor = _getTagColor(location.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(location.name),
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
              _buildBasicInfo(location),
              if (location.description != null) _buildDescription(location.description!),
              if (location.customNotes != null) _buildCustomNotes(location.customNotes!),
              _buildRawList('Locations', location.rawLocations),
              _buildRawList('Factions', location.rawFactions),
              _buildRawList('Events', location.rawEvents),
              _buildRawList('Characters', location.rawCharacters),
              _buildRawList('Items', location.rawItems),
              _buildRawList('Creatures', location.rawCreatures),
              _buildRawList('Stories', location.rawStories),
              _buildRawList('Languages', location.rawLanguages),
              _buildRawList('Religions', location.rawReligions),
              _buildRawList('Technologies', location.rawTechnologies),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(LocationEntity loc) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          if (loc.climate != null)
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: Text(loc.climate!),
              subtitle: const Text('Climate'),
            ),
          if (loc.terrain != null)
            ListTile(
              leading: const Icon(Icons.terrain),
              title: Text(loc.terrain!),
              subtitle: const Text('Terrain'),
            ),
          if (loc.population != null)
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: Text(loc.population.toString()),
              subtitle: const Text('Population'),
            ),
          if (loc.economy != null)
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: Text(loc.economy!),
              subtitle: const Text('Economy'),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Description',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(String notes) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Custom Notes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(notes),
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
  }
}