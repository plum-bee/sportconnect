import 'package:get/get.dart';
import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/services/member_service.dart';

class MemberController extends GetxController {
  final MemberService memberService = MemberService();
  final Rx<Member?> currentUser = Rx<Member?>(null);
  final String userId = supabase.auth.currentSession!.user.id;
  //final String userId = 'c7b8b038-399d-4839-be2c-acbe09a041fe';

  @override
  void onInit() {
    super.onInit();
    fetchCurrentUser();
  }

  void fetchCurrentUser() async {
    Member member = await memberService.getMemberById(userId);
    currentUser.value = member;
  }
}
