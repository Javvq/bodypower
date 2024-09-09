import 'package:flutter/material.dart';
import 'baseDatos.dart';

class ExercisesScreen extends StatefulWidget {
  @override
  _ExercisesScreenState createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final dbHelper = DatabaseHelper();



  // Variable para almacenar la dificultad seleccionada
  String? _selectedDifficulty;

  Future<void> _addExercise() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty && _selectedDifficulty != null) {
      await dbHelper.insertExercise({
        'name': name,
        'description': description,
        'difficulty': _selectedDifficulty, // Añadir dificultad
      });
      _nameController.clear();
      _descriptionController.clear();
      setState(() {});
    } else {
      // Si hay campos vacíos o no se selecciona dificultad, muestra un mensaje
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, completa todos los campos y selecciona una dificultad.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Ejercicio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre del Ejercicio',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Selecciona la Dificultad',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDifficulty,
                items: [
                  DropdownMenuItem(value: 'Principiante', child: Text('Principiante')),
                  DropdownMenuItem(value: 'Intermedio', child: Text('Intermedio')),
                  DropdownMenuItem(value: 'Experimentado', child: Text('Experimentado')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedDifficulty = value;
                  });
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addExercise,
              child: Text('Añadir Ejercicio'),
            ),
            SizedBox(height: 20),
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
                          subtitle: Text(exercise['description']),
                          trailing: Text(exercise['difficulty'] ?? 'Sin Dificultad'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}
