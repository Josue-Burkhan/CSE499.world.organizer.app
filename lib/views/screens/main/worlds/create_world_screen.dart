import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/providers/worlds_provider.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

class CreateWorldScreen extends ConsumerStatefulWidget {
  const CreateWorldScreen({super.key});

  @override
  ConsumerState<CreateWorldScreen> createState() => _CreateWorldScreenState();
}

class _CreateWorldScreenState extends ConsumerState<CreateWorldScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _coverImage;

  bool _characters = true;
  bool _locations = false;
  bool _factions = false;
  bool _items = false;
  bool _events = false;
  bool _languages = false;
  bool _abilities = false;
  bool _technology = false;
  bool _powerSystem = false;
  bool _creatures = false;
  bool _religion = false;
  bool _story = false;
  bool _races = false;
  bool _economy = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ref.read(imageUploadServiceProvider).pickImage();
    if (image != null) {
      setState(() {
        _coverImage = image;
      });
    }
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final modules = Modules(
        characters: _characters,
        locations: _locations,
        factions: _factions,
        items: _items,
        events: _events,
        languages: _languages,
        abilities: _abilities,
        technology: _technology,
        powerSystem: _powerSystem,
        creatures: _creatures,
        religion: _religion,
        story: _story,
        races: _races,
        economy: _economy,
      );

      try {
        await ref.read(worldsControllerProvider).createWorld(
              name: _nameController.text,
              description: _descriptionController.text,
              modules: modules,
              coverImage: _coverImage,
            );

        if (mounted) {
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating world: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New World'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  image: _coverImage != null
                      ? DecorationImage(
                          image: FileImage(_coverImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _coverImage == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text('Add Cover Image', style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'World Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            const Text(
              'Modules',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildModuleSwitch('Characters', _characters, (v) => setState(() => _characters = v)),
            _buildModuleSwitch('Locations', _locations, (v) => setState(() => _locations = v)),
            _buildModuleSwitch('Factions', _factions, (v) => setState(() => _factions = v)),
            _buildModuleSwitch('Items', _items, (v) => setState(() => _items = v)),
            _buildModuleSwitch('Events', _events, (v) => setState(() => _events = v)),
            _buildModuleSwitch('Languages', _languages, (v) => setState(() => _languages = v)),
            _buildModuleSwitch('Abilities', _abilities, (v) => setState(() => _abilities = v)),
            _buildModuleSwitch('Technology', _technology, (v) => setState(() => _technology = v)),
            _buildModuleSwitch('Power System', _powerSystem, (v) => setState(() => _powerSystem = v)),
            _buildModuleSwitch('Creatures', _creatures, (v) => setState(() => _creatures = v)),
            _buildModuleSwitch('Religion', _religion, (v) => setState(() => _religion = v)),
            _buildModuleSwitch('Story', _story, (v) => setState(() => _story = v)),
            _buildModuleSwitch('Races', _races, (v) => setState(() => _races = v)),
            _buildModuleSwitch('Economy', _economy, (v) => setState(() => _economy = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleSwitch(String title, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }
}