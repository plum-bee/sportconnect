import 'package:flutter/material.dart';

class SportIconGetter {
  static Widget getSportIcon(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'basketball':
        return const Icon(Icons.sports_basketball, color: Colors.orange);
      case 'football':
      case 'soccer':
        return const Icon(Icons.sports_soccer, color: Colors.grey);
      case 'paddle tennis':
        return const Icon(Icons.sports_tennis, color: Colors.yellow);
      case 'table tennis':
        return const Icon(Icons.sports_tennis, color: Colors.pink);
      case 'cycling':
        return const Icon(Icons.directions_bike, color: Colors.deepOrange);
      case 'handball':
        return const Icon(Icons.sports_handball, color: Colors.purple);
      case 'rugby':
        return const Icon(Icons.sports_rugby, color: Colors.brown);
      case 'swimming':
        return const Icon(Icons.pool, color: Colors.lightBlue);
      case 'athletics':
        return const Icon(Icons.directions_run, color: Colors.red);
      case 'golf':
        return const Icon(Icons.sports_golf, color: Colors.green);
      default:
        return const Icon(Icons.sports, color: Colors.blue);
    }
  }
}
