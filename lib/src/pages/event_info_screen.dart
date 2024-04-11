import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/widgets/media_widget.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';

class EventInfoScreen extends StatelessWidget {
  final int eventId;
  EventInfoScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    const Color primaryColor = Color(0xFF0A0E21);
    const Color secondaryColor = Color(0xFF1D1E33);
    const Color accentColor = Color(0xFFEB1555);

    TextStyle titleStyle = TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: accentColor);
    TextStyle subtitleStyle = TextStyle(fontSize: 16, color: Colors.white);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Obx(() {
          Event? event = eventController.eventsList.value
              .firstWhereOrNull((e) => e.idEvent == eventId);
          if (event != null) {
            eventController.initializeParticipationStatus(eventId);
            return Text(
                '${event.location?.name ?? 'Location'} - ${event.sportName ?? 'Sport'}',
                style: TextStyle(color: accentColor));
          }
          return const Text('Event Details',
              style: TextStyle(color: Colors.white));
        }),
        actions: <Widget>[
          Obx(() {
            bool isParticipant =
                eventController.isCurrentUserParticipating.value;
            return TextButton(
              onPressed: () async {
                if (isParticipant) {
                  await eventController.leaveEvent(eventId);
                } else {
                  await eventController.joinEvent(eventId);
                }
              },
              child: Text(
                isParticipant ? 'Leave' : 'Join',
                style: TextStyle(color: Colors.white),
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        Event? event = eventController.eventsList.value
            .firstWhereOrNull((e) => e.idEvent == eventId);

        if (event == null) {
          return Center(child: Text('Event not found.', style: subtitleStyle));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  color: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text('Sport', style: titleStyle),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SportIconGetter.getSportIcon(event.sportName ?? ''),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('${event.sportName ?? 'N/A'}',
                                style: subtitleStyle),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ..._buildEventDetailsList(
                    event, titleStyle, subtitleStyle, context),
                if (event.media?.isNotEmpty == true)
                  MediaWidget(
                    mediaList: event.media!,
                    eventId: event.idEvent,
                    refreshEventInfo: () => eventController.refreshEventInfo(),
                  )
                else
                  MediaWidget(
                    mediaList: event.media!,
                    eventId: event.idEvent,
                    refreshEventInfo: () => eventController.refreshEventInfo(),
                  )
              ],
            ),
          ),
        );
      }),
    );
  }

  List<Widget> _buildEventDetailsList(Event event, TextStyle titleStyle,
      TextStyle subtitleStyle, BuildContext context) {
    List<Widget> detailsList = [];

    var details = {
      'Skill Level': event.skillLevelName ?? 'N/A',
      'Location': event.location?.name ?? 'N/A',
      'Start Time': event.startTime != null
          ? DateFormat('yyyy-MM-dd - kk:mm').format(event.startTime!.toLocal())
          : 'N/A',
      'Registration Open': event.isRegistrationOpen ? 'Yes' : 'No',
    };

    details.forEach((title, value) {
      detailsList.add(
        Card(
          color: Color(0xFF1D1E33),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(title, style: titleStyle),
            subtitle: Text(value, style: subtitleStyle),
          ),
        ),
      );
    });

    detailsList.add(
      Card(
        color: Color(0xFF1D1E33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text('Participants', style: titleStyle),
          subtitle: event.participants?.isEmpty ?? true
              ? Text('No participants', style: subtitleStyle)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: event.participants!
                      .map((participant) => Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey.shade800,
                                backgroundImage: participant.avatarUrl !=
                                            null &&
                                        participant.avatarUrl!.isNotEmpty
                                    ? NetworkImage(participant.getAvatarUrl())
                                    : null,
                                child: participant.avatarUrl == null ||
                                        participant.avatarUrl!.isEmpty
                                    ? Icon(Icons.person,
                                        size: 20, color: Colors.white)
                                    : null,
                              ),
                              SizedBox(width: 8),
                              Text('${participant.name} ${participant.surname}',
                                  style: subtitleStyle),
                            ],
                          ))
                      .toList(),
                ),
        ),
      ),
    );

    return detailsList;
  }
}
