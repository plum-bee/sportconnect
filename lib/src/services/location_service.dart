import 'package:sportconnect/main.dart';
import 'package:sportconnect/src/models/location.dart';
import 'package:sportconnect/src/models/media.dart';

class LocationService {
  final String _tableName = 'locations';

  Future<Location> getLocationById(int locationId) async {
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

  Future<List<Media>> getLocationMedia(int locationId) async {
    final mediaResponse = await supabase
        .from('locations_media')
        .select()
        .eq('id_location', locationId);

    List<Media> mediaList = List<Media>.from(
      mediaResponse.map(
        (mediaData) => Media(
          path: mediaData['media_path'],
          type: mediaData['media_type'] == 'video'
              ? MediaType.video
              : MediaType.image,
        ),
      ),
    );

    return mediaList;
  }
}
