import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/widgets/autocomplete_chips.dart';
import 'package:worldorganizer_app/models/api_models/module_link.dart';

class LanguageFormScreen extends ConsumerStatefulWidget {
  final String? languageLocalId;
  final String worldLocalId;
  final String? worldServerId;

  const LanguageFormScreen({
    super.key,
    this.languageLocalId,
    required this.worldLocalId,
    this.worldServerId,
  });

  @override
  ConsumerState<LanguageFormScreen> createState() => _LanguageFormScreenState();
}

class _LanguageFormScreenState extends ConsumerState<LanguageFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;

  // Basic Info
  final _nameController = TextEditingController();
  final _alphabetController = TextEditingController();
  final _pronunciationRulesController = TextEditingController();
  final _grammarNotesController = TextEditingController();
  final _customNotesController = TextEditingController();
  String _tagColor = 'neutral';

  // Status
  bool _isSacred = false;
  bool _isExtinct = false;

  // Links (Raw)
  List<ModuleLink> _rawRaces = [];
  List<ModuleLink> _rawFactions = [];
  List<ModuleLink> _rawCharacters = [];
  List<ModuleLink> _rawLocations = [];
  List<ModuleLink> _rawStories = [];
  List<ModuleLink> _rawReligions = [];

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _alphabetController.dispose();
    _pronunciationRulesController.dispose();
    _grammarNotesController.dispose();
    _customNotesController.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    if (widget.languageLocalId != null) {
      final language = await ref
          .read(languageRepositoryProvider)
          .getLanguage(widget.languageLocalId!);

      if (language != null) {
        _nameController.text = language.name;
        _alphabetController.text = language.alphabet ?? '';
        _pronunciationRulesController.text = language.pronunciationRules ?? '';
        _grammarNotesController.text = language.grammarNotes ?? '';
        _customNotesController.text = language.customNotes ?? '';
        _tagColor = language.tagColor;

        _isSacred = language.isSacred;
        _isExtinct = language.isExtinct;

        _rawRaces = language.rawRaces;
        _rawFactions = language.rawFactions;
        _rawCharacters = language.rawCharacters;
        _rawLocations = language.rawLocations;
        _rawStories = language.rawStories;
        _rawReligions = language.rawReligions;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveLanguage() async {
    if (!_formKey.currentState!.validate()) return;

    final companion = LanguagesCompanion(
      localId: widget.languageLocalId != null 
          ? drift.Value(widget.languageLocalId!) 
          : const drift.Value.absent(),
      worldLocalId: drift.Value(widget.worldLocalId),
      name: drift.Value(_nameController.text),
      alphabet: drift.Value(_alphabetController.text.isEmpty ? null : _alphabetController.text),
      pronunciationRules: drift.Value(_pronunciationRulesController.text.isEmpty ? null : _pronunciationRulesController.text),
      grammarNotes: drift.Value(_grammarNotesController.text.isEmpty ? null : _grammarNotesController.text),
      isSacred: drift.Value(_isSacred),
      isExtinct: drift.Value(_isExtinct),
      customNotes: drift.Value(_customNotesController.text.isEmpty ? null : _customNotesController.text),
      tagColor: drift.Value(_tagColor),
      rawRaces: drift.Value(_rawRaces),
      rawFactions: drift.Value(_rawFactions),
      rawCharacters: drift.Value(_rawCharacters),
      rawLocations: drift.Value(_rawLocations),
      rawStories: drift.Value(_rawStories),
      rawReligions: drift.Value(_rawReligions),
    );

    try {
      if (widget.languageLocalId != null) {
        await ref.read(languageRepositoryProvider).updateLanguage(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Language updated successfully')),
          );
        }
      } else {
        await ref.read(languageRepositoryProvider).createLanguage(companion);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Language created successfully')),
          );
        }
      }
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving language: $e')),
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
          title: Text(widget.languageLocalId != null ? 'Edit Language' : 'New Language'),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveLanguage,
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basic Info'),
              Tab(text: 'Linguistic Details'),
              Tab(text: 'Links'),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: TabBarView(
            children: [
              _buildBasicInfoTab(),
              _buildLinguisticDetailsTab(),
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
            controller: _alphabetController,
            decoration: const InputDecoration(labelText: 'Alphabet', border: OutlineInputBorder()),
            maxLines: 3,
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
          SwitchListTile(
            title: const Text('Is Sacred'),
            value: _isSacred,
            onChanged: (value) => setState(() => _isSacred = value),
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: const Text('Is Extinct'),
            value: _isExtinct,
            onChanged: (value) => setState(() => _isExtinct = value),
            contentPadding: EdgeInsets.zero,
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

  Widget _buildLinguisticDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            controller: _pronunciationRulesController,
            decoration: const InputDecoration(labelText: 'Pronunciation Rules', border: OutlineInputBorder()),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _grammarNotesController,
            decoration: const InputDecoration(labelText: 'Grammar Notes', border: OutlineInputBorder()),
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
            label: 'Races',
            initialValues: _rawRaces.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawRaces, (l) => _rawRaces = l),
            searchFunction: (q) => _search(q, 'race'),
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
            label: 'Characters',
            initialValues: _rawCharacters.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawCharacters, (l) => _rawCharacters = l),
            searchFunction: (q) => _search(q, 'character'),
          ),
          const SizedBox(height: 16),
          AutocompleteChips(
            label: 'Locations',
            initialValues: _rawLocations.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawLocations, (l) => _rawLocations = l),
            searchFunction: (q) => _search(q, 'location'),
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
            label: 'Religions',
            initialValues: _rawReligions.map((e) => e.name).toList(),
            onChanged: (values) => _updateLinksList(values, _rawReligions, (l) => _rawReligions = l),
            searchFunction: (q) => _search(q, 'religion'),
          ),
        ],
      ),
    );
  }
}