import 'package:app_taxi/models/taxi.dart';
import 'package:flutter/material.dart';

class TaxiProfileHeader extends StatelessWidget {
  final Taxi taxi;

  const TaxiProfileHeader({
    super.key,
    required this.taxi,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: const Color(0xFF2E4E73),

          child: Text(
            taxi.placa.isNotEmpty
                ? taxi.placa[0].toUpperCase()
                : '?',

            style: const TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          taxi.placa,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        
      ],
    );
  }
}