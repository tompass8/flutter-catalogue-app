import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // <--- 1. ON IMPORTE LE LANCEUR WEB
import '../models/location.dart';
import '../services/api_service.dart';

class DimensionsScreen extends StatelessWidget {
  const DimensionsScreen({super.key});

  // --- 2. LA FONCTION MAGIQUE DE TÉLÉPORTATION ---
  Future<void> _launchLocationWiki(String locationName) async {
    // On remplace les espaces par des underscores
    final String formattedName = locationName.replaceAll(' ', '_');
    final Uri url = Uri.parse("https://rickandmorty.fandom.com/wiki/$formattedName");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Impossible d\'ouvrir le portail vers $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Location>>(
      future: ApiService().fetchLocations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF97CE4C)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
        } else if (snapshot.hasData) {
          final locations = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final loc = locations[index];
              return Card(
                color: const Color(0xFF1E2A4F),
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFF97CE4C),
                    child: Icon(Icons.public, color: Colors.black),
                  ),
                  title: Text(
                      loc.name,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                  subtitle: Text(
                      '${loc.type} • ${loc.dimension}',
                      style: const TextStyle(color: Colors.white70)
                  ),

                  // 3. ON AJOUTE UNE PETITE ICÔNE WEB À DROITE
                  trailing: const Icon(Icons.language, color: Color(0xFF97CE4C)),

                  // 4. ON ACTIVE LE CLIC SUR LA CARTE !
                  onTap: () {
                    _launchLocationWiki(loc.name);
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text('Aucune dimension trouvée.', style: TextStyle(color: Colors.white)));
      },
    );
  }
}