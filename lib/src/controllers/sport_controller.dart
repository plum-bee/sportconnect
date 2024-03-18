import 'package:get/get.dart';
import 'package:sportconnect/src/models/sport.dart';
import 'package:sportconnect/src/services/sport_service.dart';

class SportController extends GetxController {
  final SportService sportService = SportService();
  final Rx<List<Sport>> sportsList = Rx<List<Sport>>([]);
  final Rx<Sport?> currentSport = Rx<Sport?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchAllSports();
  }

  void fetchAllSports() async {
    List<Sport> sports = await sportService.getAllSports();
    sportsList.value = sports;
  }

  void fetchSportById(int sportId) async {
    Sport sport = await sportService.getSportById(sportId);
    currentSport.value = sport;
  }
}
