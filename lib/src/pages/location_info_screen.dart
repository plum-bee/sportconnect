import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/pages/event_creation_screen.dart';
import 'package:sportconnect/src/widgets/location_media_widget.dart';
import 'package:sportconnect/src/controllers/location_controller.dart';

class LocationInfoScreen extends StatelessWidget {
  final Location location;
  final LocationController locationController = Get.find<LocationController>();

  LocationInfoScreen({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF145D55);
    const Color accentColor = Color(0xFF9FBEB9);
    const Color buttonColor = Color(0xFF1AC077);

    TextStyle titleStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
    TextStyle subtitleStyle =
        const TextStyle(fontSize: 16, color: Colors.white);

    Decoration boxDecoration = BoxDecoration(
      color: const Color(0xFF1D1E33),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(location.name, style: const TextStyle(color: accentColor)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              decoration: boxDecoration,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Address:", style: titleStyle),
                  Text(location.address, style: subtitleStyle),
                  const SizedBox(height: 10),
                  Text("Contact:", style: titleStyle),
                  Text(location.contact, style: subtitleStyle),
                ],
              ),
            ),
            LocationMediaWidget(
              mediaList: location.media!,
              locationId: location.idLocation!,
              locationName: location.name,
              refreshLocationInfo: () => locationController.refreshLocations(),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventCreationPage(location: location),
                  ));
                },
                child: const Text('Create Event'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
