import 'package:todo_flutter/model/task.dart';
import 'package:todo_flutter/repository/task_repository.dart';

class HomeApi {
  final TaskRepository taskRepository;

  HomeApi({required this.taskRepository});

  Future<List<Task>> getTasks() async {
    return taskRepository.getTasks();
  }

  Future<void> addTask(Task task) async {
    return taskRepository.addTask(task);
  }

  Future<void> updateTask(Task task) async {
    return taskRepository.updateTask(task);
  }

  Future<void> deleteTask(Task task) async {
    return taskRepository.deleteTask(task);
  }

  Future<List<Task>> getIncompleteTasks() async {
    final tasks = await taskRepository.getTasks();
    return tasks.where((task) => !task.completed).toList();
  }

  Future<List<Task>> getCompletedTasks() async {
    final tasks = await taskRepository.getTasks();
    return tasks.where((task) => task.completed).toList();
  }

  Future<List<Task>> getTasksSortedByTitle() async {
    final tasks = await taskRepository.getTasks();
    tasks.sort((a, b) => a.title.compareTo(b.title));
    return tasks;
  }
}
