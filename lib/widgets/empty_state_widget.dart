import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No hay conductores registrados',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
      ),
    );
  }
}
