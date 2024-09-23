import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/screens/appgroups/addgroup/add_group.dart';

import 'add_group_test.mocks.dart';

@GenerateMocks([AppGroupService])
void main() {
  AppGroupService appGroupService = MockAppGroupService();

  final GetIt locator = GetIt.instance;

  setUp(() {
    locator.registerSingleton<AppGroupService>(appGroupService);
  });

  tearDown(() {
    locator.reset();
  });

  Widget createLocalizationTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
      ],
      home: child,
    );
  }

  testWidgets('displays group name field and add button',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizationTestableWidget(
        AddGroupScreen(groupType: GroupType.positive)));

    // Check if the TextField for group name is displayed
    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Group Name'), findsOneWidget);

    // Check if the Add Group button is displayed
    expect(find.widgetWithText(ElevatedButton, 'Add Group'), findsOneWidget);
  });

  testWidgets('calls appGroupService.save when button is pressed',
      (WidgetTester tester) async {
    await tester.pumpWidget(createLocalizationTestableWidget(
        AddGroupScreen(groupType: GroupType.positive)));

    // Enter text into the TextField
    await tester.enterText(find.byType(TextField), 'New Group');

    // Tap the Add Group button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Group'));
    await tester.pump();

    final appGroup = AppGroup(name: 'New Group', type: GroupType.positive);
    // Verify that group save was called with the correct argument
    verify(appGroupService.saveGroup(appGroup)).called(1);
  });

  // TODO if name is empty cannot save and popup is shown

  // TODO return to previous screen when button is pressed
}
