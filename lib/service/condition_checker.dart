import '../db/entity/group_condition.dart';

abstract class ConditionChecker {
  Future<bool> isConditionMet(GroupCondition condition);
}
