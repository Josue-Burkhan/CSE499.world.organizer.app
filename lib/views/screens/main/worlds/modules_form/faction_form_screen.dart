import 'package:flutter/material.dart';


class FactionFormScreen extends StatelessWidget {
  final String? factionLocalId;
  final String worldLocalId;
  
  const FactionFormScreen({
    super.key, 
    this.factionLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = factionLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Faction' : 'New Faction'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $factionLocalId' 
            : 'Form for new faction in $worldLocalId'
        ),
      ),
    );
  }
}