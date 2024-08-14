import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/main.dart';
import 'package:reward_raven/screens/apps/app_list.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';

void main() {
  final getIt = GetIt.instance;

  setUp(() {
    getIt.registerSingleton<AppsFetcher>(MockAppsFetcher());
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

    testWidgets('prints message on positive groups button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Positive Groups'));
      await tester.pump();
      // Check console output for the message
    });

    testWidgets('prints message on negative apps button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Negative Apps'));
      await tester.pump();
      // Check console output for the message
    });

    testWidgets('prints message on negative groups button press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      await tester.tap(find.text('Negative Groups'));
      await tester.pump();
      // Check console output for the message
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
}
