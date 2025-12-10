import '../module_link.dart';

class LocationRelation {
  final String id;
  final String name;

  LocationRelation({required this.id, required this.name});

  factory LocationRelation.fromJson(Map<String, dynamic> json) {
    return LocationRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Location {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? climate;
    final String? terrain;
    final num? population;
    final String? economy;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawCreatures;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawLanguages;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;

    Location({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.climate,
        this.terrain,
        this.population,
        this.economy,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawLocations,
        required this.rawFactions,
        required this.rawEvents,
        required this.rawCharacters,
        required this.rawItems,
        required this.rawCreatures,
        required this.rawStories,
        required this.rawLanguages,
        required this.rawReligions,
        required this.rawTechnologies,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        if (populated is List) {
          final links = <ModuleLink>[];
          for (var item in populated) {
            if (item is Map<String, dynamic> && item['name'] != null) {
              links.add(ModuleLink(id: item['_id'] ?? item['id'] ?? '', name: item['name']));
            } else if (item is String) {
               links.add(ModuleLink(id: '', name: item));
            }
          }
          if (links.isNotEmpty) return links;
        }

        if (raw is List) {
          return raw.map((item) => ModuleLink(id: '', name: item.toString())).toList();
        }
        return [];
    }

    factory Location.fromJson(Map<String, dynamic> json) {
        return Location(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            climate: json['climate'],
            terrain: json['terrain'],
            population: json['population'],
            economy: json['economicSystem'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawCreatures: _linksFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLanguages: _linksFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}