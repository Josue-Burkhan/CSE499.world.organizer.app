import 'dart:convert';

class Character {
  final String id;
  final String worldId;
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

  final List<String> rawFamily;
  final List<String> rawFriends;
  final List<String> rawEnemies;
  final List<String> rawRomance;
  final List<String> rawAbilities;
  final List<String> rawItems;
  final List<String> rawLanguages;
  final List<String> rawRaces;
  final List<String> rawFactions;
  final List<String> rawLocations;
  final List<String> rawPowerSystems;
  final List<String> rawReligions;
  final List<String> rawCreatures;
  final List<String> rawEconomies;
  final List<String> rawStories;
  final List<String> rawTechnologies;

  Character({
    required this.id,
    required this.worldId,
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
    required this.rawFamily,
    required this.rawFriends,
    required this.rawEnemies,
    required this.rawRomance,
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
      rawFamily: _listFromRaw(relationships['rawFamily']),
      rawFriends: _listFromRaw(relationships['rawFriends']),
      rawEnemies: _listFromRaw(relationships['rawEnemies']),
      rawRomance: _listFromRaw(relationships['rawRomance']),
      rawAbilities: _listFromRaw(json['rawAbilities']),
      rawItems: _listFromRaw(json['rawItems']),
      rawLanguages: _listFromRaw(json['rawLanguages']),
      rawRaces: _listFromRaw(json['rawRaces']),
      rawFactions: _listFromRaw(json['rawFactions']),
      rawLocations: _listFromRaw(json['rawLocations']),
      rawPowerSystems: _listFromRaw(json['rawPowerSystems']),
      rawReligions: _listFromRaw(json['rawReligions']),
      rawCreatures: _listFromRaw(json['rawCreatures']),
      rawEconomies: _listFromRaw(json['rawEconomies']),
      rawStories: _listFromRaw(json['rawStories']),
      rawTechnologies: _listFromRaw(json['rawTechnologies']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'world': worldId,
      'name': name,
      'age': age,
      'gender': gender,
      'nickname': nickname,
      'customNotes': customNotes,
      'tagColor': tagColor,
      'appearance': appearance?.toJson(),
      'personality': personality?.toJson(),
      'history': history?.toJson(),
      'images': images,
      'relationships': {
        'rawFamily': rawFamily,
        'rawFriends': rawFriends,
        'rawEnemies': rawEnemies,
        'rawRomance': rawRomance,
      },
      'rawAbilities': rawAbilities,
      'rawItems': rawItems,
      'rawLanguages': rawLanguages,
      'rawRaces': rawRaces,
      'rawFactions': rawFactions,
      'rawLocations': rawLocations,
      'rawPowerSystems': rawPowerSystems,
      'rawReligions': rawReligions,
      'rawCreatures': rawCreatures,
      'rawEconomies': rawEconomies,
      'rawStories': rawStories,
      'rawTechnologies': rawTechnologies,
    };
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