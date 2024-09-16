import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:reward_raven/screens/appgroups/app_group_list.dart';
import 'package:reward_raven/screens/appgroups/app_group_list_type.dart';

void main() {
  final GetIt locator = GetIt.instance;

  setUp(() {});

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

  group('AppGroupList', () {
    // TODO implement tests
    testWidgets('displays CircularProgressIndicator while waiting for data',
        (WidgetTester tester) async {
      /*final mockGroupsService = MockGroupsService();
      locator.registerSingleton<GroupsService>(mockGroupsService);
      when(mockGroupsService.getGroups()).thenAnswer((_) async => []);*/

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    test('tests', () {
      fail('To implement');
    });
  });
}
