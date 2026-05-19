import 'dart:io';
import 'package:flutter/material.dart';
import 'package:app_taxi/models/driver.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/info_card.dart';
import 'package:app_taxi/widgets/driver_profile_header.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';

class DetailDriverScreen extends StatefulWidget {
  final Driver driver;

  const DetailDriverScreen({super.key, required this.driver});

  @override
  State<DetailDriverScreen> createState() => _DetailDriverScreenState();
}

class _DetailDriverScreenState extends State<DetailDriverScreen> {
  late Driver driver;
  bool isUpdating = false;
  final ScreenshotController _screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    driver = widget.driver;
  }

  // ✅ captura el QR como imagen
  Future<File?> _capturarQR() async {
    final image = await _screenshotController.capture();
    if (image == null) return null;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/qr_${driver.cedula}.png');
    await file.writeAsBytes(image);
    return file;
  }

  // ✅ descarga en galería
  Future<void> _descargarQR() async {
    final image = await _screenshotController.capture();
    if (image == null) return;

    final result = await SaverGallery.saveImage(
      image,
      fileName: 'qr_${driver.cedula}',
      androidRelativePath: "Pictures",
      skipIfExists: false,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.isSuccess
              ? "QR guardado en galería ✅"
              : "No se pudo guardar ❌",
        ),
      ),
    );
  }

  // ✅ compartir
  Future<void> _compartirQR() async {
    final file = await _capturarQR();
    if (file == null) return;

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'QR de ${driver.nombre} - ${driver.placaTaxi}');
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

    setState(() => isUpdating = true);
    final result = await ApiService.deleteConductor(driver.id!);
    if (!mounted) return;
    setState(() => isUpdating = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));

    if (result.success) Navigator.pop(context, true);
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

              Navigator.pop(context);
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
                  if (result.success) {
                    driver = Driver(
                      id: driver.id,
                      nombre: nuevoNombre,
                      cedula: driver.cedula,
                      telefono: nuevoTel,
                      placaTaxi: driver.placaTaxi,
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
    final qrData = driver.placaTaxi != null
        ? '${driver.placaTaxi} - ${driver.nombre}'
        : null;

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
            DriverProfileHeader(driver: driver),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
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
                      value: driver.telefono?.toString() ?? "No disponible",
                    ),
                    const SizedBox(height: 12),
                    InfoCard(
                      icon: Icons.taxi_alert,
                      title: "Placa del Taxi",
                      value: driver.placaTaxi ?? "No disponible",
                    ),

                    const SizedBox(height: 12),

                    if (qrData != null)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Código QR",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // ✅ envuelve el QR con Screenshot
                            Screenshot(
                              controller: _screenshotController,
                              child: Container(
                                color: Colors.white,
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 200,
                                      height: 200,
                                      child: QrImageView(
                                        data: qrData,
                                        version: QrVersions.auto,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      qrData,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // ✅ botones compartir y descargar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: _compartirQR,
                                  icon: const Icon(Icons.share),
                                  label: const Text("Compartir"),
                                ),
                                OutlinedButton.icon(
                                  onPressed: _descargarQR,
                                  icon: const Icon(Icons.download),
                                  label: const Text("Descargar"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            if (isUpdating)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _showEditDialog,
                      icon: const Icon(Icons.edit),
                      label: const Text("Modificar Datos"),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
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
