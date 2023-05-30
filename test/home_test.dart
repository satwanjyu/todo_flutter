import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_flutter/model/task.dart';
import 'package:todo_flutter/pages/home/home.dart';
import 'package:todo_flutter/pages/home/home_api.dart';

import 'home_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HomeApi>()])

/// In-memory implementation of HomeApi
MockHomeApi mockHomeApi() {
  int id = 0;
  final api = MockHomeApi();
  final tasks = <Task>[];
  when(api.getTasks()).thenAnswer((_) => Future.value(tasks));
  when(api.addTask(any)).thenAnswer((invocation) {
    final task = invocation.positionalArguments[0] as Task;
    tasks.add(task.copyWith(id: id));
    id++;
    return Future.value();
  });
  when(api.updateTask(any)).thenAnswer((invocation) {
    final task = invocation.positionalArguments[0] as Task;
    final index = tasks.indexWhere((t) => t.id == task.id);
    tasks[index] = task;
    return Future.value();
  });
  when(api.deleteTask(any)).thenAnswer((invocation) {
    final task = invocation.positionalArguments[0] as Task;
    tasks.remove(task);
    return Future.value();
  });
  when(api.getIncompleteTasks()).thenAnswer((_) {
    final incompleteTasks = tasks.where((t) => !t.completed).toList();
    return Future.value(incompleteTasks);
  });
  when(api.getCompletedTasks()).thenAnswer((_) {
    final completedTasks = tasks.where((t) => t.completed).toList();
    return Future.value(completedTasks);
  });
  when(api.getTasksSortedByTitle()).thenAnswer((_) {
    final sortedTasks = tasks.toList()
      ..sort((a, b) => a.title.compareTo(b.title));
    return Future.value(sortedTasks);
  });
  return api;
}

void main() {
  Future pumpHome(WidgetTester tester, HomeApi api) =>
      tester.pumpWidget(MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: HomePage(api: api),
      ));

  Future addNewTask(WidgetTester tester, String title) async {
    // Tap FAB
    await tester.tap(find.byTooltip('Create a new task'));
    await tester.pumpAndSettle();

    // Fill in the title field
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Lorem',
    );
    await tester.pumpAndSettle();

    // Tap Save
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();
  }

  testWidgets('Add a new task', (tester) async {
    final api = mockHomeApi();
    await pumpHome(tester, api);

    const title = 'Lorem';

    await addNewTask(tester, title);

    verify(api.addTask(const Task(title: title))).called(1);

    // Verify new task in task list
    expect(find.widgetWithText(ListTile, title), findsOneWidget);
  });

  testWidgets('Edit task', (tester) async {
    final api = mockHomeApi();
    await pumpHome(tester, api);

    const title = 'Lorem';

    await addNewTask(tester, title);

    verify(api.addTask(const Task(title: title))).called(1);

    const newTitle = 'ipsum';

    // Tap task
    await tester.tap(find.widgetWithText(ListTile, title));
    await tester.pumpAndSettle();

    // Edit title
    final textField = find.widgetWithText(TextFormField, title);
    await tester.tap(textField);
    await tester.enterText(textField, newTitle);
    await tester.pumpAndSettle();

    // Tap save
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    verify(api.updateTask(any)).called(1);

    // Verify task name changed
    expect(find.widgetWithText(ListTile, title), findsNothing);
    expect(find.widgetWithText(ListTile, newTitle), findsOneWidget);
  });

  testWidgets('Select task', (tester) async {
    await pumpHome(tester, mockHomeApi());

    const title = 'Lorem';

    await addNewTask(tester, title);

    // Long-press task to select (& enter select mode)
    await tester.longPress(find.widgetWithText(ListTile, title));
    await tester.pumpAndSettle();

    // AppBar.title shows: '1 selected'
    expect(find.textContaining('1'), findsWidgets);
    // AppBar.leading is a 'close' IconButton
    expect(find.byIcon(Icons.close), findsOneWidget);
    // AppBar.action contains a 'delete' IconButton
    expect(find.byIcon(Icons.delete), findsOneWidget);
  });

  testWidgets('Exit select mode', (tester) async {
    await pumpHome(tester, mockHomeApi());

    const title = 'Lorem';

    await addNewTask(tester, title);

    await tester.longPress(find.widgetWithText(ListTile, title));
    await tester.pumpAndSettle();

    // Tap 'close' button
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    // Task is still there, but the AppBar goes back to normal mode
    expect(find.widgetWithText(ListTile, title), findsOneWidget);
    expect(find.byIcon(Icons.close), findsNothing);
  });

  testWidgets('Delete task', (tester) async {
    final api = mockHomeApi();
    await pumpHome(tester, api);

    const title = 'Lorem';

    await addNewTask(tester, title);

    await tester.longPress(find.widgetWithText(ListTile, title));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    verify(api.deleteTask(const Task(
      id: 0,
      title: title,
      completed: false,
    ))).called(1);

    // Task is gone, and the the AppBar goes back to normal mode
    expect(find.widgetWithText(ListTile, title), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}
