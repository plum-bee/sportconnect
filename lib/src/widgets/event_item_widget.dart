import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/pages/event_info_screen.dart';

class EventItemWidget extends StatelessWidget {
  final Event event;

  EventItemWidget({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget sportIcon =
        SportIconGetter.getSportIcon(event.sportName ?? 'Unknown');
    String formattedStartTime = event.startTime != null
        ? DateFormat('MMM d - yyyy, kk:mm').format(event.startTime!)
        : 'Date and time not set';

    String registrationStatus = event.isRegistrationOpen ? "Open" : "Closed";

    const TextStyle titleStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
    const TextStyle detailStyle =
        TextStyle(fontSize: 16, color: Colors.white70);
    TextStyle registrationStyle = TextStyle(
        fontSize: 14,
        color: event.isRegistrationOpen ? Colors.green : Color(0xFFC62828),
        fontWeight: FontWeight.bold);

    Decoration containerDecoration = BoxDecoration(
        color: const Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ]);

    return InkWell(
      onTap: () => Get.to(() => EventInfoScreen(eventId: event.idEvent)),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: containerDecoration,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey.shade800,
              radius: 24,
              child: sportIcon,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Sport: ${event.sportName ?? 'Unknown'}',
                      style: titleStyle),
                  const SizedBox(height: 4.0),
                  Text('Starts: $formattedStartTime', style: detailStyle),
                  const SizedBox(height: 8.0),
                  Text('Location: ${event.location?.name ?? 'Not specified'}',
                      style: detailStyle),
                  const SizedBox(height: 4.0),
                  Text('Address: ${event.location?.address ?? 'Not available'}',
                      style: detailStyle),
                  const SizedBox(height: 8.0),
                  Text('Skill level: ${event.skillLevelName ?? 'Not set'}',
                      style: detailStyle),
                  const SizedBox(height: 8.0),
                  Text('Registration: $registrationStatus',
                      style: registrationStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
