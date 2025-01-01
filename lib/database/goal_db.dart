import 'package:sqflite/sqflite.dart';
import 'package:business_assistant/data/goaldata.dart';

class GoalDB {
  static final GoalDB instance = GoalDB._init();
  static Database? _database;

  GoalDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('goals.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final db = await openDatabase(
      filePath,
      version: 1,
      onCreate: _createDB,
    );
    return db;
  }

  Future _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE goals (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT,
      startDate TEXT,
      limitDate TEXT,
      status TEXT,
      deleted INTEGER DEFAULT 0
    )
    ''';
    await db.execute(sql);
  }

Future<List<Goal>> fetchGoals() async {
  final db = await database; // Get your database instance
  final List<Map<String, dynamic>> maps = await db.query(
    'goals',
    where: 'deleted = ?', // Filter out deleted goals
    whereArgs: [false], // Only fetch goals where deleted is false
  );

  return List.generate(maps.length, (i) {
    return Goal(
      id: maps[i]['id'],
      title: maps[i]['title'],
      description: maps[i]['description'],
      startDate: DateTime.parse(maps[i]['startDate']),
      limitDate: DateTime.parse(maps[i]['limitDate']),
      status: maps[i]['status'],
      deleted: maps[i]['deleted'] == 1, // Ensure deleted status is properly handled
    );
  });
}



  Future<void> insertGoal(Goal goal) async {
    final db = await instance.database;
    await db.insert('goals', goal.toMap());
  }

  Future<void> updateGoal(Goal goal) async {
    final db = await instance.database;
    await db.update('goals', goal.toMap(), where: 'id = ?', whereArgs: [goal.id]);
  }

  Future<void> deleteGoal(int goalId) async {
  final db = await database; // Get your database instance
  await db.delete(
    'goals', // The table name
    where: 'id = ?', 
    whereArgs: [goalId], // Delete the goal with the given id
  );
}

  }

  
