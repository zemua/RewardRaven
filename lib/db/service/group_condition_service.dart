import 'package:logger/logger.dart';
import 'package:reward_raven/db/repository/group_condition_repository.dart';

import '../../main.dart';
import '../entity/group_condition.dart';

class GroupConditionService {
  final Logger _logger = Logger();
  final GroupConditionRepository _repository =
      locator<GroupConditionRepository>();

  Future<GroupCondition?> getGroupCondition(
      String conditionedGroupId, String conditionalGroupId) async {
    try {
      return await _repository.getGroupConditionByIds(
          conditionedGroupId: conditionedGroupId,
          conditionalGroupId: conditionalGroupId);
    } catch (e) {
      _logger.e('Error while getting group conditions: $e');
      rethrow;
    }
  }

  Future<List<GroupCondition>> getGroupConditions(String groupId) async {
    try {
      return await _repository.getGroupConditions(groupId);
    } catch (e) {
      _logger.e('Error while getting group conditions: $e');
      rethrow;
    }
  }

  Future<void> saveGroupCondition(GroupCondition groupCondition) async {
    try {
      await _repository.saveGroupCondition(groupCondition);
    } catch (e) {
      _logger.e('Error while adding group condition: $e');
      rethrow;
    }
  }

  Future<void> updateGroupCondition(GroupCondition groupCondition) async {
    try {
      await _repository.updateGroupCondition(groupCondition);
    } catch (e) {
      _logger.e('Error while updating group condition: $e');
      rethrow;
    }
  }

  Future<void> deleteGroupCondition(GroupCondition groupCondition) async {
    try {
      await _repository.deleteGroupCondition(groupCondition);
    } catch (e) {
      _logger.e('Error while deleting group condition: $e');
      rethrow;
    }
  }
}
