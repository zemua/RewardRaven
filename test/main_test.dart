import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:reward_raven/main.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'main_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlatformWrapper>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final locator = GetIt.instance;

  setUp(() {
    locator.reset();
  });

  group('RewardRavenApp', () {
    testWidgets('displays home page', (WidgetTester tester) async {
      MockPlatformWrapper mockPlatformWrapper = MockPlatformWrapper();
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
      await tester.pumpWidget(const RewardRavenApp());
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('uses Material3 theme', (WidgetTester tester) async {
      MockPlatformWrapper mockPlatformWrapper = MockPlatformWrapper();
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
      await tester.pumpWidget(const RewardRavenApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, true);
    });

    testWidgets('supports localization', (WidgetTester tester) async {
      MockPlatformWrapper mockPlatformWrapper = MockPlatformWrapper();
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
      await tester.pumpWidget(const RewardRavenApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.localizationsDelegates, isNotEmpty);
      expect(app.supportedLocales, isNotEmpty);
    });
  });
}
