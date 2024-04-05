import 'package:flutter/material.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/services/location_service.dart'; // Ensure this import is correct

class LocationInfoScreen extends StatefulWidget {
  final int locationId;

  LocationInfoScreen({Key? key, required this.locationId}) : super(key: key);

  @override
  _LocationInfoScreenState createState() => _LocationInfoScreenState();
}

class _LocationInfoScreenState extends State<LocationInfoScreen> {
  Location? location;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  Future<void> fetchLocation() async {
    // Placeholder for your location fetching logic
    // Assuming LocationService has a method to fetch location by ID
    LocationService locationService = LocationService();
    Location fetchedLocation =
        await locationService.getLocationById(widget.locationId);
    setState(() {
      location = fetchedLocation;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(location?.name ?? 'Loading...'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Text(location?.address ?? ''),
                  // Further details and media list display
                ],
              ),
            ),
    );
  }
}
