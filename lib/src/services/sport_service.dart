import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/sport.dart';

class SportService {
  final String _tableName = 'sports';

  Future<List<String>> getAllSportNames() async {
    final sportsResponse = await supabase.from(_tableName).select('name');

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

  Future<List<Sport>> getAllSports() async {
    final sportsResponse = await supabase.from(_tableName).select();

    final dataList = sportsResponse as List<dynamic>;
    return dataList.map((sport) => Sport.fromMap(sport)).toList();
  }
}
