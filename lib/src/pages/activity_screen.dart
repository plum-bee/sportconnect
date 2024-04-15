import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/widgets/activity_item_widget.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/pages/event_creation_screen.dart'; // Ensure you have this import for your EventCreationPage

class ActivityScreen extends StatelessWidget {
  ActivityScreen({Key? key}) : super(key: key);

  final EventController eventController = Get.find<EventController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (eventController.userEventsList.value.isEmpty) {
          return Center(child: CircularProgressIndicator());
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EventCreationPage(),
          ));
        },
        child: Icon(Icons.add),
        tooltip: 'Create Event',
      ),
    );
  }
}
