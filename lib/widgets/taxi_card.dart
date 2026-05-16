import 'package:flutter/material.dart';
import 'package:app_taxi/models/taxi.dart';

class TaxiCard extends StatelessWidget {
  final Taxi taxi;

  const TaxiCard({super.key, required this.taxi});

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
          /// Avatar con Icono de Taxi
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF2E4E73),
            child: Icon(Icons.local_taxi, color: Colors.white, size: 30),
          ),

          const SizedBox(width: 12),

          /// Info del Taxi
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  taxi.placa.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  "${taxi.marca} - ${taxi.modelo}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),

          

          const SizedBox(width: 8),

          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
