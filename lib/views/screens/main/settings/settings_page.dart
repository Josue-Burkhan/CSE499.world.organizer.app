import 'package:flutter/material.dart';
import '../../../../core/database/app_database.dart';

class SettingsPage extends StatefulWidget {
  final AppDatabase db;
  const SettingsPage({Key? key, required this.db}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _usernameController = TextEditingController();
  bool _enableNotifications = false;
  String _defaultLanguage = 'en';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final username = await widget.db.getSetting('username');
    final enableNotif = await widget.db.getSetting('enableNotifications');
    final language = await widget.db.getSetting('defaultLanguage');

    setState(() {
      _usernameController.text = username ?? '';
      _enableNotifications = enableNotif == 'true';
      _defaultLanguage = language ?? 'en';
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    await widget.db.setSetting('username', _usernameController.text);
    await widget.db.setSetting('enableNotifications', _enableNotifications.toString());
    await widget.db.setSetting('defaultLanguage', _defaultLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _enableNotifications,
              onChanged: (val) => setState(() => _enableNotifications = val),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _defaultLanguage,
              decoration: const InputDecoration(
                labelText: 'Default Language',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'fr', child: Text('Français')),
                DropdownMenuItem(value: 'mg', child: Text('Malagasy')),
              ],
              onChanged: (val) {
                if (val != null) setState(() => _defaultLanguage = val);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveSettings,
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }
}
