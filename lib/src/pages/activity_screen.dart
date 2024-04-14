import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/widgets/activity_item_widget.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final EventController eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (eventController.userEventsList.value.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: eventController.userEventsList.value.length,
            itemBuilder: (context, index) {
              final userEvent = eventController.userEventsList.value[index];
              return ActivityItemWidget(userEvent: userEvent);
            },
          );
        }
      }),
    );
  }
}
