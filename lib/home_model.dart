import 'package:dart_mappable/dart_mappable.dart';

part 'home_model.mapper.dart';

@MappableClass(
    generateMethods: GenerateMethods.equals |
        GenerateMethods.copy |
        GenerateMethods.encode |
        GenerateMethods.decode)
class Task with TaskMappable {
  const Task({
    required this.completed,
    required this.title,
  });

  final bool completed;
  final String title;
}
