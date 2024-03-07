import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';
import 'package:sportconnect/src/models/member.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  final MemberController memberController = Get.put(MemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
      ),
      body: Obx(() {
        Member? currentUser = memberController.currentUser.value;
        if (currentUser == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(currentUser.getAvatarUrl()),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(height: 20),
                Text('${currentUser.name} ${currentUser.surname}',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(currentUser.email,
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
                SizedBox(height: 20),
                Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
