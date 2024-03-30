import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/widgets/event_item_widget.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';

class ActivityScreen extends StatelessWidget {
  ActivityScreen({Key? key}) : super(key: key);

  final EventController eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Activities'),
      ),
      body: Obx(() {
        if (eventController.userEventsList.value.isEmpty) {
          return Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            itemCount: eventController.userEventsList.value.length,
            itemBuilder: (context, index) {
              final userEvent = eventController.userEventsList.value[index];
              return EventItemWidget(event: userEvent.event);
            },
          );
        }
      }),
    );
  }
}
