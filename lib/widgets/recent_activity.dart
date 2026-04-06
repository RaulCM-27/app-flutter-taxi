/// Used in: home_screen.dart
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// SECCIÓN DE ACTIVIDAD RECIENTE
// ─────────────────────────────────────────────
class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Ultima Actividad',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text('Ver todo', style: TextStyle(color: Colors.blue)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text(
                'No hay actividad reciente',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
