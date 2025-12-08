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
    final List<String> rawEvents;
    final String description;

    TimelineEvent({
        required this.year,
        required this.rawEvents,
        required this.description,
    });

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

    factory TimelineEvent.fromJson(Map<String, dynamic> json) {
        return TimelineEvent(
            year: json['year'],
            rawEvents: _listFromPopulatedOrRaw(json['events'], json['rawEvents']),
            description: json['description'],
        );
    }

    Map<String, dynamic> toJson() => {
        'year': year,
        'rawEvents': rawEvents,
        'description': description,
    };
}