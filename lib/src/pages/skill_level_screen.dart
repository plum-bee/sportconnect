import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/models/skill_level.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/main.dart';

class SkillLevelScreen extends StatefulWidget {
  const SkillLevelScreen({super.key});

  @override
  _SkillLevelScreenState createState() => _SkillLevelScreenState();
}

class _SkillLevelScreenState extends State<SkillLevelScreen> {
  List<Map<String, dynamic>> selectedSports = [];
  List<Sport> sports = [];
  List<SkillLevel> skillLevels = [];
  List<int> deletedSportIds = [];
  bool isLoading = true;

  final Color primaryColor = const Color(0xFF145D55);
  final Color accentColor = const Color(0xFF9FBEB9);
  final TextStyle titleStyle = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
  final TextStyle subtitleStyle =
      const TextStyle(fontSize: 16, color: Colors.white);

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
    try {
      for (var sportId in deletedSportIds) {
        await supabase
            .from('user_sport_skill_level')
            .delete()
            .match({'id_user': userId, 'id_sport': sportId});
      }
      for (var sport in selectedSports) {
        await supabase
            .from('user_sport_skill_level')
            .delete()
            .match({'id_user': userId, 'id_sport': sport['id']});
        await supabase.from('user_sport_skill_level').insert({
          'id_user': userId,
          'id_sport': sport['id'],
          'id_skill_level': sport['skillLevelId']
        });
      }
      Get.find<MemberController>().fetchCurrentUser();
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
        backgroundColor: primaryColor,
        title: const Text('Skill Level', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: selectedSports.length,
              itemBuilder: (context, index) =>
                  _buildSportContainer(selectedSports[index]),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FloatingActionButton(
                  backgroundColor: accentColor,
                  onPressed: _showSportsDialog,
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _onFinish,
                  child: const Text('Update'),
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
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: const Color(0xFF1D1E33),
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: primaryColor)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: SportIconGetter.getSportIcon(sport['name']),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sport['name'], style: titleStyle),
                DropdownButton<String>(
                  value: sport['skillLevelId'].toString(),
                  onChanged: (value) {
                    int newValue = int.parse(value!);
                    setState(() {
                      int index = selectedSports
                          .indexWhere((s) => s['id'] == sport['id']);
                      if (index != -1) {
                        selectedSports[index]['skillLevelId'] = newValue;
                      }
                    });
                  },
                  items: skillLevels
                      .map<DropdownMenuItem<String>>((SkillLevel skillLevel) {
                    return DropdownMenuItem<String>(
                      value: skillLevel.idSkillLevel.toString(),
                      child: Text(skillLevel.name, style: subtitleStyle),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                deletedSportIds.add(sport['id']);
                selectedSports.removeWhere((s) => s['id'] == sport['id']);
              });
            },
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
