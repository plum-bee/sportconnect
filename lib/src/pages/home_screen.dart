import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/widgets/event_item_widget.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final EventController eventController = Get.put(EventController());

  Future<void> _refreshData() async {
    await eventController.fetchEvents(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Obx(() {
          if (eventController.upcomingEventsList.value.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: eventController.upcomingEventsList.value.length,
              itemBuilder: (context, index) {
                final event = eventController.upcomingEventsList.value[index];
                return EventItemWidget(event: event);
              },
            );
          }
        }),
      ),
    );
  }
}
