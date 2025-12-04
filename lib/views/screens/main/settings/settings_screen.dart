import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/providers/settings_provider.dart';
import 'package:worldorganizer_app/core/services/settings_service.dart';
import 'package:worldorganizer_app/views/screens/main/settings/pending_changes_screen.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final settingsService = ref.watch(settingsServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Synchronization Section
          _buildSectionHeader(context, 'Synchronization'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Last Sync', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            settings.lastSyncTime != null
                                ? DateFormat('MMM d, h:mm a').format(settings.lastSyncTime!)
                                : 'Never',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          // Visual sync simulation
                          await Future.delayed(const Duration(seconds: 2));
                          await settingsNotifier.updateLastSyncTime();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Sync completed')),
                            );
                          }
                        },
                        icon: const Icon(Icons.sync),
                        label: const Text('Sync Now'),
                      ),
                    ],
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Auto-sync'),
                    trailing: DropdownButton<int>(
                      value: settings.autoSyncInterval,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Off')),
                        DropdownMenuItem(value: 5, child: Text('Every 5 min')),
                        DropdownMenuItem(value: 15, child: Text('Every 15 min')),
                        DropdownMenuItem(value: 30, child: Text('Every 30 min')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          settingsNotifier.setAutoSyncInterval(value);
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Sync only on Wi-Fi'),
                    value: settings.syncOnWifiOnly,
                    onChanged: (value) => settingsNotifier.setSyncOnWifiOnly(value),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Pending Changes'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PendingChangesScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Local Storage Section
          _buildSectionHeader(context, 'Local Storage'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                FutureBuilder<int>(
                  future: settingsService.getDatabaseSize(),
                  builder: (context, snapshot) {
                    return ListTile(
                      title: const Text('Storage Used'),
                      subtitle: Text(snapshot.hasData ? _formatBytes(snapshot.data!) : 'Calculating...'),
                      leading: const Icon(Icons.storage),
                    );
                  },
                ),
                ListTile(
                  title: const Text('Clean Deleted Items'),
                  subtitle: const Text('Purge items marked for deletion'),
                  leading: const Icon(Icons.delete_sweep),
                  onTap: () async {
                    await settingsService.purgeDeletedItems();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Deleted items purged')),
                      );
                    }
                  },
                ),
                ListTile(
                  title: const Text('Backup Data'),
                  leading: const Icon(Icons.upload_file),
                  onTap: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup feature coming soon')),
                      );
                  },
                ),
              ],
            ),
          ),

          // Appearance Section
          _buildSectionHeader(context, 'Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Theme'),
                  leading: const Icon(Icons.brightness_6),
                  trailing: DropdownButton<ThemeMode>(
                    value: settings.themeMode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settingsNotifier.setThemeMode(value);
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Language'),
                  leading: const Icon(Icons.language),
                  trailing: DropdownButton<String>(
                    value: settings.language,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'es', child: Text('Español')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        settingsNotifier.setLanguage(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          // Help Section
          _buildSectionHeader(context, 'Help'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  title: const Text('FAQ'),
                  leading: const Icon(Icons.help_outline),
                  onTap: () {},
                ),
                const ListTile(
                  title: Text('Version'),
                  subtitle: Text('1.0.0'),
                  leading: Icon(Icons.info_outline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}