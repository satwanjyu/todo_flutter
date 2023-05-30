import '../db.dart';
import '../model/task.dart';

class TaskRepository {
  final LocalDB localDB;

  TaskRepository({required this.localDB});

  Future<List<Task>> getTasks() async {
    return localDB.getTasks();
  }

  Future<void> addTask(Task task) async {
    return localDB.insertTask(task);
  }

  Future<void> updateTask(Task task) async {
    return localDB.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    return localDB.deleteTask(task.id!);
  }
}
