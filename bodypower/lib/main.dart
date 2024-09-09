import 'package:flutter/material.dart';
import 'registrarEjercicios.dart'; // Importa el archivo donde está la pantalla de registro de ejercicios
import 'package:bodypower/principiante.dart'; // Asegúrate de que este archivo contiene la pantalla de listado de días

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contenedores Centrados'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExercisesScreen()), // Pantalla de registro de ejercicios
              );
            },
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
                style: ElevatedButton.styleFrom(primary: Colors.blueAccent),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DaysListScreen()), // Pantalla de listado de días
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
                style: ElevatedButton.styleFrom(primary: Colors.greenAccent),
                onPressed: () {
                  // Acción para la sección Intermedio (puedes definirlo más adelante)
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
                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                onPressed: () {
                  // Acción para la sección Experimentado (puedes definirlo más adelante)
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
