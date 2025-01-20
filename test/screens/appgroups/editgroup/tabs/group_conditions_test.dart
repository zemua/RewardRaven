import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/screens/appgroups/editgroup/edit_group.dart';
import 'package:reward_raven/screens/apps/app_list_type.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';

import '../../../../test_utils/localization_testable.dart';
import 'group_conditions_test.mocks.dart';

@GenerateMocks([GroupConditionService])
@GenerateNiceMocks([
  MockSpec<AppsFetcher>(),
  MockSpec<ListedAppService>(),
  MockSpec<AppGroupService>(),
])
void main() {
  final locator = GetIt.instance;
  final mockGroupConditionService = MockGroupConditionService();
  final mockAppFetcher = MockAppsFetcher();
  final mockListedAppService = MockListedAppService();
  final mockAppGroupService = MockAppGroupService();

  locator.registerSingleton<GroupConditionService>(mockGroupConditionService);
  locator.registerSingleton<AppsFetcher>(mockAppFetcher);
  locator.registerSingleton<ListedAppService>(mockListedAppService);
  locator.registerSingleton<AppGroupService>(mockAppGroupService);

  setUp(() {});

  group('EditGroup Screen Tests', () {
    testWidgets(
        'shows "noConditionsFound" when no conditions retrieved from GroupConditionService',
        (WidgetTester tester) async {
      // Reply to call with delay to check loading spinner
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) async => []);

      // Act
      await tester
          .pumpWidget(createLocalizationTestableWidget(const EditGroupScreen(
        group: AppGroup(
            name: 'Test Group', id: 'testGroupId', type: GroupType.positive),
        listType: AppListType.positive,
      )));

      // Verify that the TabBar contains the 'Conditions' tab
      expect(find.text('Conditions'), findsOneWidget);

      // Tap on the 'Conditions' tab
      await tester.tap(find.text('Conditions'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("No conditions found"), findsOneWidget);
    });

    testWidgets('shows conditions retrieved from GroupConditionService',
        (WidgetTester tester) async {
      // Reply to call with delay to check loading spinner
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) async => [
                const GroupCondition(
                    conditionedGroupId: 'testGroupId',
                    conditionalGroupId: 'conditionalGroupId1',
                    usedTime: Duration(minutes: 11),
                    duringLastDays: 1),
                const GroupCondition(
                    conditionedGroupId: 'testGroupId',
                    conditionalGroupId: 'conditionalGroupId2',
                    usedTime: Duration(minutes: 41),
                    duringLastDays: 2),
              ]);

      when(mockAppGroupService.getGroup(GroupType.positive, 'testGroupId'))
          .thenAnswer((_) async => const AppGroup(
                name: 'Test Conditioned Group',
                id: 'testGroupId',
                type: GroupType.positive,
              ));

      when(mockAppGroupService.getGroup(
              GroupType.positive, 'conditionalGroupId1'))
          .thenAnswer((_) async => const AppGroup(
                name: 'Test Conditional Group1',
                id: 'conditionalGroupId1',
                type: GroupType.positive,
              ));

      when(mockAppGroupService.getGroup(
              GroupType.positive, 'conditionalGroupId2'))
          .thenAnswer((_) async => const AppGroup(
                name: 'Test Conditional Group2',
                id: 'conditionalGroupId2',
                type: GroupType.positive,
              ));

      // Act
      await tester
          .pumpWidget(createLocalizationTestableWidget(const EditGroupScreen(
        group: AppGroup(
            name: 'Test Group', id: 'testGroupId', type: GroupType.positive),
        listType: AppListType.positive,
      )));

      // Verify that the TabBar contains the 'Conditions' tab
      expect(find.text('Conditions'), findsOneWidget);

      // Tap on the 'Conditions' tab
      await tester.tap(find.text('Conditions'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text("Test Conditional Group1 for 0:11 in the last 1 days"),
          findsOneWidget);
      expect(find.text("Test Conditional Group2 for 0:41 in the last 2 days"),
          findsOneWidget);
    });

    testWidgets('tests to be implemented', (tester) async {
      fail("TODO");
    });
  });
}
