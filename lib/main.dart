import 'package:app_taxi/screens/login_screen.dart';
import 'package:app_taxi/screens/home_screen.dart';
import 'package:app_taxi/utils/session_manager.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: SessionManager.navigatorKey,
      initialRoute: '/login',

      routes: {
        '/login': (context) => const LoginScreen(),

        '/home': (context) {
          final username =
              ModalRoute.of(context)!.settings.arguments as String;

          return HomeScreen(username: username);
        },
      },
    );
  }
}