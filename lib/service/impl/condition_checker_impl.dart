import 'package:get_it/get_it.dart';

import '../../db/entity/group_condition.dart';
import '../../db/service/app_group_service.dart';
import '../../db/service/group_condition_service.dart';
import '../condition_checker.dart';

final GetIt locator = GetIt.instance;

class ConditionCheckerImpl implements ConditionChecker {
  final GroupConditionService _groupConditionService =
      locator.get<GroupConditionService>();
  final AppGroupService _appGroupService = locator.get<AppGroupService>();

  @override
  Future<bool> isConditionMet(GroupCondition condition) {
    throw UnimplementedError();
  }
}
