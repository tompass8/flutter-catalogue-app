class Character {
  final int id;
  final String name;
  final String image;
  final String description;
  final String date;

  final double latitude;
  final double longitude;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.date,
    required this.latitude,
    required this.longitude,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'] ?? 'Inconnu',
      image: json['image'] ?? '',
      description: "${json['species']} - ${json['status']}",
      date: json['created'] ?? '',
      latitude: 43.6047, // Coordonnées fixes
      longitude: 1.4442,
    );
  }
}