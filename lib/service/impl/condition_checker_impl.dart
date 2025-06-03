import 'package:get_it/get_it.dart';

import '../../db/entity/group_condition.dart';
import '../../db/service/time_log_service.dart';
import '../condition_checker.dart';

final GetIt locator = GetIt.instance;

class ConditionCheckerImpl implements ConditionChecker {
  final TimeLogService _timeLogService = locator.get<TimeLogService>();

  @override
  Future<bool> isConditionMet(GroupCondition condition) async {
    final usedSeconds = await _timeLogService.getGroupSecondsForLastDays(
        condition.conditionalGroupId, condition.duringLastDays);
    return usedSeconds >= condition.usedTime.inSeconds;
  }
}
