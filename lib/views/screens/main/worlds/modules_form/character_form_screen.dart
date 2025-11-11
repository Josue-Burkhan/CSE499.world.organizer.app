import 'package:flutter/material.dart';


class CharacterScreen extends StatelessWidget {
  final String? characterLocalId;
  final String worldLocalId;
  
  const CharacterScreen({
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