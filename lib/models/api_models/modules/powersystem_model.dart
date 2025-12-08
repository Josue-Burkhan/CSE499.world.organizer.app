class PowerSystemRelation {
  final String id;
  final String name;

  PowerSystemRelation({required this.id, required this.name});

  factory PowerSystemRelation.fromJson(Map<String, dynamic> json) {
    return PowerSystemRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class PowerSystem {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? sourceOfPower;
    final String? rules;
    final String? limitations;
    final List<String> classificationTypes;
    final String? symbolsOrMarks;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawCharacters;
    final List<String> rawAbilities;
    final List<String> rawFactions;
    final List<String> rawEvents;
    final List<String> rawStories;
    final List<String> rawCreatures;
    final List<String> rawReligions;
    final List<String> rawTechnologies;

    PowerSystem({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.sourceOfPower,
        this.rules,
        this.limitations,
        required this.classificationTypes,
        this.symbolsOrMarks,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawAbilities,
        required this.rawFactions,
        required this.rawEvents,
        required this.rawStories,
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

    factory PowerSystem.fromJson(Map<String, dynamic> json) {
        return PowerSystem(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            sourceOfPower: json['sourceOfPower'],
            rules: json['rules'],
            limitations: json['limitations'],
            classificationTypes: _listFromRaw(json['classificationTypes']),
            symbolsOrMarks: json['symbolsOrMarks'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawAbilities: _listFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawCreatures: _listFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}