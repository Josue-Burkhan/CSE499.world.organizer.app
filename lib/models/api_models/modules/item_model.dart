class ItemRelation {
  final String id;
  final String name;

  ItemRelation({required this.id, required this.name});

  factory ItemRelation.fromJson(Map<String, dynamic> json) {
    return ItemRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Item {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final String? type;
    final String? origin;
    final String? material;
    final num? weight;
    final String? value;
    final String? rarity;
    final List<String> magicalProperties;
    final List<String> technologicalFeatures;
    final List<String> customEffects;
    final bool isUnique;
    final bool isDestroyed;
    final String? customNotes;
    final List<String> images;
    final String tagColor;

    final List<String> rawCreatedBy;
    final List<String> rawUsedBy;
    final List<String> rawCurrentOwnerCharacter;
    final List<String> rawFactions;
    final List<String> rawEvents;
    final List<String> rawStories;
    final List<String> rawLocations;
    final List<String> rawReligions;
    final List<String> rawTechnologies;
    final List<String> rawPowerSystems;
    final List<String> rawLanguages;
    final List<String> rawAbilities;

    Item({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.type,
        this.origin,
        this.material,
        this.weight,
        this.value,
        this.rarity,
        required this.magicalProperties,
        required this.technologicalFeatures,
        required this.customEffects,
        required this.isUnique,
        required this.isDestroyed,
        this.customNotes,
        required this.images,
        required this.tagColor,
        required this.rawCreatedBy,
        required this.rawUsedBy,
        required this.rawCurrentOwnerCharacter,
        required this.rawFactions,
        required this.rawEvents,
        required this.rawStories,
        required this.rawLocations,
        required this.rawReligions,
        required this.rawTechnologies,
        required this.rawPowerSystems,
        required this.rawLanguages,
        required this.rawAbilities,
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

    factory Item.fromJson(Map<String, dynamic> json) {
        return Item(
          id: json['_id'],
          worldId: json['world'],
          name: json['name'] ?? 'Unnamed',
          description: json['description'],
          type: json['type'],
          origin: json['origin'],
          material: json['material'],
          weight: json['weight'],
          value: json['value'],
          rarity: json['rarity'],
          magicalProperties: _listFromRaw(json['magicalProperties']),
          technologicalFeatures: _listFromRaw(json['technologicalFeatures']),
          customEffects: _listFromRaw(json['customEffects']),
          isUnique: json['isUnique'] ?? false,
          isDestroyed: json['isDestroyed'] ?? false,
          customNotes: json['customNotes'],
          images: _listFromRaw(json['images']),
          tagColor: json['tagColor'] ?? 'neutral',
          rawCreatedBy: _listFromPopulatedOrRaw(json['createdBy'], json['rawCreatedBy']),
          rawUsedBy: _listFromPopulatedOrRaw(json['usedBy'], json['rawUsedBy']),
          rawCurrentOwnerCharacter: _listFromPopulatedOrRaw(json['currentOwnerCharacter'], json['rawCurrentOwnerCharacter']),
          rawFactions: _listFromPopulatedOrRaw(json['factions'], json['rawFactions']),
          rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
          rawStories: _listFromPopulatedOrRaw(json['stories'], json['rawStories']),
          rawLocations: _listFromPopulatedOrRaw(json['locations'], json['rawLocations']),
          rawReligions: _listFromPopulatedOrRaw(json['religions'], json['rawReligions']),
          rawTechnologies: _listFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
          rawPowerSystems: _listFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
          rawLanguages: _listFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
          rawAbilities: _listFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
        );
    }
}