class WorldStats {
  final int characters;
  final int locations;
  final int factions;
  final int items;
  final int events;
  final int languages;
  final int abilities;
  final int technology;
  final int powerSystem;
  final int creatures;
  final int religion;
  final int story;
  final int races;
  final int economy;
  final int characterImages;
  final int eventImages;
  final int itemImages;
  final int locationImages;
  final int creatureImages;
  final int factionImages;
  final int raceImages;
  final int technologyImages;
  final int religionImages;
  final int totalImages;

  WorldStats({
    this.characters = 0,
    this.locations = 0,
    this.factions = 0,
    this.items = 0,
    this.events = 0,
    this.languages = 0,
    this.abilities = 0,
    this.technology = 0,
    this.powerSystem = 0,
    this.creatures = 0,
    this.religion = 0,
    this.story = 0,
    this.races = 0,
    this.economy = 0,
    this.characterImages = 0,
    this.eventImages = 0,
    this.itemImages = 0,
    this.locationImages = 0,
    this.creatureImages = 0,
    this.factionImages = 0,
    this.raceImages = 0,
    this.technologyImages = 0,
    this.religionImages = 0,
    this.totalImages = 0,
  });

  factory WorldStats.fromJson(Map<String, dynamic> json) {
    return WorldStats(
      characters: json['characters'] ?? 0,
      locations: json['locations'] ?? 0,
      factions: json['factions'] ?? 0,
      items: json['items'] ?? 0,
      events: json['events'] ?? 0,
      languages: json['languages'] ?? 0,
      abilities: json['abilities'] ?? 0,
      technology: json['technology'] ?? 0,
      powerSystem: json['powerSystem'] ?? 0,
      creatures: json['creatures'] ?? 0,
      religion: json['religion'] ?? 0,
      story: json['story'] ?? 0,
      races: json['races'] ?? 0,
      economy: json['economy'] ?? 0,
      characterImages: json['characterImages'] ?? 0,
      eventImages: json['eventImages'] ?? 0,
      itemImages: json['itemImages'] ?? 0,
      locationImages: json['locationImages'] ?? 0,
      creatureImages: json['creatureImages'] ?? 0,
      factionImages: json['factionImages'] ?? 0,
      raceImages: json['raceImages'] ?? 0,
      technologyImages: json['technologyImages'] ?? 0,
      religionImages: json['religionImages'] ?? 0,
      totalImages: json['totalImages'] ?? 0,
    );
  }
}
