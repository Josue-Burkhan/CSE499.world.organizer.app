class LanguageRelation {
  final String id;
  final String name;

  LanguageRelation({required this.id, required this.name});

  factory LanguageRelation.fromJson(Map<String, dynamic> json) {
    return LanguageRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Language {
    final String id;
    final String? worldId;
    final String name;
    final String? alphabet;
    final String? pronunciationRules;
    final String? grammarNotes;
    final bool isSacred;
    final bool isExtinct;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawRaces;
    final List<String> rawFactions;
    final List<String> rawCharacters;
    final List<String> rawLocations;
    final List<String> rawStories;
    final List<String> rawReligions;

    Language({
        required this.id,
        this.worldId,
        required this.name,
        this.alphabet,
        this.pronunciationRules,
        this.grammarNotes,
        required this.isSacred,
        required this.isExtinct,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawRaces,
        required this.rawFactions,
        required this.rawCharacters,
        required this.rawLocations,
        required this.rawStories,
        required this.rawReligions,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Language.fromJson(Map<String, dynamic> json) {
        return Language(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            alphabet: json['alphabet'],
            pronunciationRules: json['pronunciationRules'],
            grammarNotes: json['grammarNotes'],
            isSacred: json['isSacred'] ?? false,
            isExtinct: json['isExtinct'] ?? false,
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawRaces: _listFromRaw(json['rawRaces']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawStories: _listFromRaw(json['rawStories']),
            rawReligions: _listFromRaw(json['rawReligions']),
        );
    }
}