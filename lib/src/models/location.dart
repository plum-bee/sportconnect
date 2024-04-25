import 'package:latlong2/latlong.dart';
import 'package:sportconnect/src/models/media.dart';
import 'package:get/get.dart';

class Location {
  final int? idLocation;
  final String name;
  final String address;
  final String contact;
  final String coordinates;

  RxList<Media>? media = RxList<Media>([]);

  Location({
    required this.idLocation,
    required this.name,
    required this.address,
    required this.contact,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      idLocation: json['id_location'],
      name: json['name'],
      address: json['address'],
      contact: json['contact'],
      coordinates: json['coordinates'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_location': idLocation,
      'name': name,
      'address': address,
      'contact': contact,
      'coordinates': coordinates,
    };
  }

  static Location fromMap(Map<String, dynamic> map) {
    return Location(
      idLocation: map['id_location'],
      name: map['name'],
      address: map['address'],
      contact: map['contact'],
      coordinates: map['coordinates'],
    );
  }

  LatLng getLatLng(String coordinates) {
    final parts = coordinates.split(', ');
    String latPart = parts[0].split('º')[0].trim();
    String lngPart = parts[1].split('º')[0].trim();

    double lat = double.parse(latPart);
    double lng = double.parse(lngPart);

    if (parts[0].contains('S')) {
      lat = -lat;
    }
    if (parts[1].contains('W')) {
      lng = -lng;
    }

    return LatLng(lat, lng);
  }
}
