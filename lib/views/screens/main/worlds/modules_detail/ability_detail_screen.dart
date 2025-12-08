import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'character_detail_screen.dart';
import 'creature_detail_screen.dart';
import 'event_detail_screen.dart';
import 'item_detail_screen.dart';
import 'powersystem_detail_screen.dart';
import 'race_detail_screen.dart';
import 'religion_detail_screen.dart';
import 'story_detail_screen.dart';
import 'technology_detail_screen.dart';
import '../modules_form/ability_form_screen.dart';

final abilityDetailStreamProvider =
    StreamProvider.family.autoDispose<AbilityEntity?, String>((ref, serverId) {
  return ref.watch(abilityRepositoryProvider).watchAbilityByServerId(serverId);
});

final abilityDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(abilitySyncServiceProvider);
  await syncService.fetchAndMergeSingleAbility(serverId);
});

class AbilityDetailScreen extends ConsumerWidget {
  final String abilityServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const AbilityDetailScreen({
    super.key,
    required this.abilityServerId,
  });

  String? _getImageUrl(AbilityEntity ability) {
    if (ability.images.isEmpty) return null;
    String path = ability.images.first;
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
    final asyncAbility = ref.watch(abilityDetailStreamProvider(abilityServerId));

    ref.listen(abilityDetailSyncProvider(abilityServerId), (prev, next) {
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

    return asyncAbility.when(
      data: (ability) {
        if (ability == null) {
          return ref.watch(abilityDetailSyncProvider(abilityServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load ability: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Ability not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, ability);
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

  Widget _buildDetailScaffold(BuildContext context, AbilityEntity ability) {
    final imageUrl = _getImageUrl(ability);
    final tagColor = _getTagColor(ability.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AbilityFormScreen(
                        abilityLocalId: ability.localId,
                        worldLocalId: ability.worldLocalId,
                      ),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(ability.name),
              background: GestureDetector(
                onTap: imageUrl != null 
                  ? () => _openFullScreenImage(context, imageUrl) 
                  : null,
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(color: tagColor.withOpacity(0.5)),
                        errorWidget: (context, url, error) => Container(color: tagColor.withOpacity(0.5)),
                      )
                    : Container(color: tagColor.withOpacity(0.5)),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _buildBasicInfo(ability),
              _buildDescription(ability.description),
              _buildEffect(ability.effect),
              _buildRequirements(ability.requirements),
              _buildCustomNotes(ability.customNotes),
              _buildLinkList(context, 'Characters', ability.rawCharacters, 'character'),
              _buildLinkList(context, 'Power Systems', ability.rawPowerSystems, 'powersystem'),
              _buildLinkList(context, 'Stories', ability.rawStories, 'story'),
              _buildLinkList(context, 'Events', ability.rawEvents, 'event'),
              _buildLinkList(context, 'Items', ability.rawItems, 'item'),
              _buildLinkList(context, 'Religions', ability.rawReligions, 'religion'),
              _buildLinkList(context, 'Technologies', ability.rawTechnologies, 'technology'),
              _buildLinkList(context, 'Creatures', ability.rawCreatures, 'creature'),
              _buildLinkList(context, 'Races', ability.rawRaces, 'race'),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(AbilityEntity ability) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(ability.type ?? 'Unknown'),
            subtitle: const Text('Type'),
          ),
          ListTile(
            leading: const Icon(Icons.wb_sunny_outlined),
            title: Text(ability.element ?? 'Unknown'),
            subtitle: const Text('Element'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart_outlined),
            title: Text(ability.level ?? 'Unknown'),
            subtitle: const Text('Level'),
          ),
          ListTile(
            leading: const Icon(Icons.attach_money_outlined),
            title: Text(ability.cost ?? 'Unknown'),
            subtitle: const Text('Cost'),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(ability.cooldown ?? 'Unknown'),
            subtitle: const Text('Cooldown'),
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
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildEffect(String? effect) {
    if (effect == null || effect.isEmpty) {
      return _buildEmptyStateCard('Effect', Icons.auto_fix_high_outlined);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Effect', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(effect),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirements(String? requirements) {
    if (requirements == null || requirements.isEmpty) {
      return _buildEmptyStateCard('Requirements', Icons.rule_outlined);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Requirements', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(requirements),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomNotes(String? notes) {
    if (notes == null || notes.isEmpty) {
      return _buildEmptyStateCard('Custom Notes', Icons.note_outlined);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Custom Notes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(notes),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkList(BuildContext context, String title, List<ModuleLink> links, String type) {
    // FORCE VISIBILITY: Check if empty and show "No links"
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            links.isEmpty
                ? const Text('No links')
                : Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: links.map((link) => ActionChip(
                      label: Text(link.name),
                      onPressed: () => _navigateToModule(context, type, link.id),
                    )).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  void _navigateToModule(BuildContext context, String type, String id) {
    if (id.isEmpty) return;

    // TODO: Implement navigation for other modules
    // This requires references to other detail screens which might not be imported yet.
    // For now, we just implement the structure.
    switch (type) {
        case 'character':
          Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterDetailScreen(characterServerId: id)));
          break;
        case 'powersystem':
          Navigator.push(context, MaterialPageRoute(builder: (_) => PowerSystemDetailScreen(powerSystemServerId: id)));
          break;
        case 'story':
          Navigator.push(context, MaterialPageRoute(builder: (_) => StoryDetailScreen(storyServerId: id)));
          break;
        case 'event':
          Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(eventServerId: id)));
          break;
        case 'item':
          Navigator.push(context, MaterialPageRoute(builder: (_) => ItemDetailScreen(itemServerId: id)));
          break;
        case 'religion':
          Navigator.push(context, MaterialPageRoute(builder: (_) => ReligionDetailScreen(religionServerId: id)));
          break;
        case 'technology':
          Navigator.push(context, MaterialPageRoute(builder: (_) => TechnologyDetailScreen(technologyServerId: id)));
          break;
        case 'creature':
          Navigator.push(context, MaterialPageRoute(builder: (_) => CreatureDetailScreen(creatureServerId: id)));
          break;
        case 'race':
          Navigator.push(context, MaterialPageRoute(builder: (_) => RaceDetailScreen(raceServerId: id)));
          break;
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
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.white),
          ),
        ),
      ),
    );
  }
}