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
      String conditionedGroupId, String conditionalGroupId) async {
    try {
      final ref =
          await _resolveReferenceByIds(conditionedGroupId, conditionalGroupId);
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

  Future<DatabaseReference> _resolveReference(GroupCondition condition) async {
    return _resolveReferenceByIds(
        condition.conditionedGroupId, condition.conditionalGroupId);
  }

  Future<DatabaseReference> _resolveReferenceByIds(
      String conditionedGroupId, String conditionalGroupId) async {
    try {
      if (conditionedGroupId.isEmpty || conditionalGroupId.isEmpty) {
        throw Exception(
            'Conditioned group id and conditional group id cannot be empty');
      }
      final dbRef = await _firebaseHelper.databaseReference;
      logger.d(
          "Processing group condition node: conditioned group ${conditionedGroupId} - conditional group ${conditionalGroupId}");
      return dbRef
          .child(sanitizeDbPath(DbCollection.groupConditions.name))
          .child(sanitizeDbPath(conditionedGroupId))
          .child(sanitizeDbPath(conditionalGroupId));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }
}
