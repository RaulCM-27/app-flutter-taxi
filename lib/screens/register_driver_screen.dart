import 'package:flutter/material.dart';
import 'package:app_taxi/widgets/modern_input.dart';
import 'package:app_taxi/widgets/save_button.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/screen_header.dart';

class RegisterDriverScreen extends StatefulWidget {
  const RegisterDriverScreen({super.key});

  @override
  State<RegisterDriverScreen> createState() => _RegisterDriverScreenState();
}

class _RegisterDriverScreenState extends State<RegisterDriverScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cedulaController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController placaController = TextEditingController();

  bool loading = false;

  List<dynamic> taxis = [];
  List<dynamic> taxisFiltrados = [];
  dynamic taxiSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarTaxis();
    placaController.addListener(_filtrarTaxis);
  }

  void _cargarTaxis() async {
    final result = await ApiService.getTaxis();
    setState(() {
      taxis = result; // List<Taxi>
    });
  }

  void _filtrarTaxis() {
    if (taxiSeleccionado != null) return;

    final query = placaController.text.trim();
    setState(() {
      if (query.isEmpty) {
        taxisFiltrados = [];
      } else {
        taxisFiltrados = taxis
            .where(
              (t) => t.placa.toString().contains(query),
            ) // ✅ t.placa no t['placa']
            .toList();
      }
    });
  }

  void _seleccionarTaxi(dynamic taxi) {
    setState(() {
      taxiSeleccionado = taxi;
      placaController.text = taxi.placa.toString();
      taxisFiltrados =
          []; // Asegúrate de convertir a String si placa no es String
    });
  }

  void registrarConductor() async {
    FocusScope.of(context).unfocus();

    final nombre = nameController.text.trim();
    final cedula = cedulaController.text.trim();
    final telefono = int.tryParse(phoneController.text.trim());

    if (nombre.isEmpty || cedula.isEmpty || telefono == null) {
      _showMessage("Completa todos los campos correctamente");
      return;
    }

    if (taxiSeleccionado == null) {
      _showMessage("Selecciona un taxi válido");
      return;
    }

    setState(() => loading = true);

    try {
      final result = await ApiService.registerDriver(
        nombre: nombre,
        cedula: cedula,
        telefono: telefono,
        taxiId: taxiSeleccionado.id,
      );

      if (!mounted) return;
      setState(() => loading = false);

      if (result.success) {
        Navigator.pop(context, true); // 👈 clave
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
    nameController.dispose();
    cedulaController.dispose();
    phoneController.dispose();
    placaController.dispose();
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
              title: 'Nuevo Conductor',
              onBack: () => Navigator.pop(context),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Registrar Conductor",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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

                          const SizedBox(height: 16),

                          ModernInput(
                            label: "Placa del Taxi *",
                            hint: "Escribe la placa",
                            controller: placaController,
                          ),

                          if (taxisFiltrados.isNotEmpty)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: taxisFiltrados.length,
                                itemBuilder: (context, index) {
                                  final t = taxisFiltrados[index];
                                  return ListTile(
                                    leading: const Icon(
                                      Icons.local_taxi,
                                      color: Colors.blue,
                                    ),
                                    title: Text(t.placa),
                                    subtitle: Text("${t.marca} - ${t.modelo}"),
                                    onTap: () => _seleccionarTaxi(t),
                                  );
                                },
                              ),
                            ),

                          if (taxiSeleccionado != null)
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.green.shade300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${taxiSeleccionado.nombre}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 24),
                          SaveButton(
                            loading: loading,
                            onPressed: registrarConductor,
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
