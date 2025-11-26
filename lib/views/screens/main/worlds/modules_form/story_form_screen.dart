import 'package:flutter/material.dart';


class StoryFormScreen extends StatelessWidget {
  final String? storyLocalId;
  final String worldLocalId;
  
  const StoryFormScreen({
    super.key, 
    this.storyLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = storyLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Story' : 'New Story'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $storyLocalId' 
            : 'Form for new story in $worldLocalId'
        ),
      ),
    );
  }
}