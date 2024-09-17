import 'package:flutter/material.dart';
import 'auth_service.dart'; // Asegúrate de tener el servicio de autenticación

class CreateUserScreen extends StatefulWidget {
  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _nombreController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roles = ['user', 'admin']; // Roles disponibles
  String _selectedRole = 'user'; // Rol predeterminado
  final AuthService _authService = AuthService();
  String _currentUserRole = 'admin'; // Obtener el rol actual del usuario

  void _createUser() async {
    final nombre = _nombreController.text;
    final password = _passwordController.text;

    try {
      final result = await _authService.createUser(
        nombre,
        password,
        _selectedRole,
        _currentUserRole,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
      // Opcional: Regresar a la pantalla anterior o limpiar los campos
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Usuario'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _nombreController,
                decoration: InputDecoration(
                  labelText: 'Nombre de Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRole = newValue!;
                  });
                },
                items: _roles.map<DropdownMenuItem<String>>((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createUser,
                child: Text('Crear Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
