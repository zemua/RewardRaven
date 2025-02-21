import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/repository/group_condition_repository.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';

import 'group_condition_service_test.mocks.dart';

@GenerateMocks([GroupConditionRepository])
void main() {
  final locator = GetIt.instance;

  group('GroupConditionService', () {
    late GroupConditionService groupConditionService;
    late MockGroupConditionRepository mockGroupConditionRepository;

    setUp(() {
      mockGroupConditionRepository = MockGroupConditionRepository();
      locator.registerSingleton<GroupConditionRepository>(
          mockGroupConditionRepository);
      groupConditionService = GroupConditionService();
    });

    tearDown(() {
      locator.reset();
    });

    test('getGroupCondition returns a GroupCondition when found', () async {
      const conditionedGroupId = 'conditionedGroup1';
      const conditionalGroupId = 'conditionalGroup1';
      final expectedGroupCondition = GroupCondition(
        conditionedGroupId: conditionedGroupId,
        conditionalGroupId: conditionalGroupId,
        usedTime: Duration(hours: 1),
        duringLastDays: 7,
      );

      when(mockGroupConditionRepository.getGroupConditionByIds(
              conditionedGroupId: conditionedGroupId,
              conditionalGroupId: conditionalGroupId))
          .thenAnswer((_) async => expectedGroupCondition);

      final result = await groupConditionService.getGroupCondition(
          conditionedGroupId: conditionedGroupId,
          conditionId: conditionalGroupId);

      expect(result, equals(expectedGroupCondition));
    });

    test('getGroupCondition returns null when not found', () async {
      const conditionedGroupId = 'conditionedGroup1';
      const conditionalGroupId = 'conditionalGroup1';

      when(mockGroupConditionRepository.getGroupConditionByIds(
              conditionedGroupId: conditionedGroupId,
              conditionalGroupId: conditionalGroupId))
          .thenAnswer((_) async => null);

      final result = await groupConditionService.getGroupCondition(
          conditionedGroupId: conditionedGroupId,
          conditionId: conditionalGroupId);

      expect(result, isNull);
    });

    test('getGroupConditions returns a list of GroupConditions when found',
        () async {
      const conditionedGroupId = 'conditionedGroup1';
      final expectedGroupConditions = [
        GroupCondition(
          conditionedGroupId: conditionedGroupId,
          conditionalGroupId: 'conditionalGroup1',
          usedTime: Duration(hours: 1),
          duringLastDays: 7,
        ),
        GroupCondition(
          conditionedGroupId: conditionedGroupId,
          conditionalGroupId: 'conditionalGroup2',
          usedTime: Duration(hours: 2),
          duringLastDays: 5,
        ),
      ];

      when(mockGroupConditionRepository.getGroupConditions(conditionedGroupId))
          .thenAnswer((_) async => expectedGroupConditions);

      final result =
          await groupConditionService.getGroupConditions(conditionedGroupId);

      expect(result, equals(expectedGroupConditions));
    });

    test(
        'getGroupConditions returns an empty list when no conditions are found',
        () async {
      const conditionedGroupId = 'conditionedGroup1';

      when(mockGroupConditionRepository.getGroupConditions(conditionedGroupId))
          .thenAnswer((_) async => []);

      final result =
          await groupConditionService.getGroupConditions(conditionedGroupId);

      expect(result, isEmpty);
    });

    test('saveGroupCondition saves a group condition successfully', () async {
      final groupCondition = GroupCondition(
        conditionedGroupId: 'testConditionedGroupId',
        conditionalGroupId: 'testConditionalGroupId',
        usedTime: Duration(hours: 1),
        duringLastDays: 7,
      );
      when(mockGroupConditionRepository.saveGroupCondition(groupCondition))
          .thenAnswer((_) => Future.value());
      await groupConditionService.saveGroupCondition(groupCondition);
      verify(mockGroupConditionRepository.saveGroupCondition(groupCondition))
          .called(1);
    });

    test('updateGroupCondition updates a group condition successfully',
        () async {
      final groupCondition = GroupCondition(
        conditionedGroupId: 'testConditionedGroupId',
        conditionalGroupId: 'testConditionalGroupId',
        usedTime: Duration(hours: 1),
        duringLastDays: 7,
      );
      when(mockGroupConditionRepository.updateGroupCondition(groupCondition))
          .thenAnswer((_) => Future.value());
      await groupConditionService.updateGroupCondition(groupCondition);
      verify(mockGroupConditionRepository.updateGroupCondition(groupCondition))
          .called(1);
    });

    test('deleteGroupCondition deletes a group condition successfully',
        () async {
      final groupCondition = GroupCondition(
        conditionedGroupId: 'testConditionedGroupId',
        conditionalGroupId: 'testConditionalGroupId',
        usedTime: Duration(hours: 1),
        duringLastDays: 7,
      );
      when(mockGroupConditionRepository.deleteGroupCondition(groupCondition))
          .thenAnswer((_) => Future.value());

      await groupConditionService.deleteGroupCondition(groupCondition);

      verify(mockGroupConditionRepository.deleteGroupCondition(groupCondition))
          .called(1);
    });
  });

  test('streamGroupConditions retrieves group conditions successfully',
      () async {
    fail("not yet implemented");
  });
}
