import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/models/event.dart';

class TestScreen extends StatelessWidget {
  final EventController eventController = Get.put(EventController());

  TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Details'),
      ),
      body: Obx(() {
        if (eventController.eventsList.value.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: eventController.eventsList.value.length,
          itemBuilder: (context, index) {
            Event event = eventController.eventsList.value[index];
            return Card(
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Event ID: ${event.idEvent}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sport Name: ${event.sportName ?? "Not available"}'),
                    Text(
                        'Skill Level: ${event.skillLevelName ?? "Not available"}'),
                    Text(
                        'Location Name: ${event.locationName ?? "Not available"}'),
                    Text(
                        'Start Time: ${event.startTime?.toIso8601String() ?? "Not specified"}'),
                  ],
                ),
                isThreeLine: true,
                trailing: event.isFinished
                    ? Icon(Icons.check_circle, color: Colors.green)
                    : Icon(Icons.hourglass_empty, color: Colors.red),
              ),
            );
          },
        );
      }),
    );
  }
}
