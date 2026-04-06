import 'package:flutter/material.dart';
import 'package:app_taxi/screens/login_screen.dart';
import 'package:app_taxi/widgets/custom_app_bar.dart';
import 'package:app_taxi/widgets/menu_grid.dart';
import 'package:app_taxi/widgets/recent_activity.dart';
import 'package:app_taxi/widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: CustomAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bienvenido,',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            Text(
              username,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
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
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const MenuGrid(),
            const SizedBox(height: 20),
            const RecentActivity(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }
}
