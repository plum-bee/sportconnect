import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);

  final MemberController memberController = Get.put(MemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Obx(() {
        if (memberController.currentUser.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          final member = memberController.currentUser.value!;
          return ListView(
            children: [
              ListTile(
                title: Text('Name'),
                subtitle: Text('${member.name} ${member.surname}'),
              ),
              ListTile(
                title: Text('Email'),
                subtitle: Text(member.email),
              ),
              ListTile(
                title: Text('Sports and Skill Levels'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: member.userSportsSkills
                      .map((e) => Text('${e.sport.name}: ${e.skillLevel.name}'))
                      .toList(),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}
