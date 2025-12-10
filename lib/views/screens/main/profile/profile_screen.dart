import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';
import 'package:worldorganizer_app/views/screens/auth/login_screen.dart';

final sessionTypeProvider = FutureProvider<String?>((ref) {
  final storage = ref.watch(secureStorageProvider);
  return storage.read(key: 'session_type');
});

final profileStreamProvider = StreamProvider<UserProfileEntity?>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.watchUserProfile();
});

final profileSyncProvider = FutureProvider<void>((ref) {
  final profileRepo = ref.watch(profileRepositoryProvider);
  return profileRepo.fetchAndSyncProfile();
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(profileRepositoryProvider).logout();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionTypeAsync = ref.watch(sessionTypeProvider);
    
    return sessionTypeAsync.when(
      data: (sessionType) {
        if (sessionType == 'offline') {
          return _buildOfflineView(context, ref);
        }
        return _buildProfileScaffold(context, ref);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => Scaffold(
        body: Center(child: Text('Error loading session: $e')),
      ),
    );
  }

  Widget _buildProfileScaffold(BuildContext context, WidgetRef ref) {
    final syncAsync = ref.watch(profileSyncProvider);
    final profileAsync = ref.watch(profileStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile != null) {
            return _buildProfileView(context, ref, profile);
          }

          return syncAsync.when(
            data: (_) {
              return _buildErrorView(
                context, ref, 'Profile data not found.');
            },
            loading: () {
              return const Center(child: CircularProgressIndicator());
            },
            error: (e, st) {
              return _buildErrorView(context, ref, e);
            },
          );
        },
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (e, st) {
          return _buildErrorView(context, ref, e);
        },
      ),
    );
  }

  Widget _buildProfileView(
    BuildContext context, 
    WidgetRef ref, 
    UserProfileEntity profile
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.refresh(profileSyncProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile.pictureUrl != null
                      ? NetworkImage(profile.pictureUrl!)
                      : null,
                  child: profile.pictureUrl == null
                      ? Text(
                          profile.firstName.isNotEmpty 
                            ? profile.firstName[0].toUpperCase() 
                            : '?',
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      profile.firstName,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _showEditProfileDialog(context, ref, profile),
                    ),
                  ],
                ),
                Text(
                  profile.email,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, WidgetRef ref, Object? error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Failed to load profile',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(profileSyncProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineView(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, color: Colors.grey, size: 60),
              const SizedBox(height: 16),
              Text(
                'Profile Unavailable',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'You are not logged in. Please login to manage your profile.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _logout(context, ref),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(
    BuildContext context, 
    WidgetRef ref, 
    UserProfileEntity currentUserData
  ) {
    final nameController = TextEditingController(
      text: currentUserData.firstName,
    );
    final langController = TextEditingController(text: currentUserData.lang);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: langController,
                decoration: const InputDecoration(
                  labelText: 'Language (e.g., en, es)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref
                      .read(profileRepositoryProvider)
                      .updateUserProfile(
                        nameController.text, 
                        langController.text
                      );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Profile updated successfully!')),
                    );
                    ref.invalidate(profileSyncProvider);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update profile: $e')),
                    );
                  }
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}