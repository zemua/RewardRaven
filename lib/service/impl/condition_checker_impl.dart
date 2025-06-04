import 'package:get_it/get_it.dart';

import '../../db/entity/group_condition.dart';
import '../../db/service/time_log_service.dart';
import '../condition_checker.dart';

final GetIt _locator = GetIt.instance;

class ConditionCheckerImpl implements ConditionChecker {
  final TimeLogService _timeLogService = _locator.get<TimeLogService>();

  @override
  Future<bool> isConditionMet(GroupCondition condition) async {
    final duration = await _timeLogService.getGroupDurationForLastDays(
        condition.conditionalGroupId, condition.duringLastDays);
    return duration.used >= condition.usedTime;
  }
}
