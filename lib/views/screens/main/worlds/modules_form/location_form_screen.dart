import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';

class LocationFormScreen extends ConsumerStatefulWidget {
  final String? locationLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const LocationFormScreen({
    super.key,
    this.locationLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<LocationFormScreen> createState() => _LocationFormScreenState();
}

class _LocationFormScreenState extends ConsumerState<LocationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Details
  final _climateController = TextEditingController();
  final _terrainController = TextEditingController();
  final _populationController = TextEditingController();
  final _economyController = TextEditingController();

  // Links (Raw)
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawFactions = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawItems = [];
  List<ModuleLink> _rawCreatures = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawLanguages = [];
  List<ModuleLink> _rawReligions = [];
  List<ModuleLink> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customNotesController.dispose();
    _climateController.dispose();
    _terrainController.dispose();
    _populationController.dispose();
    _economyController.dispose();
    super.dispose();
  }

  Future<void> _loadLocation() async {
    if (widget.locationLocalId != null) {
      final location = await ref
          .read(locationRepositoryProvider)
          .getLocation(widget.locationLocalId!);

      if (location != null) {
        _nameController.text = location.name;
        _descriptionController.text = location.description ?? '';
        _customNotesController.text = location.customNotes ?? '';
        _tagColor = location.tagColor;

        _climateController.text = location.climate ?? '';
        _terrainController.text = location.terrain ?? '';
        _populationController.text = location.population?.toString() ?? '';
        _economyController.text = location.economy ?? '';

        _rawLocations = location.rawLocations;
        _rawFactions = location.rawFactions;
        _rawEvents = location.rawEvents;
        _rawCharacters = location.rawCharacters;
        _rawItems = location.rawItems;
        _rawCreatures = location.rawCreatures;
        _rawStories = location.rawStories;
        _rawLanguages = location.rawLanguages;
        _rawReligions = location.rawReligions;
        _rawTechnologies = location.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = LocationsCompanion(
      localId: widget.locationLocalId != null 
          ? drift.Value(widget.locationLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      climate: drift.Value(_climateController.text.isEmpty ? null : _climateController.text),
      terrain: drift.Value(_terrainController.text.isEmpty ? null : _terrainController.text),
      population: drift.Value(num.tryParse(_populationController.text) as double?),
      economy: drift.Value(_economyController.text.isEmpty ? null : _economyController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawLocations: drift.Value(_rawLocations),
      rawFactions: drift.Value(_rawFactions),
      rawEvents: drift.Value(_rawEvents),
      rawCharacters: drift.Value(_rawCharacters),
      rawItems: drift.Value(_rawItems),
      rawCreatures: drift.Value(_rawCreatures),
      rawStories: drift.Value(_rawStories),
      rawLanguages: drift.Value(_rawLanguages),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.locationLocalId != null) {
        await ref.read(locationRepositoryProvider).updateLocation(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location updated successfully')),
          );
        }
      } else {
        await ref.read(locationRepositoryProvider).createLocation(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving location: $e')),
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

  void _updateLinksList(
    List<String> newNames,
    List<ModuleLink> currentLinks,
    Function(List<ModuleLink>) updateState,
  ) {
    final updatedLinks = <ModuleLink>[];
    for (final name in newNames) {
      // Find existing link with this name to preserve ID
      final existing = currentLinks.firstWhere(
        (link) => link.name == name,
        orElse: () => ModuleLink(id: '', name: name),
      );
      updatedLinks.add(existing);
    }
    updateState(updatedLinks);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.locationLocalId != null ? 'Edit Location' : 'New Location'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveLocation,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Details'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildDetailsTab(),
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

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _climateController,
                  decoration: const InputDecoration(labelText: 'Climate', border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _terrainController,
                  decoration: const InputDecoration(labelText: 'Terrain', border: OutlineInputBorder()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _populationController,
            decoration: const InputDecoration(labelText: 'Population', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _economyController,
            decoration: const InputDecoration(labelText: 'Economy', border: OutlineInputBorder()),
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
            label: 'Locations (Sub-locations)',
            initialValues: _rawLocations.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawLocations, (l) => _rawLocations = l),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Factions',
            initialValues: _rawFactions.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawFactions, (l) => _rawFactions = l),
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Events',
            initialValues: _rawEvents.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawEvents, (l) => _rawEvents = l),
            searchFunction: (q) => _search(q, 'event'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Characters',
            initialValues: _rawCharacters.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawCharacters, (l) => _rawCharacters = l),
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Items',
            initialValues: _rawItems.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawItems, (l) => _rawItems = l),
            searchFunction: (q) => _search(q, 'item'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Creatures',
            initialValues: _rawCreatures.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawCreatures, (l) => _rawCreatures = l),
            searchFunction: (q) => _search(q, 'creature'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawStories, (l) => _rawStories = l),
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Languages',
            initialValues: _rawLanguages.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawLanguages, (l) => _rawLanguages = l),
            searchFunction: (q) => _search(q, 'language'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Religions',
            initialValues: _rawReligions.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawReligions, (l) => _rawReligions = l),
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawTechnologies, (l) => _rawTechnologies = l),
            searchFunction: (q) => _search(q, 'technology'),
          ),
        ],
      ),
    );
  }
}