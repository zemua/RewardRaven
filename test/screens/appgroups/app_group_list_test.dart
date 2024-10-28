import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/screens/appgroups/addgroup/add_group.dart';
import 'package:reward_raven/screens/appgroups/app_group_list.dart';
import 'package:reward_raven/screens/appgroups/app_group_list_type.dart';
import 'package:reward_raven/screens/appgroups/editgroup/edit_group.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';

import 'app_group_list_test.mocks.dart';

@GenerateMocks([AppsFetcher, ListedAppService, AppGroupService])
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
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => const Stream.empty());

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
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => Stream.error(Exception('Failed to fetch groups')));

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the error

      expect(find.textContaining('Failed to fetch groups'), findsOneWidget);
    });

    testWidgets('displays no groups found when timeout exception',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.streamGroups(GroupType.positive)).thenAnswer(
          (_) => Stream.error(TimeoutException('Failed to fetch groups')));

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the error

      expect(
          find.textContaining('No elements or network error'), findsOneWidget);
    });

    testWidgets('displays blank screen when no groups are returned',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => const Stream.empty());

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
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => Stream.value([
                const AppGroup(name: 'Group 1', type: GroupType.positive),
                const AppGroup(name: 'Group 2', type: GroupType.positive),
              ]));

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
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => Stream.value([
                const AppGroup(name: 'Group 1', type: GroupType.positive),
                const AppGroup(name: 'Group 2', type: GroupType.positive),
              ]));

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
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => const Stream.empty());

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

    testWidgets('navigates to EditGroupScreen when a ListTile is clicked',
        (WidgetTester tester) async {
      final mockGroupsService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockGroupsService);
      final mockListedAppService = MockListedAppService();
      locator.registerSingleton<ListedAppService>(mockListedAppService);
      final mockAppsFetcher = MockAppsFetcher();
      locator.registerSingleton<AppsFetcher>(mockAppsFetcher);
      when(mockGroupsService.streamGroups(GroupType.positive))
          .thenAnswer((_) => Stream.value([
                const AppGroup(name: 'Group 1', type: GroupType.positive),
                const AppGroup(name: 'Group 2', type: GroupType.positive),
              ]));

      when(mockAppsFetcher.fetchInstalledApps()).thenAnswer((_) async => []);

      await tester.pumpWidget(createLocalizationTestableWidget(
          const AppGroupList(
              listType: AppGroupListType.positive,
              titleBarMessage: "Title Bar Message")));

      await tester.pump(); // Rebuild the widget with the data

      // Tap the first ListTile
      await tester.tap(find.text('Group 1'));
      await tester.pumpAndSettle(); // Wait for the navigation to complete

      // Verify that EditGroupScreen is displayed
      expect(find.byType(EditGroupScreen), findsOneWidget);
    });
  });
}
