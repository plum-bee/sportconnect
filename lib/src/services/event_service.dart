import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/event.dart';

class EventService {
  final String _tableName = 'events';

  Future<List<Map<String, dynamic>>> getUserEvents(String userId) async {
    final eventsResponse = await supabase
        .from('event_participants')
        .select('id_event, assisted')
        .eq('id_user', userId);

    List<dynamic> eventData = eventsResponse as List<dynamic>;
    List<Map<String, dynamic>> userEventsWithParticipation = [];

    for (var data in eventData) {
      int eventId = data['id_event'] as int;
      bool participated = data['assisted'] as bool;
      Event event = await getEventById(eventId);

      userEventsWithParticipation.add({
        'event': event,
        'assisted': participated,
      });
    }

    return userEventsWithParticipation;
  }

  Future<Event> getEventById(int eventId) async {
    final eventResponse = await supabase
        .from(_tableName)
        .select()
        .eq('id_event', eventId)
        .single();

    return Event.fromMap(eventResponse);
  }

  Future<List<Event>> getAllEvents() async {
    final eventsResponse = await supabase.from(_tableName).select();

    final dataList = eventsResponse as List<dynamic>;
    return dataList.map((event) => Event.fromMap(event)).toList();
  }

  Future<void> createEvent(Event event) async {
    final response = await supabase.from(_tableName).insert(event.toJson());

    if (response == null) {
      throw Exception('Failed to create event: ${response.error!.message}');
    }
  }

  Future<void> updateEvent(Event event) async {
    final response = await supabase
        .from(_tableName)
        .update(event.toJson())
        .eq('id_event', event.idEvent);

    if (response == null) {
      throw Exception('Failed to update event: ${response.error!.message}');
    }
  }

  Future<void> deleteEvent(int eventId) async {
    final response =
        await supabase.from(_tableName).delete().eq('id_event', eventId);

    if (response == null) {
      throw Exception('Failed to delete event: ${response.error!.message}');
    }
  }
}
