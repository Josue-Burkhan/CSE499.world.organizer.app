import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/faction_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/item_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/creature_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/language_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';

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
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: tagColor.withOpacity(0.5)),
                        errorWidget: (context, url, error) => 
                          Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(location),
              _buildDescription(location.description),
              _buildCustomNotes(location.customNotes),
              _buildLinkList(context, 'Locations', location.rawLocations),
              _buildLinkList(context, 'Factions', location.rawFactions),
              _buildLinkList(context, 'Events', location.rawEvents),
              _buildLinkList(context, 'Characters', location.rawCharacters),
              _buildLinkList(context, 'Items', location.rawItems),
              _buildLinkList(context, 'Creatures', location.rawCreatures),
              _buildLinkList(context, 'Stories', location.rawStories),
              _buildLinkList(context, 'Languages', location.rawLanguages),
              _buildLinkList(context, 'Religions', location.rawReligions),
              _buildLinkList(context, 'Technologies', location.rawTechnologies),
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
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: Text(loc.climate?.isEmpty == true ? 'Unknown' : loc.climate ?? 'Unknown'),
            subtitle: const Text('Climate'),
          ),
          ListTile(
            leading: const Icon(Icons.terrain),
            title: Text(loc.terrain?.isEmpty == true ? 'Unknown' : loc.terrain ?? 'Unknown'),
            subtitle: const Text('Terrain'),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(loc.population == null ? 'Unknown' : loc.population.toString()),
            subtitle: const Text('Population'),
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: Text(loc.economy?.isEmpty == true ? 'Unknown' : loc.economy ?? 'Unknown'),
            subtitle: const Text('Economy'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String? description) {
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
            Text(description?.isEmpty == true ? 'No description available.' : description ?? 'No description available.'),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(String? notes) {
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
            Text(notes?.isEmpty == true ? 'No custom notes.' : notes ?? 'No custom notes.'),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList(BuildContext context, String title, List<ModuleLink> links) {
    if (links.isEmpty) return const SizedBox.shrink();

    String type = '';
    if (title == 'Locations') type = 'location';
    else if (title == 'Factions') type = 'faction';
    else if (title == 'Events') type = 'event';
    else if (title == 'Characters') type = 'character';
    else if (title == 'Items') type = 'item';
    else if (title == 'Creatures') type = 'creature';
    else if (title == 'Stories') type = 'story';
    else if (title == 'Languages') type = 'language';
    else if (title == 'Religions') type = 'religion';
    else if (title == 'Technologies') type = 'technology';

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
              children: links.map((link) => ActionChip(
                label: Text(link.name),
                onPressed: () {
                   if (link.id.isEmpty) return;
                   
                   Widget? page;
                   switch (type) {
                     case 'location': page = LocationDetailScreen(locationServerId: link.id); break;
                     case 'faction': page = FactionDetailScreen(factionServerId: link.id); break;
                     case 'event': page = EventDetailScreen(eventServerId: link.id); break;
                     case 'character': page = CharacterDetailScreen(characterServerId: link.id); break;
                     case 'item': page = ItemDetailScreen(itemServerId: link.id); break;
                     case 'creature': page = CreatureDetailScreen(creatureServerId: link.id); break;
                     case 'story': page = StoryDetailScreen(storyServerId: link.id); break;
                     case 'language': page = LanguageDetailScreen(languageServerId: link.id); break;
                     case 'religion': page = ReligionDetailScreen(religionServerId: link.id); break;
                     case 'technology': page = TechnologyDetailScreen(technologyServerId: link.id); break;
                   }
                   
                   if (page != null) {
                     Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
                   }
                },
              )).toList(),
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