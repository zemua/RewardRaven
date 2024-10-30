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
import 'package:reward_raven/screens/apps/app_list_type.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';

import 'edit_group_test.mocks.dart';

@GenerateMocks([AppsFetcher, ListedAppService])
void main() {
  final locator = GetIt.instance;
  final mockAppFetcher = MockAppsFetcher();
  final mockListedAppService = MockListedAppService();

  setUp(() {
    locator.registerSingleton<AppsFetcher>(mockAppFetcher);
    locator.registerSingleton<ListedAppService>(mockListedAppService);
  });

  group('EditGroup Screen Tests', () {
    testWidgets('shows apps retrieved from AppFetcher and ListedAppService',
        (WidgetTester tester) async {
      // Define the test data
      final testApps = [
        AppInfo(
          name: 'App 1',
          packageName: 'com.example.app1',
          icon: Uint8List(0),
          versionName: '1.0.0',
          versionCode: 1,
          builtWith: BuiltWith.flutter,
          installedTimestamp: 0,
        ),
        AppInfo(
          name: 'App 2',
          packageName: 'com.example.app2',
          icon: Uint8List(0),
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
            listId: 'testGroupId',
            platform: 'android',
            status: AppStatus.positive),
      ];

      // Stub the fetch methods
      when(mockAppFetcher.fetchInstalledApps())
          .thenAnswer((_) async => testApps);
      when(mockListedAppService.fetchListedAppsByType(AppListType.positive))
          .thenAnswer((_) async => testListedApps);

      // Build the EditGroupScreen widget
      await tester.pumpWidget(
        const MaterialApp(
          home: EditGroupScreen(
            group: AppGroup(
                name: 'Test Group',
                id: 'testGroupId',
                type: GroupType.positive),
            listType: AppListType.positive,
          ),
        ),
      );

      // Verify that the TabBar contains the 'Apps' tab
      expect(find.text('Apps'), findsOneWidget);

      // Tap on the 'Apps' tab
      await tester.tap(find.text('Apps'));
      await tester.pumpAndSettle();

      // Verify that the apps list is displayed
      expect(find.byType(GroupAppItem), findsNWidgets(2));
      expect(find.text('App 1'), findsOneWidget);
      expect(find.text('App 2'), findsOneWidget);

      fail('Finish the test');
    });
  });
}
