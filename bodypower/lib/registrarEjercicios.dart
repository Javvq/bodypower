import 'package:flutter/material.dart';
import 'baseDatos.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedDifficulty = 'Principiante'; // Valor inicial
  final dbHelper = DatabaseHelper();

  Future<void> _addExercise() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      await dbHelper.insertExercise({
        'name': name,
        'description': description,
        'difficulty': _selectedDifficulty, // Añadir dificultad
      });
      _nameController.clear();
      _descriptionController.clear();
      setState(() {});
    }
  }

  Future<void> _deleteExercise(int id) async {
    await dbHelper.deleteExercise(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar Ejercicios'),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _selectedDifficulty,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedDifficulty = newValue!;
                });
              },
              items: <String>['Principiante', 'Intermedio', 'Avanzado']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: _addExercise,
            child: Text('Añadir Ejercicio'),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getExercises(),
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
                        subtitle: Text(
                            '${exercise['description']} - Dificultad: ${exercise['difficulty']}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteExercise(exercise['id']);
                          },
                        ),
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
