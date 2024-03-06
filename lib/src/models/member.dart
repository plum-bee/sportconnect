import 'package:sportconnect/src/models/user_sport_skill.dart';

class Member {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;
  List<UserSportSkill> userSportsSkills;

  Member({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.avatarUrl,
    this.createdAt,
    required this.userSportsSkills,
  });

  factory Member.fromMap(
      Map<String, dynamic> map, List<UserSportSkill> userSportsSkills) {
    return Member(
      id: map['id_user'],
      name: map['name'],
      surname: map['surname'],
      email: map['email'],
      avatarUrl: map['avatar_url'],
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      userSportsSkills: userSportsSkills,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'name': name,
      'surname': surname,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String()
    };
  }

  String getAvatarUrl() {
    return avatarUrl != null && avatarUrl!.isNotEmpty
        ? avatarUrl!
        : 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
  }
}
