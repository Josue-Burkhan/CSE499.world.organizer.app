import 'package:flutter/material.dart';
import '../../../../services/settings_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _service = SettingsService();

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
    final username = await _service.getUsername();
    final enableNotifications = await _service.getEnableNotifications();
    final defaultLanguage = await _service.getDefaultLanguage();

    setState(() {
      _usernameController.text = username ?? '';
      _enableNotifications = enableNotifications;
      _defaultLanguage = defaultLanguage ?? 'en';
      _loading = false;
    });
  }

  Future<void> _saveSettings() async {
    await _service.setUsername(_usernameController.text);
    await _service.setEnableNotifications(_enableNotifications);
    await _service.setDefaultLanguage(_defaultLanguage);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              onChanged: (value) {
                setState(() {
                  _enableNotifications = value;
                });
              },
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
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _defaultLanguage = value;
                  });
                }
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