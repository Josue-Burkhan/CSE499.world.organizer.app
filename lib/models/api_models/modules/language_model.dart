import '../module_link.dart';

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

    final List<ModuleLink> rawRaces;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawReligions;

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
            rawRaces: _linksFromPopulatedOrRaw(json['races'], json['rawRaces']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
        );
    }
}