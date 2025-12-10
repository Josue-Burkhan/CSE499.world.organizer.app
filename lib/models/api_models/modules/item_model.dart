import '../module_link.dart';

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

    final List<ModuleLink> rawCreatedBy;
    final List<ModuleLink> rawUsedBy;
    
    // final List<String> rawCurrentOwnerCharacter; // NOT USING ModuleLink for now as it seems absent in detailed map logic?
    // Actually, let's keep it consistent.
    final List<ModuleLink> rawCurrentOwnerCharacter;

    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawEvents;
    final List<ModuleLink> rawStories;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawReligions;
    final List<ModuleLink> rawTechnologies;
    final List<ModuleLink> rawPowerSystems;
    final List<ModuleLink> rawLanguages;
    final List<ModuleLink> rawAbilities;

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
          rawCreatedBy: _linksFromPopulatedOrRaw(json['createdBy'], json['rawCreatedBy']),
          rawUsedBy: _linksFromPopulatedOrRaw(json['usedBy'], json['rawUsedBy']),
          rawCurrentOwnerCharacter: _linksFromPopulatedOrRaw(json['currentOwnerCharacter'], json['rawCurrentOwnerCharacter']),
          rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
          rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
          rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
          rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
          rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
          rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
          rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
          rawLanguages: _linksFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
          rawAbilities: _linksFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
        );
    }
}