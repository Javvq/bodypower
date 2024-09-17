import 'dart:convert';
import 'package:http/http.dart' as http;

class DatabaseHelper {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Map<String, dynamic>>> getExercisesByDifficulty(String difficulty) async {
    final response = await http.get(Uri.parse('$baseUrl/exercises/$difficulty'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener ejercicios');
    }
  }

  Future<void> insertExercise(Map<String, dynamic> exercise) async {
    final response = await http.post(
      Uri.parse('$baseUrl/exercises'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(exercise),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al añadir ejercicio');
    }
  }

  Future<List<Map<String, dynamic>>> getExercises() async {
    final response = await http.get(Uri.parse('$baseUrl/exercises'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Error al obtener ejercicios');
    }
  }
}
