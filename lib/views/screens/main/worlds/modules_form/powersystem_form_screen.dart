import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';

class PowerSystemFormScreen extends ConsumerStatefulWidget {
  final String? powerSystemLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const PowerSystemFormScreen({
    super.key,
    this.powerSystemLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<PowerSystemFormScreen> createState() => _PowerSystemFormScreenState();
}

class _PowerSystemFormScreenState extends ConsumerState<PowerSystemFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // System Details
  final _sourceOfPowerController = TextEditingController();
  final _rulesController = TextEditingController();
  final _limitationsController = TextEditingController();
  final _symbolsOrMarksController = TextEditingController();
  List<String> _classificationTypes = [];

  // Links (Raw)
  List<String> _rawCharacters = [];
  List<String> _rawAbilities = [];
  List<String> _rawFactions = [];
  List<String> _rawEvents = [];
  List<String> _rawStories = [];
  List<String> _rawCreatures = [];
  List<String> _rawReligions = [];
  List<String> _rawTechnologies = [];

  @override
  void initState() {
    super.initState();
    _loadPowerSystem();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customNotesController.dispose();
    _sourceOfPowerController.dispose();
    _rulesController.dispose();
    _limitationsController.dispose();
    _symbolsOrMarksController.dispose();
    super.dispose();
  }

  Future<void> _loadPowerSystem() async {
    if (widget.powerSystemLocalId != null) {
      final powerSystem = await ref
          .read(powerSystemRepositoryProvider)
          .getPowerSystem(widget.powerSystemLocalId!);

      if (powerSystem != null) {
        _nameController.text = powerSystem.name;
        _descriptionController.text = powerSystem.description ?? '';
        _customNotesController.text = powerSystem.customNotes ?? '';
        _tagColor = powerSystem.tagColor;

        _sourceOfPowerController.text = powerSystem.sourceOfPower ?? '';
        _rulesController.text = powerSystem.rules ?? '';
        _limitationsController.text = powerSystem.limitations ?? '';
        _symbolsOrMarksController.text = powerSystem.symbolsOrMarks ?? '';
        _classificationTypes = powerSystem.classificationTypes;

        _rawCharacters = powerSystem.rawCharacters;
        _rawAbilities = powerSystem.rawAbilities;
        _rawFactions = powerSystem.rawFactions;
        _rawEvents = powerSystem.rawEvents;
        _rawStories = powerSystem.rawStories;
        _rawCreatures = powerSystem.rawCreatures;
        _rawReligions = powerSystem.rawReligions;
        _rawTechnologies = powerSystem.rawTechnologies;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _savePowerSystem() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = PowerSystemsCompanion(
      localId: widget.powerSystemLocalId != null 
          ? drift.Value(widget.powerSystemLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      description: drift.Value(_descriptionController.text.isEmpty ? null : _descriptionController.text),
      sourceOfPower: drift.Value(_sourceOfPowerController.text.isEmpty ? null : _sourceOfPowerController.text),
      rules: drift.Value(_rulesController.text.isEmpty ? null : _rulesController.text),
      limitations: drift.Value(_limitationsController.text.isEmpty ? null : _limitationsController.text),
      classificationTypes: drift.Value(_classificationTypes),
      symbolsOrMarks: drift.Value(_symbolsOrMarksController.text.isEmpty ? null : _symbolsOrMarksController.text),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawCharacters: drift.Value(_rawCharacters),
      rawAbilities: drift.Value(_rawAbilities),
      rawFactions: drift.Value(_rawFactions),
      rawEvents: drift.Value(_rawEvents),
      rawStories: drift.Value(_rawStories),
      rawCreatures: drift.Value(_rawCreatures),
      rawReligions: drift.Value(_rawReligions),
      rawTechnologies: drift.Value(_rawTechnologies),
    );

    try {
      if (widget.powerSystemLocalId != null) {
        await ref.read(powerSystemRepositoryProvider).updatePowerSystem(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Power System updated successfully')),
          );
        }
      } else {
        await ref.read(powerSystemRepositoryProvider).createPowerSystem(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Power System created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving power system: $e')),
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
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.powerSystemLocalId != null ? 'Edit Power System' : 'New Power System'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _savePowerSystem,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'System Details'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildSystemDetailsTab(),
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

  Widget _buildSystemDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _sourceOfPowerController,
            decoration: const InputDecoration(labelText: 'Source of Power', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _rulesController,
            decoration: const InputDecoration(labelText: 'Rules', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _limitationsController,
            decoration: const InputDecoration(labelText: 'Limitations', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Classification Types',
            initialValues: _classificationTypes,
            onChanged: (values) => _classificationTypes = values,
            searchFunction: (q) => Future.value([]),
            hintText: 'Add a classification type...',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _symbolsOrMarksController,
            decoration: const InputDecoration(labelText: 'Symbols or Marks', border: OutlineInputBorder()),
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
            label: 'Abilities',
            initialValues: _rawAbilities,
            onChanged: (values) => _rawAbilities = values,
            searchFunction: (q) => _search(q, 'ability'),
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
            label: 'Events',
            initialValues: _rawEvents,
            onChanged: (values) => _rawEvents = values,
            searchFunction: (q) => _search(q, 'event'),
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