import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // On importe ton nouvel écran d'accueil

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
      // Au lieu d'avoir tout le code ici, on appelle juste ton HomeScreen !
      home: const RickAndMortyScreen(),
    );
  }
}