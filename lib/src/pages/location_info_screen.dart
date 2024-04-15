import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/pages/event_creation_screen.dart';

class LocationInfoScreen extends StatelessWidget {
  final Location location;

  LocationInfoScreen({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Styling constants
    const Color primaryColor = Color(0xFF145D55);
    const Color accentColor = Color(0xFF9FBEB9);

    TextStyle titleStyle = const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1AC077));
    TextStyle subtitleStyle =
        const TextStyle(fontSize: 16, color: Colors.white);

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
            Card(
              color: Color(0xFF1D1E33),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Address:", style: titleStyle),
                    Text(location.address, style: subtitleStyle),
                    SizedBox(height: 10),
                    Text("Contact:", style: titleStyle),
                    Text(location.contact, style: subtitleStyle),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("Additional Details", style: titleStyle),
            Card(
              color: const Color(0xFF1D1E33),
              child: ListTile(
                title: Text("Create Event", style: titleStyle),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EventCreationPage(location: location),
                  ));
                },
                subtitle: const Icon(Icons.map, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
