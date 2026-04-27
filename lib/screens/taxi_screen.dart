import 'dart:convert';
import 'package:app_taxi/models/taxi.dart';
import 'package:app_taxi/services/api_service.dart';
import 'package:app_taxi/widgets/empty_state_widget.dart';
import 'package:app_taxi/widgets/screen_header.dart';
import 'package:app_taxi/widgets/search_bar_widget.dart';
import 'package:app_taxi/widgets/taxi_card.dart';
import 'package:flutter/material.dart';

class TaxiScreen extends StatefulWidget {
  const TaxiScreen({super.key});

  @override
  State<TaxiScreen> createState() => TaxiScreenState();
}

class TaxiScreenState extends State<TaxiScreen> {
  List<Taxi> taxis = [];
  List<Taxi> filteredTaxis = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTaxis();
  }

  Future<void> fetchTaxis() async {
    setState(() => isLoading = true);

    final result = await ApiService.getTaxis();

    if (result.success) {
      try {
        final List data = jsonDecode(result.message);
        final taxisList = data.map((e) => Taxi.fromJson(e)).toList();

        setState(() {
          taxis = taxisList;
          filteredTaxis = taxisList;
          isLoading = false;
        });
      } catch (e) {
        setState(() => isLoading = false);
        _showError("Error al procesar datos");
      }
    } else {
      setState(() => isLoading = false);
      _showError("Error al cargar taxis");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  void filterTaxis(String query) {
    final results = taxis.where((taxi) {
      final placa = taxi.placa.toLowerCase();
      final marca = taxi.marca.toLowerCase();
      final input = query.toLowerCase();

      return placa.contains(input) || marca.contains(input);
    }).toList();

    setState(() => filteredTaxis = results);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const ScreenHeader(title: 'Taxis'),
          const SizedBox(height: 16),

          SearchBarWidget(onChanged: filterTaxis),

          const SizedBox(height: 10),

          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredTaxis.isEmpty
                ? const EmptyStateWidget()
                : RefreshIndicator(
                    onRefresh: fetchTaxis,
                    child: ListView.builder(
                      itemCount: filteredTaxis.length,
                      itemBuilder: (context, index) {
                        final taxi = filteredTaxis[index];
                        return TaxiCard(key: ValueKey(taxi.placa), taxi: taxi);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
