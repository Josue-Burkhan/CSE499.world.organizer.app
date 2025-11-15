import 'dart:convert';

class AbilityRelation {
    final String id;
    final String name;

    AbilityRelation({required this.id, required this.name});

    factory AbilityRelation.fromjson(Map<String, dynamic> json) {
        return AbilityRelation(
            id: json['_id'],
            name: json['name'] ?? 'Unknown',
        );

        Map<String, dynamic> toJson() => {
            '_id': id,
            'name': name,
        }
    };
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
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Ability.fromJson(Map<String, dynamic> json) {
        final relationships = json['relationships'] ?? {};
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
        )
    }
}
