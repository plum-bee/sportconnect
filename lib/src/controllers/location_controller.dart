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

  Future<void> fetchAllLocations() async {
    List<Location> locations = await locationService.getAllLocations();
    await Future.forEach<Location>(locations, (location) async {
      var mediaList =
          await locationService.getLocationMedia(location.idLocation!);
      location.media?.assignAll(mediaList);
    });
    allLocations.assignAll(locations);
    filteredLocations.assignAll(locations);
  }

  void filterLocations(String searchTerm) {
    if (searchTerm.isEmpty) {
      filteredLocations.assignAll(allLocations);
    } else {
      filteredLocations.assignAll(allLocations
          .where((location) =>
              location.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
              location.address
                  .toLowerCase()
                  .contains(searchTerm.toLowerCase()) ||
              location.contact.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList());
    }
  }

  void refreshLocations() async {
    fetchAllLocations();
  }
}
