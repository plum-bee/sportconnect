class User {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['name'],
      email: json['email'],
      avatarUrl: json['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
    };
  }
}
