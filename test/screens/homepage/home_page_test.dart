import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/main.dart';
import 'package:reward_raven/screens/appgroups/app_group_list.dart';
import 'package:reward_raven/screens/apps/app_list.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'home_page_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlatformWrapper>()])
void main() {
  final getIt = GetIt.instance;

  setUp(() {
    getIt.registerSingleton<AppsFetcher>(MockAppsFetcher());
    getIt.registerSingleton<AppGroupService>(MockAppGroupService());
    getIt.registerSingleton<PlatformWrapper>(MockPlatformWrapper());
  });

  tearDown(() {
    getIt.reset();
  });

  group('Home Page', () {
    testWidgets('navigates to app list on positive apps button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Positive Apps'));
      await tester.pumpAndSettle();
      expect(find.byType(AppList), findsOneWidget);
    });

    testWidgets('navigates to app group list on positive groups button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Positive Groups'));
      await tester.pumpAndSettle();
      expect(find.byType(AppGroupList), findsOneWidget);
    });

    testWidgets('navigates to negative apps list on negative apps button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Negative Apps'));
      await tester.pumpAndSettle();
      expect(find.byType(AppList), findsOneWidget);
    });

    testWidgets(
        'navigates to negative groups list on negative groups button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Negative Groups'));
      await tester.pumpAndSettle();
      expect(find.byType(AppGroupList), findsOneWidget);
    });

    testWidgets('prints message on random checks button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Random Checks'));
      await tester.pump();
      // Check console output for the message
    });

    testWidgets('prints message on my timings button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('My Timings'));
      await tester.pump();
      // Check console output for the message
    });

    testWidgets('prints message on settings button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Settings'));
      await tester.pump();
      // Check console output for the message
    });
  });
}

class MockAppsFetcher extends Mock implements AppsFetcher {
  @override
  Future<List<AppInfo>> fetchInstalledApps() async {
    return [];
  }

  @override
  Future<List<AppInfo>> fetchAllApps() async {
    return [];
  }

  @override
  bool hasHiddenApps() {
    return true;
  }
}

class MockAppGroupService extends Mock implements AppGroupService {
  @override
  Future<List<AppGroup>> getGroups(GroupType type) async {
    return [
      AppGroup(name: 'Group 1', type: type),
      AppGroup(name: 'Group 2', type: type),
    ];
  }

  @override
  Stream<List<AppGroup>> streamGroups(GroupType type) {
    return Stream.value([
      AppGroup(name: 'Group 1', type: type),
      AppGroup(name: 'Group 2', type: type),
    ]);
  }
}
