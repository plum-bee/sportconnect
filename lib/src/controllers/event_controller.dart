import 'package:get/get.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/services/event_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';
import 'package:sportconnect/src/services/location_service.dart';
import 'package:sportconnect/src/services/skill_level_service.dart';

class EventController extends GetxController {
  final EventService eventService = EventService();
  final SportService sportService = SportService();
  final SkillLevelService skillLevelService = SkillLevelService();
  final LocationService locationService = LocationService();

  final Rx<List<Event>> eventsList = Rx<List<Event>>([]);
  final Rx<Event?> currentEvent = Rx<Event?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    List<Event> events = await eventService.getAllEvents();
    await Future.forEach<Event>(events, (event) async {
      await fetchEventDetails(event);
    });
    eventsList.value = events;
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
      event.locationName = location.name;
    }
  }
}
