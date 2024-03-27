import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/widgets/event_item_widget.dart'; // Update this import based on your file structure
import 'package:sportconnect/src/controllers/event_controller.dart'; // Update this import based on your file structure

class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Events List'),
        ),
        body: Obx(() {
          if (eventController.eventsList.value.isEmpty) {
            return Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: eventController.eventsList.value.length,
              itemBuilder: (context, index) {
                final event = eventController.eventsList.value[index];
                return EventItemWidget(event: event);
              },
            );
          }
        }));
  }
}
