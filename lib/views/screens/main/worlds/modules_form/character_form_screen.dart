import 'package:flutter/material.dart';


class CharacterFormScreen extends StatelessWidget {
  final String? characterLocalId;
  final String worldLocalId;
  
  const CharacterFormScreen({
    super.key, 
    this.characterLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = characterLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Character' : 'New Character'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $characterLocalId' 
            : 'Form for new character in $worldLocalId'
        ),
      ),
    );
  }
}