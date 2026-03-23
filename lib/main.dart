import 'package:flutter/material.dart';
import 'models/character.dart';
import 'services/api_service.dart';
import 'screens/character_detail.dart';
import 'screens/dimensions_screen.dart';
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

// --------------------------------------------------------
// 1. ON PASSE EN STATEFUL WIDGET (Écran avec mémoire)
// --------------------------------------------------------
class RickAndMortyScreen extends StatefulWidget {
  const RickAndMortyScreen({super.key});

  @override
  State<RickAndMortyScreen> createState() => _RickAndMortyScreenState();
}

class _RickAndMortyScreenState extends State<RickAndMortyScreen> {

  // 2. LA MÉMOIRE : On retient l'onglet sélectionné (0 = Accueil par défaut)
  int _selectedIndex = 0;

  // 3. LA FONCTION : Ce qu'il se passe quand on clique sur un onglet
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // On met à jour la mémoire
    });
  }

  // 4. TON CODE INTACT : J'ai juste rangé ta liste dans cette "boîte"
  Widget _buildCatalogue() {
    return FutureBuilder<List<Character>>(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterDetailScreen(character: char),
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
    );
  }

  @override
  Widget build(BuildContext context) {

    // 5. LES 3 SOUS-ÉCRANS DE NOTRE APPLICATION
    final List<Widget> pages = [
      _buildCatalogue(), // Index 0 : Ton catalogue

      const DimensionsScreen(), // <--- C'EST ICI LA MAGIE ! On appelle ta nouvelle page !

      const Center(child: Text('🔍 La page Personnages arrivera ici !', style: TextStyle(color: Colors.white, fontSize: 20))), // Index 2
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF24325F), // Fond bleu pour les pages vides

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

      // 6. ON AFFICHE LA PAGE QUI CORRESPOND À L'ONGLET SÉLECTIONNÉ
      body: pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF24325F),
        selectedItemColor: const Color(0xFF97CE4C),
        unselectedItemColor: Colors.white54,

        // 7. ON BRANCHE LA MÉMOIRE AU MENU !
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Dimensions'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Personnages'),
        ],
      ),
    );
  }
}