import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/widgets/media_widget.dart';
import 'package:sportconnect/src/utils/sport_icon_getter.dart';
import 'package:sportconnect/src/pages/event_edit_screen.dart';
import 'package:sportconnect/src/widgets/event_qr_widget.dart';

class EventInfoScreen extends StatelessWidget {
  final int eventId;
  final String currentUserId = supabase.auth.currentSession!.user.id;
  EventInfoScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    const Color primaryColor = Color(0xFF145D55);
    //const Color secondaryColor = Color(0xFF2CC27F);
    const Color accentColor = Color(0xFF9FBEB9);

    TextStyle titleStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
    TextStyle subtitleStyle =
        const TextStyle(fontSize: 16, color: Colors.white);
    TextStyle buttonTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

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
                style: const TextStyle(color: accentColor));
          }
          return const Text('Event Details',
              style: TextStyle(color: Colors.white));
        }),
        // Inside AppBar actions of EventInfoScreen
        actions: <Widget>[
          Obx(() {
            bool isParticipant =
                eventController.isCurrentUserParticipating.value;
            Event? event = eventController.eventsList.value
                .firstWhereOrNull((e) => e.idEvent == eventId);

            bool isOrganizer = event?.organizerId == currentUserId;

            if (isOrganizer) {
              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton(
                      icon: Icon(Icons.qr_code),
                      onPressed: () {
                        // Display QR code in a bottom sheet
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return QRCodeWidget(eventData: eventId.toString(), imageUrl: "https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$eventId",);
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 100,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      EventEditScreen(eventId: eventId)));
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text('Edit', style: buttonTextStyle),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  gradient: isParticipant
                      ? LinearGradient(
                          colors: [Colors.red[300]!, Colors.red[700]!])
                      : LinearGradient(
                          colors: [Colors.green[300]!, Colors.green[700]!]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextButton(
                  onPressed: () async {
                    if (isParticipant) {
                      await eventController.leaveEvent(eventId);
                    } else {
                      await eventController.joinEvent(eventId);
                    }
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: Colors.grey,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isParticipant ? Icons.logout : Icons.login,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(isParticipant ? 'Leave' : 'Join',
                          style: buttonTextStyle),
                    ],
                  ),
                ),
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
                  color: const Color(0xFF1D1E33),
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
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text('${event.sportName}',
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
          color: const Color(0xFF1D1E33),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: ListTile(
            title: Text(title, style: titleStyle),
            subtitle: Text(value, style: subtitleStyle),
          ),
        ),
      );
    });

    detailsList.add(
      Card(
        color: const Color(0xFF1D1E33),
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
                                    ? const Icon(Icons.person,
                                        size: 20, color: Colors.white)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  '${participant.name} ${participant.surname}${participant.id == currentUserId ? " (You)" : ""}',
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
