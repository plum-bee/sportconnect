// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/services/sport_service.dart';

class SkillLevelScreen extends StatefulWidget {
  const SkillLevelScreen({super.key});

  @override
  _SkillLevelScreenState createState() => _SkillLevelScreenState();
}

class _SkillLevelScreenState extends State<SkillLevelScreen> {
  List<Map<String, dynamic>> selectedSports = [];
  List<String> sportNames = [];

  @override
  void initState() {
    super.initState();
    _loadSportNames();
  }

  Future<void> _loadSportNames() async {
    final sportService = SportService();
    sportNames = await sportService.getAllSportNames();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skill Level'),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedSports.length,
              itemBuilder: (context, index) {
                return _buildSportContainer(selectedSports[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _showSportsDialog();
                  },
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  child: const Text('Finish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportContainer(Map<String, dynamic> sport) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(),
        color: const Color.fromARGB(255, 132, 131, 131),
      ),
      child: Row(
        children: [
          SportIconGetter.getSportIcon(sport['name']),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sport['name'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value: sport['skillLevel'],
                onChanged: (value) {
                  setState(() {
                    sport['skillLevel'] = value!;
                  });
                },
                items: <String>['Beginner', 'Amateur', 'Pro']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                selectedSports.remove(sport);
              });
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _showSportsDialog() async {
    final selectedSport = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Sport'),
          children: sportNames.map((sport) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, sport);
              },
              child: Text(sport),
            );
          }).toList(),
        );
      },
    );

    if (selectedSport != null) {
      bool alreadySelected =
          selectedSports.any((sport) => sport['name'] == selectedSport);

      if (!alreadySelected) {
        setState(() {
          selectedSports.add({'name': selectedSport, 'skillLevel': 'Beginner'});
        });
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Este deporte ya ha sido seleccionado.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
