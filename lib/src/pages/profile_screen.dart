import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final MemberController memberController = Get.put(MemberController());

  Future<void> _logout(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    Navigator.of(context).pushReplacementNamed('/search');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Obx(() {
        Member? currentUser = memberController.currentUser.value;
        if (currentUser == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(currentUser.getAvatarUrl()),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 20),
                Text('${currentUser.name} ${currentUser.surname}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text(currentUser.email,
                    style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 20),
                const Divider(),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Sports Skills:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                ...currentUser.userSportsSkills
                    .map((skill) => ListTile(
                          title: Text(skill.sport.name),
                          trailing: Text(skill.skillLevel.name),
                        ))
                    .toList(),
              ],
            ),
          );
        }
      }),
    );
  }
}
