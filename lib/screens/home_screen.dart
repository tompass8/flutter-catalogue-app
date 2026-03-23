import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import 'character_detail.dart';
import 'dimensions_screen.dart';
import 'search_screen.dart';

class RickAndMortyScreen extends StatefulWidget {
  const RickAndMortyScreen({super.key});

  @override
  State<RickAndMortyScreen> createState() => _RickAndMortyScreenState();
}

class _RickAndMortyScreenState extends State<RickAndMortyScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Extrait le widget de la carte pour éviter la duplication de code
  Widget _buildCharacterCard(BuildContext context, Character char) {
    return Card(
      color: const Color(0xFF1E2A4F),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      elevation: 3,
      child: Center(
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(char.image),
          ),
          title: Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
          subtitle: Text(char.description, style: const TextStyle(color: Colors.white70)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF97CE4C)),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CharacterDetailScreen(character: char),
              ),
            );
          },
        ),
      ),
    );
  }

  // Gère la récupération des données et l'affichage responsive
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

          return LayoutBuilder(
            builder: (context, constraints) {
              // Passage en GridView pour les tablettes ou écrans larges
              if (constraints.maxWidth > 600) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    return _buildCharacterCard(context, characters[index]);
                  },
                );
              }
              // Affichage classique en ListView pour les smartphones
              else {
                return ListView.builder(
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    return _buildCharacterCard(context, characters[index]);
                  },
                );
              }
            },
          );
        }
        return const Center(child: Text('Aucun personnage trouvé.', style: TextStyle(color: Colors.white)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Gestion de la navigation entre les vues
    final List<Widget> pages = [
      _buildCatalogue(),
      const DimensionsScreen(),
      const SearchScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF24325F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF97CE4C),
        title: const Text(
          'Rick & Morty Dex',
          style: TextStyle(fontFamily: 'GetSchwifty', fontSize: 32, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF24325F),
        selectedItemColor: const Color(0xFF97CE4C),
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: 'Dimensions'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Recherche'),
        ],
      ),
    );
  }
}