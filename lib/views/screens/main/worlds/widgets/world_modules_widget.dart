import 'package:flutter/material.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';

class WorldModulesWidget extends StatelessWidget {
  final Modules? modules;

  const WorldModulesWidget({super.key, required this.modules});

  @override
  Widget build(BuildContext context) {
    if (modules == null) {
      return const Center(
        child: Text('No modules enabled for this world.'),
      );
    }

    final activeModules = modules!.toMap()
      ..removeWhere((key, value) => value == false);

    if (activeModules.isEmpty) {
      return const Center(
        child: Text('No modules are currently active.'),
      );
    }

    return ListView(
      children: activeModules.entries.map((entry) {
        return Card(
          child: ListTile(
            title: Text(entry.key),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to the specific module screen
            },
          ),
        );
      }).toList(),
    );
  }
}
