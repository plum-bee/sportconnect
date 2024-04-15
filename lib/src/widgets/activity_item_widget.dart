import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/pages/event_info_screen.dart';

class ActivityItemWidget extends StatelessWidget {
  final UserEvent userEvent;

  ActivityItemWidget({Key? key, required this.userEvent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Event event = userEvent.event;
    Widget sportIcon =
        SportIconGetter.getSportIcon(event.sportName ?? 'Unknown');
    String formattedStartTime = event.startTime != null
        ? DateFormat('kk:mm \'on\' EEEE d, MMM, yyyy').format(event.startTime!)
        : 'Date and time not set';
    String registrationStatus = event.isRegistrationOpen ? "Open" : "Closed";
    String participationStatus =
        userEvent.participated ? "Participated" : "Not Participated";

    const TextStyle titleStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
    const TextStyle detailStyle = TextStyle(fontSize: 16, color: Colors.white);
    const TextStyle statusStyle = TextStyle(
        fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold);

    Decoration containerDecoration = BoxDecoration(
      color: const Color(0xFF1D1E33),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );

    return GestureDetector(
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
                  Text('Skill Level: ${event.skillLevelName ?? 'Not set'}',
                      style: detailStyle),
                  const SizedBox(height: 8.0),
                  Text('Registration: $registrationStatus',
                      style: statusStyle.apply(
                        color: event.isRegistrationOpen
                            ? Colors.green
                            : Colors.red,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(participationStatus,
                        style: TextStyle(
                            color: userEvent.participated
                                ? Colors.green
                                : Colors.red,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
