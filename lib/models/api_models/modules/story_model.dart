import '../module_link.dart';

class StoryRelation {
  final String id;
  final String name;

  StoryRelation({required this.id, required this.name});

  factory StoryRelation.fromJson(Map<String, dynamic> json) {
    return StoryRelation(
      id: json['_id'],
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}

class Story {
    final String id;
    final String? worldId;
    final String name;
    final String? summary;
    final Timeline? timeline;
    final String tagColor;

    Story({
        required this.id,
        this.worldId,
        required this.name,
        this.summary,
        this.timeline,
        required this.tagColor,
    });

    factory Story.fromJson(Map<String, dynamic> json) {
        return Story(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            summary: json['summary'],
            timeline: json['timeline'] != null
            ? Timeline.fromJson(json['timeline'])
            : null,
            tagColor: json['tagColor'] ?? 'neutral',
        );
    }
}

class Timeline {
    final List<TimelineEvent>? timelineEvents;

    Timeline({this.timelineEvents});

    factory Timeline.fromJson(Map<String, dynamic> json) {
        return Timeline(
            timelineEvents: (json['events'] as List? ?? [])
            .map((e) => TimelineEvent.fromJson(e))
            .toList(),
        );
    }

    Map<String, dynamic> toJson() => {
        'timelineEvents': timelineEvents?.map((e) => e.toJson()).toList(),
    };
}

class TimelineEvent {
    final num year;
    final List<ModuleLink> rawEvents;
    final String description;

    TimelineEvent({
        required this.year,
        required this.rawEvents,
        required this.description,
    });

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

    factory TimelineEvent.fromJson(Map<String, dynamic> json) {
        return TimelineEvent(
            year: json['year'],
            rawEvents: _linksFromPopulatedOrRaw(json['events'], json['rawEvents']),
            description: json['description'],
        );
    }

    Map<String, dynamic> toJson() => {
        'year': year,
        'rawEvents': rawEvents.map((e) => e.name).toList(),
        'description': description,
    };
}