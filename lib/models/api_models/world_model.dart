import 'dart:convert';

class World {
  final String id;
  final String name;
  final String description;
  final Modules? modules;
  final String? coverImage;
  final String? customImage;

  World({
    required this.id,
    required this.name,
    required this.description,
    this.modules,
    this.coverImage,
    this.customImage,
  });

  factory World.fromJson(Map<String, dynamic> json) {
    return World(
      id: json['_id'],
      name: json['name'] ?? 'Unnamed World',
      description: json['description'] ?? '',
      modules: json['modules'] != null ? Modules.fromJson(json['modules']) : null,
      coverImage: json['cover_image'],
      customImage: json['custom_image'],
    );
  }
}

class Modules {
  final bool characters;
  final bool locations;
  final bool factions;
  final bool items;
  final bool events;
  final bool languages;
  final bool abilities;
  final bool technology;
  final bool powerSystem;
  final bool creatures;
  final bool religion;
  final bool story;
  final bool races;
  final bool economy;

  Modules({
    required this.characters,
    required this.locations,
    required this.factions,
    required this.items,
    required this.events,
    required this.languages,
    required this.abilities,
    required this.technology,
    required this.powerSystem,
    required this.creatures,
    required this.religion,
    required this.story,
    required this.races,
    required this.economy,
  });

  factory Modules.fromJson(Map<String, dynamic> json) {
    return Modules(
      characters: json['characters'] ?? false,
      locations: json['locations'] ?? false,
      factions: json['factions'] ?? false,
      items: json['items'] ?? false,
      events: json['events'] ?? false,
      languages: json['languages'] ?? false,
      abilities: json['abilities'] ?? false,
      technology: json['technology'] ?? false,
      powerSystem: json['powerSystem'] ?? false,
      creatures: json['creatures'] ?? false,
      religion: json['religion'] ?? false,
      story: json['story'] ?? false,
      races: json['races'] ?? false,
      economy: json['economy'] ?? false,
    );
  }

  Map<String, bool> toMap() {
    return {
      'Characters': characters,
      'Locations': locations,
      'Factions': factions,
      'Items': items,
      'Events': events,
      'Languages': languages,
      'Abilities': abilities,
      'Technology': technology,
      'Power System': powerSystem,
      'Creatures': creatures,
      'Religion': religion,
      'Story': story,
      'Races': races,
      'Economy': economy,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }
}