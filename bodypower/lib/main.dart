import 'admin_screen.dart';
import 'user_screen.dart';
import 'package:flutter/material.dart';
import 'exercises_screen.dart';
import 'days_list_screen.dart';
import 'login_screen.dart'; // Asegúrate de que esté importado LoginScreen
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contenedores Centrados'),
        leading: IconButton(
          icon: Icon(Icons.login), // Icono de login
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()), // Navega a la pantalla de login
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExercisesScreen()),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Principiante')),
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
                  backgroundColor: Colors.greenAccent,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Intermedio')),
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
                    MaterialPageRoute(builder: (context) => ExercisesListScreen(difficulty: 'Experimentado')),
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final role = prefs.getString('user_role');

  runApp(MyApp(initialRole: role));
}

class MyApp extends StatelessWidget {
  final String? initialRole;

  MyApp({this.initialRole});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BodyPower',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: initialRole == null
          ? HomeScreen()
          : initialRole == 'admin'
          ? AdminScreen()
          : UserScreen(),
    );
  }
}

