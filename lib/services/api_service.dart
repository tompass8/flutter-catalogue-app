import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';

class ApiService {
  // L'URL de l'API Rick & Morty
  static const String apiUrl = 'https://rickandmortyapi.com/api/character';

  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Si le serveur répond OK, on transforme le JSON en liste d'objets Dart
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        return results.map((json) => Character.fromJson(json)).toList();
      } else {
        throw Exception('Erreur de serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}