import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/event.dart';

class EventService {
  final String _tableName = 'events';

  Future<Event> getEventById(String eventId) async {
    final eventResponse =
        await supabase.from(_tableName).select().eq('id_event', eventId).single();

    return Event.fromMap(eventResponse);
  }

  Future<List<Event>> getAllEvents() async {
    final eventsResponse = await supabase.from(_tableName).select();

    return List<Event>.from(eventsResponse.map((event) => Event.fromMap(event)));
  }

  Future<void> createEvent(Event event) async {
    final response = await supabase.from(_tableName).insert(event.toJson());

    if (response.error != null) {
      throw Exception('Failed to delete event: ${response.error!.message}');
    }
  }

  Future<void> updateEvent(Event event) async {
    final response = await supabase
        .from(_tableName)
        .update(event.toJson())
        .eq('id_event', event.id);
    if (response.error != null) {
      throw Exception('Failed to update event: ${response.error!.message}');
    }
  }

  Future<void> deleteEvent(String eventId) async {
    final response = await supabase.from(_tableName).delete().eq('id_event', eventId);
    if (response.error != null) {
      throw Exception('Failed to delete event: ${response.error!.message}');
    }
  }
}
