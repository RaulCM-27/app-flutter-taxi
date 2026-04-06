/// Used in: (no screens found)
import 'package:flutter/material.dart';
import '../utils/constants.dart';

// ─────────────────────────────────────────────
// BOTON
// ─────────────────────────────────────────────
class LoginButton extends StatelessWidget {
  final bool loading;
  final VoidCallback onPressed;

  const LoginButton({
    super.key,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: loading
          ? const Center(child: CircularProgressIndicator())
          : ElevatedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.login, size: 18),
              label: const Text("Ingresar"),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
    );
  }
}
