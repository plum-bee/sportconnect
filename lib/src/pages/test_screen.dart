import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/location_controller.dart';
import 'package:sportconnect/src/models/location.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key}) : super(key: key);

  final LocationController locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Locations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (locationController.allLocations.isEmpty) {
                return Center(child: Text('No locations found'));
              } else {
                return ListView.builder(
                  itemCount: locationController.allLocations.length,
                  itemBuilder: (context, index) {
                    Location location = locationController.allLocations[index];
                    return ListTile(
                      title: Text(location.name),
                      subtitle: Text(location.address),
                    );
                  },
                );
              }
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter Location ID',
              ),
              onSubmitted: (value) {
                locationController.fetchLocationById(value.trim());
              },
            ),
          ),
          Obx(() {
            final location = locationController.currentLocation.value;
            return location == null
                ? Container()
                : Card(
                    child: ListTile(
                      title: Text(location.name),
                      subtitle: Text(location.address),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
