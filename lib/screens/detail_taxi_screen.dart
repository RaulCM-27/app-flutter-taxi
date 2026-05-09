import 'package:flutter/material.dart';
import 'package:app_taxi/models/taxi.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/info_card.dart';
import 'package:app_taxi/widgets/taxi_profile_header.dart';

class DetailTaxiScreen extends StatefulWidget {
  final Taxi taxi;

  const DetailTaxiScreen({super.key, required this.taxi});

  @override
  State<DetailTaxiScreen> createState() => _DetailTaxiScreenState();
}

class _DetailTaxiScreenState extends State<DetailTaxiScreen> {
  late Taxi taxi;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    taxi = widget.taxi;
  }

  void _showEditDialog() {
    final marcaController = TextEditingController(text: taxi.marca);
    final modeloController = TextEditingController(text: taxi.modelo);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Editar Taxi"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: "Marca"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: "Modelo"),
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
              final nuevaMarca = marcaController.text.trim();
              final nuevoModelo = modeloController.text.trim();

              if (nuevaMarca.isEmpty || nuevoModelo.isEmpty) return;
              if (taxi.id == null) return;

              Navigator.pop(context);
              setState(() => isUpdating = true);

              final result = await ApiService.updateTaxi(
                id: taxi.id!,
                placa: taxi.placa,
                marca: nuevaMarca,
                modelo: nuevoModelo,
                conductorId: taxi.conductor?.id,
              );

              if (mounted) {
                setState(() {
                  isUpdating = false;
                  if (result.success) {
                    taxi = Taxi(
                      id: taxi.id,
                      placa: taxi.placa,
                      marca: nuevaMarca,
                      modelo: nuevoModelo,
                      conductor: taxi.conductor,
                    );
                  }
                });

                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(result.message)));
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
              title: 'Detalle del Taxi',
              onBack: () => Navigator.pop(context),
            ),

            const SizedBox(height: 20),

            /// HEADER
            TaxiProfileHeader(taxi: taxi),

            const SizedBox(height: 20),

            /// INFORMACIÓN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),

              child: Column(
                children: [
                  InfoCard(
                    icon: Icons.confirmation_number,
                    title: "Placa",
                    value: taxi.placa,
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.branding_watermark,
                    title: "Marca",
                    value: taxi.marca,
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.calendar_month,
                    title: "Modelo",
                    value: taxi.modelo,
                  ),

                  const SizedBox(height: 12),

                  InfoCard(
                    icon: Icons.person,
                    title: "Conductor",
                    value: taxi.conductor?.nombre ?? "No asignado",
                  ),
                ],
              ),
            ),

            if (isUpdating)
              const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(),
              ),

            const Spacer(),

            /// BOTONES
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
