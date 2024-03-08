import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sportconnect/src/pages/splash_screen.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:sportconnect/src/pages/register_screen.dart';
import 'package:sportconnect/src/pages/search_screen.dart';
import 'package:sportconnect/src/pages/profile_screen.dart';
import 'package:sportconnect/src/pages/test_screen.dart';

class SportConnectApp extends StatelessWidget {
  const SportConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Flutter',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.green,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.green,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
          ),
        ),
      ),
      initialRoute: '/splash',
      routes: <String, WidgetBuilder>{
        '/': (_) => const Scaffold(
              body: Center(
                child: Text('Hello World!'),
              ),
            ),
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => RegisterScreen(),
        '/search': (_) => const SearchScreen(),
        '/profile': (_) => UserProfileScreen(),
      },
    );
  }
}
