import 'package:flutter/material.dart';
import 'package:sportconnect/src/pages/login_screen.dart';

void main() {
  runApp(const LoginScreen());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
