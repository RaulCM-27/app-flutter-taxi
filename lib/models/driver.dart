class Driver {
  final int? id;
  final String nombre;
  final String cedula;
  final int? telefono;
  final String? placaTaxi;

  Driver({
    this.id,
    required this.nombre,
    required this.cedula,
    this.telefono,
    this.placaTaxi,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      nombre: json['nombre'] ?? '',
      cedula: json['cedula'] ?? '',
      telefono: json['telefono'] != null
          ? int.parse(json['telefono'].toString())
          : null,
      placaTaxi: json['taxi'] != null
          ? json['taxi']['placa']
          : null,
    );
  }
}