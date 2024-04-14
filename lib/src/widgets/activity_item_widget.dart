import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';

class ActivityItemWidget extends StatelessWidget {
  final UserEvent userEvent;

  const ActivityItemWidget({super.key, required this.userEvent});

  @override
  Widget build(BuildContext context) {
    Event event = userEvent.event;
    Widget sportIcon =
        SportIconGetter.getSportIcon(event.sportName ?? 'Unknown');
    String formattedStartTime = event.startTime != null
        ? DateFormat('EEE, MMM d, yyyy').format(event.startTime!)
        : 'Date not set';
    String registrationStatus =
        event.isRegistrationOpen ? "Registration Open" : "Registration Closed";
    String participationStatus =
        userEvent.participated ? "Participated" : "Not Participated";

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
          offset: const Offset(0, 3),
        ),
      ],
    );

    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: containerDecoration,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to the start
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: sportIcon,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(event.sportName ?? 'Sport Name',
                    style:
                        const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
                Text(formattedStartTime,
                    style: TextStyle(color: Colors.grey.shade600)),
                const SizedBox(height: 8.0),
                Text(event.location?.name ?? 'Location not set',
                    style: const TextStyle(fontSize: 16.0)),
                const SizedBox(height: 4.0),
                Text(event.location?.address ?? '',
                    style:
                        TextStyle(fontSize: 14.0, color: Colors.grey.shade600)),
                const SizedBox(height: 8.0),
                Text(event.skillLevelName ?? 'Skill Level',
                    style: const TextStyle(fontSize: 14.0)),
                const SizedBox(height: 8.0),
                Text(registrationStatus,
                    style: TextStyle(
                        fontSize: 14.0,
                        color: event.isRegistrationOpen
                            ? Colors.green
                            : Colors.red)),
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
    );
  }
}
