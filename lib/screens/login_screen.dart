import 'package:flutter/material.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/utils/constants.dart';
import 'package:app_taxi/widgets/form_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool obscurePassword = true;

  void login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Completa los campos")));
      return;
    }

    setState(() => loading = true);
    final result = await ApiService.login(username, password);
    if (!mounted) return;
    setState(() => loading = false);

    if (result.success) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: username, // ✅
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FormCard(
              usernameController: usernameController,
              passwordController: passwordController,
              obscurePassword: obscurePassword,
              loading: loading,
              onTogglePassword: () =>
                  setState(() => obscurePassword = !obscurePassword),
              onLogin: login,
            ),
          ),
        ),
      ),
    );
  }
}
