class SearchResult {
  final String id;
  final String name;
  final String type;

  SearchResult({
    required this.id,
    required this.name,
    required this.type,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['_id'],
      name: json['name'] ?? 'Unnamed',
      type: json['type'] ?? 'Unknown',
    );
  }
}