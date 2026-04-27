import "dart:convert";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

/// Resultado genérico para respuestas de la API
class ApiResult {
  final bool success;
  final String message;

  ApiResult({required this.success, required this.message});
}

class ApiService {
  static const String baseUrl = "http://10.0.2.2:8080";

  static Future<ApiResult> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: response.body, // 👈 NO jsonDecode
        );
      } else if (response.statusCode == 401) {
        return ApiResult(success: false, message: "Contraseña incorrecta");
      } else if (response.statusCode == 404) {
        return ApiResult(success: false, message: "Usuario no encontrado");
      } else {
        return ApiResult(
          success: false,
          message: "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(
        success: false,
        message: "Error de conexión. Verifica tu internet.",
      );
    }
  }

  static Future<ApiResult> registerDriver({
    required String nombre,
    required String cedula,
    required int telefono,
  }) async {
    final url = Uri.parse("$baseUrl/api/conductores");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "cedula": cedula,
          "telefono": telefono,
        }),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Conductor registrado correctamente",
        );
      } else if (response.statusCode == 409) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "La cédula ya está registrada",
        );
      } else if (response.statusCode == 400) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Datos inválidos",
        );
      } else {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  static Future<ApiResult> registerTaxi({
    required String placa,
    required String marca,
    required String modelo,
  }) async {
    final url = Uri.parse("$baseUrl/api/taxis");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"placa": placa, "marca": marca, "modelo": modelo}),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Taxi registrado correctamente",
        );
      } else if (response.statusCode == 409) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "La placa ya está registrada",
        );
      } else if (response.statusCode == 400) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Datos inválidos",
        );
      } else {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  //OPTENER CONDUCTORES
  static Future<ApiResult> getConductores() async {
    final url = Uri.parse("$baseUrl/api/conductores");

    try {
      final response = await http.get(url);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResult(success: true, message: response.body);
      } else {
        return ApiResult(
          success: false,
          message: "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  //OBTENER TAXIS
  static Future<ApiResult> getTaxis() async {
    final url = Uri.parse("$baseUrl/api/taxis");

    try {
      final response = await http.get(url);

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      if (response.statusCode == 200) {
        return ApiResult(success: true, message: response.body);
      } else {
        return ApiResult(
          success: false,
          message: "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  //ACTUALIZAR CONDUCTOR
  static Future<ApiResult> updateConducor({
    required int id,
    required String nombre,
    required String cedula,
    required int telefono,
  }) async {
    final url = Uri.parse("$baseUrl/api/conductores/$id");

    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "cedula": cedula,
          "telefono": telefono,
        }),
      );

      debugPrint("STATUS: ${response.statusCode}");
      debugPrint("BODY: ${response.body}");

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Conductor actualizado correctamente",
        );
      } else if (response.statusCode == 404) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Conductor no encontrado",
        );
      } else if (response.statusCode == 400) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Datos inválidos",
        );
      } else {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Error ${response.statusCode}",
        );
      }
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }
}
