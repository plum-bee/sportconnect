import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/models/sport.dart';

class Event {
  final String id;
  final Sport sport;
  final Location location;
  final DateTime date;
  final String description;
  final List<Member> participants;

  Event({
    required this.id,
    required this.sport,
    required this.location,
    required this.date,
    required this.description,
    required this.participants,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'],
      sport: Sport.fromMap(map['sport']),
      location: Location.fromMap(map['location']),
      date: DateTime.parse(map['date']),
      description: map['description'],
      participants: [], 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport.toMap(),
      'location': location.toJson(),
      'date': date.toIso8601String(),
      'description': description,
      // Participants are not included in JSON as they might be too large to store inline
    };
  }

  void addParticipant(Member participant) {
    participants.add(participant);
  }

  void removeParticipant(Member participant) {
    participants.removeWhere((p) => p.id == participant.id);
  }
}
