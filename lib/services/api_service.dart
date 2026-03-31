import "dart:convert";

import "package:http/http.dart" as http;

/// Clase de servicio para manejar las solicitudes a la API del backend de la aplicación de taxi.
/// Esta clase proporciona métodos para autenticar usuarios y obtener datos del servidor.
class LoginResult {
  final bool success;
  final String message;

  LoginResult({required this.success, required this.message});
}

class ApiService {
  /// La URL base para el servidor de la API.
  /// Nota: Cambia a "http://10.0.2.2:8080" si usas emulador Android, o a tu IP de host (ej. "http://192.168.1.100:8080") si usas dispositivo físico.
  static const String baseUrl = "http://10.0.2.2:8080";

  /// Inicia sesión de un usuario con el nombre de usuario y contraseña proporcionados.
  ///
  /// Llama al endpoint POST /auth/login y retorna un `LoginResult` con:
  /// - success=true cuando el usuario se autentica con 200.
  /// - success=false con mensaje según 401/404/u otros.
  ///
  /// Envía una solicitud POST al endpoint de login con las credenciales.
  /// Devuelve un [LoginResult] con el status de la operación y un mensaje amigable.
  static Future<LoginResult> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/auth/login");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      return LoginResult(success: true, message: "Login exitoso");
    } else if (response.statusCode == 401) {
      return LoginResult(success: false, message: "Contraseña incorrecta");
    } else if (response.statusCode == 404) {
      return LoginResult(success: false, message: "Usuario no encontrado");
    } else {
      // Para otros códigos, devolvemos mensaje del backend si está en texto plano.
      final serverMessage = response.body.isNotEmpty
          ? response.body
          : "Error de servidor ${response.statusCode}";
      return LoginResult(success: false, message: serverMessage);
    }
  }

  /// Obtiene la lista de conductores desde la API.
  ///
  /// Envía una solicitud GET al endpoint de conductores e imprime los datos de respuesta
  /// si es exitosa, o imprime un mensaje de error si la solicitud falla.
  Future<void> obtenerConductores() async {
    final url = Uri.parse('http://localhost:8080/api/conductores');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(data);
    } else {
      print('Error: ${response.statusCode}');
    }
  }
}
