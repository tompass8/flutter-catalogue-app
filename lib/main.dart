import 'package:flutter/material.dart';
import 'models/character.dart';
import 'services/api_service.dart';
import 'screens/character_detail.dart'; // Import de ta nouvelle page !

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty Dex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF97CE4C)),
        useMaterial3: true,
      ),
      home: const RickAndMortyScreen(),
    );
  }
}

class RickAndMortyScreen extends StatelessWidget {
  const RickAndMortyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: const Color(0xFF97CE4C),
        title: const Text(
          'Rick & Morty Dex',
          style: TextStyle(
            fontFamily: 'GetSchwifty',
            fontSize: 32,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),

      // --- LE FUTUR BUILDER (Pour charger l'API) ---
      body: FutureBuilder<List<Character>>(
        future: ApiService().fetchCharacters(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF97CE4C)));
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          } else if (snapshot.hasData) {
            final characters = snapshot.data!;

            return ListView.builder(
              itemCount: characters.length,
              itemBuilder: (context, index) {
                final char = characters[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(char.image),
                    ),
                    title: Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text(char.description),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                    // --- LE FAMEUX ROUTAGE EST ICI ! ---
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterDetailScreen(character: char), // On envoie le perso à la nouvelle page
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Aucun personnage trouvé.'));
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF24325F),
        selectedItemColor: const Color(0xFF97CE4C),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Dimensions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Personnages'),
        ],
      ),
    );
  }
}