import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

 Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'exercises.db');
  return openDatabase(
    path,
    version: 2, // Incrementa la versión aquí
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE exercises (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          difficulty TEXT
        )
      ''');
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          ALTER TABLE exercises ADD COLUMN difficulty TEXT
        ''');
      }
    },
  );
}



  Future<int> insertExercise(Map<String, dynamic> exercise) async {
    final db = await database;
    return db.insert('exercises', exercise);
  }
Future<int> deleteExercise(int id) async {
  final db = await database;
  return db.delete(
    'exercises',
    where: 'id = ?',
    whereArgs: [id],
  );
}

 Future<List<Map<String, dynamic>>> getExercises({String? difficulty}) async {
  final db = await database;
  if (difficulty != null) {
    return db.query(
      'exercises',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
    );
  } else {
    return db.query('exercises');
  }
}

  getExercisesByDifficulty(String difficulty) {}

}
