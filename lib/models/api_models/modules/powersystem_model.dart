class FactionRelation {
  final String id;
  final String name;

  FactionRelation({required this.id, required this.name});

  factory FactionRelation.fromJson(Map<String, dynamic> json) {
    return FactionRelation(
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
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawAbilities: _listFromRaw(json['rawAbilities']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawStories: _listFromRaw(json['rawStories']),
            rawCreatures: _listFromRaw(json['rawCreatures']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
        );
    }
}