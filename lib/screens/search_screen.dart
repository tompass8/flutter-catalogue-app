import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import 'character_detail.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Le contrôleur pour lire ce qui est tapé au clavier
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Le mot qu'on va envoyer à l'API

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // --- LA BARRE DE RECHERCHE ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Chercher un personnage...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF97CE4C)),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.white54),
                onPressed: () {
                  _searchController.clear(); // On vide le texte
                  setState(() => _searchQuery = ''); // On vide les résultats
                },
              ),
              filled: true,
              fillColor: const Color(0xFF1E2A4F), // Fond de la barre
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            // Quand l'utilisateur appuie sur "Entrée" sur son clavier
            onSubmitted: (value) {
              setState(() {
                _searchQuery = value; // On lance la recherche !
              });
            },
          ),
        ),

        // --- LES RÉSULTATS DE LA RECHERCHE ---
        Expanded(
          child: _searchQuery.isEmpty
              ? const Center(
            child: Text('Tapez un nom et appuyez sur Entrée ⌨️',
                style: TextStyle(color: Colors.white70, fontSize: 18)),
          )
              : FutureBuilder<List<Character>>(
            future: ApiService().searchCharacters(_searchQuery),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF97CE4C)));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Erreur du portail.', style: TextStyle(color: Colors.red)));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Aucun personnage trouvé 😢', style: TextStyle(color: Colors.white)));
              }

              // Si on a des résultats, on affiche la liste !
              final characters = snapshot.data!;
              return ListView.builder(
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final char = characters[index];
                  return Card(
                    color: const Color(0xFF1E2A4F),
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: NetworkImage(char.image)),
                      title: Text(char.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(char.description, style: const TextStyle(color: Colors.white70)),
                      trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF97CE4C), size: 16),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => CharacterDetailScreen(character: char),
                        ));
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}