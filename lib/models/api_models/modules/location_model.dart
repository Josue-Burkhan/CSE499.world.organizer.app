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
            rawLocations: _listFromRaw(json['rawLocations']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawItems: _listFromRaw(json['rawItems']),
            rawCreatures: _listFromRaw(json['rawCreatures']),
            rawStories: _listFromRaw(json['rawStories']),
            rawLanguages: _listFromRaw(json['rawLanguages']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
        );
    }
}