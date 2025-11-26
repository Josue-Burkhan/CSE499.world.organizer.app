import 'package:flutter/material.dart';


class EventFormScreen extends StatelessWidget {
  final String? eventLocalId;
  final String worldLocalId;
  
  const EventFormScreen({
    super.key, 
    this.eventLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = eventLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Event' : 'New Event'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $eventLocalId' 
            : 'Form for new event in $worldLocalId'
        ),
      ),
    );
  }
}