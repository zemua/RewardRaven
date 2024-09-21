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
import 'package:reward_raven/screens/appgroups/app_group_list.dart';
import 'package:reward_raven/screens/appgroups/app_group_list_type.dart';

import 'app_group_list_test.mocks.dart';

@GenerateMocks([AppGroupService])
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
    testWidgets('displays CircularProgressIndicator while waiting for data',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when fetch fails',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => throw Exception('Failed to fetch groups'));

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the error

      expect(find.text('Error: Exception: Failed to fetch groups'),
          findsOneWidget);
    });

    testWidgets('displays blank screen when no groups are returned',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the empty data

      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets('displays list of groups', (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => [
                AppGroup(name: 'Group 1', type: GroupType.positive),
                AppGroup(name: 'Group 2', type: GroupType.positive),
              ]);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the data

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('Group 1'), findsOneWidget);
      expect(find.text('Group 2'), findsOneWidget);
    });

    testWidgets('displays floating action button before and after data load',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => [
                AppGroup(name: 'Group 1', type: GroupType.positive),
                AppGroup(name: 'Group 2', type: GroupType.positive),
              ]);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      // Check if FAB is displayed before data load
      expect(find.byType(FloatingActionButton), findsOneWidget);

      await tester.pump(); // Rebuild the widget with the data

      // Check if FAB is still displayed after data load
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets(
        'navigates to AddGroupScreen when floating action button is clicked',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.getGroups(GroupType.positive))
          .thenAnswer((_) async => []);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the empty data

      // Tap the floating action button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      // Verify that AddGroupScreen is displayed
      expect(find.byType(AddGroupScreen), findsOneWidget);
    });
  });
}
