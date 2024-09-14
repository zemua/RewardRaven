import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reward_raven/screens/appgroups/group_list.dart';

void main() {
  final GetIt locator = GetIt.instance;

  setUp(() {
    // Set up any necessary dependencies here
  });

  tearDown(() {
    locator.reset();
  });

  testWidgets('shows CircularProgressIndicator while waiting for data',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppGroupList(titleBarMessage: 'Test Title'),
      ),
    );

    // Verify that the CircularProgressIndicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
