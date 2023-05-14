import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  Future pumpHome(WidgetTester tester) => tester.pumpWidget(const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: HomePage(),
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
    await pumpHome(tester);

    const title = 'Lorem';

    await addNewTask(tester, title);

    // Verify new task in task list
    expect(find.widgetWithText(ListTile, title), findsOneWidget);
  });

  testWidgets('Edit task', (tester) async {
    await pumpHome(tester);

    const title = 'Lorem';

    await addNewTask(tester, title);

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

    // Verify task name changed
    expect(find.widgetWithText(ListTile, title), findsNothing);
    expect(find.widgetWithText(ListTile, newTitle), findsOneWidget);
  });

  testWidgets('Select task', (tester) async {
    await pumpHome(tester);

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
    await pumpHome(tester);

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
    await pumpHome(tester);

    const title = 'Lorem';

    await addNewTask(tester, title);

    await tester.longPress(find.widgetWithText(ListTile, title));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    // Task is gone, and the the AppBar goes back to normal mode
    expect(find.widgetWithText(ListTile, title), findsNothing);
    expect(find.byIcon(Icons.close), findsNothing);
  });
}
