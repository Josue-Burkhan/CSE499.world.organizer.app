import 'package:flutter/material.dart';


class LanguageFormScreen extends StatelessWidget {
  final String? languageLocalId;
  final String worldLocalId;
  
  const LanguageFormScreen({
    super.key, 
    this.languageLocalId,
    required this.worldLocalId,
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = languageLocalId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Language' : 'New Language'),
      ),
      body: Center(
        child: Text(
          isEditing 
            ? 'Form for editing $languageLocalId' 
            : 'Form for new language in $worldLocalId'
        ),
      ),
    );
  }
}