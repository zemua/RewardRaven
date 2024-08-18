import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/screens/apps/app_list.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';

import 'app_list_test.mocks.dart';

@GenerateMocks([AppsFetcher, ListedAppService])
void main() {
  final locator = GetIt.instance;

  setUp(() {
    locator.reset();
  });

  tearDown(() {
    locator.reset();
  });

  Widget createTestableWidget(Widget child) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      home: child,
    );
  }

  group('AppList', () {
    testWidgets('displays CircularProgressIndicator while waiting for data',
        (WidgetTester tester) async {
      final mockAppsFetcher = MockAppsFetcher();
      locator.registerSingleton<AppsFetcher>(mockAppsFetcher);
      when(mockAppsFetcher.fetchInstalledApps()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestableWidget(AppList()));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays error message when fetch fails',
        (WidgetTester tester) async {
      final mockAppsFetcher = MockAppsFetcher();
      locator.registerSingleton<AppsFetcher>(mockAppsFetcher);
      when(mockAppsFetcher.fetchInstalledApps())
          .thenAnswer((_) async => throw Exception('Failed to fetch apps'));

      await tester.pumpWidget(createTestableWidget(AppList()));
      await tester.pump();

      expect(
          find.text('Error: Exception: Failed to fetch apps'), findsOneWidget);
    });

    testWidgets('displays no apps found message when no apps are installed',
        (WidgetTester tester) async {
      final mockAppsFetcher = MockAppsFetcher();
      locator.registerSingleton<AppsFetcher>(mockAppsFetcher);
      when(mockAppsFetcher.fetchInstalledApps()).thenAnswer((_) async => []);

      await tester.pumpWidget(createTestableWidget(AppList()));
      await tester.pump();

      expect(find.text('No apps found'), findsOneWidget);
    });

    testWidgets('displays list of installed apps', (WidgetTester tester) async {
      final apps = [
        AppInfo(
          name: 'App 1',
          icon: Uint8List(0),
          packageName: 'com.example.app1',
          versionName: '1.0.0',
          versionCode: 1,
          builtWith: BuiltWith.flutter,
          installedTimestamp: DateTime.now().millisecondsSinceEpoch,
        ),
        AppInfo(
          name: 'App 2',
          icon: Uint8List(0),
          packageName: 'com.example.app2',
          versionName: '1.0.0',
          versionCode: 1,
          builtWith: BuiltWith.flutter,
          installedTimestamp: DateTime.now().millisecondsSinceEpoch,
        ),
      ];
      final mockAppsFetcher = MockAppsFetcher();
      locator.registerSingleton<AppsFetcher>(mockAppsFetcher);
      when(mockAppsFetcher.fetchInstalledApps()).thenAnswer((_) async => apps);
      final mockListedAppService = MockListedAppService();
      locator.registerSingleton<ListedAppService>(mockListedAppService);
      when(mockListedAppService.fetchStatus(any))
          .thenAnswer((_) async => AppStatus.NEUTRAL);

      await tester.pumpWidget(createTestableWidget(AppList()));
      await tester.pump();

      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text('App 1'), findsOneWidget);
      expect(find.text('App 2'), findsOneWidget);
    });
  });
}
