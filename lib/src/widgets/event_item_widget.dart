import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:get/get.dart'; // Import GetX if you're using it for navigation
import 'package:sportconnect/src/pages/event_info_screen.dart'; // Import your EventInfoScreen

class EventItemWidget extends StatelessWidget {
  final Event event;

  EventItemWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget sportIcon =
        SportIconGetter.getSportIcon(event.sportName ?? 'Unknown');
    String formattedStartTime = event.startTime != null
        ? DateFormat('EEE, MMM d, yyyy').format(event.startTime!)
        : 'Date not set';

    String registrationStatus =
        event.isRegistrationOpen ? "Registration Open" : "Registration Closed";

    Decoration containerDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.white, Colors.grey.shade200],
      ),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 6,
          offset: Offset(0, 3),
        ),
      ],
    );

    return GestureDetector(
      onTap: () {
        Get.to(() => EventInfoScreen(eventId: event.idEvent));
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(16.0),
        decoration: containerDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: sportIcon,
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.sportName ?? 'Sport Name',
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.0),
                  Text(formattedStartTime,
                      style: TextStyle(color: Colors.grey.shade600)),
                  SizedBox(height: 8.0),
                  Text(event.location?.name ?? 'Location not set',
                      style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 4.0),
                  Text(event.location?.address ?? '',
                      style: TextStyle(
                          fontSize: 14.0, color: Colors.grey.shade600)),
                  SizedBox(height: 8.0),
                  Text(event.skillLevelName ?? 'Skill Level',
                      style: TextStyle(fontSize: 14.0)),
                  SizedBox(height: 8.0),
                  Text(registrationStatus,
                      style: TextStyle(
                          fontSize: 14.0,
                          color: event.isRegistrationOpen
                              ? Colors.green
                              : Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
