import 'package:flutter/material.dart';
import 'package:app_taxi/models/taxi.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/info_card.dart';
import 'package:app_taxi/widgets/screen_header.dart';
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

  void _eliminarTaxi() async {
    if (taxi.id == null) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Taxi"),
          content: const Text("¿Seguro que deseas eliminar este taxi?"),
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

    final result = await ApiService.deleteTaxi(taxi.id!);

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

            TaxiProfileHeader(taxi: taxi),

            const SizedBox(height: 20),

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

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// BOTÓN ELIMINAR
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _eliminarTaxi,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),

                      icon: const Icon(Icons.delete),

                      label: const Text("Eliminar Taxi"),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// BOTÓN VOLVER
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
