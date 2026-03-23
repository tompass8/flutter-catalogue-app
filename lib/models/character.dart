class Character {
  final int id;
  final String name;
  final String image;
  final String description;
  final String wikiUrl;

  Character({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.wikiUrl,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'] ?? 'Inconnu',
      image: json['image'] ?? '',
      description: "${json['species']} - ${json['status']}",
      wikiUrl: json['url'] ?? 'https://rickandmortyapi.com',
    );
  }
}