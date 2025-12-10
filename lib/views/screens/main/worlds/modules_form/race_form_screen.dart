import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';

class RaceFormScreen extends ConsumerStatefulWidget {
  final String? raceLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const RaceFormScreen({
    super.key,
    this.raceLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<RaceFormScreen> createState() => _RaceFormScreenState();
}

class _RaceFormScreenState extends ConsumerState<RaceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _tagColor = 'neutral';

  // Physical Traits
  final _lifespanController = TextEditingController();
  final _averageHeightController = TextEditingController();
  final _averageWeightController = TextEditingController();
  List<String> _traits = [];

  // Culture
  final _cultureController = TextEditingController();
  bool _isExtinct = false;

  // Links (Raw)
  // Links (Raw)
  List<ModuleLink> _rawLanguages = [];
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawReligions = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawPowerSystems = [];
  List<ModuleLink> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadRace();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _lifespanController.dispose();
    _averageHeightController.dispose();
    _averageWeightController.dispose();
    _cultureController.dispose();
    super.dispose();
  }

  Future<void> _loadRace() async {
    if (widget.raceLocalId != null) {
      final race = await ref
          .read(raceRepositoryProvider)
          .getRace(widget.raceLocalId!);

      if (race != null) {
        _nameController.text = race.name;
        _descriptionController.text = race.description ?? '';
        _tagColor = race.tagColor;
        _lifespanController.text = race.lifespan ?? '';
        _averageHeightController.text = race.averageHeight ?? '';
        _averageWeightController.text = race.averageWeight ?? '';
        _traits = race.traits;
        _cultureController.text = race.culture ?? '';
        _isExtinct = race.isExtinct;
        
        _rawLanguages = race.rawLanguages;
        _rawCharacters = race.rawCharacters;
        _rawLocations = race.rawLocations;
        _rawReligions = race.rawReligions;
        _rawStories = race.rawStories;
        _rawEvents = race.rawEvents;
        _rawPowerSystems = race.rawPowerSystems;
        _rawTechnologies = race.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveRace() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = RacesCompanion(
      localId: widget.raceLocalId != null 
          ? drift.Value(widget.raceLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      tagColor: drift.Value(_tagColor),
      lifespan: drift.Value(_lifespanController.text.isEmpty ? null : _lifespanController.text),
      averageHeight: drift.Value(_averageHeightController.text.isEmpty ? null : _averageHeightController.text),
      averageWeight: drift.Value(_averageWeightController.text.isEmpty ? null : _averageWeightController.text),
      traits: drift.Value(_traits),
      culture: drift.Value(_cultureController.text.isEmpty ? null : _cultureController.text),
      isExtinct: drift.Value(_isExtinct),
      rawLanguages: drift.Value(_rawLanguages),
      rawCharacters: drift.Value(_rawCharacters),
      rawLocations: drift.Value(_rawLocations),
      rawReligions: drift.Value(_rawReligions),
      rawStories: drift.Value(_rawStories),
      rawEvents: drift.Value(_rawEvents),
      rawPowerSystems: drift.Value(_rawPowerSystems),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.raceLocalId != null) {
        await ref.read(raceRepositoryProvider).updateRace(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Race updated successfully')),
          );
        }
      } else {
        await ref.read(raceRepositoryProvider).createRace(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Race created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving race: $e')),
        );
      }
    }
  }

  List<ModuleLink> _updateLinksList(List<ModuleLink> currentList, List<String> newNames) {
    final Map<String, ModuleLink> existingMap = {
      for (var item in currentList) item.name: item,
    };
    
    return newNames.map((name) {
      if (existingMap.containsKey(name)) {
        return existingMap[name]!;
      }
      return ModuleLink(id: '', name: name);
    }).toList();
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.raceLocalId != null ? 'Edit Race' : 'New Race'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveRace,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Physical Traits'),
              Tab(text: 'Culture'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildPhysicalTraitsTab(),
              _buildCultureTab(),
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
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Is Extinct'),
            value: _isExtinct,
            onChanged: (value) => setState(() => _isExtinct = value),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalTraitsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _lifespanController,
            decoration: const InputDecoration(labelText: 'Lifespan', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _averageHeightController,
            decoration: const InputDecoration(labelText: 'Average Height', border: OutlineInputBorder()),
          ),
          TextFormField(
            controller: _averageWeightController,
            decoration: const InputDecoration(labelText: 'Average Weight', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildCultureTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _cultureController,
            decoration: const InputDecoration(labelText: 'Culture', border: OutlineInputBorder()),
            maxLines: 5,
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
            label: 'Languages',
            initialValues: _rawLanguages.map((e) => e.name).toList(),
            onChanged: (values) => _rawLanguages = _updateLinksList(_rawLanguages, values),
            searchFunction: (q) => _search(q, 'language'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Characters',
            initialValues: _rawCharacters.map((e) => e.name).toList(),
            onChanged: (values) => _rawCharacters = _updateLinksList(_rawCharacters, values),
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations.map((e) => e.name).toList(),
            onChanged: (values) => _rawLocations = _updateLinksList(_rawLocations, values),
            searchFunction: (q) => _search(q, 'location'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Religions',
            initialValues: _rawReligions.map((e) => e.name).toList(),
            onChanged: (values) => _rawReligions = _updateLinksList(_rawReligions, values),
            searchFunction: (q) => _search(q, 'religion'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _rawStories = _updateLinksList(_rawStories, values),
            searchFunction: (q) => _search(q, 'story'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Events',
            initialValues: _rawEvents.map((e) => e.name).toList(),
            onChanged: (values) => _rawEvents = _updateLinksList(_rawEvents, values),
            searchFunction: (q) => _search(q, 'event'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Power Systems',
            initialValues: _rawPowerSystems.map((e) => e.name).toList(),
            onChanged: (values) => _rawPowerSystems = _updateLinksList(_rawPowerSystems, values),
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Technologies',
            initialValues: _rawTechnologies.map((e) => e.name).toList(),
            onChanged: (values) => _rawTechnologies = _updateLinksList(_rawTechnologies, values),
            searchFunction: (q) => _search(q, 'technology'),
          ),
        ],
      ),
    );
  }
}