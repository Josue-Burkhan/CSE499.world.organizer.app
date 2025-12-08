import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final languageDetailStreamProvider =
    StreamProvider.family.autoDispose<LanguageEntity?, String>((ref, serverId) {
  return ref.watch(languageRepositoryProvider).watchLanguageByServerId(serverId);
});

final languageDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(languageSyncServiceProvider);
  await syncService.fetchAndMergeSingleLanguage(serverId);
});

class LanguageDetailScreen extends ConsumerWidget {
  final String languageServerId;
  static const String _imageBaseUrl = 'https://writers.wild-fantasy.com';

  const LanguageDetailScreen({
    super.key,
    required this.languageServerId,
  });

  String? _getImageUrl(LanguageEntity lang) {
    if (lang.images.isEmpty) return null;
    String path = lang.images.first;
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
    final asyncLanguage = ref.watch(languageDetailStreamProvider(languageServerId));

    ref.listen(languageDetailSyncProvider(languageServerId), (prev, next) {
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

    return asyncLanguage.when(
      data: (language) {
        if (language == null) {
          return ref.watch(languageDetailSyncProvider(languageServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load language: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Language not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, language);
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

  Widget _buildDetailScaffold(BuildContext context, LanguageEntity language) {
    final imageUrl = _getImageUrl(language);
    final tagColor = _getTagColor(language.tagColor);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            backgroundColor: tagColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(language.name),
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
              _buildBasicInfo(language),
              _buildLinguisticDetails(language),
              _buildCustomNotes(language.customNotes),
              _buildRawList('Races', language.rawRaces),
              _buildRawList('Factions', language.rawFactions),
              _buildRawList('Characters', language.rawCharacters),
              _buildRawList('Locations', language.rawLocations),
              _buildRawList('Stories', language.rawStories),
              _buildRawList('Religions', language.rawReligions),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfo(LanguageEntity lang) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              lang.isSacred ? Icons.auto_awesome : Icons.chat_bubble_outline,
              color: lang.isSacred ? Colors.amber : null,
            ),
            title: Text(lang.isSacred ? 'Sacred Language' : 'Common Language'),
            subtitle: const Text('Status'),
          ),
          ListTile(
            leading: Icon(
              lang.isExtinct ? Icons.history : Icons.groups,
              color: lang.isExtinct ? Colors.grey : Colors.green,
            ),
            title: Text(lang.isExtinct ? 'Extinct' : 'Active'),
            subtitle: const Text('Usage'),
          ),
        ],
      ),
    );
  }

  Widget _buildLinguisticDetails(LanguageEntity lang) {
    // Always show the card, but use "Unknown" for empty fields
    // final hasAlphabet = lang.alphabet != null && lang.alphabet!.isNotEmpty;
    // final hasPronunciation = lang.pronunciationRules != null && lang.pronunciationRules!.isNotEmpty;
    // final hasGrammar = lang.grammarNotes != null && lang.grammarNotes!.isNotEmpty;

    // if (!hasAlphabet && !hasPronunciation && !hasGrammar) {
    //   return const SizedBox.shrink();
    // }

    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Linguistic Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Alphabet', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(lang.alphabet?.isEmpty == true ? 'Unknown' : lang.alphabet ?? 'Unknown'),

            const SizedBox(height: 16),
            const Text('Pronunciation Rules', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(lang.pronunciationRules?.isEmpty == true ? 'Unknown' : lang.pronunciationRules ?? 'Unknown'),

            const SizedBox(height: 16),
            const Text('Grammar Notes', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(lang.grammarNotes?.isEmpty == true ? 'Unknown' : lang.grammarNotes ?? 'Unknown'),
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