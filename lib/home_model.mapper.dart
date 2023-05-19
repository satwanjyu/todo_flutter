// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element

part of 'home_model.dart';

class TaskMapper extends ClassMapperBase<Task> {
  TaskMapper._();

  static TaskMapper? _instance;
  static TaskMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TaskMapper._());
    }
    return _instance!;
  }

  static T _guard<T>(T Function(MapperContainer) fn) {
    ensureInitialized();
    return fn(MapperContainer.globals);
  }

  @override
  final String id = 'Task';

  static bool _$completed(Task v) => v.completed;
  static const Field<Task, bool> _f$completed = Field('completed', _$completed);
  static String _$title(Task v) => v.title;
  static const Field<Task, String> _f$title = Field('title', _$title);

  @override
  final Map<Symbol, Field<Task, dynamic>> fields = const {
    #completed: _f$completed,
    #title: _f$title,
  };

  static Task _instantiate(DecodingData data) {
    return Task(completed: data.dec(_f$completed), title: data.dec(_f$title));
  }

  @override
  final Function instantiate = _instantiate;

  static Task fromMap(Map<String, dynamic> map) {
    return _guard((c) => c.fromMap<Task>(map));
  }

  static Task fromJson(String json) {
    return _guard((c) => c.fromJson<Task>(json));
  }
}

mixin TaskMappable {
  String toJson() {
    return TaskMapper._guard((c) => c.toJson(this as Task));
  }

  Map<String, dynamic> toMap() {
    return TaskMapper._guard((c) => c.toMap(this as Task));
  }

  TaskCopyWith<Task, Task, Task> get copyWith =>
      _TaskCopyWithImpl(this as Task, $identity, $identity);
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            TaskMapper._guard((c) => c.isEqual(this, other)));
  }

  @override
  int get hashCode {
    return TaskMapper._guard((c) => c.hash(this));
  }
}

extension TaskValueCopy<$R, $Out> on ObjectCopyWith<$R, Task, $Out> {
  TaskCopyWith<$R, Task, $Out> get $asTask =>
      $base.as((v, t, t2) => _TaskCopyWithImpl(v, t, t2));
}

abstract class TaskCopyWith<$R, $In extends Task, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? completed, String? title});
  TaskCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TaskCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Task, $Out>
    implements TaskCopyWith<$R, Task, $Out> {
  _TaskCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Task> $mapper = TaskMapper.ensureInitialized();
  @override
  $R call({bool? completed, String? title}) => $apply(FieldCopyWithData({
        if (completed != null) #completed: completed,
        if (title != null) #title: title
      }));
  @override
  Task $make(CopyWithData data) => Task(
      completed: data.get(#completed, or: $value.completed),
      title: data.get(#title, or: $value.title));

  @override
  TaskCopyWith<$R2, Task, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _TaskCopyWithImpl($value, $cast, t);
}
