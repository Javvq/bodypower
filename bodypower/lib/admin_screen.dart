import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla de Administrador'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove('userRole');
              await prefs.remove('userToken');
              Navigator.pushReplacementNamed(context, '/login'); // Redirige a la pantalla de login
            },
          ),
        ],
      ),
      body: AdminBody(),
    );
  }
}

class AdminBody extends StatefulWidget {
  @override
  _AdminBodyState createState() => _AdminBodyState();
}

class _AdminBodyState extends State<AdminBody> {
  List<Map<String, dynamic>> _users = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3001/users'), // Cambia esto según tu URL de backend
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          _users = List<Map<String, dynamic>>.from(data);
        });
      } else {
        throw Exception('Error al obtener usuarios');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de red. Inténtalo de nuevo.';
      });
      print('Error: $e');
    }
  }

  Future<void> _createUser(BuildContext context) async {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    String? _selectedRole = 'user'; // Valor predeterminado para el rol

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Crear Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
              ),
              DropdownButton<String>(
                value: _selectedRole,
                items: <String>['user', 'admin'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue;
                  });
                },
                hint: Text('Selecciona un rol'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final String name = _nameController.text;
                final String password = _passwordController.text;

                try {
                  final response = await http.post(
                    Uri.parse('http://localhost:3001/users'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'nombre': name,
                      'password': password,
                      'rol': _selectedRole ?? 'user', // Usa el rol seleccionado o predeterminado
                    }),
                  );

                  // Imprime la respuesta del servidor para depuración
                  print('Response status: ${response.statusCode}');
                  print('Response body: ${response.body}');

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    _fetchUsers(); // Refresca la lista de usuarios
                  } else {
                    throw Exception('Error al crear usuario: ${response.body}');
                  }
                } catch (e) {
                  // Manejo de errores
                  setState(() {
                    _errorMessage = 'Error al crear el usuario. Inténtalo de nuevo.';
                  });
                  print('Error: $e');
                }
              },
              child: Text('Crear'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }


  Future<void> _createExercise(BuildContext context) async {
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descriptionController = TextEditingController();
    String? _selectedDifficulty = 'Principiante'; // Valor predeterminado para la dificultad

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registrar Ejercicio'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del Ejercicio'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              DropdownButton<String>(
                value: _selectedDifficulty,
                items: <String>['Principiante', 'Intermedio', 'Experimentado'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDifficulty = newValue;
                  });
                },
                hint: Text('Selecciona una dificultad'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                final String name = _nameController.text;
                final String description = _descriptionController.text;

                try {
                  final response = await http.post(
                    Uri.parse('http://localhost:3000/exercises'),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, String>{
                      'name': name,
                      'description': description,
                      'difficulty': _selectedDifficulty ?? 'Principiante', // Usa la dificultad seleccionada o predeterminada
                    }),
                  );

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    // Puedes agregar un método para refrescar la lista de ejercicios si es necesario
                  } else {
                    throw Exception('Error al registrar ejercicio');
                  }
                } catch (e) {
                  // Manejo de errores
                  print('Error: $e');
                }
              },
              child: Text('Registrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => _createUser(context),
                child: Text('Crear Nuevo Usuario'),
              ),
              ElevatedButton(
                onPressed: () => _createExercise(context),
                child: Text('Registrar Ejercicio'),
              ),
            ],
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: Colors.red),
            ),
          ),
        Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                title: Text(user['nombre']),
                subtitle: Text('Rol: ${user['rol']}'),
                trailing: Icon(Icons.person),
              );
            },
          ),
        ),
      ],
    );
  }
}



