import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/skill_level.dart';

class SkillLevelService {
  final String _tableName = 'skill_levels';

  Future<SkillLevel> getSkillLevelById(int skillLevelId) async {
    final skillLevelResponse = await supabase
        .from(_tableName)
        .select()
        .eq('id_skill_level', skillLevelId)
        .single();

    return SkillLevel.fromMap(skillLevelResponse);
  }

  Future<List<SkillLevel>> getAllSkillLevels() async {
    final skillLevelsResponse = await supabase.from(_tableName).select();

    final dataList = skillLevelsResponse as List<dynamic>;
    return dataList.map((skillLevel) => SkillLevel.fromMap(skillLevel)).toList();
  }
}
