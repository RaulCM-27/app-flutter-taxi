/// Used in: home_screen.dart
import 'package:flutter/material.dart';
import 'menu_card.dart';
import '../screens/register_driver_screen.dart';

// ─────────────────────────────────────────────
// GRID DEL MENÚ PRINCIPAL
// ─────────────────────────────────────────────
class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  void _navigateToRegisterDriver(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterDriverScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.5,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          MenuCard(icon: Icons.local_taxi, label: 'Nuevo Taxi'),
          MenuCard(
            icon: Icons.person_add,
            label: 'Nuevo Conductor',
            onTap: () => _navigateToRegisterDriver(context),
          ),
          MenuCard(
            icon: Icons.swap_horiz,
            label: 'Asignar Turno',
            backgroundColor: Color(0xFFF4B942),
          ),
          MenuCard(icon: Icons.description, label: 'Reportes'),
        ],
      ),
    );
  }
}
