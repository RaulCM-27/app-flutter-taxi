import 'package:flutter/material.dart';
import 'package:app_taxi/models/driver.dart';

class DriverProfileHeader extends StatelessWidget {
  final Driver driver;

  const DriverProfileHeader({super.key, required this.driver});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF2E4E73),
          child: Text(
            driver.nombre.isNotEmpty ? driver.nombre[0].toUpperCase() : '?',
            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          driver.nombre,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
