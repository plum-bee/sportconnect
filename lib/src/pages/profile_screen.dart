import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/widgets/avatar_widget.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/pages/skill_level_screen.dart';
import 'package:sportconnect/main.dart';

const Color mainColor = Color(0xFF1AC077);
const Color detailColor = Colors.white70;
const Color backgroundColor = Color(0xFF1D1E33);
const Color buttonColor = Color(0xFF4CAF50);

const TextStyle titleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: mainColor,
);

const TextStyle detailStyle = TextStyle(
  fontSize: 16,
  color: detailColor,
);

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final MemberController memberController = Get.put(MemberController());

  Future<void> _refreshUserProfile() async {
    memberController.fetchCurrentUser();
  }

  Future<void> _onUpload(String imageUrl) async {
    final Member? currentUser = memberController.currentUser.value;
    if (currentUser != null) {
      await supabase.from('members').upsert({
        'id_user': currentUser.id,
        'avatar_url': imageUrl,
      });
    }
    _refreshUserProfile();
  }

  Widget _userInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: mainColor),
          const SizedBox(width: 10),
          Text('$title: $value', style: detailStyle),
        ],
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      overlayColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Obx(() {
        Member? currentUser = memberController.currentUser.value;
        if (currentUser == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Failed to load user data. Please try again.',
                    style: detailStyle),
                ElevatedButton(
                  onPressed: _refreshUserProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else {
          return RefreshIndicator(
            onRefresh: _refreshUserProfile,
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Avatar(
                        imageUrl: currentUser.getAvatarUrl(),
                        onUpload: _onUpload),
                    const SizedBox(height: 20),
                    Text('${currentUser.name} ${currentUser.surname}',
                        style: titleStyle),
                    Text(currentUser.email, style: detailStyle),
                    const SizedBox(height: 20),
                    _userInfoRow(
                        "Member since",
                        DateFormat('yyyy-MM-dd')
                            .format(currentUser.createdAt ?? DateTime.now()),
                        Icons.calendar_today),
                    ...currentUser.userSportsSkills.map((skill) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SportIconGetter.getSportIcon(skill.sport.name),
                              const SizedBox(width: 10),
                              Text(
                                  '${skill.sport.name}: ${skill.skillLevel.name}',
                                  style: detailStyle),
                            ],
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SkillLevelScreen(),
                            ),
                          );
                        },
                        child: const Text('Edit Sports'),
                        style: buttonStyle(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
