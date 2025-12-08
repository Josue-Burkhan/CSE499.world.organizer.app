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
            rawLanguages: _listFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}