import 'package:flutter/material.dart';
//import 'package:sportconnect/src/pages/splas_screen.dart';
import 'package:sportconnect/src/pages/login_screen.dart';
import 'package:sportconnect/src/pages/register_screen.dart';
import 'package:sportconnect/src/pages/search_screen.dart';

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
      initialRoute: '/login',
      routes: <String, WidgetBuilder>{
        '/': (_) => const Scaffold(
              body: Center(
                child: Text('Hello World!'),
              ),
            ),
        // '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/search': (_) => const SearchScreen(),
      },
    );
  }
}
