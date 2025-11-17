import 'dart:convert';

class EconomyRelation {
    final String id;
    final String name;

    EconomyRelation({required this.id, required this.name});

    factory EconomyRelation.fromJson(Map<String, dynamic> json) {
        return EconomyRelation(
            id: json['_id'],
            name: json['name'] ?? 'Unknown',
        );

        Map<String, dynamic> toJson() => {
            '_id': id,
            'name': name,
        }
    };
}

class Economy {
    final String id;
    final String? worldId;
    final String name;
    final String? description;
    final Currency? currency;
    final List<String> tradeGoods;
    final List<String> keyIndustries;
    final String economicSystem;
    final List<String> images;
    final String tagColor;

    final List<String> rawCharacters;
    final List<String> rawFactions;
    final List<String> rawLocations;
    final List<String> rawItems;
    final List<String> rawRaces;
    final List<String> rawStories;

    Economy({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.currency,
        required this.tradeGoods,
        required this.keyIndustries,
        this.economicSystem,
        required this.images,
        required this.tagColor,
        required this.rawCharacters,
        required this.rawFactions,
        required this.rawLocations,
        required this.rawItems,
        required this.rawRaces,
        required this.rawStories,
    });

      static List<String> _listFromRaw(dynamic raw) {
        if (raw is List) {
        return List<String>.from(raw.map((item) => item.toString()));
        }
        return [];
    }

    factory Economy.fromJson(Map<String, dynamic> json) {
        return Economy(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            description: json['description'],
            currency: json['currency'] != null
                ? Currency.fromJson(json['currency'])
                : null,
            tradeGoods: _listFromRaw(json['tradeGoods']),
            keyIndustries: _listFromRaw(json['keyIndustries']),
            economicSystem: json['economicSystem'],
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _listFromRaw(json['rawCharacters']),
            rawFactions: _listFromRaw(json['rawFactions']),
            rawLocations: _listFromRaw(json['rawLocations']),
            rawItems: _listFromRaw(json['rawItems']),
            rawRaces: _listFromRaw(json['rawRaces']),
            rawStories: _listFromRaw(json['rawStories']),
        )
    }
}

class Currency {
    final String? name;
    final String? symbol;
    final String? valueBase;

    Currency({
        this.name,
        this.symbol,
        this.valueBase,
    });

    factory Currency.fromJson(Map<String, dynamic> json) {
        return Currency(
            name: json['name'] ?? 'Unnamed',
            symbol: json['symbol'],
            valueBase: json['valueBase'],
        );
    }

    Map<String, dynamic> toJson() => {
        'name': name,
        'symbol': symbol,
        'valueBase': valueBase,
    };
}