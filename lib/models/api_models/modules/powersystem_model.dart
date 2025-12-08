import '../module_link.dart';

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

    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawAbilities;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawCreatures;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;

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
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawAbilities: _linksFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawCreatures: _linksFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}