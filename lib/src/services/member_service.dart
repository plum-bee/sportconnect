import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/main.dart';

class MemberService {
  final String _tableName = 'users';

  Future<Member> getMember(String userId) async {
    final response =
        await supabase.from(_tableName).select().eq('id_user', userId).single();

    return Member.fromMap(response);
  }
}
