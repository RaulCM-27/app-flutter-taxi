/// Used in: login_screen.dart
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import 'filled_input.dart';
import 'login_button.dart';

// ─────────────────────────────────────────────
// TARJETA PRINCIPAL
// ─────────────────────────────────────────────
class FormCard extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool loading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;

  const FormCard({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.obscurePassword,
    required this.loading,
    required this.onTogglePassword,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ICONO
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFF3E5C3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_car, color: Colors.amber),
          ),

          const SizedBox(height: 16),

          // TITULO
          Text(
            "COOTRASAMBER",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primaryBlue,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "San Bernardo - Lorica",
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 24),

          // EMAIL
          FilledInput(
            label: "Nombre de usuario",
            hint: "admin",
            controller: usernameController,
          ),

          const SizedBox(height: 16),

          // PASSWORD
          FilledInput(
            label: "Contraseña",
            hint: "********",
            controller: passwordController,
            obscureText: obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
              ),
              onPressed: onTogglePassword,
            ),
          ),

          const SizedBox(height: 24),

          // BOTON
          LoginButton(loading: loading, onPressed: onLogin),

          const SizedBox(height: 16),

          const Text(
            "Sistema de administracion de la cooperativa",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.black45),
          ),
        ],
      ),
    );
  }
}
