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
    if (condition.id != null) {
      throw Exception('Group condition id cannot be set');
    }
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
    if (condition.id == null) {
      throw Exception('Group condition id cannot be null');
    }
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
          "Deleted group condition: ${condition.conditionedGroupId} ${condition.id}");
    } catch (e) {
      logger.e('Failed to delete group condition: $e');
    }
  }

  Future<GroupCondition?> getGroupConditionByIds(
      {required String conditionedGroupId, required String conditionId}) async {
    try {
      final ref = await _resolveReferenceByIds(
          conditionedGroupId: conditionedGroupId, conditionId: conditionId);
      final dbEvent = await ref.once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        logger.d("Got group condition from: ${ref.path}");
        GroupCondition groupCondition = GroupCondition.fromJson(
            json: Map<String, dynamic>.from(snapshot.value as Map));
        groupCondition.id = snapshot.key;
        return GroupCondition.fromJson(
            json: Map<String, dynamic>.from(snapshot.value as Map));
      } else {
        logger.d('Group condition not found: $conditionedGroupId $conditionId');
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
        final List<GroupCondition> groupConditions =
            groupConditionsMap.entries.map((entry) {
          GroupCondition fetchedCondition = GroupCondition.fromJson(
              json: Map<String, dynamic>.from(entry.value));
          fetchedCondition.id = entry.key;
          return fetchedCondition;
        }).toList();
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

  Stream<List<GroupCondition>> streamGroupConditions(String groupId) {
    logger.d('Streaming conditions of group id: $groupId');
    return _resolveReferenceById(groupId).asStream().asyncExpand((ref) {
      logger.d('Resolved reference at: ${ref.path}');
      final completer = Completer<void>();
      return ref.onValue.timeout(const Duration(seconds: 10),
          onTimeout: (sink) {
        if (!completer.isCompleted) {
          completer.completeError(
              TimeoutException('Timeout while streaming conditions'));
          sink.addError(TimeoutException('Timeout while streaming conditions'));
        }
      }).map((event) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        logger.d('Received event: $event');
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          final Map<dynamic, dynamic> conditionsMap =
              snapshot.value as Map<dynamic, dynamic>;
          final List<GroupCondition> conditions =
              conditionsMap.entries.map((entry) {
            GroupCondition fetchedCondition = GroupCondition.fromJson(
                json: Map<String, dynamic>.from(entry.value));
            fetchedCondition.id = entry.key;
            return fetchedCondition;
          }).toList();
          logger.i(
              "Streamed ${conditions.length} conditions of group id: $groupId");
          return conditions;
        } else {
          logger.i('No conditions found for group id: $groupId');
          return [];
        }
      });
    });
  }

  Future<DatabaseReference> _resolveReference(GroupCondition condition) async {
    return _resolveReferenceByIds(
        conditionedGroupId: condition.conditionedGroupId,
        conditionId: condition.id);
  }

  Future<DatabaseReference> _resolveReferenceByIds(
      {required String conditionedGroupId,
      required String? conditionId}) async {
    try {
      final dbRef = await _resolveReferenceById(conditionedGroupId);
      DatabaseReference newNode;
      if (conditionId == null || conditionId.isEmpty) {
        newNode = dbRef.push();
      } else {
        newNode = dbRef.child(sanitizeDbPath(conditionId));
      }
      logger.d("Processing group condition node: conditional group $newNode");
      return newNode;
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
