import 'package:flutter/material.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/create_world_screen.dart';
import 'package:worldorganizer_app/views/screens/main/add/select_world_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/character_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/ability_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/creature_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/economy_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/event_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/faction_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/item_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/language_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/location_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/powersystem_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/race_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/religion_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/story_form_screen.dart';
import 'package:worldorganizer_app/views/screens/main/worlds/modules_form/technology_form_screen.dart';

class GeneralAddScreen extends StatelessWidget {
  const GeneralAddScreen({super.key});

  void _navigateToForm(BuildContext context, String title, Widget Function(String worldId) formBuilder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectWorldScreen(
          title: 'Select World for $title',
          onWorldSelected: (worldId) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => formBuilder(worldId)),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Add'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem(
            context,
            icon: Icons.person,
            label: 'Character',
            color: Colors.blue,
            onTap: () => _navigateToForm(
              context,
              'Character',
              (worldId) => CharacterFormScreen(worldLocalId: worldId),
            ),
          ),
          const SizedBox(height: 16),
          _buildItem(
            context,
            icon: Icons.public,
            label: 'World',
            color: Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateWorldScreen()),
              );
            },
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          _buildGrid(context),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    final items = [
      _GridItem(
        icon: Icons.flash_on,
        label: 'Ability',
        color: Colors.orange,
        onTap: () => _navigateToForm(context, 'Ability', (id) => AbilityFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.pets,
        label: 'Creature',
        color: Colors.brown,
        onTap: () => _navigateToForm(context, 'Creature', (id) => CreatureFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.attach_money,
        label: 'Economy',
        color: Colors.amber,
        onTap: () => _navigateToForm(context, 'Economy', (id) => EconomyFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.event,
        label: 'Event',
        color: Colors.red,
        onTap: () => _navigateToForm(context, 'Event', (id) => EventFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.groups,
        label: 'Faction',
        color: Colors.indigo,
        onTap: () => _navigateToForm(context, 'Faction', (id) => FactionFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.backpack,
        label: 'Item',
        color: Colors.teal,
        onTap: () => _navigateToForm(context, 'Item', (id) => ItemFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.language,
        label: 'Language',
        color: Colors.lightBlue,
        onTap: () => _navigateToForm(context, 'Language', (id) => LanguageFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.place,
        label: 'Location',
        color: Colors.greenAccent,
        onTap: () => _navigateToForm(context, 'Location', (id) => LocationFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.bolt,
        label: 'Power System',
        color: Colors.purple,
        onTap: () => _navigateToForm(context, 'Power System', (id) => PowerSystemFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.face,
        label: 'Race',
        color: Colors.pink,
        onTap: () => _navigateToForm(context, 'Race', (id) => RaceFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.temple_buddhist,
        label: 'Religion',
        color: Colors.deepPurple,
        onTap: () => _navigateToForm(context, 'Religion', (id) => ReligionFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.book,
        label: 'Story',
        color: Colors.deepOrange,
        onTap: () => _navigateToForm(context, 'Story', (id) => StoryFormScreen(worldLocalId: id)),
      ),
      _GridItem(
        icon: Icons.computer,
        label: 'Technology',
        color: Colors.cyan,
        onTap: () => _navigateToForm(context, 'Technology', (id) => TechnologyFormScreen(worldLocalId: id)),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: items.map((item) => _buildGridItemCard(context, item)).toList(),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridItemCard(BuildContext context, _GridItem item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, color: item.color, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _GridItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });
}
