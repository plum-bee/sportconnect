import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:sportconnect/src/controllers/location_controller.dart';
import 'package:sportconnect/src/widgets/location_item_widget.dart';
import 'package:sportconnect/src/pages/location_info_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final LocationController locationController = Get.put(LocationController());
  final TextEditingController _searchController = TextEditingController();
  bool showMap = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    locationController.filterLocations(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Locations'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(showMap ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                showMap = !showMap;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!showMap) const SizedBox(height: 20.0),
              if (!showMap)
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 20.0),
              SizedBox(
                height: screenSize.height * 0.7,
                child: showMap ? _buildMap() : _buildLocationList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(41.3732071, 2.1403263),
        initialZoom: 13.0,
      ),
      children: [
        TileLayer(
            urlTemplate:
                "https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=pk.eyJ1IjoibHVtaXpvciIsImEiOiJjbHV3cTQ1bW8wZDk5MmpwYnYxMnJ0d2x3In0.pK3SzMwwmQ18o3DNpZGcog",
            additionalOptions: const {
              'access_token':
                  "pk.eyJ1IjoibHVmaXpvciIsImEiOiJjbHV3cXZhbXkwaTZvMnBudmkyZms1bXV6In0.R1wnaCdQitGymGJfImGfgg",
              'id': "mapbox/streets-v12"
            }),
        MarkerLayer(
          markers: locationController.filteredLocations.map((location) {
            return Marker(
                width: 80.0,
                height: 80.0,
                point: location.getLatLng(location.coordinates),
                child: GestureDetector(
                    onTap: () {
                      Get.to(() => LocationInfoScreen(location: location));
                    },
                    child: const Icon(Icons.location_on,
                        color: Colors.red, size: 40.0)));
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationList() {
    return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: locationController.filteredLocations.length,
          itemBuilder: (context, index) {
            return LocationItemWidget(
                location: locationController.filteredLocations[index]);
          },
        ));
  }
}
