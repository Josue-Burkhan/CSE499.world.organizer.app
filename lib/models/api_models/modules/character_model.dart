import '../module_link.dart';

class CharacterRelation {
  final String id;
  final String name;

  CharacterRelation({required this.id, required this.name});

  factory CharacterRelation.fromJson(Map<String, dynamic> json) {
    return CharacterRelation(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Character {
  final String id;
  final String? worldId;
  final String name;
  final int? age;
  final String? gender;
  final String? nickname;
  final String? customNotes;
  final String tagColor;
  
  final Appearance? appearance;
  final Personality? personality;
  final History? history;
  final List<String> images;

  final List<CharacterRelation> family;
  final List<CharacterRelation> friends;
  final List<CharacterRelation> enemies;
  final List<CharacterRelation> romance;

  final List<ModuleLink> rawAbilities;
  final List<ModuleLink> rawItems;
  final List<ModuleLink> rawLanguages;
  final List<ModuleLink> rawRaces;
  final List<ModuleLink> rawFactions;
  final List<ModuleLink> rawLocations;
  final List<ModuleLink> rawPowerSystems;
  final List<ModuleLink> rawReligions;
  final List<ModuleLink> rawCreatures;
  final List<ModuleLink> rawEconomies;
  final List<ModuleLink> rawStories;
  final List<ModuleLink> rawTechnologies;

  Character({
    required this.id,
    this.worldId,
    required this.name,
    this.age,
    this.gender,
    this.nickname,
    this.customNotes,
    required this.tagColor,
    this.appearance,
    this.personality,
    this.history,
    required this.images,
    required this.family,
    required this.friends,
    required this.enemies,
    required this.romance,
    required this.rawAbilities,
    required this.rawItems,
    required this.rawLanguages,
    required this.rawRaces,
    required this.rawFactions,
    required this.rawLocations,
    required this.rawPowerSystems,
    required this.rawReligions,
    required this.rawCreatures,
    required this.rawEconomies,
    required this.rawStories,
    required this.rawTechnologies,
  });

  static List<String> _listFromRaw(dynamic raw) {
    if (raw is List) {
      return List<String>.from(raw.map((item) => item.toString()));
    }
    return [];
  }

  static List<CharacterRelation> _relationsFromRaw(dynamic raw) {
    if (raw is List) {
      return raw.map((item) {
        if (item is Map<String, dynamic>) {
          final rel = CharacterRelation.fromJson(item);
          if (rel.id.isEmpty) return null;
          return rel;
        }
        if (item is String) {
          if (item.isEmpty) return null;
          return CharacterRelation(id: item, name: item);
        }
        return null; 
      }).whereType<CharacterRelation>().toList();
    }
    return [];
  }



  static List<ModuleLink> _linksFromPopulatedOrRaw(dynamic populated, dynamic raw) {
    // Try raw first IF it is a list of maps (from DB sync or full objects)
    // But API sends populated in 'abilities' and list-of-strings in 'rawAbilities'?
    // Wait, API sends populated objects now.
    
    // Check populated first for full objects
    if (populated is List) {
      return populated.map((item) {
        if (item is Map<String, dynamic>) {
           return ModuleLink.fromJson(item);
        }
        return null; // Skip if not object
      }).whereType<ModuleLink>().toList();
    }
    
    // Check raw (might be strings or maps depending on context)
    if (raw is List) {
       return raw.map((item) {
         if (item is Map<String, dynamic>) {
           return ModuleLink.fromJson(item);
         }
         // If string, we don't have ID, so we can't make a valid link?
         // Or we make a link with empty ID?
         // The requirement is clickable ID.
         // If we only have name, we can't click.
         if (item is String) {
           return ModuleLink(id: '', name: item);
         }
         return null;
       }).whereType<ModuleLink>().toList();
    }

    return [];
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    final relationships = json['relationships'] ?? {};
    return Character(
      id: json['_id'],
      worldId: json['world'],
      name: json['name'] ?? 'Unnamed',
      age: json['age'],
      gender: json['gender'],
      nickname: json['nickname'],
      customNotes: json['customNotes'],
      tagColor: json['tagColor'] ?? 'neutral',
      appearance: json['appearance'] != null
          ? Appearance.fromJson(json['appearance'])
          : null,
      personality: json['personality'] != null
          ? Personality.fromJson(json['personality'])
          : null,
      history: json['history'] != null
          ? History.fromJson(json['history'])
          : null,
      images: _listFromRaw(json['images']),
      family: _relationsFromRaw(relationships['family']),
      friends: _relationsFromRaw(relationships['friends']),
      enemies: _relationsFromRaw(relationships['enemies']),
      romance: _relationsFromRaw(relationships['romance']),
      rawAbilities: _linksFromPopulatedOrRaw(json['abilities'], json['rawAbilities']),
      rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
      rawLanguages: _linksFromPopulatedOrRaw(json['languages'], json['rawLanguages']),
      rawRaces: _linksFromPopulatedOrRaw(json['races'], json['rawRaces']),
      rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
      rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
      rawPowerSystems: _linksFromPopulatedOrRaw(json['powerSystems'], json['rawPowerSystems']),
      rawReligions: _linksFromPopulatedOrRaw(json['religions'], json['rawReligions']),
      rawCreatures: _linksFromPopulatedOrRaw(json['creatures'], json['rawCreatures']),
      rawEconomies: _linksFromPopulatedOrRaw(json['economies'], json['rawEconomies']),
      rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
      rawTechnologies: _linksFromPopulatedOrRaw(json['technologies'], json['rawTechnologies']),
    );
  }
}

class Appearance {
  final num? height;
  final num? weight;
  final String? eyeColor;
  final String? hairColor;
  final String? clothingStyle;

  Appearance({
    this.height,
    this.weight,
    this.eyeColor,
    this.hairColor,
    this.clothingStyle,
  });

  factory Appearance.fromJson(Map<String, dynamic> json) {
    return Appearance(
      height: json['height'],
      weight: json['weight'],
      eyeColor: json['eyeColor'],
      hairColor: json['hairColor'],
      clothingStyle: json['clothingStyle'],
    );
  }

  Map<String, dynamic> toJson() => {
        'height': height,
        'weight': weight,
        'eyeColor': eyeColor,
        'hairColor': hairColor,
        'clothingStyle': clothingStyle,
      };
}

class Personality {
  final List<String> traits;
  final List<String> strengths;
  final List<String> weaknesses;

  Personality({
    required this.traits,
    required this.strengths,
    required this.weaknesses,
  });

  factory Personality.fromJson(Map<String, dynamic> json) {
    return Personality(
      traits: List<String>.from(json['traits'] ?? []),
      strengths: List<String>.from(json['strengths'] ?? []),
      weaknesses: List<String>.from(json['weaknesses'] ?? []),
    );
  }

  Map<String, dynamic> toJson() => {
        'traits': traits,
        'strengths': strengths,
        'weaknesses': weaknesses,
      };
}

class History {
  final String? birthplace;
  final List<HistoryEvent> events;

  History({this.birthplace, required this.events});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      birthplace: json['birthplace'],
      events: (json['events'] as List? ?? [])
          .map((e) => HistoryEvent.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'birthplace': birthplace,
        'events': events.map((e) => e.toJson()).toList(),
      };
}

class HistoryEvent {
  final String year;
  final List<String> rawEvents;
  final String description;

  HistoryEvent({
    required this.year,
    required this.rawEvents,
    required this.description,
  });

  factory HistoryEvent.fromJson(Map<String, dynamic> json) {
    return HistoryEvent(
      year: json['year'],
      rawEvents: List<String>.from(json['rawEvents'] ?? []),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'rawEvents': rawEvents,
        'description': description,
      };
}