class Character {
  final int id;
  final String name;
  final String image;
  final String description; // Correction : "description"
  final String date;        // Correction : "String" avec un "n"

  final double latitude;
  final double longitude;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.description, // Correction : "description"
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
      latitude: 43.6047, // Coordonnées fixes (ex: Toulouse) pour l'exercice
      longitude: 1.4442,
    );
  }
}