import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/sport.dart';

class SportService {
  final String  _tableName = 'sports';

  Future<void> saveUserSports(List<Map<String, dynamic>> selectedSports) async {
    String? userId = supabase.auth.currentUser?.id;
    if (userId == null) throw Exception("User not logged in");

    for (var sport in selectedSports) {
      var sportId = await _getSportIdByName(sport['name']);
      if (sportId == null) continue;  

      var response = await supabase
        .from('user_sport_skill_level')
        .select()
        .match({'user_id': userId, 'sport_id': sportId});

      if (response.data.isEmpty) {
        // Insert new record
        await supabase.from('user_sport_skill_level').insert({
          'user_id': userId,
          'sport_id': sportId,
          'skill_level': sport['skillLevel']
        });
      } else {
        // Update existing record
        await supabase.from('user_sport_skill_level').update({
          'skill_level': sport['skillLevel']
        }).match({'user_id': userId, 'sport_id': sportId});
      }
    }
  }

  Future<List<String>> getAllSportNames() async {
    final sportsResponse =
        await supabase.from(_tableName).select('name');

    final dataList = sportsResponse.data as List<dynamic>;
    return dataList.map((sport) => sport['name'] as String).toList();
  }

  Future<Sport> getSportById(int sportId) async {
    final sportResponse = await supabase
        .from(_tableName)
        .select()
        .eq('id_sport', sportId)
        .single();

    return Sport.fromMap(sportResponse);
  }

    Future<int?> _getSportIdByName(String name) async {
    var response = await supabase
      .from('sports')
      .select('id_sport')
      .eq('name', name)
      .single();
    return response.data['id'];
  }

  Future<List<Sport>> getAllSports() async {
    final sportsResponse = await supabase.from(_tableName).select().execute();

    final dataList = sportsResponse.data as List<dynamic>;
    return dataList.map((sport) => Sport.fromMap(sport)).toList();
  }

   Future<List<Map<String, dynamic>>> getUserSportsAndSkills(String userId) async {
    final response = await supabase
      .from('user_sport_skill_level')
      .select('id_sport, sports: id_sport (name), id_skill_level, skill_level: id_skill_level (name)')
      .eq('id_user', userId);

    return List<Map<String, dynamic>>.from(response.data.map((x) => {
      'name': x['sports']['name'],
      'skillLevel': x['skill_level']['name'],
    }));
  }
}

