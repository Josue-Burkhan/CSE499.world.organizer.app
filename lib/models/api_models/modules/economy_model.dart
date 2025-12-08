import 'package:worldorganizer_app/models/api_models/module_link.dart';

class EconomyRelation {
    final String id;
    final String name;

    EconomyRelation({required this.id, required this.name});

    factory EconomyRelation.fromJson(Map<String, dynamic> json) {
        return EconomyRelation(
            id: json['_id'],
            name: json['name'] ?? 'Unknown',
        );
    }
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

    final List<ModuleLink> rawCharacters;
    final List<ModuleLink> rawFactions;
    final List<ModuleLink> rawLocations;
    final List<ModuleLink> rawItems;
    final List<ModuleLink> rawRaces;
    final List<ModuleLink> rawStories;

    Economy({
        required this.id,
        this.worldId,
        required this.name,
        this.description,
        this.currency,
        required this.tradeGoods,
        required this.keyIndustries,
        required this.economicSystem,
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
            economicSystem: json['economicSystem'] ?? 'Unknown',
            images: _listFromRaw(json['images']),
            tagColor: json['tagColor'] ?? 'neutral',
            rawCharacters: _linksFromPopulatedOrRaw(json['characters'], json['rawCharacters']),
            rawFactions: _linksFromPopulatedOrRaw(json['factions'], json['rawFactions']),
            rawLocations: _linksFromPopulatedOrRaw(json['locations'], json['rawLocations']),
            rawItems: _linksFromPopulatedOrRaw(json['items'], json['rawItems']),
            rawRaces: _linksFromPopulatedOrRaw(json['races'], json['rawRaces']),
            rawStories: _linksFromPopulatedOrRaw(json['stories'], json['rawStories']),
        );
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