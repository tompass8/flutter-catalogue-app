import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // On prépare notre appel à l'API
  late Future<List<Character>> futureCharacters;

  @override
  void initState() {
    super.initState();
    futureCharacters = ApiService().fetchCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue Rick & Morty'),
        backgroundColor: Colors.greenAccent,
      ),
      // FutureBuilder attend que les données d'internet arrivent pour construire l'écran
      body: FutureBuilder<List<Character>>(
        future: futureCharacters,
        builder: (context, snapshot) {
          // 1. Si ça charge, on montre un rond qui tourne
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // 2. S'il y a une erreur internet
          else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          // 3. Si les données sont bien là !
          else if (snapshot.hasData) {
            List<Character> characters = snapshot.data!;

            // C'EST ICI QU'ON GÈRE LE RESPONSIVE (Mobile vs Tablette)
            return LayoutBuilder(
              builder: (context, constraints) {
                // Si l'écran est petit (Mobile) : on retourne une Liste classique
                if (constraints.maxWidth < 600) {
                  return ListView.builder(
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(characters[index].image),
                        title: Text(characters[index].name),
                        subtitle: Text(characters[index].description),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: characters[index],
                          );
                        },
                      );
                    },
                  );
                }
                // Si l'écran est grand (Tablette) : on retourne une Grille
                else {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 3 colonnes sur tablette
                      childAspectRatio: 0.8,
                    ),
                    itemCount: characters.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        // 1. L'action au clic
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: characters[index],
                          );
                        },
                        // 2. L'enfant (la carte visuelle)
                        child: Card(
                          child: Column(
                            children: [
                              Expanded(child: Image.network(characters[index].image, fit: BoxFit.cover)),
                              Text(characters[index].name, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(characters[index].description),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            );
          }

          // 4. Si la liste est vide ou en cas de problème imprévu
          return const Center(child: Text('Aucune donnée'));
        },
      ),
    );
  }
}