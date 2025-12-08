import '../module_link.dart';

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

    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawAbilities;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawPowerSystems;
    final List<ModuleLink> rawReligions;

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

    static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        // Try raw first - if it's a list of strings
        if (raw is List && raw.isNotEmpty) {
             return raw.map((item) {
                return ModuleLink(id: '', name: item.toString());
            }).toList();
        }
        
        // Fallback to populated if it contains objects
        if (populated is List) {
            return populated.map((item) {
                if (item is Map<String, dynamic> && item['name'] != null) {
                    final id = item['id'] ?? item['_id'] ?? '';
                    return ModuleLink(id: id, name: item['name'].toString());
                }
                return null;
            }).whereType<ModuleLink>().toList();
        }
        return [];
    }

    factory Creature.fromJson(Map<String, dynamic> json) {
        return Creature(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            speciesType: json['speciesType'],
            description: json['description'] ?? '',
            habitat: json['habitat'] ?? '',
            weaknesses: _listFromRaw(json['weaknesses']),
            domesticated: json['domesticated'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawAbilities: _linksFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
        );
    }
}