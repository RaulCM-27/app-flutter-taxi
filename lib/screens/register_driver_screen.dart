import 'package:flutter/material.dart';
import 'package:app_taxi/widgets/custom_app_bar.dart';
import 'package:app_taxi/widgets/modern_input.dart';
import 'package:app_taxi/widgets/save_button.dart';
import 'package:app_taxi/widgets/bottom_nav_bar.dart';
import 'package:app_taxi/services/api_service.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() => _RegisterDriverScreenState();
}

class _RegisterDriverScreenState extends State<RegisterDriverScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool loading = false;

  void registrarConductor() async {
    final nombre = nameController.text.trim();
    final cedula = cedulaController.text.trim();
    final telefono = int.tryParse(phoneController.text.trim());

    /// VALIDACIONES
    if (nombre.isEmpty || cedula.isEmpty || telefono == null) {
      _showMessage("Completa todos los campos correctamente");
      return;
    }

    setState(() => loading = true);

    try {
      final result = await ApiService.registerDriver(
        nombre: nombre,
        cedula: cedula,
        telefono: telefono,
      );

      if (!mounted) return;

      setState(() => loading = false);

      _showMessage(result.message);

      if (result.success) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() => loading = false);

      _showMessage("Error de conexión");
    }
  }

  /// 🔹 Método reutilizable
  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    nameController.dispose();
    cedulaController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),

      appBar: CustomAppBar(
        title: const Text(
          'Nuevo Conductor',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        onBack: () => Navigator.pop(context),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Registrar Conductor",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "La cédula será el ID único del conductor",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ModernInput(
                    label: "Nombre Completo *",
                    hint: "Jose Perez",
                    controller: nameController,
                  ),

                  const SizedBox(height: 16),

                  ModernInput(
                    label: "Cédula *",
                    hint: "123456789",
                    controller: cedulaController,
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 16),

                  ModernInput(
                    label: "Teléfono *",
                    hint: "3001234567",
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 24),

                  SaveButton(loading: loading, onPressed: registrarConductor),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomNavBar(selectedIndex: 3),
    );
  }
}
