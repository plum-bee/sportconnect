class SkillLevel {
  final int idSkillLevel;
  final String name;

  SkillLevel({
    required this.idSkillLevel,
    required this.name,
  });

  factory SkillLevel.fromMap(Map<String, dynamic> map) {
    return SkillLevel(
      idSkillLevel: map['id_skill_level'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_skill_level': idSkillLevel,
      'name': name,
    };
  }
}
