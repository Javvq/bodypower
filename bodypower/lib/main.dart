import 'package:flutter/material.dart';
import 'homeScreen.dart'; // Asegúrate de que el archivo sea importado correctamente
// Asegúrate de que 'home_screen.dart' contenga la clase HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(), // Aquí se establece HomeScreen como la pantalla principal
    );
  }
}
