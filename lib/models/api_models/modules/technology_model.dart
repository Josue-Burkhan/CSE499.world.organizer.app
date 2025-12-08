import '../module_link.dart';

class TechnologyRelation {
  final String id;
  final String name;

  TechnologyRelation({required this.id, required this.name});

  factory TechnologyRelation.fromJson(Map<String, dynamic> json) {
    return TechnologyRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Technology {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? techType;
    final String? origin;
    final num? yearCreated;
    final String? currentUse;
    final String? limitations;
    final String? energySource;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<ModuleLink> rawCreators;
    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawPowerSystems;

    Technology({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.techType,
        this.origin,
        this.yearCreated,
        this.currentUse,
        this.limitations,
        this.energySource,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCreators,
        required this.rawCharacters,
        required this.rawFactions,
        required this.rawItems,
        required this.rawEvents,
        required this.rawStories,
        required this.rawLocations,
        required this.rawPowerSystems,
    });

    static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
            return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
        if (populated is List) {
          final links = <ModuleLink>[];
          for (var item in populated) {
            if (item is Map<String, dynamic> && item['name'] != null) {
              links.add(ModuleLink(id: item['_id'] ?? item['id'] ?? '', name: item['name']));
            } else if (item is String) {
               links.add(ModuleLink(id: '', name: item));
            }
          }
          if (links.isNotEmpty) return links;
        }

        if (raw is List) {
          return raw.map((item) => ModuleLink(id: '', name: item.toString())).toList();
        }
        return [];
    }

    factory Technology.fromJson(Map<String, dynamic> json) {
        return Technology(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            techType: json['techType'],
            origin: json['origin'],
            yearCreated: json['yearCreated'],
            currentUse: json['currentUse'],
            limitations: json['limitations'],
            energySource: json['energySource'],
            customNotes: json['customNotes'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCreators: _linksFromPopulatedOrRaw(json['creators'], json['rawCreators']),
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
        );
    }
}