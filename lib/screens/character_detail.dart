import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir le navigateur
import '../models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Character character;

  const CharacterDetailScreen({super.key, required this.character});

  // --- 1. TA FONCTION DE TÉLÉPORTATION (WIKI) EST ICI ---
  Future<void> _launchWiki() async {
    // On remplace les espaces par des underscores pour le Wiki Fandom
    final String formattedName = character.name.replaceAll(' ', '_');
    final Uri url = Uri.parse("https://rickandmorty.fandom.com/wiki/$formattedName");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir le portail vers $url');
    }
  }

  // --- 2. LA FONCTION QUI DESSINE L'ÉCRAN ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF24325F), // Ton bleu espace
      appBar: AppBar(
        backgroundColor: const Color(0xFF97CE4C),
        title: Text(
          character.name,
          style: const TextStyle(fontFamily: 'GetSchwifty', color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image du perso
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.network(
                character.image,
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Nom du perso
            Text(
              character.name,
              style: const TextStyle(
                fontSize: 30,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Description / Statut
            Text(
              character.description,
              style: const TextStyle(fontSize: 18, color: Color(0xFF97CE4C)),
            ),

            const SizedBox(height: 50),

            // --- 3. TON BOUTON QUI APPELLE LA FONCTION ---
            ElevatedButton.icon(
              onPressed: _launchWiki, // <--- On appelle la fonction définie plus haut
              icon: const Icon(Icons.auto_stories), // Icône de livre/wiki
              label: const Text("VOIR LE WIKI FANDOM"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF97CE4C),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}