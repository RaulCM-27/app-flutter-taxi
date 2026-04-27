import 'package:flutter/material.dart';
import 'package:app_taxi/models/driver.dart';

class DriverCard extends StatelessWidget {
  final Driver driver;

  const DriverCard({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Avatar
          CircleAvatar(
            radius: 25,
            backgroundColor: const Color(0xFF2E4E73),
            child: Text(
              driver.nombre.isNotEmpty ? driver.nombre[0].toUpperCase() : '?',
              style: const TextStyle(color: Colors.white),
            ),
          ),

          const SizedBox(width: 12),

          /// Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driver.nombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "CC: ${driver.cedula}",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ],
            ),
          ),

          /// Estado
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text("Libre"),
          ),

          const SizedBox(width: 8),

          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
