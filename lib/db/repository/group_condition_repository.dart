import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/main.dart';

import '../entity/collections.dart';
import '../entity/group_condition.dart';
import '../helper/firebase_helper.dart';

class GroupConditionRepository {
  final FirebaseHelper _firebaseHelper = locator.get<FirebaseHelper>();

  final logger = Logger();

  GroupConditionRepository();

  Future<void> saveGroupCondition(GroupCondition condition) async {
    try {
      final ref = await _resolveReference(condition);
      logger.d("Saving group condition to: ${ref.path}");
      await ref.set(condition.toJson()).timeout(const Duration(seconds: 10));
      logger.d(
          "Saved group condition: ${condition.conditionedGroupId} ${condition.conditionalGroupId}");
    } catch (e) {
      logger.e('Failed to save group condition: $e');
    }
  }

  Future<void> updateGroupCondition(GroupCondition condition) async {
    try {
      final ref = await _resolveReference(condition);
      await ref.update(condition.toJson()).timeout(const Duration(seconds: 10));
      logger.d(
          "Updated group condition: ${condition.conditionedGroupId} ${condition.conditionalGroupId}");
    } catch (e) {
      logger.e('Failed to update group condition: $e');
    }
  }

  Future<void> deleteGroupCondition(GroupCondition condition) async {
    try {
      final ref = await _resolveReference(condition);
      await ref.remove().timeout(const Duration(seconds: 10));
      logger.d(
          "Deleted group condition: ${condition.conditionedGroupId} ${condition.conditionalGroupId}");
    } catch (e) {
      logger.e('Failed to delete group condition: $e');
    }
  }

  Future<GroupCondition?> getGroupConditionByIds(
      {required String conditionedGroupId,
      required String conditionalGroupId}) async {
    try {
      final ref = await _resolveReferenceByIds(
          conditionedGroupId: conditionedGroupId,
          conditionalGroupId: conditionalGroupId);
      final dbEvent = await ref.once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        logger.d("Got group condition from: ${ref.path}");
        return GroupCondition.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      } else {
        logger.d(
            'Group condition not found: $conditionedGroupId $conditionalGroupId');
      }
    } catch (e) {
      logger.e('Failed to get group condition: $e');
      rethrow;
    }
    return null;
  }

  Future<List<GroupCondition>> getGroupConditions(String groupId) async {
    try {
      final ref = await _resolveReferenceById(groupId);
      final dbEvent = await ref.once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        final Map<dynamic, dynamic> groupConditionsMap =
            snapshot.value as Map<dynamic, dynamic>;
        final List<GroupCondition> groupConditions = groupConditionsMap.values
            .map((json) =>
                GroupCondition.fromJson(Map<String, dynamic>.from(json)))
            .toList();
        logger.d("Got group conditions for group $groupId: $groupConditions");
        return groupConditions;
      } else {
        logger.d('No group conditions found for group: $groupId');
      }
    } catch (e) {
      logger.e('Failed to get group conditions: $e');
      rethrow;
    }
    return [];
  }

  Future<DatabaseReference> _resolveReference(GroupCondition condition) async {
    return _resolveReferenceByIds(
        conditionedGroupId: condition.conditionedGroupId,
        conditionalGroupId: condition.conditionalGroupId);
  }

  Future<DatabaseReference> _resolveReferenceByIds(
      {required String conditionedGroupId,
      required String conditionalGroupId}) async {
    try {
      if (conditionalGroupId.isEmpty) {
        throw Exception('Conditional group id cannot be empty');
      }
      final dbRef = await _resolveReferenceById(conditionedGroupId);
      logger.d(
          "Processing group condition node: conditional group $conditionalGroupId");
      return dbRef.child(sanitizeDbPath(conditionalGroupId));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }

  Future<DatabaseReference> _resolveReferenceById(
      String conditionedGroupId) async {
    try {
      if (conditionedGroupId.isEmpty) {
        throw Exception(
            'Conditioned group id and conditional group id cannot be empty');
      }
      final dbRef = await _firebaseHelper.databaseReference;
      logger.d(
          "Processing group condition node: conditioned group $conditionedGroupId");
      return dbRef
          .child(sanitizeDbPath(DbCollection.groupConditions.name))
          .child(sanitizeDbPath(conditionedGroupId));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }
}
