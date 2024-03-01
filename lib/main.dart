import 'package:flutter/material.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:sportconnect/src/pages/register_screen.dart';
import 'package:sportconnect/src/pages/search_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchScreen(),
    );
  }
}
