import 'package:flutter/material.dart';
import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/models/skill_level.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';

class SkillLevelScreen extends StatefulWidget {
  const SkillLevelScreen({super.key});

  @override
  _SkillLevelScreenState createState() => _SkillLevelScreenState();
}

class _SkillLevelScreenState extends State<SkillLevelScreen> {
  List<Map<String, dynamic>> selectedSports = [];
  List<Sport> sports = [];
  List<SkillLevel> skillLevels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      await Future.wait([
        _loadSports(),
        _loadSkillLevels(),
      ]);
      await _preloadUserSportsAndSkills();
    } catch (e) {
      _showErrorDialog('Failed to load data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadSports() async {
    final sportService = SportService();
    sports = await sportService.getAllSports();
  }

  Future<void> _loadSkillLevels() async {
    final skillLevelService = SkillLevelService();
    skillLevels = await skillLevelService.getAllSkillLevels();
  }

  Future<void> _preloadUserSportsAndSkills() async {
    final MemberController memberController = Get.find<MemberController>();
    memberController.fetchCurrentUser();
    Member? currentUser = memberController.currentUser.value;
    if (currentUser != null) {
      selectedSports = currentUser.userSportsSkills.map((userSportSkill) {
        return {
          'id': userSportSkill.sport.idSport,
          'name': userSportSkill.sport.name,
          'skillLevelId': userSportSkill.skillLevel.idSkillLevel,
        };
      }).toList();
    }
  }

  void _onFinish() async {
    final String userId = Get.find<MemberController>().currentUser.value!.id;
    final entries = selectedSports.map((sport) {
      return {
        'id_user': userId,
        'id_sport': sport['id'],
        'id_skill_level': sport['skillLevelId']
      };
    }).toList();

    try {
      await supabase.from('user_sport_skill_level').upsert(entries);
      Navigator.pop(context);
    } catch (e) {
      _showErrorDialog('Failed to update sports data: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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
              itemBuilder: (context, index) =>
                  _buildSportContainer(selectedSports[index]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  onPressed: _showSportsDialog,
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: _onFinish,
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
        color: Colors.grey[300],
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
              DropdownButton<String>(
                value: sport['skillLevelId'].toString(),
                onChanged: (value) {
                  setState(() {
                    sport['skillLevelId'] = int.parse(value!);
                  });
                },
                items: skillLevels
                    .map<DropdownMenuItem<String>>((SkillLevel skillLevel) {
                  return DropdownMenuItem<String>(
                    value: skillLevel.idSkillLevel.toString(),
                    child: Text(skillLevel.name),
                  );
                }).toList(),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: () => setState(() {
              selectedSports.remove(sport);
            }),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _showSportsDialog() async {
    final Sport? selectedSport = await showDialog<Sport>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Sport'),
          children: sports.map((Sport sport) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(context, sport),
              child: Text(sport.name),
            );
          }).toList(),
        );
      },
    );

    if (selectedSport != null) {
      bool alreadySelected = selectedSports.any(
          (Map<String, dynamic> sport) => sport['id'] == selectedSport.idSport);
      if (!alreadySelected) {
        setState(() {
          selectedSports.add({
            'id': selectedSport.idSport,
            'name': selectedSport.name,
            'skillLevelId': skillLevels.first.idSkillLevel
          } as Map<String, dynamic>);
        });
      } else {
        _showErrorDialog('This sport has already been selected.');
      }
    }
  }
}
