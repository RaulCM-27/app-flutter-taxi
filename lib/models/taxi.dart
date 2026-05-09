import 'package:app_taxi/models/driver.dart';

class Taxi {
  final int? id;
  final String placa;
  final String marca;
  final String modelo;
  final Driver? conductor;

  Taxi({
    this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
    this.conductor,
  });

  factory Taxi.fromJson(Map<String, dynamic> json) {
    return Taxi(
      id: json['id'],
      placa: json['placa'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
      conductor: json['conductor'] != null
          ? Driver.fromJson(json['conductor'])
          : null,
    );
  }
}