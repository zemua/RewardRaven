import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';
import 'package:reward_raven/service/impl/condition_checker_impl.dart';

import 'condition_checker_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GroupConditionService>(),
  MockSpec<AppGroupService>(),
])
void main() {
  final locator = GetIt.instance;

  late ConditionCheckerImpl conditionChecker;

  late MockGroupConditionService mockGroupConditionService;
  late MockAppGroupService mockAppGroupService;

  setUp(() {
    mockGroupConditionService = MockGroupConditionService();
    locator.registerSingleton<GroupConditionService>(mockGroupConditionService);

    mockAppGroupService = MockAppGroupService();
    locator.registerSingleton<AppGroupService>(mockAppGroupService);

    conditionChecker = ConditionCheckerImpl();
  });

  tearDown(() {
    locator.reset();
  });

  group('AppsFetcherProvider', () {
    test('Checks that a condition is met', () async {
      final isMet = await conditionChecker.isConditionMet(GroupCondition(
          conditionedGroupId: "asdfg",
          conditionalGroupId: "zxcvb",
          usedTime: const Duration(hours: 1),
          duringLastDays: 2));

      expect(isMet, true);
    });
  });
}
