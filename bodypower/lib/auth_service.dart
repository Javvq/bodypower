import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://localhost:3000';

  // Método para crear un usuario
  Future<Map<String, dynamic>> createUser(
      String nombre,
      String password,
      String rol,
      String adminRole
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nombre': nombre,
        'password': password,
        'rol': rol,
        'adminRole': adminRole,
      }),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Error al crear usuario');
    }
  }
}
