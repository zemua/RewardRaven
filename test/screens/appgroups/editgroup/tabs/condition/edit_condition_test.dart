import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
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

  setUp(() {
    mockGroupConditionService = MockGroupConditionService();
    mockAppGroupService = MockAppGroupService();
    appGroup = const AppGroup(
        id: 'testgroupid', name: 'group name', type: GroupType.positive);
    groupCondition = GroupCondition(
      id: 'testconditionid',
      conditionedGroupId: 'conditionedGroupId',
      conditionalGroupId: 'conditionalGroupId',
      usedTime: const Duration(hours: 1),
      duringLastDays: 7,
    );

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

    expect(find.text('Edit Condition'), findsOneWidget);
    expect(find.text('Condition'), findsOneWidget);
    expect(find.text('Group'), findsOneWidget);
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

    await tester.tap(find.byKey(const Key('timeButton')));
    await tester.pump();

    expect(find.byType(TimePickerDialog), findsOneWidget);
  });

  testWidgets('Days picker is displayed when button is pressed',
      (tester) async {
    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: groupCondition,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('daysButton')));
    await tester.pump();

    expect(find.byType(Dialog), findsOneWidget);
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

    await tester.enterText(find.byKey(const Key('timeController')), '10:00');
    await tester.enterText(find.byKey(const Key('daysController')), '5');
    await tester.tap(find.byKey(const Key('saveButton')));

    expect(find.byKey(const Key('saveButton')), findsOneWidget);
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

    await tester.enterText(find.byKey(const Key('timeController')), '');
    await tester.enterText(find.byKey(const Key('daysController')), '5');
    await tester.tap(find.byKey(const Key('saveButton')));

    expect(find.byKey(const Key('saveButton')), findsNothing);
  });

  testWidgets('tests to be implemented', (tester) async {
    fail("TODO");
  });
}
