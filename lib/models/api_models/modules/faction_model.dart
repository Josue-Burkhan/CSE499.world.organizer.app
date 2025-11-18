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

class Faction {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? type;
    final String? symbol;
    final String? economicSystem;
    final String? technology;
    final List<String> goals;
    final String? history;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<FactionRelation> allies;
    final List<FactionRelation> enemies;
    
    final List<String> rawCharacters;
    final List<String> rawLocations;
    final List<String> rawHeadquarters;
    final List<String> rawTerritory;
    final List<String> rawEvents;
    final List<String> rawItems;
    final List<String> rawStories;
    final List<String> rawReligions;
    final List<String> rawTechnologies;
    final List<String> rawLanguages;
    final List<String> rawPowerSystems;

    Faction({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.type,
        this.symbol,
        this.economicSystem,
        this.technology,
        required this.goals,
        this.history,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.allies,
        required this.enemies,
        required this.rawCharacters,
        required this.rawLocations,
        required this.rawHeadquarters,
        required this.rawTerritory,
        required this.rawEvents,
        required this.rawItems,
        required this.rawStories,
        required this.rawReligions,
        required this.rawTechnologies,
        required this.rawLanguages,
        required this.rawPowerSystems,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    static List<FactionRelation> _relationsFromRaw(dynamic raw) {
        if (raw is List) {
            return raw.map((item) {
                if (item is Map<String, dynamic>) {
                return FactionRelation.fromJson(item);
                }
                return null; 
            }).whereType<FactionRelation>().toList();
        }
        return [];
    }

    factory Faction.fromJson(Map<String, dynamic> json) {
        final relationships = json['relationships'] ?? {};
        return Faction(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            type: json['type'],
            symbol: json['symbol'],
            economicSystem: json['economicSystem'],
            technology: json['technology'],
            goals: _listFromRaw(json['goals']),
            history: json['history'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            allies: _relationsFromRaw(relationships['allies']),
            enemies: _relationsFromRaw(relationships['enemies']),
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawHeadquarters: _listFromRaw(json['rawLocations']),
            rawTerritory: _listFromRaw(json['rawLocations']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawItems: _listFromRaw(json['rawItems']),
            rawStories: _listFromRaw(json['rawStories']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
            rawLanguages: _listFromRaw(json['rawLanguages']),
            rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
        );
    }
}