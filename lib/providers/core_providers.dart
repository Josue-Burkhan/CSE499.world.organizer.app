import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:worldorganizer_app/core/database/app_database.dart';
import 'package:worldorganizer_app/core/database/daos/worlds_dao.dart';
import 'package:worldorganizer_app/core/database/daos/abilities_dao.dart';
import 'package:worldorganizer_app/core/database/daos/characters_dao.dart';
import 'package:worldorganizer_app/core/database/daos/creatures_dao.dart';
import 'package:worldorganizer_app/core/database/daos/economies_dao.dart';
import 'package:worldorganizer_app/core/database/daos/events_dao.dart';
import 'package:worldorganizer_app/core/database/daos/factions_dao.dart';
import 'package:worldorganizer_app/core/database/daos/items_dao.dart';
import 'package:worldorganizer_app/core/database/daos/languages_dao.dart';
import 'package:worldorganizer_app/core/database/daos/locations_dao.dart';
import 'package:worldorganizer_app/core/database/daos/powersystems_dao.dart';
import 'package:worldorganizer_app/core/database/daos/races_dao.dart';
import 'package:worldorganizer_app/core/database/daos/religions_dao.dart';
import 'package:worldorganizer_app/core/database/daos/stories_dao.dart';
import 'package:worldorganizer_app/core/database/daos/technologies_dao.dart';
import 'package:worldorganizer_app/repositories/profile_repository.dart';
import 'package:worldorganizer_app/repositories/world_repository.dart';
import 'package:worldorganizer_app/core/services/world_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/ability_repository.dart';
import 'package:worldorganizer_app/core/services/modules/ability_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/character_repository.dart';
import 'package:worldorganizer_app/core/services/modules/character_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/creature_repository.dart';
import 'package:worldorganizer_app/core/services/modules/creature_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/economy_repository.dart';
import 'package:worldorganizer_app/core/services/modules/economy_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/event_repository.dart';
import 'package:worldorganizer_app/core/services/modules/event_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/faction_repository.dart';
import 'package:worldorganizer_app/core/services/modules/faction_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/item_repository.dart';
import 'package:worldorganizer_app/core/services/modules/item_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/language_repository.dart';
import 'package:worldorganizer_app/core/services/modules/language_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/location_repository.dart';
import 'package:worldorganizer_app/core/services/modules/location_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/powersystem_repository.dart';
import 'package:worldorganizer_app/core/services/modules/powersystem_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/race_repository.dart';
import 'package:worldorganizer_app/core/services/modules/race_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/religion_repository.dart';
import 'package:worldorganizer_app/core/services/modules/religion_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/story_repository.dart';
import 'package:worldorganizer_app/core/services/modules/story_sync_service.dart';
import 'package:worldorganizer_app/repositories/modules/technology_repository.dart';
import 'package:worldorganizer_app/core/services/modules/technology_sync_service.dart';
import 'package:worldorganizer_app/core/services/api_service.dart';
import 'package:worldorganizer_app/core/services/image_upload_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final imageUploadServiceProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
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
    apiService: ref.watch(apiServiceProvider),
    imageUploadService: ref.watch(imageUploadServiceProvider),
  );
});

// abilities
final abilitiesDaoProvider = Provider<AbilitiesDao>((ref) {
  return ref.watch(appDatabaseProvider).abilitiesDao;
});

final abilityRepositoryProvider = Provider<AbilityRepository>((ref) {
  return AbilityRepository(
    dao: ref.watch(abilitiesDaoProvider),
  );
});

final abilitySyncServiceProvider = Provider<AbilitySyncService>((ref) {
  return AbilitySyncService(
    dao: ref.watch(abilitiesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

//characters
final charactersDaoProvider = Provider<CharactersDao>((ref) {
  return ref.watch(appDatabaseProvider).charactersDao;
});

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  return CharacterRepository(
    dao: ref.watch(charactersDaoProvider),
    syncService: ref.watch(characterSyncServiceProvider),
  );
});

final characterSyncServiceProvider = Provider<CharacterSyncService>((ref) {
  return CharacterSyncService(
    dao: ref.watch(charactersDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Creatures
final creaturesDaoProvider = Provider<CreaturesDao>((ref) {
  return ref.watch(appDatabaseProvider).creaturesDao;
});

final creatureRepositoryProvider = Provider<CreatureRepository>((ref) {
  return CreatureRepository(
    dao: ref.watch(creaturesDaoProvider),
  );
});

final creatureSyncServiceProvider = Provider<CreatureSyncService>((ref) {
  return CreatureSyncService(
    dao: ref.watch(creaturesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Economy
final economiesDaoProvider = Provider<EconomiesDao>((ref) {
  return ref.watch(appDatabaseProvider).economiesDao;
});

final economyRepositoryProvider = Provider<EconomyRepository>((ref) {
  return EconomyRepository(
    dao: ref.watch(economiesDaoProvider),
  );
});

final economySyncServiceProvider = Provider<EconomySyncService>((ref) {
  return EconomySyncService(
    dao: ref.watch(economiesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Event
final eventsDaoProvider = Provider<EventsDao>((ref) {
  return ref.watch(appDatabaseProvider).eventsDao;
});

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository(
    dao: ref.watch(eventsDaoProvider),
  );
});

final eventSyncServiceProvider = Provider<EventSyncService>((ref) {
  return EventSyncService(
    dao: ref.watch(eventsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// factions
final factionsDaoProvider = Provider<FactionsDao>((ref) {
  return ref.watch(appDatabaseProvider).factionsDao;
});

final factionRepositoryProvider = Provider<FactionRepository>((ref) {
  return FactionRepository(
    dao: ref.watch(factionsDaoProvider),
  );
});

final factionSyncServiceProvider = Provider<FactionSyncService>((ref) {
  return FactionSyncService(
    dao: ref.watch(factionsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Item
final itemsDaoProvider = Provider<ItemsDao>((ref) {
  return ref.watch(appDatabaseProvider).itemsDao;
});

final itemRepositoryProvider = Provider<ItemRepository>((ref) {
  return ItemRepository(
    dao: ref.watch(itemsDaoProvider),
  );
});

final itemSyncServiceProvider = Provider<ItemSyncService>((ref) {
  return ItemSyncService(
    dao: ref.watch(itemsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Language
final languagesDaoProvider = Provider<LanguagesDao>((ref) {
  return ref.watch(appDatabaseProvider).languagesDao;
});

final languageRepositoryProvider = Provider<LanguageRepository>((ref) {
  return LanguageRepository(
    dao: ref.watch(languagesDaoProvider),
  );
});

final languageSyncServiceProvider = Provider<LanguageSyncService>((ref) {
  return LanguageSyncService(
    dao: ref.watch(languagesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Location
final locationsDaoProvider = Provider<LocationsDao>((ref) {
  return ref.watch(appDatabaseProvider).locationsDao;
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(
    dao: ref.watch(locationsDaoProvider),
  );
});

final locationSyncServiceProvider = Provider<LocationSyncService>((ref) {
  return LocationSyncService(
    dao: ref.watch(locationsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// PowerSystem
final powerSystemsDaoProvider = Provider<PowerSystemsDao>((ref) {
  return ref.watch(appDatabaseProvider).powerSystemsDao;
});

final powerSystemRepositoryProvider = Provider<PowerSystemRepository>((ref) {
  return PowerSystemRepository(
    dao: ref.watch(powerSystemsDaoProvider),
  );
});

final powerSystemSyncServiceProvider = Provider<PowerSystemSyncService>((ref) {
  return PowerSystemSyncService(
    dao: ref.watch(powerSystemsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Race
final racesDaoProvider = Provider<RacesDao>((ref) {
  return ref.watch(appDatabaseProvider).racesDao;
});

final raceRepositoryProvider = Provider<RaceRepository>((ref) {
  return RaceRepository(
    dao: ref.watch(racesDaoProvider),
  );
});

final raceSyncServiceProvider = Provider<RaceSyncService>((ref) {
  return RaceSyncService(
    dao: ref.watch(racesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Religion
final religionsDaoProvider = Provider<ReligionsDao>((ref) {
  return ref.watch(appDatabaseProvider).religionsDao;
});

final religionRepositoryProvider = Provider<ReligionRepository>((ref) {
  return ReligionRepository(
    dao: ref.watch(religionsDaoProvider),
  );
});

final religionSyncServiceProvider = Provider<ReligionSyncService>((ref) {
  return ReligionSyncService(
    dao: ref.watch(religionsDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Story
final storiesDaoProvider = Provider<StoriesDao>((ref) {
  return ref.watch(appDatabaseProvider).storiesDao;
});

final storyRepositoryProvider = Provider<StoryRepository>((ref) {
  return StoryRepository(
    dao: ref.watch(storiesDaoProvider),
  );
});

final storySyncServiceProvider = Provider<StorySyncService>((ref) {
  return StorySyncService(
    dao: ref.watch(storiesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Technology
final technologiesDaoProvider = Provider<TechnologiesDao>((ref) {
  return ref.watch(appDatabaseProvider).technologiesDao;
});

final technologyRepositoryProvider = Provider<TechnologyRepository>((ref) {
  return TechnologyRepository(
    dao: ref.watch(technologiesDaoProvider),
  );
});

final technologySyncServiceProvider = Provider<TechnologySyncService>((ref) {
  return TechnologySyncService(
    dao: ref.watch(technologiesDaoProvider),
    worldsDao: ref.watch(worldsDaoProvider),
    storage: ref.watch(secureStorageProvider),
  );
});