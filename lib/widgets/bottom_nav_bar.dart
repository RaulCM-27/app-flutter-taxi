import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// BARRA DE NAVEGACIÓN INFERIOR
// ─────────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,

      // ✅ AQUÍ ESTÁ LA CLAVE (ANTES LO TENÍAS MAL)
      onDestinationSelected: onItemTapped,

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
