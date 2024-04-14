import 'package:get/get.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/services/location_service.dart';

class LocationController extends GetxController {
  final LocationService locationService = LocationService();
  final RxList<Location> allLocations = RxList<Location>();
  final RxList<Location> filteredLocations = RxList<Location>();

  @override
  void onInit() {
    super.onInit();
    fetchAllLocations();
  }

  void fetchAllLocations() async {
    List<Location> locations = await locationService.getAllLocations();
    if (locations.isNotEmpty) {
      allLocations.assignAll(locations);
      filteredLocations.assignAll(locations); // Ensure this is done
    }
  }

  void filterLocations(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredLocations.assignAll(allLocations);
    } else {
      filteredLocations.assignAll(
        allLocations.where((location) =>
          location.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
          location.address.toLowerCase().contains(searchTerm.toLowerCase()) ||
          location.contact.toLowerCase().contains(searchTerm.toLowerCase())
        ).toList()
      );
    }
  }
}
