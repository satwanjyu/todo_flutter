import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:todo_flutter/model/task.dart';
import 'package:todo_flutter/pages/home/home_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.api,
  });

  final HomeApi api;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _selectedTasks = <Task>{};
  bool get _selectMode => _selectedTasks.isNotEmpty;

  late Future<List<Task>> _tasksFuture;

  void _refreshTasks() => _tasksFuture = widget.api.getTasks();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _tasksFuture,
      initialData: const <Task>[],
      builder: (context, snapshot) {
        // TODO(satwanjyu): DB/network action indicator (non-intrusive progress indicator)
        // TODO(satwanjyu): Error handling
        final tasks = snapshot.data!;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              if (!_selectMode)
                SliverAppBar.large(
                  title: Text(AppLocalizations.of(context).tasks),
                )
              else
                _EditingAppBar(
                  selectedTaskCount: _selectedTasks.length,
                  onDeletePressed: () {
                    setState(() {
                      for (final task in _selectedTasks) {
                        widget.api.deleteTask(task);
                      }
                      _selectedTasks.clear();
                      _refreshTasks();
                    });
                  },
                  onCancelPressed: () {
                    setState(() {
                      _selectedTasks.clear();
                    });
                  },
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final task = tasks[index];
                    final selected = _selectedTasks.contains(tasks[index]);

                    void flipSelected() {
                      // Flip selected
                      if (!selected) {
                        _selectedTasks.add(task);
                      } else {
                        _selectedTasks.remove(task);
                      }
                    }

                    return _TaskItem(
                      task: task,
                      selected: selected,
                      onTap: () async {
                        if (_selectMode) {
                          setState(() {
                            flipSelected();
                          });
                        } else {
                          // Push edit dialog
                          final result = await Navigator.of(context)
                              .push(_taskRoute(task));
                          if (result != null && result != task) {
                            await widget.api.updateTask(result);
                            setState(() {
                              _refreshTasks();
                            });
                          }
                        }
                      },
                      onLongPress: () {
                        setState(() {
                          flipSelected();
                        });
                      },
                      onCheckboxChanged: (value) {
                        setState(() {
                          widget.api.updateTask(
                              tasks[index].copyWith(completed: value));
                          _refreshTasks();
                        });
                      },
                    );
                  },
                  childCount: tasks.length,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            tooltip: AppLocalizations.of(context).createANewTask,
            onPressed: () async {
              final task = await Navigator.of(context).push(_taskRoute());
              if (task != null) {
                widget.api.addTask(task);
              }
              setState(() {
                _refreshTasks();
              });
            },
            icon: const Icon(Icons.add),
            label: Text(AppLocalizations.of(context).newTask),
          ),
        );
      },
    );
  }
}

class _EditingAppBar extends StatelessWidget {
  const _EditingAppBar({
    required this.selectedTaskCount,
    required this.onDeletePressed,
    required this.onCancelPressed,
  });

  final int selectedTaskCount;
  final VoidCallback onDeletePressed;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar.large(
      title: Text(AppLocalizations.of(context).selected(selectedTaskCount)),
      actions: [
        IconButton(
          tooltip: AppLocalizations.of(context).deleteSelectedTasks,
          icon: const Icon(Icons.delete),
          onPressed: onDeletePressed,
        ),
      ],
      leading: IconButton(
        tooltip: AppLocalizations.of(context).cancel,
        icon: const Icon(Icons.close),
        onPressed: onCancelPressed,
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.task,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onCheckboxChanged,
  });

  final Task task;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<bool> onCheckboxChanged;

  TextStyle _completedTitleTextStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).disabledColor,
        decoration: TextDecoration.lineThrough,
        decorationColor: Theme.of(context).disabledColor,
      );

  ListTileThemeData _selectedListTileThemeData(BuildContext context) =>
      ListTileThemeData(
        selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
        selectedTileColor:
            Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
      );

  @override
  Widget build(BuildContext context) {
    return ListTileTheme(
      data: selected ? _selectedListTileThemeData(context) : null,
      child: ListTile(
        selectedColor: Theme.of(context).colorScheme.onPrimaryContainer,
        selectedTileColor: Theme.of(context).colorScheme.primaryContainer,
        trailing: selected
            ? null
            : Checkbox(
                value: task.completed,
                onChanged: (value) => onCheckboxChanged(value!),
              ),
        onTap: onTap,
        selected: selected,
        onLongPress: onLongPress,
        title: Text(
          task.title,
          style: task.completed ? _completedTitleTextStyle(context) : null,
        ),
      ),
    );
  }
}

MaterialPageRoute<Task> _taskRoute([Task? task]) => MaterialPageRoute<Task>(
    builder: (context) => _TaskDialog(task: task), fullscreenDialog: true);

/// Create/Edit task
class _TaskDialog extends StatefulWidget {
  const _TaskDialog({required this.task});

  final Task? task;

  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  final _formKey = GlobalKey<FormState>();

  late final _titleController = TextEditingController(text: widget.task?.title);

  late final _createTask = widget.task == null;

  String _title(BuildContext context) => _createTask
      ? AppLocalizations.of(context).newTask
      : AppLocalizations.of(context).editTask;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(_title(context)),
            actions: [
              IconButton(
                tooltip: AppLocalizations.of(context).save,
                icon: const Icon(Icons.check),
                onPressed: () {
                  final validated = _formKey.currentState?.validate();
                  if (validated == true) {
                    final task = widget.task;
                    if (task == null) {
                      // New task
                      final result = Task(title: _titleController.text);
                      Navigator.of(context).pop(result);
                    } else {
                      // Edit task
                      final result =
                          task.copyWith(title: _titleController.text);
                      Navigator.of(context).pop(result);
                    }
                  }
                },
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    autofocus: true,
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context).title,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context).titleCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
