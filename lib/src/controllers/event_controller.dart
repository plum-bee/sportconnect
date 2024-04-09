import 'package:get/get.dart';
import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/services/event_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/location_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/models/media.dart';

class UserEvent {
  final Event event;
  final bool participated;

  UserEvent({required this.event, required this.participated});
}

class EventController extends GetxController {
  final EventService eventService = EventService();
  final SportService sportService = SportService();
  final SkillLevelService skillLevelService = SkillLevelService();
  final LocationService locationService = LocationService();

  final Rx<List<Event>> eventsList = Rx<List<Event>>([]);
  final Rx<List<UserEvent>> userEventsList = Rx<List<UserEvent>>([]);
  final Rx<List<Event>> upcomingEventsList = Rx<List<Event>>([]);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
    fetchUserEvents();
  }

  Future<void> fetchEvents() async {
    List<Event> events = await eventService.getAllEvents();
    List<Event> upcomingEvents = [];
    var currentTime = DateTime.now();

    await Future.forEach<Event>(events, (event) async {
      await fetchEventDetails(event);
      if (event.startTime!.isAfter(currentTime)) {
        upcomingEvents.add(event);
      }
    });

    eventsList.value = events;
    upcomingEventsList.value = upcomingEvents;
  }

  Future<void> fetchUserEvents() async {
    String userId = supabase.auth.currentUser!.id;

    var userEventsWithParticipation = await eventService.getUserEvents(userId);

    List<UserEvent> userEvents = [];
    await Future.forEach<Map<String, dynamic>>(userEventsWithParticipation,
        (eventWithParticipation) async {
      Event event = eventWithParticipation['event'];
      bool participated = eventWithParticipation['assisted'];

      await fetchEventDetails(event);
      userEvents.add(UserEvent(event: event, participated: participated));
    });

    userEventsList.value = userEvents;
  }

  Future<void> fetchEventDetails(Event event) async {
    if (event.idSport != null) {
      final sport = await sportService.getSportById(event.idSport!);
      event.sportName = sport.name;
    }
    if (event.idSkillLevel != null) {
      final skillLevel =
          await skillLevelService.getSkillLevelById(event.idSkillLevel!);
      event.skillLevelName = skillLevel.name;
    }
    if (event.idLocation != null) {
      final location = await locationService.getLocationById(event.idLocation!);
      event.location = location;
      List<Member> participants =
          await eventService.getEventParticipants(event.idEvent);
      event.participants = participants;
    }

    List<Media> media = await eventService.getEventMedia(event.idEvent);
    event.media.value = media;
  }

  Future<void> refreshEventInfo() async {
    await fetchEvents();
  }
}
