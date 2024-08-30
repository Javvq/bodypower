import 'package:flutter/material.dart';
import 'baseDatos.dart';

class ExercisesScreen extends StatefulWidget {
  final String difficulty; // Agrega este campo para recibir la dificultad

  ExercisesScreen({required this.difficulty}); // Asegúrate de que el constructor acepte este parámetro

  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dbHelper = DatabaseHelper();

  Future<void> _addExercise() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      await dbHelper.insertExercise({
        'name': name,
        'description': description,
        'difficulty': widget.difficulty, // Usa el parámetro difficulty aquí
      });
      _nameController.clear();
      _descriptionController.clear();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios (${widget.difficulty})'), // Muestra la dificultad en el título
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre del Ejercicio'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
          ),
          ElevatedButton(
            onPressed: _addExercise,
            child: Text('Añadir Ejercicio'),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getExercisesByDifficulty(widget.difficulty), // Obtén los ejercicios por dificultad
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay ejercicios.'));
                } else {
                  final exercises = snapshot.data!;
                  return ListView.builder(
                    itemCount: exercises.length,
                    itemBuilder: (context, index) {
                      final exercise = exercises[index];
                      return ListTile(
                        title: Text(exercise['name']),
                        subtitle: Text(exercise['description']),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
