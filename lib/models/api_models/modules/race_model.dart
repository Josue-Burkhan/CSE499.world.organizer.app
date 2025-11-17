import 'dart:convert';

class RaceRelation {
  final String id;
  final String name;

  RaceRelation({required this.id, required this.name});

  factory RaceRelation.fromJson(Map<String, dynamic> json) {
    return RaceRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Race {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final List<String> traits;
    final String? lifespan;
    final String? averageHeight;
    final String? averageWeight;
    final String? culture;
    final bool isExtinct;
    final List<String> images;
    final String tagColor;

    final List<String> rawLanguages;
    final List<String> rawCharacters;
    final List<String> rawLocations;
    final List<String> rawReligions;
    final List<String> rawStories;
    final List<String> rawEvents;
    final List<String> rawPowerSystems;
    final List<String> rawTechnologies;

    Race({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        required this.traits,
        this.lifespan,
        this.averageHeight,
        this.averageWeight,
        this.culture,
        required this.isExtinct,
        required this.images,
        required this.tagColor,
        required this.rawLanguages,
        required this.rawCharacters,
        required this.rawLocations,
        required this.rawReligions,
        required this.rawStories,
        required this.rawEvents,
        required this.rawPowerSystems,
        required this.rawTechnologies,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Race.fromJson(Map<String, dynamic> json) {
        return Race(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            traits: _listFromRaw(json['traits']),
            lifespan: json['lifespan'],
            averageHeight: json['averageHeight'],
            averageWeight: json['averageWeight'],
            culture: json['culture'],
            isExtinct: json['isExtinct'] ?? false,
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawLanguages: _listFromRaw(json['rawLanguages']),
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawStories: _listFromRaw(json['rawStories']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
        );
    }
}