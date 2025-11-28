import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worldorganizer_app/models/api_models/world_model.dart';
import 'package:worldorganizer_app/providers/core_providers.dart';

final worldsControllerProvider = Provider<WorldsController>((ref) {
  return WorldsController(ref);
});

class WorldsController {
  final Ref _ref;

  WorldsController(this._ref);

  Future<void> createWorld({
    required String name,
    required String description,
    required Modules modules,
    File? coverImage,
  }) async {
    await _ref.read(worldRepositoryProvider).createWorld(
      name: name,
      description: description,
      modules: modules,
      coverImage: coverImage,
    );

    _ref.read(worldSyncServiceProvider).syncDirtyWorlds();
  }

  Future<void> updateWorld({
    required String localId,
    required String name,
    required String description,
    required Modules modules,
    File? coverImage,
    String? oldImageUrl,
  }) async {
    // If a new image is provided and there was an old one (that was a remote URL), delete the old one
    if (coverImage != null && oldImageUrl != null && oldImageUrl.startsWith('http')) {
      await _ref.read(imageUploadServiceProvider).deleteImage(oldImageUrl);
    }

    await _ref.read(worldRepositoryProvider).updateWorld(
      localId: localId,
      name: name,
      description: description,
      modules: modules,
      coverImage: coverImage,
    );
    
    _ref.read(worldSyncServiceProvider).syncDirtyWorlds();
  }
}
