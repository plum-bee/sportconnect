import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/models/member.dart';
import 'package:sportconnect/src/models/sport.dart';

class Event {
  final int id;
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
      id: map['id_event'],
      sport: Sport.fromMap(map['sport']),
      location: Location.fromMap(map['location']),
      date: DateTime.parse(map['date']),
      description: map['description'],
      participants: [],
    );
  }
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id_event'] as int? ?? 0,
      sport: Sport.fromMap(json['sport'] as Map<String, dynamic>),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      description: json['description'] as String? ?? '',
      participants: [], // Puedes agregar los participantes aquí si es necesario
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sport': sport.toMap(),
      'location': location.toJson(),
      'date': date.toIso8601String(),
      'description': description,
    };
  }

  void addParticipant(Member participant) {
    participants.add(participant);
  }

  void removeParticipant(Member participant) {
    participants.removeWhere((p) => p.id == participant.id);
  }
}
