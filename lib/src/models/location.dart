class Location {
  final String idLocation;
  final String name;
  final String address;
  final String contact;
  final String coordinates; // Assuming a string format "lat,lng"

  Location({
    required this.idLocation,
    required this.name,
    required this.address,
    required this.contact,
    required this.coordinates,
  });

  // Factory constructor for creating a new Location instance from a map (e.g., JSON data).
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      idLocation: json['id_location'],
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      coordinates: json['coordinates'],
    );
  }

  // Method to convert Location instance into a map.
  // Useful for converting the Location object to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'name': name,
      'address': address,
      'contact': contact,
      'coordinates': coordinates,
    };
  }
}
