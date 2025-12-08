import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/character_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/location_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/religion_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/story_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/event_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/powersystem_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/technology_detail_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_detail/language_detail_screen.dart';

final raceDetailStreamProvider =
    StreamProvider.family.autoDispose<RaceEntity?, String>((ref, serverId) {
  return ref.watch(raceRepositoryProvider).watchRaceByServerId(serverId);
});

final raceDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(raceSyncServiceProvider);
  await syncService.fetchAndMergeSingleRace(serverId);
});

class RaceDetailScreen extends ConsumerWidget {
  final String raceServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const RaceDetailScreen({
    super.key,
    required this.raceServerId,
  });

  String? _getImageUrl(RaceEntity race) {
    if (race.images.isEmpty) return null;
    String path = race.images.first;
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
    final asyncRace = ref.watch(raceDetailStreamProvider(raceServerId));

    ref.listen(raceDetailSyncProvider(raceServerId), (prev, next) {
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

    return asyncRace.when(
      data: (race) {
        if (race == null) {
          return ref.watch(raceDetailSyncProvider(raceServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load race: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Race not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, race);
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

  Widget _buildDetailScaffold(BuildContext context, RaceEntity race) {
    final imageUrl = _getImageUrl(race);
    final tagColor = _getTagColor(race.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(race.name),
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
              if (race.isExtinct) _buildExtinctBanner(),
              _buildBasicInfo(race),
              _buildDescription(race.description),
              _buildCulture(race.culture),
              _buildChipList('Traits', race.traits),
              _buildLinkList(context, 'Languages', race.rawLanguages),
              _buildLinkList(context, 'Characters', race.rawCharacters),
              _buildLinkList(context, 'Locations', race.rawLocations),
              _buildLinkList(context, 'Religions', race.rawReligions),
              _buildLinkList(context, 'Stories', race.rawStories),
              _buildLinkList(context, 'Events', race.rawEvents),
              _buildLinkList(context, 'Power Systems', race.rawPowerSystems),
              _buildLinkList(context, 'Technologies', race.rawTechnologies),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildExtinctBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.history, color: Colors.grey.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This race is extinct',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(RaceEntity race) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.timelapse),
            title: Text(race.lifespan?.isEmpty == true ? 'Unknown' : race.lifespan ?? 'Unknown'),
            subtitle: const Text('Lifespan'),
          ),
          ListTile(
            leading: const Icon(Icons.height),
            title: Text(race.averageHeight?.isEmpty == true ? 'Unknown' : race.averageHeight ?? 'Unknown'),
            subtitle: const Text('Average Height'),
          ),
          ListTile(
            leading: const Icon(Icons.monitor_weight_outlined),
            title: Text(race.averageWeight?.isEmpty == true ? 'Unknown' : race.averageWeight ?? 'Unknown'),
            subtitle: const Text('Average Weight'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String? description) {
    if (description == null || description.isEmpty) {
      return _buildEmptyStateCard('Description', Icons.description_outlined);
    }
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

  Widget _buildCulture(String? culture) {
    if (culture == null || culture.isEmpty) {
      return _buildEmptyStateCard('Culture', Icons.people_outline);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Culture',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(culture),
          ],
        ),
      ),
    );
  }

  Widget _buildChipList(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
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
              children: items.map((item) => Chip(label: Text(item))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList(BuildContext context, String title, List<ModuleLink> links) {
    if (links.isEmpty) return const SizedBox.shrink();

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
                onPressed: () => _navigateToModule(context, link, title),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, ModuleLink link, String title) {
    if (link.id.isEmpty) return;

    Widget? page;
    switch (title) {
      case 'Languages': page = LanguageDetailScreen(languageServerId: link.id); break;
      case 'Characters': page = CharacterDetailScreen(characterServerId: link.id); break;
      case 'Locations': page = LocationDetailScreen(locationServerId: link.id); break;
      case 'Religions': page = ReligionDetailScreen(religionServerId: link.id); break;
      case 'Stories': page = StoryDetailScreen(storyServerId: link.id); break;
      case 'Events': page = EventDetailScreen(eventServerId: link.id); break;
      case 'Power Systems': page = PowerSystemDetailScreen(powerSystemServerId: link.id); break;
      case 'Technologies': page = TechnologyDetailScreen(technologyServerId: link.id); break;
    }

    if (page != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
    }
  }
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
          child: CachedNetworkImage(imageUrl: imageUrl),
        ),
      ),
    );
  }
}