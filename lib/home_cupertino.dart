import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'home_model.dart';

class CupertinoHomePage extends StatefulWidget {
  const CupertinoHomePage({super.key});

  @override
  State<CupertinoHomePage> createState() => _CupertinoHomePageState();
}

class _CupertinoHomePageState extends State<CupertinoHomePage> {
  // TODO(satwanjyu): Use a proper repository
  final _tasks = <Task>[];

  final _selectedTasks = <Task>{};
  bool _selectMode = false;

  void _exitSelectMode() => _selectedTasks.clear();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          if (!_selectMode)
            CupertinoSliverNavigationBar(
              largeTitle: Text(AppLocalizations.of(context).tasks),
              leading: CupertinoButton(
                onPressed: () {
                  setState(() {
                    _selectMode = true;
                  });
                },
                child: const Icon(CupertinoIcons.check_mark_circled),
              ),
              trailing: CupertinoButton(
                onPressed: () async {
                  final task = await Navigator.of(context).push(_newTaskRoute);
                  if (task != null) {
                    setState(() {
                      _tasks.add(task);
                    });
                  }
                },
                child: const Icon(CupertinoIcons.add),
              ),
            )
          else
            _EditingAppBar(
              selectedTaskCount: _selectedTasks.length,
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
                  onCheckboxPressed: () {
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
                );
              },
              childCount: _tasks.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _EditingAppBar extends StatelessWidget {
  const _EditingAppBar({
    required this.selectedTaskCount,
    required this.onCancelPressed,
  });

  final int selectedTaskCount;
  final VoidCallback onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverNavigationBar(
      largeTitle:
          Text(AppLocalizations.of(context).selected(selectedTaskCount)),
      trailing: CupertinoButton(
        onPressed: onCancelPressed,
        child: Text(AppLocalizations.of(context).done),
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem({
    required this.task,
    required this.selected,
    required this.onCheckboxPressed,
  });

  final Task task;
  final bool selected;
  final VoidCallback onCheckboxPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      // TODO(satwanjyu): Build custom checkbox
      onTap: onCheckboxPressed,
      title: Text(task.title),
    );
  }
}

CupertinoPageRoute<Task> get _newTaskRoute => CupertinoPageRoute<Task>(
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
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(AppLocalizations.of(context).newTask),
            trailing: CupertinoButton(
              child: Text(AppLocalizations.of(context).save),
              onPressed: () {
                final validated = _formKey.currentState?.validate();
                if (validated == true) {
                  final result =
                      Task(title: _titleController.text, completed: false);
                  Navigator.of(context).pop(result);
                }
              },
            ),
          ),
          Form(
            key: _formKey,
            child: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: CupertinoTextField(
                    autofocus: true,
                    controller: _titleController,
                    placeholder: AppLocalizations.of(context).title,
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
