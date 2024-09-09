import 'package:flutter/material.dart';
import '/homescreen.dart'; // Importa el archivo donde está la clase HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyPower', 
      theme: ThemeData(
        primarySwatch: Colors.blue, // Define el tema de la aplicación
      ),
      home: HomeScreen(), // Llama a la clase HomeScreen como pantalla inicial
    );
  }
}
