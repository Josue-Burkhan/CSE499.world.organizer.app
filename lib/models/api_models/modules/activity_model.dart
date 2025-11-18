class ActivityRelation {
    final String id;
    final String name;

    ActivityRelation({required this.id, required this.name});

    factory ActivityRelation.fromJson(Map<String, dynamic> json) {
        return ActivityRelation(
            id: json['_id'],
            name: json['name'] ?? 'Unknown',
        );
    }
}

class Activity {
    final String id;
    final String? worldId;
    final String name;
    final String type;
    final String description;
    final String? actionType;

    Activity({
        required this.id,
        this.worldId,
        required this.name,
        required this.type,
        required this.description,
        required this.actionType,
    });

    factory Activity.fromJson(Map<String, dynamic> json) {
        return Activity(
            id: json['_id'],
            worldId: json['world'],
            name: json['name'] ?? 'Unnamed',
            type: json['type'],
            description: json['description'],
            actionType: json['actionType']
        );
    }
}