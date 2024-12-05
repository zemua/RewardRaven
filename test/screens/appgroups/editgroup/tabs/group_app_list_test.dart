import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/screens/appgroups/editgroup/edit_group.dart';
import 'package:reward_raven/screens/appgroups/editgroup/tabs/group_app_list.dart';
import 'package:reward_raven/screens/apps/app_list_type.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';

import '../../../../test_utils/localization_testable.dart';
import 'group_app_list_test.mocks.dart';

// TODO move file to tabs folder for apps
@GenerateMocks([AppsFetcher, ListedAppService])
void main() {
  final locator = GetIt.instance;
  final mockAppFetcher = MockAppsFetcher();
  final mockListedAppService = MockListedAppService();

  locator.registerSingleton<AppsFetcher>(mockAppFetcher);
  locator.registerSingleton<ListedAppService>(mockListedAppService);

  setUp(() {
    // Define the test data
    final testApps = [
      AppInfo(
        name: 'App 1',
        packageName: 'com.example.app1',
        icon: Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
        versionName: '1.0.0',
        versionCode: 1,
        builtWith: BuiltWith.flutter,
        installedTimestamp: 0,
      ),
      AppInfo(
        name: 'App 2',
        packageName: 'com.example.app2',
        icon: Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
        versionName: '1.0.0',
        versionCode: 1,
        builtWith: BuiltWith.flutter,
        installedTimestamp: 0,
      ),
      AppInfo(
        name: 'App 3',
        packageName: 'com.example.app3',
        icon: Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
        versionName: '1.0.0',
        versionCode: 1,
        builtWith: BuiltWith.flutter,
        installedTimestamp: 0,
      ),
      AppInfo(
        name: 'App 4',
        packageName: 'com.example.app4',
        icon: Uint8List.fromList([0, 1, 2, 3, 4, 5, 6, 7, 8, 9]),
        versionName: '1.0.0',
        versionCode: 1,
        builtWith: BuiltWith.flutter,
        installedTimestamp: 0,
      ),
    ];

    final testListedApps = [
      const ListedApp(
          identifier: 'com.example.app1',
          listId: 'testGroupId',
          platform: 'android',
          status: AppStatus.positive),
      const ListedApp(
          identifier: 'com.example.app2',
          listId: null,
          platform: 'android',
          status: AppStatus.positive),
      const ListedApp(
          identifier: 'com.example.appXXX',
          listId: 'testGroupId',
          platform: 'android',
          status: AppStatus.positive),
      const ListedApp(
          identifier: 'com.example.app4',
          listId: 'anotherGroup',
          platform: 'android',
          status: AppStatus.positive),
    ];

    // Stub the fetch methods
    when(mockAppFetcher.fetchInstalledApps()).thenAnswer((_) async => testApps);
    when(mockListedAppService.fetchListedAppsByType(AppListType.positive))
        .thenAnswer((_) async => testListedApps);
    when(mockAppFetcher.fetchApp(testApps[0].packageName))
        .thenAnswer((_) async => testApps[0]);
    when(mockAppFetcher.fetchApp(testApps[1].packageName))
        .thenAnswer((_) async => testApps[1]);
    when(mockAppFetcher.fetchApp(testApps[2].packageName))
        .thenAnswer((_) async => testApps[2]);
    when(mockAppFetcher.fetchApp(testApps[3].packageName))
        .thenAnswer((_) async => testApps[3]);
    when(mockAppFetcher.fetchApp('com.example.appXXX'))
        .thenAnswer((_) async => null);
  });

  group('EditGroup Screen Tests', () {
    testWidgets('shows apps retrieved from AppFetcher and ListedAppService',
        (WidgetTester tester) async {
      // Build the EditGroupScreen widget
      await tester
          .pumpWidget(createLocalizationTestableWidget(const EditGroupScreen(
        group: AppGroup(
            name: 'Test Group', id: 'testGroupId', type: GroupType.positive),
        listType: AppListType.positive,
      )));

      // Verify that the TabBar contains the 'Apps' tab
      expect(find.text('Apps'), findsOneWidget);

      // Tap on the 'Apps' tab
      await tester.tap(find.text('Apps'));
      await tester.pumpAndSettle();

      // Verify that the apps list is displayed
      expect(find.byType(GroupAppItem), findsNWidgets(3));

      expect(find.text('App 1'), findsOneWidget);
      expect(
          find.descendant(
              of: find.ancestor(
                  of: find.text('App 1'), matching: find.byType(ListTile)),
              matching: find.byWidgetPredicate((widget) =>
                  widget is Switch &&
                  widget.value == true &&
                  widget.onChanged != null)),
          findsOneWidget);

      expect(find.text('App 2'), findsOneWidget);
      expect(
          find.descendant(
              of: find.ancestor(
                  of: find.text('App 2'), matching: find.byType(ListTile)),
              matching: find.byWidgetPredicate((widget) =>
                  widget is Switch &&
                  widget.value == false &&
                  widget.onChanged != null)),
          findsOneWidget);

      expect(find.text('App 3'), findsNothing);

      expect(find.text('App 4'), findsOneWidget);
      expect(
          find.descendant(
              of: find.ancestor(
                  of: find.text('App 4'), matching: find.byType(ListTile)),
              matching: find.byWidgetPredicate((widget) =>
                  widget is Switch &&
                  widget.value == false &&
                  widget.onChanged == null)),
          findsOneWidget);
    });

    testWidgets('Test interactions with the switches',
        (WidgetTester tester) async {
      // Build the EditGroupScreen widget
      await tester
          .pumpWidget(createLocalizationTestableWidget(const EditGroupScreen(
        group: AppGroup(
            name: 'Test Group', id: 'testGroupId', type: GroupType.positive),
        listType: AppListType.positive,
      )));

      // Verify that the TabBar contains the 'Apps' tab
      expect(find.text('Apps'), findsOneWidget);

      // Tap on the 'Apps' tab
      await tester.tap(find.text('Apps'));
      await tester.pumpAndSettle();

      // Verify thw switch interactions
      await tester.tap(find.descendant(
          of: find.ancestor(
              of: find.text('App 1'), matching: find.byType(ListTile)),
          matching: find.byType(Switch)));
      await tester.pumpAndSettle();

      var captured1 = verify(mockListedAppService.updateListedApp(captureAny))
          .captured
          .single as ListedApp;
      expect(captured1.listId, null);
      expect(captured1.identifier, "com.example.app1");
      expect(captured1.status, AppStatus.positive);
      expect(captured1.platform, "android");

      await tester.tap(find.descendant(
          of: find.ancestor(
              of: find.text('App 2'), matching: find.byType(ListTile)),
          matching: find.byType(Switch)));
      await tester.pumpAndSettle();

      var captured2 = verify(mockListedAppService.updateListedApp(captureAny))
          .captured
          .single as ListedApp;
      expect(captured2.listId, "testGroupId");
      expect(captured2.identifier, "com.example.app2");
      expect(captured2.status, AppStatus.positive);
      expect(captured2.platform, "android");
    });
  });
}
