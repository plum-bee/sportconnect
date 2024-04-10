import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/event.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/services/member_service.dart';
import 'package:sportconnect/src/models/media.dart';
import 'package:get/get.dart';

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

  Future<RxList<Member>> getEventParticipants(int eventId) async {
    final participantsResponse = await supabase
        .from('event_participants')
        .select('id_user')
        .eq('id_event', eventId);

    RxList<Member> participants = RxList<Member>();
    for (var data in participantsResponse) {
      String userId = data['id_user'];
      Member member = await MemberService().getMemberById(userId);
      participants.add(member);
    }

    return participants;
  }

  Future<List<Media>> getEventMedia(int eventId) async {
    final mediaResponse =
        await supabase.from('events_media').select().eq('id_event', eventId);
    List<Media> media = [];
    for (var data in mediaResponse) {
      media.add(Media.fromMap(data));
    }
    return media;
  }
}
