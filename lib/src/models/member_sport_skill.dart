import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/models/skill_level.dart';

class UserSportSkill {
  final Sport sport;
  final SkillLevel skillLevel;

  UserSportSkill({required this.sport, required this.skillLevel});

  factory UserSportSkill.fromMap(Map<String, dynamic> map) {
    return UserSportSkill(
      sport: Sport.fromMap(map['sport']),
      skillLevel: SkillLevel.fromMap(map['skill_level']),
    );
  }
}
