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
    final String name;
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
        required this.name,
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

    factory Event.fromJson(Map<String, dynamic> json) {
        return Event(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            date: json['date'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawItems: _listFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawAbilities: _listFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawCreatures: _listFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}