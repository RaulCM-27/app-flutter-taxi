import 'package:flutter/material.dart';
import 'package:app_taxi/models/driver.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/info_card.dart';
import 'package:app_taxi/widgets/driver_profile_header.dart';

class DetailDriverScreen extends StatefulWidget {
  final Driver driver;

  const DetailDriverScreen({super.key, required this.driver});

  @override
  State<DetailDriverScreen> createState() => _DetailDriverScreenState();
}

class _DetailDriverScreenState extends State<DetailDriverScreen> {
  late Driver driver;

  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    driver = widget.driver;
  }

  void _eliminarConductor() async {
    if (driver.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Conductor"),
          content: const Text("¿Seguro que deseas eliminar este conductor?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    setState(() {
      isUpdating = true;
    });

    final result = await ApiService.deleteConductor(driver.id!);

    if (!mounted) return;

    setState(() {
      isUpdating = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) {
      Navigator.pop(context, true);
    }
  }

  void _showEditDialog() {
    final nameController = TextEditingController(text: driver.nombre);
    final phoneController = TextEditingController(
      text: driver.telefono?.toString() ?? "",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Conductor"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              final nuevoNombre = nameController.text.trim();
              final nuevoTel = int.tryParse(phoneController.text.trim());

              if (nuevoNombre.isEmpty || nuevoTel == null) return;
              if (driver.id == null) return;

              Navigator.pop(context); // ✅ Cierra el diálogo primero
              setState(() => isUpdating = true);

              final result = await ApiService.updateConducor(
                id: driver.id!,
                nombre: nuevoNombre,
                cedula: driver.cedula,
                telefono: nuevoTel,
              );

              if (mounted) {
                setState(() {
                  isUpdating = false;
                  // ✅ Actualiza el driver en el mismo setState
                  if (result.success) {
                    driver = Driver(
                      id: driver.id,
                      nombre: nuevoNombre,
                      cedula: driver.cedula,
                      telefono: nuevoTel,
                    );
                  }
                });

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(result.message)));
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: SafeArea(
        child: Column(
          children: [
            ScreenHeader(
              title: 'Detalle de Conductores',
              onBack: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            /// 🔹 AVATAR + NOMBRE
            DriverProfileHeader(
              driver: driver,
            ), // Se actualiza automáticamente al cambiar el estado

            const SizedBox(height: 20),

            /// 🔹 INFORMACIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  InfoCard(
                    icon: Icons.badge,
                    title: "Cédula",
                    value: driver.cedula,
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.phone,
                    title: "Teléfono",
                    value:
                        driver.telefono?.toString() ??
                        "No disponible", // Se actualiza automáticamente
                  ),   

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.taxi_alert,
                    title: "Placa del Taxi",
                    value: driver.placaTaxi ?? "No disponible",    
                  )   
                ],
              ),
            ),

            if (isUpdating)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            const Spacer(),

            /// 🔹 BOTONES
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// BOTÓN MODIFICAR
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Modificar Datos"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  ///BOTÓN ELIMINAR
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: _eliminarConductor,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),

                      icon: const Icon(Icons.delete),

                      label: const Text("Eliminar Conductor"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// BOTÓN VOLVER
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E4E73),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Volver"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
