import 'dart:convert';

class Member {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String? avatarUrl;
  final DateTime? createdAt;

  Member({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.avatarUrl,
    this.createdAt,
  });

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map['id_user'] as String,
      name: map['name'] as String,
      surname: map['surname'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatar_url'] as String?,
      createdAt:
          map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));

  Map<String, dynamic> toJson() {
    return {
      'id_user': id,
      'name': name,
      'surname': surname,
      'email': email,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String getAvatarUrl() {
    return avatarUrl != null && avatarUrl!.isNotEmpty
        ? avatarUrl!
        : 'http://forum.spaceengine.org/styles/se/theme/images/no_avatar.jpg';
  }
}
