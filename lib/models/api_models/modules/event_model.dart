import 'package:worldorganizer_app/models/api_models/module_link.dart';

class EventRelation {
  final String id;
  final String name;

  EventRelation({required this.id, required this.name});

  factory EventRelation.fromJson(Map<String, dynamic> json) {
    return EventRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Event {
    final String id;
    final String? worldId;
    final String name;
    final String? date;
    final String? description;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawAbilities;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawPowerSystems;
    final List<ModuleLink> rawCreatures;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;

    Event({
        required this.id,
        this.worldId,
        required this.name,
        this.date,
        this.description,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawFactions,
        required this.rawLocations,
        required this.rawItems,
        required this.rawAbilities,
        required this.rawStories,
        required this.rawPowerSystems,
        required this.rawCreatures,
        required this.rawReligions,
        required this.rawTechnologies,
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

    factory Event.fromJson(Map<String, dynamic> json) {
        return Event(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            date: json['date'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawAbilities: _linksFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
            rawCreatures: _linksFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
            rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
            rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
        );
    }
}