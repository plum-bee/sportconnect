import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/pages/location_info_screen.dart';

class LocationItemWidget extends StatelessWidget {
  final Location location;

  const LocationItemWidget({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextStyle titleStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1AC077), // Same green used in other widgets
    );

    const TextStyle detailStyle = TextStyle(
      fontSize: 16,
      color: Colors.white70, // Slightly opaque white for details
    );

    Decoration containerDecoration = BoxDecoration(
      color: const Color(0xFF1D1E33), // Dark bluish-grey
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2), // Consistent light shadow
        ),
      ],
    );

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
        decoration: containerDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.name,
              style: titleStyle,
            ),
            const SizedBox(height: 8),
            Text(
              location.address,
              style: detailStyle,
            ),
            const SizedBox(height: 8),
            Text(
              "Contact: ${location.contact}",
              style: detailStyle,
            ),
          ],
        ),
      ),
    );
  }
}
