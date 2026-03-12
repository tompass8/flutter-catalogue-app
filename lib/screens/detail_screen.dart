import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/character.dart';

class DetailScreen extends StatelessWidget {
  final Character character;

  const DetailScreen({super.key, required this.character});

  Future<void> _launchAdultSwimUrl() async {
    final Uri url = Uri.parse('https://gorickyourself.com/');
    if (!await launchUrl(url)){
      throw Exception('pistoportail en panne $url');
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Image.network(character.image, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text(
              character.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                character.description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _launchAdultSwimUrl,
              icon: const Icon(Icons.tv),
              label: const Text('Voir sur Adult Swim'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}