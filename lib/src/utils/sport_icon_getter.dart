import 'package:flutter/material.dart';

class SportIconGetter {
  static const double _iconSize = 28.0;

  static Icon _styledIcon(IconData iconData, Color iconColor) {
    return Icon(iconData, color: iconColor, size: _iconSize);
  }

  static Icon getSportIcon(String sportName) {
    switch (sportName.toLowerCase()) {
      case 'basketball':
        return _styledIcon(Icons.sports_basketball, Colors.orange.shade800);
      case 'football':
      case 'soccer':
        return _styledIcon(Icons.sports_soccer, Colors.green.shade800);
      case 'paddle tennis':
        return _styledIcon(Icons.sports_tennis, Colors.blue.shade600);
      case 'table tennis':
        return _styledIcon(Icons.sports_tennis, Colors.red.shade700);
      case 'cycling':
        return _styledIcon(Icons.directions_bike, Colors.yellow.shade700);
      case 'handball':
        return _styledIcon(Icons.sports_handball, Colors.purple.shade700);
      case 'rugby':
        return _styledIcon(Icons.sports_rugby, Colors.brown.shade800);
      case 'swimming':
        return _styledIcon(Icons.pool, Colors.cyan.shade600);
      case 'athletics':
        return _styledIcon(Icons.directions_run, Colors.red.shade600);
      case 'golf':
        return _styledIcon(Icons.sports_golf, Colors.green.shade700);
      default:
        return _styledIcon(Icons.sports, Colors.grey.shade700);
    }
  }
}
