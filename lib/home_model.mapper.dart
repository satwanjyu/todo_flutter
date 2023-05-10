// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'home_model.dart';

class TaskMapper extends MapperBase<Task> {
  static MapperContainer container = MapperContainer(
    mappers: {TaskMapper()},
  );

  @override
  TaskMapperElement createElement(MapperContainer container) {
    return TaskMapperElement._(this, container);
  }

  @override
  String get id => 'Task';
}

class TaskMapperElement extends MapperElementBase<Task> {
  TaskMapperElement._(super.mapper, super.container);

  @override
  int hash(Task self) =>
      container.hash(self.completed) ^ container.hash(self.title);
  @override
  bool equals(Task self, Task other) =>
      container.isEqual(self.completed, other.completed) &&
      container.isEqual(self.title, other.title);
}

mixin TaskMappable {
  TaskCopyWith<Task, Task, Task> get copyWith =>
      _TaskCopyWithImpl(this as Task, $identity, $identity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (runtimeType == other.runtimeType &&
          TaskMapper.container.isEqual(this, other));
  @override
  int get hashCode => TaskMapper.container.hash(this);
}

extension TaskValueCopy<$R, $Out extends Task>
    on ObjectCopyWith<$R, Task, $Out> {
  TaskCopyWith<$R, Task, $Out> get asTask =>
      base.as((v, t, t2) => _TaskCopyWithImpl(v, t, t2));
}

typedef TaskCopyWithBound = Task;

abstract class TaskCopyWith<$R, $In extends Task, $Out extends Task>
    implements ObjectCopyWith<$R, $In, $Out> {
  TaskCopyWith<$R2, $In, $Out2> chain<$R2, $Out2 extends Task>(
      Then<Task, $Out2> t, Then<$Out2, $R2> t2);
  $R call({bool? completed, String? title});
}

class _TaskCopyWithImpl<$R, $Out extends Task>
    extends CopyWithBase<$R, Task, $Out>
    implements TaskCopyWith<$R, Task, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);
  @override
  TaskCopyWith<$R2, Task, $Out2> chain<$R2, $Out2 extends Task>(
          Then<Task, $Out2> t, Then<$Out2, $R2> t2) =>
      _TaskCopyWithImpl($value, t, t2);

  @override
  $R call({bool? completed, String? title}) => $then(Task(
      completed: completed ?? $value.completed, title: title ?? $value.title));
}
