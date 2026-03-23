import 'package:flutter/material.dart';
import 'models/character.dart';
import 'services/api_service.dart';
void main() {
  runApp(const MyApp());
}

// 1. LE MOTEUR DE L'APPLICATION
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty Dex',
      debugShowCheckedModeBanner: false, // Enlève le bandeau "DEBUG"
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF97CE4C)),
        useMaterial3: true,
      ),
      home: const RickAndMortyScreen(), // On lance NOTRE écran au démarrage
    );
  }
}

// 2. NOTRE ÉCRAN RICK & MORTY
class RickAndMortyScreen extends StatelessWidget {
  const RickAndMortyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // --- LE HEADER (AppBar) ---
      appBar: AppBar(
        backgroundColor: const Color(0xFF97CE4C), // Le Vert "Portal"
        title: const Text(
          'Rick & Morty Dex',
          style: TextStyle(
            fontFamily: 'GetSchwifty', // La police personnalisée !
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),

      // --- LE CORPS DE L'APPLICATION ---
      body: FutureBuilder<List<Character>>(
        // On lance la requête API ici
        future: ApiService().fetchCharacters(),
        builder: (context, snapshot) {

          // CAS 1 : C'est en train de charger ⏳
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF97CE4C)), // Un loader aux couleurs de Rick
            );
          }

          // CAS 2 : Le serveur a planté ou pas d'internet ❌
          else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red)),
            );
          }

          // CAS 3 : On a reçu les données ! 🎉
          else if (snapshot.hasData) {
            final characters = snapshot.data!;

            // On génère une liste défilante
            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final char = characters[index];

                // Le design d'une "carte" de personnage
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(char.image), // L'image depuis l'API !
                    ),
                    title: Text(
                        char.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                    ),
                    subtitle: Text(char.description),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Pour plus tard : quand on cliquera pour voir les détails !
                      print('Tu as cliqué sur ${char.name}');
                    },
                  ),
                );
              },
            );
          }

          // CAS 4 : La liste est vide 🕳️
          return const Center(child: Text('Aucun personnage trouvé dans cette dimension.'));
        },
      ),
      // --- LE FOOTER (BottomNavigationBar) ---
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF24325F), // Bleu Espace
        selectedItemColor: const Color(0xFF97CE4C), // Vert Portal
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.animation),
            label: 'Dimensions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Personnages',
          ),
        ],
      ),

    );
  }
}