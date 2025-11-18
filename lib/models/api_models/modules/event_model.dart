class EventRelation {
  final String id;
  final String name;

  EventRelation({required this.id, required this.name});

  factory EventRelation.fromJson(Map<String, dynamic> json) {
    return EventRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Event {
    final String id;
    final String? worldId;
    final String? date;
    final String? description;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawCharacters;
    final List<String> rawFactions;
    final List<String> rawLocations;
    final List<String> rawItems;
    final List<String> rawAbilities;
    final List<String> rawStories;
    final List<String> rawPowerSystems;
    final List<String> rawCreatures;
    final List<String> rawReligions;
    final List<String> rawTechnologies;

    Event({
        required this.id,
        this.worldId,
        this.date,
        this.description,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawFactions,
        required this.rawLocations,
        required this.rawItems,
        required this.rawAbilities,
        required this.rawStories,
        required this.rawPowerSystems,
        required this.rawCreatures,
        required this.rawReligions,
        required this.rawTechnologies,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Event.fromjson(Map<String, dynamic> json) {
        return Event(
            id: json['_id'],
            worldId: json['world'],
            description: json['description'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawItems: _listFromRaw(json['rawItems']),
            rawAbilities: _listFromRaw(json['rawAbilities']),
            rawStories: _listFromRaw(json['rawStories']),
            rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
            rawCreatures: _listFromRaw(json['rawCreatures']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
        );
    }
}