import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  List<Map<String, dynamic>> _exercises = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchExercises();
  }

  Future<void> _fetchExercises() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/exercises/get'), // Cambia esto a tu endpoint de ejercicios
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _exercises = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Error al obtener ejercicios');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de red. Inténtalo de nuevo.';
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios'),
      ),
      body: Column(
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                final exercise = _exercises[index];
                return ListTile(
                  title: Text(exercise['name']),
                  subtitle: Text('Dificultad: ${exercise['difficulty']}'),
                  trailing: Icon(Icons.fitness_center),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
