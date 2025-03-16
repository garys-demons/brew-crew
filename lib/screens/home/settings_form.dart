import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugars = ['0', '1', '2', '3', '4'];

  // Form values
  String? _currentName;
  String? _currentSugars;
  int? _currentStrength;

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User1>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;

          _currentName ??= userData?.name;
          _currentSugars ??= userData?.sugars;
          _currentStrength ??= userData?.strength;

          return Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Update your brew settings',
                  style: TextStyle(fontSize: 18.0),
                ),
                const SizedBox(height: 20.0),
                // Name input
                TextFormField(
                  initialValue: _currentName,
                  decoration: textInputDecoration,
                  validator: (val) =>
                      val!.isEmpty ? 'Please enter a name' : null,
                  onChanged: (val) => setState(() {
                    _currentName = val;
                  }),
                ),
                const SizedBox(height: 20.0),
                // Dropdown for sugars
                DropdownButtonFormField(
                  decoration: textInputDecoration,
                  value: _currentSugars,
                  items: sugars.map((sugar) {
                    return DropdownMenuItem(
                      value: sugar,
                      child: Text("$sugar sugars"),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() {
                    _currentSugars = val as String;
                  }),
                ),
                // Slider for strength
                Slider(
                  value: (_currentStrength ?? 100).toDouble(),
                  onChanged: (val) => setState(() {
                    _currentStrength = val.round();
                  }),
                  activeColor: Colors.brown[
                      _currentStrength ?? 100],
                  inactiveColor: Colors.brown[
                      _currentStrength ?? 100],
                  min: 100,
                  max: 900,
                  divisions: 8,
                ),
                // Update button
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                        _currentSugars ?? userData?.sugars ?? '0',
                        _currentName ?? userData?.name ?? 'New crew member',
                        _currentStrength ?? userData?.strength ?? 100,
                      );
                      // ignore: use_build_context_synchronously
                      if (mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Loading();
        }
      },
    );
  }
}