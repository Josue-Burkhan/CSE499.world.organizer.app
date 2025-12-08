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

    final List<String> rawCharacters;
    final List<String> rawPowerSystems;
    final List<String> rawStories;
    final List<String> rawEvents;
    final List<String> rawItems;
    final List<String> rawReligions;
    final List<String> rawTechnologies;
    final List<String> rawCreatures;
    final List<String> rawRaces;

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

            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawItems: _listFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
            rawCreatures: _listFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawRaces: _listFromPopulatedOrRaw(json['races'], json['rawRaces']),
        );
    }
}
