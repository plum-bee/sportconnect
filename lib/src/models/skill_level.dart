class SkillLevel {
  final int id;
  final String name;

  SkillLevel({
    required this.id,
    required this.name,
  });

  factory SkillLevel.fromMap(Map<String, dynamic> map) {
    return SkillLevel(
      id: map['id_skill_level'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_skill_level': id,
      'name': name,
    };
  }
}
