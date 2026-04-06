/// Used in: (no screens found)
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';

// ─────────────────────────────────────────────
// HEADER DE LA PANTALLA PRINCIPAL
// ─────────────────────────────────────────────
class Header extends StatelessWidget {
  final String username;

  const Header({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF2E4E73),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Bienvenido,',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 5),
              Text(
                username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
