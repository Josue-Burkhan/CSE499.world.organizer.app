import 'package:flutter/material.dart';


class CreatureFormScreen extends StatelessWidget {
  final String? creatureLocalId;
  final String worldLocalId;
  
  const CreatureFormScreen({
    super.key, 
    this.creatureLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = creatureLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Creature' : 'New Creature'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $creatureLocalId' 
            : 'Form for new creature in $worldLocalId'
        ),
      ),
    );
  }
}