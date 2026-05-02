import "dart:convert";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class ApiResult {
  final bool success;
  final String message;

  ApiResult({required this.success, required this.message});
}

class ApiService {
  // ✅ cambia la URL según el entorno
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8080', // local por defecto
  );

  // ✅ guarda el token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // ✅ obtiene el token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ✅ headers con token para rutas protegidas
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // LOGIN
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
        final data = jsonDecode(response.body);
        await saveToken(data['token']); // ✅ guarda el token
        return ApiResult(success: true, message: "Login exitoso");
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

  // CONDUCTORES - GET
  static Future<ApiResult> getConductores() async {
    final url = Uri.parse("$baseUrl/api/conductores");
    try {
      final response = await http.get(
        url,
        headers: await _authHeaders(),
      ); // ✅ token
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

  // CONDUCTORES - POST
  static Future<ApiResult> registerDriver({
    required String nombre,
    required String cedula,
    required int telefono,
  }) async {
    final url = Uri.parse("$baseUrl/api/conductores");
    try {
      final response = await http.post(
        url,
        headers: await _authHeaders(), // ✅ token
        body: jsonEncode({
          "nombre": nombre,
          "cedula": cedula,
          "telefono": telefono,
        }),
      );
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Conductor registrado",
        );
      } else if (response.statusCode == 409) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "La cédula ya está registrada",
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

  // CONDUCTORES - PUT
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
        headers: await _authHeaders(), // ✅ token
        body: jsonEncode({
          "nombre": nombre,
          "cedula": cedula,
          "telefono": telefono,
        }),
      );
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Conductor actualizado",
        );
      } else if (response.statusCode == 404) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Conductor no encontrado",
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

  // TAXIS - GET
  static Future<ApiResult> getTaxis() async {
    final url = Uri.parse("$baseUrl/api/taxis");
    try {
      final response = await http.get(
        url,
        headers: await _authHeaders(),
      ); // ✅ token
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

  // TAXIS - POST
  static Future<ApiResult> registerTaxi({
    required String placa,
    required String marca,
    required String modelo,
  }) async {
    final url = Uri.parse("$baseUrl/api/taxis");
    try {
      final response = await http.post(
        url,
        headers: await _authHeaders(), // ✅ token
        body: jsonEncode({"placa": placa, "marca": marca, "modelo": modelo}),
      );
      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
      if (response.statusCode == 201 || response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Taxi registrado",
        );
      } else if (response.statusCode == 409) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "La placa ya está registrada",
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
