class Event {
  final int idEvent;
  final int? idLocation;
  final int? idSport;
  final int? idSkillLevel;
  final DateTime? startTime;
  final bool isFinished;

  // Additional fields to hold the fetched names
  String? sportName;
  String? skillLevelName;
  String? locationName;

  Event({
    required this.idEvent,
    this.idLocation,
    this.idSport,
    this.idSkillLevel,
    this.startTime,
    this.isFinished = false,
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
      isFinished: map['is_finished'] ?? false,
      // Names are not initialized from the map, as they are not stored in the table
    );
  }

  Map<String, dynamic> toJson() {
    // Convert the event instance to a JSON-compatible map
    return {
      'id_event': idEvent,
      'id_location': idLocation,
      'id_sport': idSport,
      'id_skill_level': idSkillLevel,
      'start_time': startTime?.toIso8601String(),
      'is_finished': isFinished,
      // Note: The name fields are not included in the JSON, as they are not part of the table schema
    };
  }
}
