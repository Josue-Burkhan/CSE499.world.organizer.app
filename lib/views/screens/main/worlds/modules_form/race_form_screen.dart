import 'package:flutter/material.dart';


class RaceFormScreen extends StatelessWidget {
  final String? raceLocalId;
  final String worldLocalId;
  
  const RaceFormScreen({
    super.key, 
    this.raceLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = raceLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Race' : 'New Race'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $raceLocalId' 
            : 'Form for new race in $worldLocalId'
        ),
      ),
    );
  }
}