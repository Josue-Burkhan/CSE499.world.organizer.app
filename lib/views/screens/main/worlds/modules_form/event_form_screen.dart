import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final String? eventLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const EventFormScreen({
    super.key,
    this.eventLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Links (Raw)
  List<String> _rawCharacters = [];
  List<String> _rawFactions = [];
  List<String> _rawLocations = [];
  List<String> _rawItems = [];
  List<String> _rawAbilities = [];
  List<String> _rawStories = [];
  List<String> _rawPowerSystems = [];
  List<String> _rawCreatures = [];
  List<String> _rawReligions = [];
  List<String> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _customNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadEvent() async {
    if (widget.eventLocalId != null) {
      final event = await ref
          .read(eventRepositoryProvider)
          .getEvent(widget.eventLocalId!);

      if (event != null) {
        _nameController.text = event.name;
        _dateController.text = event.date ?? '';
        _descriptionController.text = event.description ?? '';
        _customNotesController.text = event.customNotes ?? '';
        _tagColor = event.tagColor;

        _rawCharacters = event.rawCharacters;
        _rawFactions = event.rawFactions;
        _rawLocations = event.rawLocations;
        _rawItems = event.rawItems;
        _rawAbilities = event.rawAbilities;
        _rawStories = event.rawStories;
        _rawPowerSystems = event.rawPowerSystems;
        _rawCreatures = event.rawCreatures;
        _rawReligions = event.rawReligions;
        _rawTechnologies = event.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = EventsCompanion(
      localId: widget.eventLocalId != null 
          ? drift.Value(widget.eventLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      date: drift.Value(_dateController.text.isEmpty ? null : _dateController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawCharacters: drift.Value(_rawCharacters),
      rawFactions: drift.Value(_rawFactions),
      rawLocations: drift.Value(_rawLocations),
      rawItems: drift.Value(_rawItems),
      rawAbilities: drift.Value(_rawAbilities),
      rawStories: drift.Value(_rawStories),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawCreatures: drift.Value(_rawCreatures),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.eventLocalId != null) {
        await ref.read(eventRepositoryProvider).updateEvent(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event updated successfully')),
          );
        }
      } else {
        await ref.read(eventRepositoryProvider).createEvent(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Event created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving event: $e')),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.eventLocalId != null ? 'Edit Event' : 'New Event'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveEvent,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildLinksTab(),
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
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Date', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 4,
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
            controller: _customNotesController,
            decoration: const InputDecoration(labelText: 'Custom Notes', border: OutlineInputBorder()),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildLinksTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AutocompleteChips(
            label: 'Characters',
            initialValues: _rawCharacters,
            onChanged: (values) => _rawCharacters = values,
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Factions',
            initialValues: _rawFactions,
            onChanged: (values) => _rawFactions = values,
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations,
            onChanged: (values) => _rawLocations = values,
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Items',
            initialValues: _rawItems,
            onChanged: (values) => _rawItems = values,
            searchFunction: (q) => _search(q, 'item'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Abilities',
            initialValues: _rawAbilities,
            onChanged: (values) => _rawAbilities = values,
            searchFunction: (q) => _search(q, 'ability'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories,
            onChanged: (values) => _rawStories = values,
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Power Systems',
            initialValues: _rawPowerSystems,
            onChanged: (values) => _rawPowerSystems = values,
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Creatures',
            initialValues: _rawCreatures,
            onChanged: (values) => _rawCreatures = values,
            searchFunction: (q) => _search(q, 'creature'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Religions',
            initialValues: _rawReligions,
            onChanged: (values) => _rawReligions = values,
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies,
            onChanged: (values) => _rawTechnologies = values,
            searchFunction: (q) => _search(q, 'technology'),
          ),
        ],
      ),
    );
  }
}