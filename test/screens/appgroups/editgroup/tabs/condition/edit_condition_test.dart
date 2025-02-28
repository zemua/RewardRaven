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
import 'package:reward_raven/tools/injectable_time_picker.dart';

import '../../../../../test_utils/localization_testable.dart';
import 'edit_condition_test.mocks.dart';

@GenerateMocks([GroupConditionService, AppGroupService, InjectableTimePicker])
void main() {
  late MockGroupConditionService mockGroupConditionService;
  late MockAppGroupService mockAppGroupService;
  late MockInjectableTimePicker mockTimePicker;
  late AppGroup appGroup;
  late GroupCondition groupCondition;
  late AppGroup positiveGroup;
  final locator = GetIt.instance;

  setUp(() {
    mockGroupConditionService = MockGroupConditionService();
    mockAppGroupService = MockAppGroupService();
    mockTimePicker = MockInjectableTimePicker();
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
    GetIt.instance.registerSingleton<InjectableTimePicker>(mockTimePicker);
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
    when(mockTimePicker.showPicker(
            context: anyNamed("context"),
            initialTime: anyNamed("initialTime"),
            builder: anyNamed("builder")))
        .thenAnswer((invocation) async => showTimePicker(
            context: invocation.namedArguments[#context],
            initialTime: invocation.namedArguments[#initialTime],
            builder: invocation.namedArguments[#builder]));

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

  testWidgets('Save button is disabled when days field is empty',
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

  testWidgets('Save button is disabled when time field is 00:00',
      (tester) async {
    when(mockTimePicker.showPicker(
            context: anyNamed("context"),
            initialTime: anyNamed("initialTime"),
            builder: anyNamed("builder")))
        .thenAnswer((_) async => const TimeOfDay(hour: 00, minute: 00));

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
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    verifyNever(mockGroupConditionService.updateGroupCondition(any));
  });

  testWidgets('Save button is enabled when values entered on fields',
      (tester) async {
    when(mockTimePicker.showPicker(
            context: anyNamed("context"),
            initialTime: anyNamed("initialTime"),
            builder: anyNamed("builder")))
        .thenAnswer((_) async => const TimeOfDay(hour: 01, minute: 36));

    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: null,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('daysField')), '1');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeField')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('conditionalGroupDropdown')));
    await tester.pumpAndSettle();
    expect(find.text('listed group'), findsOneWidget);
    await tester.tap(find.text('listed group'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    verifyNever(mockGroupConditionService.updateGroupCondition(any));
    verify(mockGroupConditionService.saveGroupCondition(any)).called(1);
  });

  testWidgets('Save button is disabled when no dropdown selection',
      (tester) async {
    when(mockTimePicker.showPicker(
            context: anyNamed("context"),
            initialTime: anyNamed("initialTime"),
            builder: anyNamed("builder")))
        .thenAnswer((_) async => const TimeOfDay(hour: 01, minute: 36));

    await tester.pumpWidget(
      createLocalizationTestableWidget(
        EditCondition(
          conditionedGroup: appGroup,
          condition: null,
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('daysField')), '1');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('timeField')));
    await tester.pumpAndSettle();
    // Not selecting an entry for the dropdown
    // Commented out code below is used to select an entry for the dropdown,
    // but it is not executed in this test, so the save button should be
    // disabled.
    //
    // await tester.tap(find.byKey(const Key('conditionalGroupDropdown')));
    // await tester.pumpAndSettle();
    // expect(find.text('listed group'), findsOneWidget);
    // await tester.tap(find.text('listed group'));
    // await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('saveButton')));
    await tester.pumpAndSettle();

    verifyNever(mockGroupConditionService.updateGroupCondition(any));
    verifyNever(mockGroupConditionService.saveGroupCondition(any));
  });
}
