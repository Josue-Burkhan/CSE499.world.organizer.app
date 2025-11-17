import 'dart:convert';

class WorldRelation {
  final String id;
  final String name;

  WorldRelation({required this.id, required this.name});

  factory WorldRelation.fromJson(Map<String, dynamic> json) {
    return WorldRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class World {
    final String id;
    final String name;
    final String? description;
    final String? image;

    final bool characters;
    final bool locations;
    final bool factions;
    final bool items;
    final bool events;
    final bool languages;
    final bool abilities;
    final bool technologies;
    final bool powerSystems;
    final bool creatures;
    final bool religions;
    final bool stories;
    final bool races;
    final bool economies;
    final List<String> moduleOrder;

    World({
        required this.id,
        required this.name,
        this.description,
        this.image,
        required this.characters,
        required this.locations,
        required this.factions,
        required this.items,
        required this.events,
        required this.languages,
        required this.abilities,
        required this.technologies,
        required this.powerSystems,
        required this.creatures,
        required this.religions,
        required this.stories,
        required this.races,
        required this.economies,
        required this.moduleOrder,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory World.fromJson(Map<String, dynamic> json) {
        return World(
            id: json['_id'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            image: json['image'],
            characters: json['characters'] ?? false,
            locations: json['locations'] ?? false,
            factions: json['factions'] ?? false,
            items: json['items'] ?? false,
            events: json['events'] ?? false,
            languages: json['languages'] ?? false,
            abilities: json['abilities'] ?? false,
            technologies: json['technologies'] ?? false,
            powerSystems: json['powerSystems'] ?? false,
            creatures: json['creatures'] ?? false,
            religions: json['religions'] ?? false,
            stories: json['stories'] ?? false,
            races: json['races'] ?? false,
            economies: json['economies'] ?? false,
            moduleOrder: _listFromRaw(json['moduleOrder']),
        );
    }
}