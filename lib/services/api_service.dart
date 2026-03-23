import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/character.dart';
import '../models/location.dart'; // <--- 1. On importe le nouveau modèle

class ApiService {
  static const String apiUrl = 'https://rickandmortyapi.com/api/character';
  static const String locationUrl = 'https://rickandmortyapi.com/api/location'; // <--- 2. La nouvelle URL

  // Ta fonction existante pour les personnages (ne la touche pas)
  Future<List<Character>> fetchCharacters() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
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

  // --- 3. LA NOUVELLE FONCTION POUR LES DIMENSIONS ---
  Future<List<Location>> fetchLocations() async {
    try {
      final response = await http.get(Uri.parse(locationUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> results = data['results'];
        return results.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Erreur de serveur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }
}