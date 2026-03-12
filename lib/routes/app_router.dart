import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../models/character.dart';

class AppRouter{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case'/':
        return MaterialPageRoute(builder:(_) => const HomeScreen());

      case '/detail':
        final character = settings.arguments as Character;
        return MaterialPageRoute(builder:(_) =>  DetailScreen(character: character));

        default:

          return MaterialPageRoute(
              builder: (_) => Scaffold(
            appBar: AppBar(title:const Text('Rickrror')),
            body: Center(child: Text('Ce portail ne va nul part ${settings.name}')),

              ),
            );
    }
  }
}
