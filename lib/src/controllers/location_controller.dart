import 'package:get/get.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/services/location_service.dart';

class LocationController extends GetxController {
  final LocationService locationService = LocationService();
  final Rx<Location?> currentLocation = Rx<Location?>(null);
  final RxList<Location> allLocations = RxList<Location>(); 

  @override
  void onInit() {
    super.onInit();
    fetchAllLocations();
  }

  void fetchLocationById(int locationId) async {
    Location location = await locationService.getLocationById(locationId);
    currentLocation.value = location;
  }

  void fetchAllLocations() async {
    List<Location> locations = await locationService.getAllLocations();
    allLocations.assignAll(locations);
  }
}
