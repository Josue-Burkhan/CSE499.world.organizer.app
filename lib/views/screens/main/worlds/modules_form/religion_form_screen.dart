import 'package:flutter/material.dart';


class ReligionFormScreen extends StatelessWidget {
  final String? religionLocalId;
  final String worldLocalId;
  
  const ReligionFormScreen({
    super.key, 
    this.religionLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = religionLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Religion' : 'New Religion'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $religionLocalId' 
            : 'Form for new religion in $worldLocalId'
        ),
      ),
    );
  }
}