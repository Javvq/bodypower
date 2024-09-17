const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
const PORT = process.env.PORT || 3000;

// Conectar a MySQL
const db = mysql.createConnection({
  host: 'localhost', // O la IP de tu servidor MySQL
  user: 'root',
  password: '', // Cambia 'your_password' por tu contraseña real
  database: 'bodypower' // Nombre de tu base de datos
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the MySQL database.');
});

// Ruta para obtener todos los ejercicios
app.get('/exercises', (req, res) => {
  db.query('SELECT * FROM exercises', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Ruta para obtener ejercicios por dificultad
app.get('/exercises/:difficulty', (req, res) => {
  const difficulty = req.params.difficulty;
  db.query('SELECT * FROM exercises WHERE difficulty = ?', [difficulty], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});

// Ruta para añadir un ejercicio
app.post('/exercises', (req, res) => {
  const { name, description, difficulty } = req.body;
  db.query('INSERT INTO exercises (name, description, difficulty) VALUES (?, ?, ?)', 
    [name, description, difficulty], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json({ message: 'Exercise added successfully!' });
  });
});

// Ruta para autenticar usuarios
app.post('/login', (req, res) => {
  const { nombre, password } = req.body;

  // Buscar el usuario en la base de datos por nombre de usuario
  db.query('SELECT * FROM users WHERE nombre = ?', [nombre], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {
      // Usuario no encontrado
      return res.status(401).json({ message: 'Usuario no encontrado' });
    }

    const user = results[0];

    // Comparar la contraseña proporcionada con la almacenada
    if (user.password === password) {
      // La contraseña es correcta, devolver el rol del usuario
      return res.json({ message: 'Inicio de sesión exitoso', rol: user.rol });
    } else {
      // Contraseña incorrecta
      return res.status(401).json({ message: 'Contraseña incorrecta' });
    }
  });
});
// Ruta para añadir un nuevo usuario
app.post('/users', (req, res) => {
  const { nombre, password, rol, adminRole } = req.body;

  // Verificar que el rol es 'admin' antes de permitir la creación de usuarios
  if (adminRole !== 'admin') {
    return res.status(403).json({ message: 'No autorizado' });
  }

  // Insertar nuevo usuario en la base de datos
  db.query('INSERT INTO users (nombre, password, rol) VALUES (?, ?, ?)', 
    [nombre, password, rol], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Usuario creado exitosamente!' });
  });
});




app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


