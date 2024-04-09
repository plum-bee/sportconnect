import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/event_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/widgets/media_widget.dart';

class EventInfoScreen extends StatelessWidget {
  final int eventId;
  EventInfoScreen({Key? key, required this.eventId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Obx(() {
        Event? event = eventController.eventsList.value
            .firstWhereOrNull((e) => e.idEvent == eventId);

        if (event == null) {
          return Center(child: Text('Event not found.'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sport: ${event.sportName ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headline6),
                Text('Skill Level: ${event.skillLevelName ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headline6),
                Text('Location: ${event.location?.name ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headline6),
                Text(
                    'Start Time: ${event.startTime?.toLocal().toString() ?? 'N/A'}',
                    style: Theme.of(context).textTheme.headline6),
                Text(
                    'Participants: ${event.participants?.length.toString() ?? '0'}',
                    style: Theme.of(context).textTheme.headline6),
                Obx(
                  () => event.media.isNotEmpty
                      ? MediaWidget(
                          mediaList: event.media,
                          eventId: event.idEvent,
                          refreshEventInfo: () =>
                              eventController.refreshEventInfo(),
                        )
                      : SizedBox.shrink(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
