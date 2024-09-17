import 'package:flutter/material.dart';
import 'login_screen.dart'; // Asegúrate de importar la pantalla de login
import 'admin_screen.dart'; // Asegúrate de importar la pantalla de admin
import 'exercises_screen.dart'; // Asegúrate de importar la pantalla de ejercicios
import 'package:intl/date_symbol_data_local.dart'; 
void main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es_ES');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/admin': (context) => AdminScreen(),
        '/exercises': (context) => ExercisesScreen(), // Pantalla para usuarios no admins
        // Agrega otras rutas aquí
      },
    );
  }
}
