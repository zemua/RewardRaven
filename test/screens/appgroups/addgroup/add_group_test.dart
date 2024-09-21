import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reward_raven/screens/appgroups/addgroup/add_group.dart';

void main() {
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
    await tester.pumpWidget(createLocalizationTestableWidget(AddGroupScreen()));

    // Check if the TextField for group name is displayed
    expect(find.byType(TextField), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Group Name'), findsOneWidget);

    // Check if the Add Group button is displayed
    expect(find.widgetWithText(ElevatedButton, 'Add Group'), findsOneWidget);
  });

  // TODO save to db when button is pressed

  // TODO if name is empty cannot save

  // TODO return to previous screen when button is pressed
}
