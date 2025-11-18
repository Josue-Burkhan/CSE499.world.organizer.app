class ReligionRelation {
  final String id;
  final String name;

  ReligionRelation({required this.id, required this.name});

  factory ReligionRelation.fromJson(Map<String, dynamic> json) {
    return ReligionRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Religion {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final List<String> deityNames;
    final String? originStory;
    final List<String> practices;
    final List<String> taboos;
    final List<String> sacredTexts;
    final List<String> festivals;
    final List<String> symbols;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawCharacters;
    final List<String> rawFactions;
    final List<String> rawLocations;
    final List<String> rawCreatures;
    final List<String> rawEvents;
    final List<String> rawPowerSystems;
    final List<String> rawStories;
    final List<String> rawTechnologies;

    Religion({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        required this.deityNames,
        this.originStory,
        required this.practices,
        required this.taboos,
        required this.sacredTexts,
        required this.festivals,
        required this.symbols,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawFactions,
        required this.rawLocations,
        required this.rawCreatures,
        required this.rawEvents,
        required this.rawPowerSystems,
        required this.rawStories,
        required this.rawTechnologies,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Religion.fromJson(Map<String, dynamic> json) {
        return Religion(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            deityNames: _listFromRaw(json['deityNames']),
            originStory: json['originStory'],
            practices: _listFromRaw(json['practices']),
            taboos: _listFromRaw(json['taboos']),
            sacredTexts: _listFromRaw(json['sacredTexts']),
            festivals: _listFromRaw(json['festivals']),
            symbols: _listFromRaw(json['symbols']),
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawCreatures: _listFromRaw(json['rawCreatures']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
            rawStories: _listFromRaw(json['rawStories']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
        );
    }
}