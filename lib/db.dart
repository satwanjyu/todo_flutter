import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/task.dart';

class LocalDB {
  static LocalDB? _instance;

  static LocalDB getInstance() => _instance ??= LocalDB._();

  LocalDB._();

  Database? _db;

  static const _taskTable = 'tasks';

  Future<void> init() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $_taskTable('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'title TEXT, '
          'completed INTEGER'
          ')',
        );
      },
      version: 1,
    );
  }

  Future<List<Task>> getTasks() async {
    if (_db == null) await init();
    final List<Map<String, dynamic>> maps = await _db!.query(_taskTable);
    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'],
        title: maps[i]['title'],
        completed: maps[i]['completed'] == 1,
      );
    });
  }

  Future<void> insertTask(Task task) async {
    if (_db == null) await init();
    await _db!.insert(
      _taskTable,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTask(Task task) async {
    if (_db == null) await init();
    await _db!.update(
      _taskTable,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> deleteTask(int id) async {
    if (_db == null) await init();
    await _db!.delete(
      _taskTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
