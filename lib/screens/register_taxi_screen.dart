import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/modern_input.dart';
import 'package:app_taxi/widgets/save_button.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:flutter/material.dart';

class RegisterTaxiScreen extends StatefulWidget {
  const RegisterTaxiScreen({super.key});

  @override
  State<RegisterTaxiScreen> createState() => _RegisterTaxiScreenState();
}

class _RegisterTaxiScreenState extends State<RegisterTaxiScreen> {
  final TextEditingController placaController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController modeloController = TextEditingController();

  bool loading = false;

  void registrarTaxi() async {
    FocusScope.of(context).unfocus();

    final placa = placaController.text.trim();
    final marca = marcaController.text.trim();
    final modelo = modeloController.text.trim();

    if (placa.isEmpty || marca.isEmpty || modelo.isEmpty) {
      _showMessage("Completa todos los campos correctamente");
      return;
    }

    setState(() => loading = true);

    try {
      final result = await ApiService.registerTaxi(
        placa: placa,
        marca: marca,
        modelo: modelo,
      );

      if (!mounted) return;
      setState(() => loading = false);

      if (result.success) {
        Navigator.pop(context, true);
      } else {
        _showMessage(result.message);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      _showMessage("No se pudo conectar con el servidor");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    placaController.dispose();
    marcaController.dispose();
    modeloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: "Nuevo Taxi",
              onBack: () => Navigator.pop(context),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Registrar Taxi",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "La placa será el ID único del taxi",
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ModernInput(
                            label: "Placa *",
                            hint: "ABC123",
                            controller: placaController,
                          ),
                          const SizedBox(height: 16),
                          ModernInput(
                            label: "Marca *",
                            hint: "Toyota",
                            controller: marcaController,
                          ),
                          const SizedBox(height: 16),
                          ModernInput(
                            label: "Modelo *",
                            hint: "Corolla",
                            controller: modeloController,
                          ),

                          const SizedBox(height: 24),
                          SaveButton(
                            loading: loading,
                            onPressed: registrarTaxi,
                            text: "Registrar Taxi",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
