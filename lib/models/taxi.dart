class Taxi {
  final int? id;
  final String placa;
  final String marca;
  final String modelo;

  Taxi({
    this.id,
    required this.placa,
    required this.marca,
    required this.modelo,
  });

  factory Taxi.fromJson(Map<String, dynamic> json) {
    return Taxi(
      id: json['id'],
      placa: json['placa'] ?? '',
      marca: json['marca'] ?? '',
      modelo: json['modelo'] ?? '',
    );
  }
}
