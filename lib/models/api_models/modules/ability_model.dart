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

            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
            rawStories: _listFromRaw(json['rawStories']),
            rawEvents: _listFromRaw(json['rawEvents']),
            rawItems: _listFromRaw(json['rawItems']),
            rawReligions: _listFromRaw(json['rawReligions']),
            rawTechnologies: _listFromRaw(json['rawTechnologies']),
            rawCreatures: _listFromRaw(json['rawCreatures']),
            rawRaces: _listFromRaw(json['rawRaces']),
        );
    }
}
