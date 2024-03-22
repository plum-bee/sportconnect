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
        title: const Text('Events List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (eventController.eventsList.value.isEmpty) { 
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: eventController.eventsList.value.length,
                  itemBuilder: (context, index) {
                    Event event = eventController.eventsList.value[index]; 
                    return ListTile(
                      subtitle: Text('ID: ${event.idEvent}'), 
                      title: Text(event.sport.name),
                      onTap: () {
                        eventController.fetchEventById(event.idEvent); 
                      },
                    );
                  },
                );
              }
            }),
          ),
          Obx(() {
            return Text(
              'Selected Event: ${eventController.currentEvent.value?.idEvent ?? "None"}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }),
          ElevatedButton(
            onPressed: () {
              int someEventId = 1; 
              eventController.fetchEventById(someEventId);
            },
            child: const Text('Fetch Event with ID 1'),
          ),
        ],
      ),
    );
  }
}
