import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final technologyDetailStreamProvider =
    StreamProvider.family.autoDispose<TechnologyEntity?, String>((ref, serverId) {
  return ref.watch(technologyRepositoryProvider).watchTechnologyByServerId(serverId);
});

final technologyDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(technologySyncServiceProvider);
  await syncService.fetchAndMergeSingleTechnology(serverId);
});

class TechnologyDetailScreen extends ConsumerWidget {
  final String technologyServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const TechnologyDetailScreen({
    super.key,
    required this.technologyServerId,
  });

  String? _getImageUrl(TechnologyEntity tech) {
    if (tech.images.isEmpty) return null;
    String path = tech.images.first;
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
    final asyncTechnology = ref.watch(technologyDetailStreamProvider(technologyServerId));

    ref.listen(technologyDetailSyncProvider(technologyServerId), (prev, next) {
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

    return asyncTechnology.when(
      data: (technology) {
        if (technology == null) {
          return ref.watch(technologyDetailSyncProvider(technologyServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load technology: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Technology not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, technology);
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

  Widget _buildDetailScaffold(BuildContext context, TechnologyEntity technology) {
    final imageUrl = _getImageUrl(technology);
    final tagColor = _getTagColor(technology.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(technology.name),
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
              _buildBasicInfo(technology),
              if (technology.description != null) _buildDescription(technology.description!),
              _buildTechnologyDetails(technology),
              if (technology.customNotes != null) _buildCustomNotes(technology.customNotes!),
              _buildRawList('Creators', technology.rawCreators),
              _buildRawList('Characters', technology.rawCharacters),
              _buildRawList('Factions', technology.rawFactions),
              _buildRawList('Items', technology.rawItems),
              _buildRawList('Events', technology.rawEvents),
              _buildRawList('Stories', technology.rawStories),
              _buildRawList('Locations', technology.rawLocations),
              _buildRawList('Power Systems', technology.rawPowerSystems),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(TechnologyEntity tech) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          if (tech.techType != null)
            ListTile(
              leading: const Icon(Icons.category_outlined),
              title: Text(tech.techType!),
              subtitle: const Text('Technology Type'),
            ),
          if (tech.yearCreated != null)
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: Text(tech.yearCreated.toString()),
              subtitle: const Text('Year Created'),
            ),
          if (tech.energySource != null)
            ListTile(
              leading: const Icon(Icons.bolt),
              title: Text(tech.energySource!),
              subtitle: const Text('Energy Source'),
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

  Widget _buildTechnologyDetails(TechnologyEntity tech) {
    final hasOrigin = tech.origin != null && tech.origin!.isNotEmpty;
    final hasCurrentUse = tech.currentUse != null && tech.currentUse!.isNotEmpty;
    final hasLimitations = tech.limitations != null && tech.limitations!.isNotEmpty;

    if (!hasOrigin && !hasCurrentUse && !hasLimitations) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Technology Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            if (hasOrigin) ...[
              const SizedBox(height: 16),
              const Text(
                'Origin',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(tech.origin!),
            ],
            if (hasCurrentUse) ...[
              const SizedBox(height: 16),
              const Text(
                'Current Use',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(tech.currentUse!),
            ],
            if (hasLimitations) ...[
              const SizedBox(height: 16),
              const Text(
                'Limitations',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(tech.limitations!),
            ],
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