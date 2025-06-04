import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/entity/time_log.dart';
import 'package:reward_raven/db/service/time_log_service.dart';
import 'package:reward_raven/service/impl/condition_checker_impl.dart';

import 'condition_checker_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TimeLogService>(),
])
void main() {
  final locator = GetIt.instance;

  late ConditionCheckerImpl conditionChecker;

  late MockTimeLogService mockTimeLogService;

  setUp(() {
    mockTimeLogService = MockTimeLogService();
    locator.registerSingleton<TimeLogService>(mockTimeLogService);

    conditionChecker = ConditionCheckerImpl();
  });

  tearDown(() {
    locator.reset();
  });

  group('AppsFetcherProvider', () {
    test('Checks that a condition is met', () async {
      when(mockTimeLogService.getGroupDurationForLastDays("zxcvb", 2))
          .thenAnswer((_) => Future.value(TimeLog(
              used: const Duration(hours: 2),
              counted: const Duration(minutes: 30),
              dateTime: DateTime.now())));

      final isMet = await conditionChecker.isConditionMet(GroupCondition(
          conditionedGroupId: "asdfg",
          conditionalGroupId: "zxcvb",
          usedTime: const Duration(hours: 1),
          duringLastDays: 2));

      expect(isMet, true);

      final isNotMet = await conditionChecker.isConditionMet(GroupCondition(
          conditionedGroupId: "asdfg",
          conditionalGroupId: "zxcvb",
          usedTime: const Duration(hours: 3),
          duringLastDays: 2));

      expect(isNotMet, false);
    });
  });
}
