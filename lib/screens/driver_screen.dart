import 'package:app_taxi/models/driver.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/screens/detail_driver_screen.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/search_bar_widget.dart';
import 'package:app_taxi/widgets/driver_card.dart';
import 'package:app_taxi/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => DriverScreenState();
}

class DriverScreenState extends State<DriverScreen> {
  List<Driver> drivers = [];
  List<Driver> filteredDrivers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
  setState(() => isLoading = true);

  try {
    final driversList = await ApiService.getConductores();

    setState(() {
      drivers = driversList;
      filteredDrivers = driversList;
      isLoading = false;
    });
  } catch (e) {
    setState(() => isLoading = false);
    _showError("Error al cargar conductores");
  }
}

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void filterDrivers(String query) {
    final results = drivers.where((driver) {
      final nombre = driver.nombre.toLowerCase();
      final cedula = driver.cedula.toLowerCase();
      final input = query.toLowerCase();

      return nombre.contains(input) || cedula.contains(input);
    }).toList();

    setState(() => filteredDrivers = results);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const ScreenHeader(title: 'Conductores'),
          const SizedBox(height: 16),

          SearchBarWidget(onChanged: filterDrivers),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredDrivers.isEmpty
                ? const EmptyStateWidget()
                : RefreshIndicator(
                    onRefresh: fetchDrivers,
                    child: ListView.builder(
                      itemCount: filteredDrivers.length,
                      itemBuilder: (context, index) {
                        final driver = filteredDrivers[index];

                        return InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailDriverScreen(driver: driver),
                              ),
                            );
                            fetchDrivers();
                          },
                          child: DriverCard(
                            key: ValueKey(driver.cedula),
                            driver: driver,
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

