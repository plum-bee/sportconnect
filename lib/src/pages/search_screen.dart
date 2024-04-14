import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportconnect/src/controllers/location_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationController locationController = Get.put(LocationController());

  final List<String> items = [
    'Texto 1',
    'Texto 2',
    'Texto 3',
    'Texto 4',
    'Texto 5'
  ];
  String dropdownValue = 'Texto 1';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenSize.width * 0.5,
              maxHeight: screenSize.height * 0.05,
            ),
            child: Image.asset(
              'assets/images/logo_text.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: const Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items: items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                  height: screenSize.height * 0.7,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(40.416775, -3.703790),
                      initialZoom: 13.0,
                    ),
                    children: [
                      TileLayer(
                          urlTemplate:
                              "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibHVtaXpvciIsImEiOiJjbHV3cXZhbXkwaTZvMnBudmkyZms1bXV6In0.R1wnaCdQitGymGJfImGfgg",
                          additionalOptions: const {
                            'access_token':
                                "pk.eyJ1IjoibHVtaXpvciIsImEiOiJjbHV3cXZhbXkwaTZvMnBudmkyZms1bXV6In0.R1wnaCdQitGymGJfImGfgg",
                            'id': "mapbox/streets-v12"
                          }),
                      MarkerLayer(
                        markers: locationController.allLocations.value
                            .map((location) {
                          return  Marker(
                            width: 80.0,
                            height: 80.0,
                            point: location.getLatLng(location.coordinates),
                            child: GestureDetector(
                              onTap: () {
                                showDialog(
                                 context: context,
                                 builder: (context) => AlertDialog(
                                    title: Text(location.name),
                                    content: Text(location.address),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                 );
                              },
                              child: const Icon(
                                Icons.location_on,
                                color: Colors.red,
                                size: 40.0
                            ))
                          );
                        }).toList(),
                      ),
                      
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
