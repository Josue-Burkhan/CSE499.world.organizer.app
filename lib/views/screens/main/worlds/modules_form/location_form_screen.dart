import 'package:flutter/material.dart';


class LocationFormScreen extends StatelessWidget {
  final String? locationLocalId;
  final String worldLocalId;
  
  const LocationFormScreen({
    super.key, 
    this.locationLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = locationLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Location' : 'New Location'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $locationLocalId' 
            : 'Form for new location in $worldLocalId'
        ),
      ),
    );
  }
}