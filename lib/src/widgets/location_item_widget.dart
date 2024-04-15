import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/pages/location_info_screen.dart';

class LocationItemWidget extends StatelessWidget {
  final Location location;

  const LocationItemWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LocationInfoScreen(location: location),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green, // Set text color to black
              ),
            ),
            const SizedBox(height: 8),
            Text(
              location.address,
              style: const TextStyle(
                color: Colors.black, // Set text color to black
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Contact: ${location.contact}",
              style: const TextStyle(
                color: Colors.black, // Set text color to black
              ),
            ),
          ],
        ),
      ),
    );
  }
}
