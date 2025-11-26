import 'package:flutter/material.dart';


class AbilityFormScreen extends StatelessWidget {
  final String? abilityLocalId;
  final String worldLocalId;
  
  const AbilityFormScreen({
    super.key, 
    this.abilityLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = abilityLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Ability' : 'New Ability'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $abilityLocalId' 
            : 'Form for new ability in $worldLocalId'
        ),
      ),
    );
  }
}