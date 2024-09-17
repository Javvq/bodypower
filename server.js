const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());
const PORT = process.env.PORT || 3000;

// Conectar a MySQL
const db = mysql.createConnection({
  host: 'localhost', 
  user: 'root',
  password: '0315', 
  database: 'bodypower' 
});

db.connect(err => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the MySQL database.');
});


app.get('/exercises', (req, res) => {
  db.query('SELECT * FROM exercises', (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});


app.get('/exercises/:difficulty', (req, res) => {
  const difficulty = req.params.difficulty;
  db.query('SELECT * FROM exercises WHERE difficulty = ?', [difficulty], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.json(results);
  });
});


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


app.post('/login', (req, res) => {
  const { nombre, password } = req.body;

  db.query('SELECT * FROM users WHERE nombre = ?', [nombre], (err, results) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    if (results.length === 0) {

      return res.status(401).json({ message: 'Usuario no encontrado' });
    }

    const user = results[0];


    if (user.password === password) {

      return res.json({ message: 'Inicio de sesión exitoso', rol: user.rol });
    } else {

      return res.status(401).json({ message: 'Contraseña incorrecta' });
    }
  });
});

app.post('/users', (req, res) => {
  const { nombre, password, rol, adminRole } = req.body;

  if (adminRole !== 'admin') {
    return res.status(403).json({ message: 'No autorizado' });
  }

  db.query('INSERT INTO users (nombre, password, rol) VALUES (?, ?, ?)', 
    [nombre, password, rol], (err) => {
    if (err) {
      return res.status(500).json({ error: err.message });
    }
    res.status(201).json({ message: 'Usuario creado exitosamente!' });
  });
});



app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});


