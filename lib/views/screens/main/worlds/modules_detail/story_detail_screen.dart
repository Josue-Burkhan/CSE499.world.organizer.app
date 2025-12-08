import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/story_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final storyDetailStreamProvider =
    StreamProvider.family.autoDispose<StoryEntity?, String>((ref, serverId) {
  return ref.watch(storyRepositoryProvider).watchStoryByServerId(serverId);
});

final storyDetailSyncProvider =
    FutureProvider.family<void, String>((ref, serverId) async {
  final syncService = ref.watch(storySyncServiceProvider);
  await syncService.fetchAndMergeSingleStory(serverId);
});

class StoryDetailScreen extends ConsumerWidget {
  final String storyServerId;

  const StoryDetailScreen({
    super.key,
    required this.storyServerId,
  });

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncStory = ref.watch(storyDetailStreamProvider(storyServerId));

    ref.listen(storyDetailSyncProvider(storyServerId), (prev, next) {
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

    return asyncStory.when(
      data: (story) {
        if (story == null) {
          return ref.watch(storyDetailSyncProvider(storyServerId)).when(
                loading: () => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: CircularProgressIndicator()),
                ),
                error: (e, s) => Scaffold(
                  appBar: AppBar(),
                  body: Center(child: Text('Failed to load story: $e')),
                ),
                data: (_) => Scaffold(
                  appBar: AppBar(),
                  body: const Center(child: Text('Story not found.')),
                ),
              );
        }
        return _buildDetailScaffold(context, story);
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

  Widget _buildDetailScaffold(BuildContext context, StoryEntity story) {
    final tagColor = _getTagColor(story.tagColor);

    Timeline? timeline;
    if (story.timelineJson != null) {
      timeline = Timeline.fromJson(jsonDecode(story.timelineJson!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(story.name),
        backgroundColor: tagColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummary(story.summary),
            _buildTimeline(timeline),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(String? summary) {
    if (summary == null || summary.isEmpty) {
      return _buildEmptyStateCard('Summary', Icons.subject);
    }
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(summary),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeline(Timeline? timeline) {
    if (timeline == null || timeline.timelineEvents == null || timeline.timelineEvents!.isEmpty) {
      return _buildEmptyStateCard('Timeline', Icons.timeline);
    }
    final events = timeline.timelineEvents!;
    
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Timeline',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...events.map((event) => _buildTimelineEvent(event)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineEvent(TimelineEvent event) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Year ${event.year}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.description,
                  style: const TextStyle(fontSize: 14),
                ),
                  const SizedBox(height: 8),
                  event.rawEvents.isNotEmpty
                      ? Wrap(
                          spacing: 6.0,
                          runSpacing: 4.0,
                          children: event.rawEvents
                              .map((e) => Chip(
                                    label: Text(e, style: const TextStyle(fontSize: 11)),
                                    padding: const EdgeInsets.all(4),
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ))
                              .toList(),
                        )
                      : const Text(
                          'Related: None',
                          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
                        ),
                ],
            ),
          ),
        ],
      ),
    );
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
