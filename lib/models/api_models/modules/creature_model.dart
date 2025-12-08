class CreatureRelation {
  final String id;
  final String name;

  CreatureRelation({required this.id, required this.name});

  factory CreatureRelation.fromJson(Map<String, dynamic> json) {
    return CreatureRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }
}

class Creature {
    final String id;
    final String? worldId;
    final String name;
    final String? speciesType;
    final String description;
    final String habitat;
    final List<String> weaknesses;
    final bool? domesticated;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawCharacters;
    final List<String> rawAbilities;
    final List<String> rawFactions;
    final List<String> rawEvents;
    final List<String> rawStories;
    final List<String> rawLocations;
    final List<String> rawPowerSystems;
    final List<String> rawReligions;

    Creature({
        required this.id,
        this.worldId,
        required this.name,
        this.speciesType,
        required this.description,
        required this.habitat,
        required this.weaknesses,
        this.domesticated,
        this.customNotes,
        required this.images,
        required this.tagColor,

        required this.rawCharacters,
        required this.rawAbilities,
        required this.rawFactions,
        required this.rawEvents,
        required this.rawStories,
        required this.rawLocations,
        required this.rawPowerSystems,
        required this.rawReligions,
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

    factory Creature.fromJson(Map<String, dynamic> json) {
        return Creature(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            speciesType: json['speciesType'],
            description: json['description'],
            habitat: json['habitat'],
            weaknesses: _listFromRaw(json['weaknesses']),
            domesticated: json['domesticated'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawAbilities: _listFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
        );
    }
}