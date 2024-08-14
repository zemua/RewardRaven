import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reward_raven/main.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';

void main() {
  group('RewardRavenApp', () {
    testWidgets('displays home page', (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('uses Material3 theme', (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.theme!.useMaterial3, true);
    });

    testWidgets('supports localization', (WidgetTester tester) async {
      await tester.pumpWidget(const RewardRavenApp());
      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.localizationsDelegates, isNotEmpty);
      expect(app.supportedLocales, isNotEmpty);
    });
  });
}
