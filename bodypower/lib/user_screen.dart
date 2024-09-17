import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exercises_screen.dart';
import 'days_list_screen.dart';
import 'login_screen.dart'; // Asegúrate de que este import sea correcto según tu estructura de proyecto

class UserScreen extends StatelessWidget {
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userRole');
    await prefs.remove('userToken');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de que LoginScreen esté correctamente configurado
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Escoja su ejercicio!'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Icono de logout
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Cambia 'primary' a 'backgroundColor'
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Principiante')), // Pasa la dificultad
                  );
                },
                child: Text(
                  'Principiante',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Cambia 'primary' a 'backgroundColor'
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Intermedio')), // Pasa la dificultad
                  );
                },
                child: Text(
                  'Intermedio',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Experimentado')), // Pasa la dificultad
                  );
                },
                child: Text(
                  'Experimentado',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
