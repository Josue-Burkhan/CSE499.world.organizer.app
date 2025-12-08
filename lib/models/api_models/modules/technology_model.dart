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

    final List<String> rawCreators;
    final List<String> rawCharacters;
    final List<String> rawFactions;
    final List<String> rawItems;
    final List<String> rawEvents;
    final List<String> rawStories;
    final List<String> rawLocations;
    final List<String> rawPowerSystems;

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
            rawCreators: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawCharacters: _listFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawItems: _listFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
            rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
        );
    }
}