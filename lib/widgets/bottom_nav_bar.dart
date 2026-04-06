/// Used in: register_driver_screen.dart, home_screen.dart
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BARRA DE NAVEGACIÓN INFERIOR
// ─────────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;

  const BottomNavBar({super.key, this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home), label: 'Inicio'),
        NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
        NavigationDestination(icon: Icon(Icons.local_taxi), label: 'Taxis'),
        NavigationDestination(icon: Icon(Icons.people), label: 'Conductores'),
        NavigationDestination(icon: Icon(Icons.person), label: 'Perfil'),
      ],
    );
  }
}
