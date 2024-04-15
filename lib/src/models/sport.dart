class Sport {
  final int idSport;
  final String name;

  Sport({
    required this.idSport,
    required this.name,
  });

  factory Sport.fromMap(Map<String, dynamic> map) {
    return Sport(
      idSport: map['id_sport'] as int,
      name: map['name'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_sport': idSport,
      'name': name,
    };
  }
}
