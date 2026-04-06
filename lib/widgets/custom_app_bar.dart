/// Used in: register_driver_screen.dart, home_screen.dart
import 'package:flutter/material.dart';
import 'package:app_taxi/utils/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.centerTitle = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: primaryBlue,
      elevation: 0,
      centerTitle: centerTitle,
      title: title,
      leading: onBack == null
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            ),
      actions: actions,
    );
  }
}
