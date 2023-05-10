import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_flutter/home.dart';

void main() {
  Future pumpHome(WidgetTester tester) =>
      tester.pumpWidget(const MaterialApp(home: HomePage()));

  testWidgets('Add a new task', (tester) async {
    await pumpHome(tester);

    // Click FAB
    await tester.tap(find.byTooltip('Create a new task'));
    await tester.pumpAndSettle();

    // Fill in the title field
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Title'),
      'Lorem',
    );
    await tester.pumpAndSettle();

    // Click Save
    await tester.tap(find.byTooltip('Save'));
    await tester.pumpAndSettle();

    // Verify new task in task list
    expect(find.text('Lorem'), findsOneWidget);
  });
}
