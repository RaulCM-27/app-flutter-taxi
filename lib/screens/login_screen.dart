import 'package:flutter/material.dart';
import 'package:app_taxi/services/api_service.dart';
import 'home_screen.dart';

/// Pantalla de inicio de sesión de la aplicación.
///
/// Contiene campos de texto para usuario y contraseña, botón de login y
/// validación básica de entrada. Llama a `ApiService.login` y navega a
/// `HomeScreen` en caso de éxito.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Indicador de carga que muestra el `CircularProgressIndicator` mientras
  /// se espera la respuesta del servidor.
  bool loading = false;

  void login() async {
    String username = usernameController.text;
    String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Completa los campos")));
      return;
    }

    setState(() {
      loading = true;
    });

    final result = await ApiService.login(username, password);

    if (!mounted) return;

    setState(() {
      loading = false;
    });

    if (result.success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
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
      appBar: AppBar(title: const Text("Login Taxi App")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Usuario",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Contraseña",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: login,
                    child: const Text("Iniciar sesión"),
                  ),
          ],
        ),
      ),
    );
  }
}
