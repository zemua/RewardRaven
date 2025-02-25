import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';
import 'package:reward_raven/screens/appgroups/editgroup/tabs/condition/edit_condition.dart';

import '../../../../../test_utils/localization_testable.dart';
import 'edit_condition_test.mocks.dart';

@GenerateMocks([GroupConditionService, AppGroupService])
void main() {
  late MockGroupConditionService mockGroupConditionService;
  late MockAppGroupService mockAppGroupService;
  late AppGroup appGroup;
  late GroupCondition groupCondition;
  late AppGroup positiveGroup;
  late GetIt locator;

  setUp(() {
    mockGroupConditionService = MockGroupConditionService();
    mockAppGroupService = MockAppGroupService();
    appGroup = const AppGroup(
        id: 'testgroupid', name: 'group name', type: GroupType.positive);
    positiveGroup = const AppGroup(
        id: 'listedGroupId', name: 'listed group', type: GroupType.positive);
    groupCondition = GroupCondition(
      id: 'testconditionid',
      conditionedGroupId: 'conditionedGroupId',
      conditionalGroupId: 'listedGroupId',
      usedTime: const Duration(hours: 1),
      duringLastDays: 7,
    );

    when(mockAppGroupService.getGroups(GroupType.positive))
        .thenAnswer((_) async => [positiveGroup]);

    GetIt.instance
        .registerSingleton<GroupConditionService>(mockGroupConditionService);
    GetIt.instance.registerSingleton<AppGroupService>(mockAppGroupService);
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('EditCondition widget displays correctly', (tester) async {
    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: groupCondition,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Edit Condition'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));
  });

  testWidgets('Time picker is displayed when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: groupCondition,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('timeField')));
    await tester.pump();

    expect(find.byType(TimePickerDialog), findsOneWidget);
  });

  testWidgets('Save button is enabled when all fields are filled',
      (tester) async {
    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: groupCondition,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('daysField')), '5');

    expect(find.byKey(const Key('saveButton')), findsOneWidget);
    await tester.tap(find.byKey(const Key('saveButton')));

    final updatedCondition = GroupCondition(
      id: "testconditionid",
      conditionedGroupId: "testgroupid",
      conditionalGroupId: "listedGroupId",
      usedTime: const Duration(hours: 1),
      duringLastDays: 5,
    );
    verify(mockGroupConditionService.updateGroupCondition(updatedCondition))
        .called(1);
  });

  testWidgets('Save button is disabled when any field is empty',
      (tester) async {
    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: groupCondition,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('daysField')), '');
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    verifyNever(mockGroupConditionService.updateGroupCondition(any));
  });

  testWidgets('tests to be implemented', (tester) async {
    fail("TODO");
  });
}
