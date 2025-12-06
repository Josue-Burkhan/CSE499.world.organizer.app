import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/models/api_models/modules/story_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class StoryFormScreen extends ConsumerStatefulWidget {
  final String? storyLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const StoryFormScreen({
    super.key,
    this.storyLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<StoryFormScreen> createState() => _StoryFormScreenState();
}

class _StoryFormScreenState extends ConsumerState<StoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _summaryController = TextEditingController();
  String _tagColor = 'neutral';

  // Timeline
  List<TimelineEvent> _timelineEvents = [];

  @override
  void initState() {
    super.initState();
    _loadStory();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _loadStory() async {
    if (widget.storyLocalId != null) {
      final story = await ref
          .read(storyRepositoryProvider)
          .getStory(widget.storyLocalId!);

      if (story != null) {
        _nameController.text = story.name;
        _summaryController.text = story.summary ?? '';
        _tagColor = story.tagColor;

        if (story.timelineJson != null) {
          final timeline = Timeline.fromJson(jsonDecode(story.timelineJson!));
          _timelineEvents = timeline.timelineEvents ?? [];
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveStory() async {
    if (!_formKey.currentState!.validate()) return;

    final timeline = Timeline(timelineEvents: _timelineEvents);

    final companion = StoriesCompanion(
      localId: widget.storyLocalId != null 
          ? drift.Value(widget.storyLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      summary: drift.Value(_summaryController.text.isEmpty ? null : _summaryController.text),
      tagColor: drift.Value(_tagColor),
      timelineJson: drift.Value(jsonEncode(timeline.toJson())),
    );

    try {
      if (widget.storyLocalId != null) {
        await ref.read(storyRepositoryProvider).updateStory(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Story updated successfully')),
          );
        }
      } else {
        await ref.read(storyRepositoryProvider).createStory(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Story created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving story: $e')),
        );
      }
    }
  }

  Future<List<String>> _search(String query, String type) async {
    if (widget.worldServerId == null) return [];
    try {
      final results = await ref
          .read(worldSyncServiceProvider)
          .searchInWorld(widget.worldServerId!, query, type: type);
      return results.map((r) => r.name).toList();
    } catch (e) {
      return [];
    }
  }

  void _addTimelineEvent() {
    setState(() {
      _timelineEvents.add(TimelineEvent(
        year: 0,
        rawEvents: [],
        description: '',
      ));
    });
  }

  void _removeTimelineEvent(int index) {
    setState(() {
      _timelineEvents.removeAt(index);
    });
  }

  void _updateTimelineEvent(int index, TimelineEvent event) {
    setState(() {
      _timelineEvents[index] = event;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.storyLocalId != null ? 'Edit Story' : 'New Story'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveStory,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Timeline'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildTimelineTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _tagColor,
            decoration: const InputDecoration(labelText: 'Tag Color', border: OutlineInputBorder()),
            items: ['neutral', 'blue', 'purple', 'green', 'red', 'amber', 'lime', 'black']
                .map((color) => DropdownMenuItem(value: color, child: Text(color)))
                .toList(),
            onChanged: (value) => setState(() => _tagColor = value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _summaryController,
            decoration: const InputDecoration(labelText: 'Summary', border: OutlineInputBorder()),
            maxLines: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Text('Timeline Events', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _addTimelineEvent,
                icon: const Icon(Icons.add),
                label: const Text('Add Event'),
              ),
            ],
          ),
        ),
        Expanded(
          child: _timelineEvents.isEmpty
              ? const Center(
                  child: Text(
                    'No timeline events yet. Tap "Add Event" to create one.',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: _timelineEvents.length,
                  itemBuilder: (context, index) {
                    return _TimelineEventCard(
                      event: _timelineEvents[index],
                      onUpdate: (event) => _updateTimelineEvent(index, event),
                      onDelete: () => _removeTimelineEvent(index),
                      searchFunction: _search,
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _TimelineEventCard extends StatefulWidget {
  final TimelineEvent event;
  final Function(TimelineEvent) onUpdate;
  final VoidCallback onDelete;
  final Future<List<String>> Function(String, String) searchFunction;

  const _TimelineEventCard({
    required this.event,
    required this.onUpdate,
    required this.onDelete,
    required this.searchFunction,
  });

  @override
  State<_TimelineEventCard> createState() => _TimelineEventCardState();
}

class _TimelineEventCardState extends State<_TimelineEventCard> {
  late TextEditingController _yearController;
  late TextEditingController _descriptionController;
  late List<String> _rawEvents;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _yearController = TextEditingController(text: widget.event.year.toString());
    _descriptionController = TextEditingController(text: widget.event.description);
    _rawEvents = List.from(widget.event.rawEvents);
  }

  @override
  void dispose() {
    _yearController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _notifyUpdate() {
    widget.onUpdate(TimelineEvent(
      year: num.tryParse(_yearController.text) ?? 0,
      rawEvents: _rawEvents,
      description: _descriptionController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              'Year ${_yearController.text}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _descriptionController.text.isEmpty 
                  ? 'No description' 
                  : _descriptionController.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => _notifyUpdate(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (_) => _notifyUpdate(),
                  ),
                  const SizedBox(height: 16),
                  AutocompleteChips(
                    label: 'Related Events',
                    initialValues: _rawEvents,
                    onChanged: (values) {
                      _rawEvents = values;
                      _notifyUpdate();
                    },
                    searchFunction: (q) => widget.searchFunction(q, 'event'),
                    hintText: 'Add related event...',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}