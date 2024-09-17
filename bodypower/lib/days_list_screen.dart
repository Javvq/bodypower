import 'package:flutter/material.dart';
import 'baseDatos.dart';
import 'package:intl/intl.dart'; // Necesario para el formateo de fechas
import 'dart:math'; // Necesario para la generación de números aleatorios

class ExercisesListScreen extends StatefulWidget {
  final String difficulty;

  ExercisesListScreen({required this.difficulty});

  @override
  _ExercisesListScreenState createState() => _ExercisesListScreenState();
}

class _ExercisesListScreenState extends State<ExercisesListScreen> {
  Map<DateTime, List<Map<String, dynamic>>> _completedExercises = {};

  List<DateTime> _getNext15Days() {
    DateTime today = DateTime.now();
    return List.generate(15, (index) => today.add(Duration(days: index)));
  }

  List<Map<String, dynamic>> _getRandomExercises(List<Map<String, dynamic>> exercises) {
    final Random random = Random();
    if (exercises.length <= 3) {
      return exercises;
    } else {
      return List.generate(3, (_) => exercises[random.nextInt(exercises.length)]);
    }
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM', 'es_ES');
    return formatter.format(date);
  }

  void _markAsCompleted(DateTime date, List<Map<String, dynamic>> exercises) {
    setState(() {
      _completedExercises[date] = exercises;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Felicitaciones! Ejercicios del ${_formatDate(date)} marcados como realizados.')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ejercicios - ${widget.difficulty}'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: DatabaseHelper().getExercisesByDifficulty(widget.difficulty),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay ejercicios para esta dificultad.'));
          }
          
          List<Map<String, dynamic>> exercises = snapshot.data!;
          List<DateTime> dates = _getNext15Days();
          DateTime today = DateTime.now();

          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (context, index) {
              DateTime date = dates[index];
              String formattedDate = _formatDate(date);

              // Obtener 3 ejercicios aleatorios para el día actual
              List<Map<String, dynamic>> dailyExercises = _getRandomExercises(exercises);

              // Determinar si el día es el día actual
              bool isToday = date.isAtSameMomentAs(today);
              bool isCompleted = _completedExercises.containsKey(date);

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? Colors.lightGreenAccent // Color de contenedor cuando completado
                      : (isToday ? Colors.transparent : Colors.grey[300]),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isCompleted ? Colors.green : Colors.transparent,
                    width: 2.0,
                  ),
                ),
                child: ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text('Fecha: $formattedDate')),
                      if (isCompleted)
                        Icon(Icons.check, color: Colors.green),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dailyExercises.map((exercise) {
                      return Column(
                        children: [
                          SizedBox(height: 4.0), // Espacio entre los ejercicios
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text('${exercise['name']}: ${exercise['description']}'),
                              ),
                              if (isToday && !isCompleted) // Solo muestra el botón si es hoy y no está completado
                                ElevatedButton(
                                  onPressed: () {
                                    _markAsCompleted(date, dailyExercises);
                                  },
                                  child: Text('Realizado'),
                                ),
                            ],
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  trailing: !isToday
                      ? Icon(Icons.lock, color: Colors.grey)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
