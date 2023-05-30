import 'package:dart_mappable/dart_mappable.dart';

part 'task.mapper.dart';

@MappableClass(generateMethods: GenerateMethods.equals | GenerateMethods.copy)
class Task with TaskMappable {
  const Task({
    this.id,
    this.completed = false,
    required this.title,
  });

  final int? id;
  final bool completed;
  final String title;

  /// Map to sqlflite map
  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'completed': completed ? 1 : 0,
        'title': title,
      };
}
