import 'package:worldorganizer_app/models/api_models/module_link.dart';

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
    
    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawHeadquarters;
    final List<ModuleLink> rawTerritory;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;
    final List<ModuleLink> rawLanguages;
    final List<ModuleLink> rawPowerSystems;

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

    static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        // Try raw first
        if (raw is List && raw.isNotEmpty) {
             return raw.map((item) => ModuleLink(id: '', name: item.toString())).toList();
        }
        // Fallback to populated if it contains objects with names
        if (populated is List) {
            return populated.map((item) {
                if (item is Map<String, dynamic>) {
                    return ModuleLink.fromJson(item);
                }
                return null;
            }).whereType<ModuleLink>().toList();
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
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawHeadquarters: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawTerritory: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
            rawLanguages: _linksFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
        );
    }
}