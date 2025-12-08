import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';

class TechnologyFormScreen extends ConsumerStatefulWidget {
  final String? technologyLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const TechnologyFormScreen({
    super.key,
    this.technologyLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<TechnologyFormScreen> createState() => _TechnologyFormScreenState();
}

class _TechnologyFormScreenState extends ConsumerState<TechnologyFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Technical Details
  final _techTypeController = TextEditingController();
  final _originController = TextEditingController();
  final _yearCreatedController = TextEditingController();
  final _energySourceController = TextEditingController();

  // Usage & Limitations
  final _currentUseController = TextEditingController();
  final _limitationsController = TextEditingController();

  // Links (Raw)
  List<ModuleLink> _rawCreators = [];
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawFactions = [];
  List<ModuleLink> _rawItems = [];
  List<ModuleLink> _rawEvents = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawPowerSystems = [];

  @override
  void initState() {
    super.initState();
    _loadTechnology();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customNotesController.dispose();
    _techTypeController.dispose();
    _originController.dispose();
    _yearCreatedController.dispose();
    _energySourceController.dispose();
    _currentUseController.dispose();
    _limitationsController.dispose();
    super.dispose();
  }

  Future<void> _loadTechnology() async {
    if (widget.technologyLocalId != null) {
      final technology = await ref
          .read(technologyRepositoryProvider)
          .getTechnology(widget.technologyLocalId!);

      if (technology != null) {
        _nameController.text = technology.name;
        _descriptionController.text = technology.description ?? '';
        _customNotesController.text = technology.customNotes ?? '';
        _tagColor = technology.tagColor;
        _techTypeController.text = technology.techType ?? '';
        _originController.text = technology.origin ?? '';
        _yearCreatedController.text = technology.yearCreated?.toString() ?? '';
        _energySourceController.text = technology.energySource ?? '';
        _currentUseController.text = technology.currentUse ?? '';
        _limitationsController.text = technology.limitations ?? '';
        
        _rawCreators = technology.rawCreators;
        _rawCharacters = technology.rawCharacters;
        _rawFactions = technology.rawFactions;
        _rawItems = technology.rawItems;
        _rawEvents = technology.rawEvents;
        _rawStories = technology.rawStories;
        _rawLocations = technology.rawLocations;
        _rawPowerSystems = technology.rawPowerSystems;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveTechnology() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = TechnologiesCompanion(
      localId: widget.technologyLocalId != null 
          ? drift.Value(widget.technologyLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      techType: drift.Value(_techTypeController.text.isEmpty ? null : _techTypeController.text),
      origin: drift.Value(_originController.text.isEmpty ? null : _originController.text),
      yearCreated: drift.Value(num.tryParse(_yearCreatedController.text) as double?),
      energySource: drift.Value(_energySourceController.text.isEmpty ? null : _energySourceController.text),
      currentUse: drift.Value(_currentUseController.text.isEmpty ? null : _currentUseController.text),
      limitations: drift.Value(_limitationsController.text.isEmpty ? null : _limitationsController.text),
      rawCreators: drift.Value(_rawCreators),
      rawCharacters: drift.Value(_rawCharacters),
      rawFactions: drift.Value(_rawFactions),
      rawItems: drift.Value(_rawItems),
      rawEvents: drift.Value(_rawEvents),
      rawStories: drift.Value(_rawStories),
      rawLocations: drift.Value(_rawLocations),
      rawPowerSystems: drift.Value(_rawPowerSystems),
    );

    try {
      if (widget.technologyLocalId != null) {
        await ref.read(technologyRepositoryProvider).updateTechnology(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Technology updated successfully')),
          );
        }
      } else {
        await ref.read(technologyRepositoryProvider).createTechnology(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Technology created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving technology: $e')),
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.technologyLocalId != null ? 'Edit Technology' : 'New Technology'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveTechnology,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Technical Details'),
              Tab(text: 'Usage & Limitations'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildTechnicalDetailsTab(),
              _buildUsageTab(),
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
          TextFormField(
            controller: _customNotesController,
            decoration: const InputDecoration(labelText: 'Custom Notes', border: OutlineInputBorder()),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _techTypeController,
            decoration: const InputDecoration(labelText: 'Technology Type', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _originController,
            decoration: const InputDecoration(labelText: 'Origin', border: OutlineInputBorder()),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _yearCreatedController,
            decoration: const InputDecoration(labelText: 'Year Created', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _energySourceController,
            decoration: const InputDecoration(labelText: 'Energy Source', border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _currentUseController,
            decoration: const InputDecoration(labelText: 'Current Use', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _limitationsController,
            decoration: const InputDecoration(labelText: 'Limitations', border: OutlineInputBorder()),
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
            label: 'Creators',
            initialValues: _rawCreators.map((e) => e.name).toList(),
            onChanged: (values) => _rawCreators = _updateLinksList(_rawCreators, values),
            searchFunction: (q) => _search(q, 'character'),
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
            label: 'Factions',
            initialValues: _rawFactions.map((e) => e.name).toList(),
            onChanged: (values) => _rawFactions = _updateLinksList(_rawFactions, values),
            searchFunction: (q) => _search(q, 'faction'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Items',
            initialValues: _rawItems.map((e) => e.name).toList(),
            onChanged: (values) => _rawItems = _updateLinksList(_rawItems, values),
            searchFunction: (q) => _search(q, 'item'),
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
            label: 'Stories',
            initialValues: _rawStories.map((e) => e.name).toList(),
            onChanged: (values) => _rawStories = _updateLinksList(_rawStories, values),
            searchFunction: (q) => _search(q, 'story'),
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
            label: 'Power Systems',
            initialValues: _rawPowerSystems.map((e) => e.name).toList(),
            onChanged: (values) => _rawPowerSystems = _updateLinksList(_rawPowerSystems, values),
            searchFunction: (q) => _search(q, 'powersystem'),
          ),
        ],
      ),
    );
  }
}