import "dart:convert";
import "package:app_taxi/models/driver.dart";
import "package:app_taxi/models/taxi.dart";
import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class ApiResult {
  final bool success;
  final String message;

  ApiResult({required this.success, required this.message});
}

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://proyecto-api-taxis.onrender.com', // ✅ cambia esto
  );

  // ✅ guarda ambos tokens
  static Future<void> saveTokens(String token, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('refreshToken', refreshToken);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  // ✅ borra ambos tokens
  static Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('refreshToken');
  }

  // ✅ headers con access token
  static Future<Map<String, String>> _authHeaders() async {
    final token = await getToken();
    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  // ✅ renueva el access token con el refresh token
  static Future<bool> renewToken() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) return false;

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/refresh"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'token',
          data['token'],
        ); // ✅ solo actualiza el access token
        return true;
      }
    } catch (e) {
      debugPrint("Error renovando token: $e");
    }
    return false;
  }

  // ✅ maneja el 401 automáticamente
  static Future<http.Response?> _retryWithRefresh(
    Future<http.Response> Function() request,
  ) async {
    var response = await request();

    if (response.statusCode == 401) {
      final renewed = await renewToken();
      if (renewed) {
        response = await request(); // reintenta con nuevo token
      } else {
        await _clearTokens();
        return null; // señal de sesión expirada
      }
    }
    return response;
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
        await saveTokens(data['token'], data['refreshToken']); // ✅ guarda ambos
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
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  // LOGOUT
  static Future<void> logout() async {
    await _clearTokens();
  }

  // CONDUCTORES - GET
  static Future<List<Driver>> getConductores() async {
    final url = Uri.parse("$baseUrl/api/conductores");

    try {
      final response = await _retryWithRefresh(
        () async => http.get(url, headers: await _authHeaders()),
      );

      if (response != null && response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Driver.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  // CONDUCTORES - POST
  static Future<ApiResult> registerDriver({
    required String nombre,
    required String cedula,
    required int telefono,
    int? taxiId,
  }) async {
    final url = Uri.parse("$baseUrl/api/conductores");
    try {
      final response = await _retryWithRefresh(
        () async => http.post(
          url,
          headers: await _authHeaders(),
          body: jsonEncode({
            "nombre": nombre,
            "cedula": cedula,
            "telefono": telefono,
            "taxi": {"id": taxiId},
          }),
        ),
      );
      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }
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
      }
      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
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
    int? taxiId,
  }) async {
    final url = Uri.parse("$baseUrl/api/conductores/$id");
    try {
      final response = await _retryWithRefresh(
        () async => http.put(
          url,
          headers: await _authHeaders(),
          body: jsonEncode({
            "nombre": nombre,
            "cedula": cedula,
            "telefono": telefono,
            "taxi": {"id": taxiId},
          }),
        ),
      );

      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }

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
      }
      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  //CONDUCTOR - DELETE
  static Future<ApiResult> deleteConductor(int id) async {
    final url = Uri.parse("$baseUrl/api/conductores/$id");
    try {
      final response = await _retryWithRefresh(
        () async => http.delete(url, headers: await _authHeaders()),
      );

      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Conductor eliminado",
        );
      } else if (response.statusCode == 404) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Conductor no encontrado",
        );
      } 
    
      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  // TAXIS - GET
  static Future<List<Taxi>> getTaxis() async {
    final url = Uri.parse("$baseUrl/api/taxis");

    try {
      final response = await _retryWithRefresh(
        () async => http.get(url, headers: await _authHeaders()),
      );

      if (response != null && response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        return data.map((e) => Taxi.fromJson(e)).toList();
      }

      return [];
    } catch (e) {
      return [];
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
      final response = await _retryWithRefresh(
        () async => http.post(
          url,
          headers: await _authHeaders(),
          body: jsonEncode({
            "placa": placa,
            "marca": marca,
            "modelo": modelo,
          }),
        ),
      );
      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }
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
      }
      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  // TAXIS - PUT
  static Future<ApiResult> updateTaxi({
    required int id,
    required String placa,
    required String marca,
    required String modelo,
  }) async {
    final url = Uri.parse("$baseUrl/api/taxis/$id");
    try {
      final response = await _retryWithRefresh(
        () async => http.put(
          url,
          headers: await _authHeaders(),
          body: jsonEncode({
            "placa": placa,
            "marca": marca,
            "modelo": modelo,
          }),
        ),
      );

      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Taxi actualizado",
        );
      } else if (response.statusCode == 404) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Taxi no encontrado",
        );
      }

      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }

  // TAXIS - DELETE
  static Future<ApiResult> deleteTaxi(int id) async {
    final url = Uri.parse("$baseUrl/api/taxis/$id");
    try {
      final response = await _retryWithRefresh(
        () async => http.delete(url, headers: await _authHeaders()),
      );

      if (response == null) {
        return ApiResult(success: false, message: "SESION_EXPIRADA");
      }

      final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResult(
          success: true,
          message: data?["message"] ?? "Taxi eliminado",
        );
      } else if (response.statusCode == 404) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "Taxi no encontrado",
        );
      } else if (response.statusCode == 409) {
        return ApiResult(
          success: false,
          message: data?["message"] ?? "El taxi tiene un conductor asignado",
        );
      }

      return ApiResult(
        success: false,
        message: data?["message"] ?? "Error ${response.statusCode}",
      );
    } catch (e) {
      return ApiResult(success: false, message: "Error de conexión");
    }
  }
}
