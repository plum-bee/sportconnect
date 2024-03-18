import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);

  final EventController eventController = Get.put(EventController());

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    title: const Text('Test Screen'),
  ),
  body: GetX<EventController>(
    builder: (controller) {
      if (eventController.eventsList.value == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return ListView(
          children: [
            for (var index = 0; index < controller.eventsList.value.length; index++) ...[
              ListTile(
                title: Text('Event ID: ${controller.eventsList.value[index].id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sport: ${controller.eventsList.value[index].sport.name}'),
                    Text('Location: ${controller.eventsList.value[index].location.name}'),
                    Text('Date: ${controller.eventsList.value[index].date.toString()}'),
                    Text('Description: ${controller.eventsList.value[index].description}'),
                  ],
                ),
              ),
            ],
          ],
        );
      }
    },
  ),
);

  }
}
