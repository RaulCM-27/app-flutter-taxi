/// Used in: (no screens found)
import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
// TARJETA DEL MENÚ (REUTILIZABLE)
// ─────────────────────────────────────────────
class MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const MenuCard({
    super.key,
    required this.icon,
    required this.label,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap:
            onTap ??
            () {}, // Usar callback si está definido, sino función vacía
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 2)
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor ?? const Color(0xFF2E4E73), size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: iconColor ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
