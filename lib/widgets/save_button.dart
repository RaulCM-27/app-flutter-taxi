/// Used in: register_driver_screen.dart
import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.save),
              label: const Text("Guardar Conductor"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
    );
  }
}
