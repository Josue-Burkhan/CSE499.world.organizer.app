import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/repositories/profile_repository.dart';
import 'package:worldorganizer_app/repositories/world_repository.dart';
import 'package:worldorganizer_app/core/services/world_sync_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    db: ref.watch(appDatabaseProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

final worldsDaoProvider = Provider<WorldsDao>((ref) {
  return ref.watch(appDatabaseProvider).worldsDao;
});

final worldRepositoryProvider = Provider<WorldRepository>((ref) {
  return WorldRepository(
    worldsDao: ref.watch(worldsDaoProvider),
  );
});

final worldSyncServiceProvider = Provider<WorldSyncService>((ref) {
  return WorldSyncService(
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});