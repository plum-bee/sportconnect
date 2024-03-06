import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/models/user_sport_skill.dart';

class MemberService {
  final String _tableName = 'users';

  Future<Member> getMemberById(String userId) async {
    final userResponse =
        await supabase.from(_tableName).select().eq('id_user', userId).single();

    final sportsSkillsResponse = await supabase
        .from('user_sport_skill_level')
        .select('sport: id_sport (*), skill_level: id_skill_level (*)')
        .eq('id_user', userId);

    final userSportsSkills = sportsSkillsResponse
        .map<UserSportSkill>((e) => UserSportSkill.fromMap(e))
        .toList();

    return Member.fromMap(userResponse, userSportsSkills);
  }
}
