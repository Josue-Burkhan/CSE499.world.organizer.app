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
            rawRaces: _listFromPopulatedOrRaw(json['races'], json['rawRaces']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
        );
    }
}