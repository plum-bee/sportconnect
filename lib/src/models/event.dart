import 'package:sportconnect/src/models/sport.dart';

class Event {
  final int idEvent;
  final int? idLocation;
  final int? idSport;
  Sport sport;
  final int? idSkillLevel;
  final DateTime? startTime;
  final bool isFinished;

  Event({
    required this.idEvent,
    this.idLocation,
    this.idSport,
    required this.sport,
    this.idSkillLevel,
    this.startTime,
    this.isFinished = false,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      idEvent: map['id_event'],
      idLocation: map['id_location'],
      idSport: map['id_sport'],
      sport: Sport.fromMap(map),
      idSkillLevel: map['id_skill_level'],
      startTime:
          map['start_time'] != null ? DateTime.parse(map['start_time']) : null,
      isFinished: map['is_finished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_event': idEvent,
      'id_location': idLocation,
      'id_sport': idSport,
      'id_skill_level': idSkillLevel,
      'start_time': startTime?.toIso8601String(),
      'is_finished': isFinished,
    };
  }
}
