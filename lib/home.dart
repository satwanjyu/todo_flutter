import 'package:flutter/material.dart';

import 'home_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TODO(satwanjyu): Use a proper repository
  final _tasks = <Task>[];

  final _selectedTasks = <Task>{};
  bool get _selectMode => _selectedTasks.isNotEmpty;

  void _exitSelectMode() => _selectedTasks.clear();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          if (!_selectMode)
            SliverAppBar.large(
              title: const Text('Tasks'),
            )
          else
            _EditingAppBar(
              selectedTaskCount: _selectedTasks.length,
              onDeletePressed: () {
                setState(() {
                  for (final task in _selectedTasks) {
                    _tasks.remove(task);
                  }
                  _selectedTasks.clear();
                });
              },
              onCancelPressed: () {
                setState(() {
                  _exitSelectMode();
                });
              },
            ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final task = _tasks[index];
                final selected = _selectedTasks.contains(_tasks[index]);

                void flipSelected() {
                  if (!selected) {
                    _selectedTasks.add(task);
                  } else {
                    _selectedTasks.remove(task);
                  }
                }

                return _TaskItem(
                  task: task,
                  selected: selected,
                  onTap: () {
                    if (!_selectMode) {
                      setState(() {
                        // Flip completed
                        _tasks[index] = task.copyWith(
                          completed: !task.completed,
                        );
                      });
                    } else {
                      setState(() {
                        flipSelected();
                      });
                    }
                  },
                  onLongPress: () {
                    setState(() {
                      flipSelected();
                    });
                  },
                );
              },
              childCount: _tasks.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        tooltip: 'Create a new task',
        onPressed: () async {
          final task = await Navigator.of(context).push(_newTaskRoute);
          if (task != null) {
            setState(() {
              _tasks.add(task);
            });
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
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
      title: Text('$selectedTaskCount selected'),
      actions: [
        IconButton(
          tooltip: 'Delete selected tasks',
          icon: const Icon(Icons.delete),
          onPressed: onDeletePressed,
        ),
      ],
      leading: IconButton(
        tooltip: 'Cancel',
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
  });

  final Task task;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

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
                onChanged: (_) {
                  onTap();
                },
              ),
        onTap: () {
          onTap();
        },
        selected: selected,
        onLongPress: () {
          onLongPress();
        },
        title: Text(
          task.title,
          style: task.completed ? _completedTitleTextStyle(context) : null,
        ),
      ),
    );
  }
}

MaterialPageRoute<Task> get _newTaskRoute => MaterialPageRoute<Task>(
    builder: (context) => const _NewTaskDialog(), fullscreenDialog: true);

class _NewTaskDialog extends StatefulWidget {
  const _NewTaskDialog();

  @override
  State<_NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<_NewTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('New task'),
            actions: [
              IconButton(
                tooltip: 'Save',
                icon: const Icon(Icons.check),
                onPressed: () {
                  final validated = _formKey.currentState?.validate();
                  if (validated == true) {
                    final result =
                        Task(title: _titleController.text, completed: false);
                    Navigator.of(context).pop(result);
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
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
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
