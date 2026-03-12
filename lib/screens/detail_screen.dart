import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/character.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  // Nouvelle fonction pour le Wiki
  Future<void> _launchWikiUrl() async {
    // 1. On remplace les espaces par des underscores (_)
    String formattedName = character.name.replaceAll(' ', '_');

    // 2. On injecte le nom formaté à la fin de l'URL de base
    final Uri url = Uri.parse('https://rickandmorty.fandom.com/wiki/$formattedName');

    // 3. On lance la page internet
    if (!await launchUrl(url)){
      throw Exception('Impossible de charger la page $url');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(character.image, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              character.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                character.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              // On appelle notre nouvelle fonction
              onPressed: _launchWikiUrl,
              // J'ai mis une icône de livre (menu_book) au lieu de la TV
              icon: const Icon(Icons.menu_book),
              // On change le texte du bouton
              label: const Text('Voir sur le Wiki Fandom'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}