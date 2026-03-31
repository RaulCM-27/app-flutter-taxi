import 'package:flutter/material.dart';
import 'login_screen.dart';

/// Pantalla principal de la aplicación después del login.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - Taxi App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido a la app de taxi!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
