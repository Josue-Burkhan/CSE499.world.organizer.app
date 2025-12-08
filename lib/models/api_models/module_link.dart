class ModuleLink {
  final String id;
  final String name;

  ModuleLink({required this.id, required this.name});

  factory ModuleLink.fromJson(Map<String, dynamic> json) {
    return ModuleLink(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
