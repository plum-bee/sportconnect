import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';

class ActivityItemWidget extends StatelessWidget {
  final UserEvent userEvent;

  ActivityItemWidget({Key? key, required this.userEvent}) : super(key: key);

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
          offset: Offset(0, 3),
        ),
      ],
    );

    return Container(
      margin: EdgeInsets.all(8.0),
      padding: EdgeInsets.all(16.0),
      decoration: containerDecoration,
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Align items to the start
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: sportIcon,
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Align text to the start
              children: [
                Text(event.sportName ?? 'Sport Name',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.0),
                Text(formattedStartTime,
                    style: TextStyle(color: Colors.grey.shade600)),
                SizedBox(height: 8.0),
                Text(event.location?.name ?? 'Location not set',
                    style: TextStyle(fontSize: 16.0)),
                SizedBox(height: 4.0),
                Text(event.location?.address ?? '',
                    style:
                        TextStyle(fontSize: 14.0, color: Colors.grey.shade600)),
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
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
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
