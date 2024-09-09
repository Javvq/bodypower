import 'package:flutter/material.dart';
import 'baseDatos.dart';

class ExercisesListScreen extends StatelessWidget {
  final String difficulty;

  ExercisesListScreen({required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios - $difficulty'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getExercisesByDifficulty(difficulty),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay ejercicios para esta dificultad.'));
          }
          List<Map<String, dynamic>> exercises = snapshot.data!;
          return ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(exercises[index]['name']),
                subtitle: Text(exercises[index]['description']),
              );
            },
          );
        },
      ),
    );
  }
}
