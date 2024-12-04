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
      const expectedGroupCondition = GroupCondition(
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
          conditionalGroupId: conditionalGroupId);

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
          conditionalGroupId: conditionalGroupId);

      expect(result, isNull);
    });

    test('should perform some action', () async {
      fail("Not yet implemented");
    });
  });
}
