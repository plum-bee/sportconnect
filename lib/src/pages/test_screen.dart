import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sportconnect/src/controllers/sport_controller.dart';
import 'package:sportconnect/src/models/sport.dart';

class TestScreen extends StatelessWidget {
  final SportController sportController = Get.put(SportController());

  TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sports List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (sportController.sportsList.value.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView.builder(
                  itemCount: sportController.sportsList.value.length,
                  itemBuilder: (context, index) {
                    Sport sport = sportController.sportsList.value[index];
                    return ListTile(
                      title: Text(sport.name),
                      subtitle: Text('ID: ${sport.id}'),
                      onTap: () {
                        sportController.fetchSportById(sport.id);
                      },
                    );
                  },
                );
              }
            }),
          ),
          Obx(() {
            return Text(
              'Selected Sport: ${sportController.currentSport.value?.name ?? "None"}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          }),
          ElevatedButton(
            onPressed: () {
              int someSportId = 1; // Replace with some valid ID to fetch.
              sportController.fetchSportById(someSportId);
            },
            child: const Text('Fetch Sport with ID 1'),
          ),
        ],
      ),
    );
  }
}
