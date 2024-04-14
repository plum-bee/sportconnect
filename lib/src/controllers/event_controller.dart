import 'package:get/get.dart';
import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/services/event_service.dart';
import 'package:sportconnect/src/services/member_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/location_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';
import 'package:sportconnect/src/models/member.dart';

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

  final RxBool isCurrentUserParticipating = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshEventInfo();
  }

  Future<void> fetchEvents() async {
    List<Event> events = await eventService.getAllEvents();
    var currentTime = DateTime.now();

    List<Future> detailFutures = [];
    for (var event in events) {
      detailFutures.add(fetchEventDetails(event));
    }
    await Future.wait(detailFutures);

    List<Event> upcomingEvents =
        events.where((e) => e.startTime!.isAfter(currentTime)).toList();

    eventsList.value = events;
    upcomingEventsList.value = upcomingEvents;
  }

  Future<void> fetchUserEvents() async {
    String userId = supabase.auth.currentUser!.id;
    var userEventsWithParticipation = await eventService.getUserEvents(userId);

    List<Future> detailFutures = [];
    List<UserEvent> userEvents = [];

    for (var eventWithParticipation in userEventsWithParticipation) {
      Event event = eventWithParticipation['event'];
      bool participated = eventWithParticipation['assisted'];
      userEvents.add(UserEvent(event: event, participated: participated));
      detailFutures.add(fetchEventDetails(event));
    }

    await Future.wait(detailFutures);

    userEventsList.value = userEvents;
  }

  Future<void> fetchEventDetails(Event event) async {
    var futures = <Future>[];

    if (event.idSport != null) {
      futures.add(sportService
          .getSportById(event.idSport!)
          .then((sport) => event.sportName = sport.name));
    }
    if (event.idSkillLevel != null) {
      futures.add(skillLevelService
          .getSkillLevelById(event.idSkillLevel!)
          .then((skill) => event.skillLevelName = skill.name));
    }
    if (event.idLocation != null) {
      futures.add(locationService
          .getLocationById(event.idLocation!)
          .then((loc) => event.location = loc));
      futures.add(eventService
          .getEventParticipants(event.idEvent)
          .then((participants) => event.participants = participants));
    }
    if (event.organizerId != null) {
      futures.add(MemberService()
          .getMemberById(event.organizerId!)
          .then((organizer) => event.organizer = organizer));
    }
    futures.add(eventService
        .getEventMedia(event.idEvent)
        .then((media) => event.media?.value = media));

    await Future.wait(futures);
    initializeParticipationStatus(event.idEvent);
  }

  Future<void> refreshEventInfo() async {
    await fetchEvents();
    await fetchUserEvents();
  }

  Future<bool> isCurrentUserParticipant(Event event) async {
    if (event.participants == null || event.participants!.isEmpty) {
      RxList<Member> participants =
          await eventService.getEventParticipants(event.idEvent);
      event.participants = participants;
    }

    String currentUserId = supabase.auth.currentUser!.id;

    return event.participants!.any((member) => member.id == currentUserId);
  }

  Future<void> joinEvent(int eventId) async {
    String userId = supabase.auth.currentUser!.id;
    try {
      await eventService.addParticipantToEvent(eventId, userId);

      var eventIndex =
          eventsList.value.indexWhere((event) => event.idEvent == eventId);
      if (eventIndex != -1) {
        Member newParticipant = await MemberService().getMemberById(userId);
        eventsList.value[eventIndex].participants?.add(newParticipant);
        eventsList.refresh();

        bool isUpcoming =
            eventsList.value[eventIndex].startTime!.isAfter(DateTime.now());
        bool isParticipant = eventsList.value[eventIndex].participants!
            .any((m) => m.id == userId);

        if (isUpcoming && !isParticipant) {
          UserEvent newUserEvent = UserEvent(
              event: eventsList.value[eventIndex], participated: true);
          userEventsList.value = [...userEventsList.value, newUserEvent];
          userEventsList.refresh();
        }

        isCurrentUserParticipating.value = true;
      }
    } catch (e) {
      print("Error joining event: $e");
    }
  }

  Future<void> leaveEvent(int eventId) async {
    String userId = supabase.auth.currentUser!.id;
    try {
      await eventService.removeParticipantFromEvent(eventId, userId);

      var eventIndex =
          eventsList.value.indexWhere((event) => event.idEvent == eventId);
      if (eventIndex != -1) {
        eventsList.value[eventIndex].participants
            ?.removeWhere((member) => member.id == userId);
        eventsList.refresh();
      }
      isCurrentUserParticipating.value = false;
    } catch (e) {
      print("Error leaving event: $e");
    }
  }

  void initializeParticipationStatus(int eventId) async {
    Event? event =
        eventsList.value.firstWhereOrNull((e) => e.idEvent == eventId);
    if (event != null) {
      bool isParticipant = await isCurrentUserParticipant(event);
      isCurrentUserParticipating.value = isParticipant;
    }
  }

  void addNewEvent(Event event) {
    var currentTime = DateTime.now();
    eventsList.value = [...eventsList.value, event];
    if (event.startTime!.isAfter(currentTime)) {
      upcomingEventsList.value = [...upcomingEventsList.value, event];
    }
    eventsList.refresh();
    upcomingEventsList.refresh();
    userEventsList.refresh();
  }
}
