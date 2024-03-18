import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/location.dart';

class LocationService {
  final String _tableName = 'locations';

  Future<Location> getLocationById(String locationId) async {
    final locationResponse = await supabase
        .from(_tableName)
        .select()
        .eq('id_location', locationId)
        .single();

    return Location.fromJson(locationResponse);
  }

  Future<List<Location>> getAllLocations() async {
    final locationsResponse = await supabase.from(_tableName).select();

    return List<Location>.from(
      locationsResponse.map((e) => Location.fromJson(e)),
    );
  }
}
