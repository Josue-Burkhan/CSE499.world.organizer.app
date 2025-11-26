import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

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
            flexibleSpace: FlexibleSpaceBar(
              title: Text(ability.name),
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
              _buildBasicInfo(ability),
              if (ability.description != null) _buildDescription(ability.description!),
              if (ability.effect != null) _buildEffect(ability.effect!),
              if (ability.requirements != null) _buildRequirements(ability.requirements!),
              if (ability.customNotes != null) _buildCustomNotes(ability.customNotes!),
              _buildRawList('Characters', ability.rawCharacters),
              _buildRawList('Power Systems', ability.rawPowerSystems),
              _buildRawList('Stories', ability.rawStories),
              _buildRawList('Events', ability.rawEvents),
              _buildRawList('Items', ability.rawItems),
              _buildRawList('Religions', ability.rawReligions),
              _buildRawList('Technologies', ability.rawTechnologies),
              _buildRawList('Creatures', ability.rawCreatures),
              _buildRawList('Races', ability.rawRaces),
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
          if (ability.type != null)
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(ability.type!),
              subtitle: const Text('Type'),
            ),
          if (ability.element != null)
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: Text(ability.element!),
              subtitle: const Text('Element'),
            ),
          if (ability.level != null)
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: Text(ability.level!),
              subtitle: const Text('Level'),
            ),
          if (ability.cost != null)
            ListTile(
              leading: const Icon(Icons.attach_money_outlined),
              title: Text(ability.cost!),
              subtitle: const Text('Cost'),
            ),
          if (ability.cooldown != null)
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: Text(ability.cooldown!),
              subtitle: const Text('Cooldown'),
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
            const Text('Description', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8.0),
            Text(description),
          ],
        ),
      ),
    );
  }

  Widget _buildEffect(String effect) {
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

  Widget _buildRequirements(String requirements) {
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

  Widget _buildCustomNotes(String notes) {
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