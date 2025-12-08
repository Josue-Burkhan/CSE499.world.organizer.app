import '../module_link.dart';

class AbilityRelation {
    final String id;
    final String name;

    AbilityRelation({required this.id, required this.name});

    factory AbilityRelation.fromJson(Map<String, dynamic> json) {
        return AbilityRelation(
            id: json['_id'],
            name: json['name'] ?? 'Unknown',
        );
    }
}

class Ability {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? type;
    final String? element;
    final String? cooldown;
    final String? cost;
    final String? level;
    final String? requirements;
    final String? effect;
    final String? customNotes;

    final List<String> images;
    final String tagColor;

    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawPowerSystems;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;
    final List<ModuleLink> rawCreatures;
    final List<ModuleLink> rawRaces;

    Ability({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.type,
        this.element,
        this.cooldown,
        this.cost,
        this.level,
        this.requirements,
        this.effect,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawPowerSystems,
        required this.rawStories,
        required this.rawEvents,
        required this.rawItems,
        required this.rawReligions,
        required this.rawTechnologies,
        required this.rawCreatures,
        required this.rawRaces,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        // Check populated first for full objects
        if (populated is List) {
          return populated.map((item) {
            if (item is Map<String, dynamic>) {
               return ModuleLink.fromJson(item);
            }
            return null;
          }).whereType<ModuleLink>().toList();
        }
        
        // Check raw
        if (raw is List) {
           return raw.map((item) {
             if (item is Map<String, dynamic>) {
               return ModuleLink.fromJson(item);
             }
             if (item is String) {
               return ModuleLink(id: '', name: item);
             }
             return null;
           }).whereType<ModuleLink>().toList();
        }
        return [];
    }
    
    factory Ability.fromJson(Map<String, dynamic> json) {
        return Ability(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            type: json['type'],
            element: json['element'],
            cooldown: json['cooldown'],
            cost: json['cost'],
            level: json['level'],
            requirements: json['requirements'],
            effect: json['effect'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',

            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
            rawCreatures: _linksFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawRaces: _linksFromPopulatedOrRaw(json['races'], json['rawRaces']),
        );
    }
}
