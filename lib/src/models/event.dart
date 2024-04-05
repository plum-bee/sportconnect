import 'package:sportconnect/src/models/member.dart';

class Event {
  final int idEvent;
  final int? idLocation;
  final int? idSport;
  final int? idSkillLevel;
  final DateTime? startTime;
  final bool isRegistrationOpen;

  String? sportName;
  String? skillLevelName;
  String? locationName;
  List<Member>? participants;

  Event({
    required this.idEvent,
    this.idLocation,
    this.idSport,
    this.idSkillLevel,
    this.startTime,
    this.isRegistrationOpen = false,
    this.sportName,
    this.skillLevelName,
    this.locationName,
  });

  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      idEvent: map['id_event'],
      idLocation: map['id_location'],
      idSport: map['id_sport'],
      idSkillLevel: map['id_skill_level'],
      startTime:
          map['start_time'] != null ? DateTime.parse(map['start_time']) : null,
      isRegistrationOpen: map['is_finished'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_event': idEvent,
      'id_location': idLocation,
      'id_sport': idSport,
      'id_skill_level': idSkillLevel,
      'start_time': startTime?.toIso8601String(),
      'is_finished': isRegistrationOpen,
    };
  }
}
