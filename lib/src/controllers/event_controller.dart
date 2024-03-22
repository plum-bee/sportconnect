import 'dart:math';

import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/sport_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/models/sport.dart';
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
    try {
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
        final location =
            await locationService.getLocationById(event.idLocation!);
        event.locationName = location.name;
      }
    } catch (e) {
      print("Error fetching event details: $e");
    }
  }
}


//   void setCurrentEvent(Event event) {
//     currentEvent.value = event;
//   }

//   Future<void> createEvent(Event event) async {
//     try {
//       await eventService.createEvent(event);
//       fetchEvents();
//     } catch (e) {
//       print('Error creating event: $e');
//     }
//   }

//   Future<void> updateEvent(Event event) async {
//     try {
//       await eventService.updateEvent(event);
//       fetchEvents();
//     } catch (e) {
//       print('Error updating event: $e');
//     }
//   }

//   Future<void> deleteEvent(String eventId) async {
//     try {
//       await eventService.deleteEvent(eventId);
//       fetchEvents();
//     } catch (e) {
//       print('Error deleting event: $e');
//     }
//   }

