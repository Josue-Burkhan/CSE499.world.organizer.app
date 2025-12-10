import '../module_link.dart';

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

    final List<ModuleLink> rawLanguages;
    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawPowerSystems;
    final List<ModuleLink> rawTechnologies;

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
            rawLanguages: _linksFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}