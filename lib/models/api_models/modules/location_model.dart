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

    final List<String> rawLocations;
    final List<String> rawFactions;
    final List<String> rawEvents;
    final List<String> rawCharacters;
    final List<String> rawItems;
    final List<String> rawCreatures;
    final List<String> rawStories;
    final List<String> rawLanguages;
    final List<String> rawReligions;
    final List<String> rawTechnologies;

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

    static List<String> _listFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        // Try raw first
        if (raw is List && raw.isNotEmpty) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        // Fallback to populated if it contains objects with names
        if (populated is List) {
            return populated.map((item) {
                if (item is Map<String, dynamic> && item['name'] != null) {
                    return item['name'].toString();
                }
                if (item is String) {
                    return item;
                }
                return null;
            }).whereType<String>().toList();
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
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawItems: _listFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawCreatures: _listFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLanguages: _listFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}