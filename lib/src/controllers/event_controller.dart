import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/sport_controller.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/services/event_service.dart';
import 'package:sportconnect/src/services/sport_service.dart';


class EventController extends GetxController {
  final EventService eventService = EventService();
  final SportService sportService = SportService();
  final Rx<List<Event>> eventsList = Rx<List<Event>>([]);
  final Rx<Event?> currentEvent = Rx<Event?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  void fetchEvents() async {
    List<Event> events = await eventService.getAllEvents();
    eventsList.value = events;

    for (Event event in events) {
      Sport currentSport = await Get.find<SportService>().getSportById(event.idSport!);
      event.sport = currentSport;
      
    }
  }

    void fetchEventById(int eventId) async {
    Event event = await eventService.getEventById(eventId);
    currentEvent.value = event;
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
}
