class Location {
  final int id;
  final String name;
  final String type;
  final String dimension;

  Location({
    required this.id,
    required this.name,
    required this.type,
    required this.dimension,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'] ?? 'Inconnu',
      type: json['type'] ?? 'Inconnu',
      dimension: json['dimension'] ?? 'Inconnue',
    );
  }
}