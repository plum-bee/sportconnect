import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/member_controller.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final MemberController memberController = Get.put(MemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Member Service'),
      ),
      body: Obx(() {
        if (memberController.currentUser.value == null) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListTile(
            leading: memberController.currentUser.value!.avatarUrl != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(
                      memberController.currentUser.value!.getAvatarUrl(),
                    ),
                  )
                : CircleAvatar(
                    child: Icon(Icons.person),
                  ),
            title: Text(memberController.currentUser.value!.name),
            subtitle: Text(memberController.currentUser.value!.email),
          );
        }
      }),
    );
  }
}
