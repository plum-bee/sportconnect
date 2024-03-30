import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/widgets/avatar_widget.dart';
import 'package:intl/intl.dart';
import 'package:sportconnect/main.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);

  final MemberController memberController = Get.put(MemberController());

  Future<void> _refreshUserProfile() async {
    memberController.fetchCurrentUser();
  }

  Future<void> _onUpload(String imageUrl) async {
    final Member? currentUser = memberController.currentUser.value;
    if (currentUser != null) {
      await supabase
          .from('members')
          .upsert({'id_user': currentUser.id, 'avatar_url': imageUrl});
    }
    _refreshUserProfile();
  }

  Widget _userInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text('$title:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Flexible(child: Text(value)),
        ],
      ),
    );
  }

  IconData _getSportIcon(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'paddle':
        return Icons.sports_tennis;
      case 'table tennis':
        return Icons.sports_baseball;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        Member? currentUser = memberController.currentUser.value;
        if (currentUser == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Failed to load user data. Please try again.'),
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
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Avatar(
                    imageUrl: currentUser.getAvatarUrl(),
                    onUpload: _onUpload,
                  ),
                  const SizedBox(height: 20),
                  Text('${currentUser.name} ${currentUser.surname}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(currentUser.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 20),
                  _userInfoRow(
                      "Member since",
                      DateFormat('yyyy-MM-dd')
                          .format(currentUser.createdAt ?? DateTime.now()),
                      Icons.calendar_today),
                  ...currentUser.userSportsSkills.map((skill) => ListTile(
                        leading: Icon(
                          _getSportIcon(skill.sport.name),
                          color: Colors.deepOrange,
                        ),
                        title: Text(skill.sport.name),
                        subtitle: Text('Skill Level: ${skill.skillLevel.name}'),
                      )),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
