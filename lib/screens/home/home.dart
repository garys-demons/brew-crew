import 'package:brew_crew/screens/home/settings_form.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:provider/provider.dart';
import 'package:brew_crew/screens/home/brew_list.dart';
import 'package:brew_crew/models/brew.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {

    void _showSettingsPanel() {
      showModalBottomSheet(context: context, builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: const Settings(),
        );
      });
    }

    return StreamProvider<List<Brew>>.value(
      value: DatabaseService().brews,
      initialData: const [],
      child: Scaffold(
        backgroundColor: Colors.brown[100],
        appBar: AppBar(
          title: const Text('Brew Crew'),
          backgroundColor: const Color.fromARGB(255, 95, 66, 55),
          elevation: 0.0,
          actions: [
            TextButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              label: const Text(
                'logout',
                style: TextStyle(
                  color: Colors.black
                ),
                ),
              icon: const Icon(Icons.person, color: Colors.black,),
              ),
              TextButton.icon(
                onPressed: () => _showSettingsPanel(), 
                label: const Text(''),
                icon: const Icon(Icons.settings, color: Colors.black,),)
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/coffee_wallpaper.jpeg'),
              fit: BoxFit.cover
              )
          ),
          child: const BrewList()
          ),
      ),
    );
  }
}