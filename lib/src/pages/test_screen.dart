import 'package:flutter/material.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/services/sport_service.dart';

class TestLevelScreen extends StatefulWidget {
  const TestLevelScreen({Key? key}) : super(key: key);

  @override
  _TestLevelScreenState createState() => _TestLevelScreenState();
}

class _TestLevelScreenState extends State<TestLevelScreen> {
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
            child: FloatingActionButton(
              onPressed: () {
                _showSportsDialog();
              },
              child: const Icon(Icons.add),
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
      setState(() {
        selectedSports.add({'name': selectedSport, 'skillLevel': 'Beginner'});
      });
    }
  }
}
