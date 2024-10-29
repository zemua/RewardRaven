import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/db/entity/app_group.dart';

import '../../main.dart';
import '../entity/collections.dart';
import '../helper/firebase_helper.dart';

class AppGroupRepository {
  final FirebaseHelper _firebaseHelper = locator.get<FirebaseHelper>();

  final logger = Logger();

  AppGroupRepository();

  Future<void> saveGroup(AppGroup group) async {
    try {
      final ref = await _resolveReference(group.type);
      final newChildRef = ref.push();
      logger.d("Saving group to node: ${newChildRef.path}");
      await newChildRef
          .set(group.toJson())
          .timeout(const Duration(seconds: 10));
      logger.d("Saved group to node: ${newChildRef.path}");
    } catch (e) {
      logger.e('Failed to save group: $e');
    }
  }

  Future<void> updateGroup(String key, AppGroup group) async {
    try {
      final ref = await _resolveReference(group.type);
      await ref
          .child(key)
          .update(group.toJson())
          .timeout(const Duration(seconds: 10));
      logger.i("Updated group with id: ${group.type}.$key");
    } catch (e) {
      logger.e('Failed to update ${group.type}.$key group: $e');
    }
  }

  Future<AppGroup?> getGroup(GroupType type, String key) async {
    try {
      final ref = await _resolveReference(type);
      final dbEvent =
          await ref.child(key).once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic> groupMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        final AppGroup group = AppGroup.fromJson(json: groupMap, id: key);
        logger.i("Retrieved group with key: $key of type: $type");
        return group;
      } else {
        logger.i('No group found for key: $key and type: $type');
      }
    } catch (e) {
      logger.e('Failed to get group: $e');
    }
    return null;
  }

  Future<List<AppGroup>> getGroups(GroupType type) async {
    try {
      final ref = await _resolveReference(type);
      final dbEvent = await ref.once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        final Map<dynamic, dynamic> groupsMap =
            snapshot.value as Map<dynamic, dynamic>;
        final List<AppGroup> groups = groupsMap.entries.map((entry) {
          return AppGroup.fromJson(
              json: Map<String, dynamic>.from(entry.value), id: entry.key);
        }).toList();
        logger.i("Retrieved ${groups.length} groups of type: $type");
        return groups;
      } else {
        logger.i('No groups found for type: $type');
      }
    } catch (e) {
      logger.e('Failed to get groups: $e');
    }
    return [];
  }

  Stream<List<AppGroup>> streamGroups(GroupType type) {
    logger.d('Streaming groups of type: $type');
    return _resolveReference(type).asStream().asyncExpand((ref) {
      logger.d('Resolved reference at: ${ref.path}');
      final completer = Completer<void>();
      return ref.onValue.timeout(const Duration(seconds: 10),
          onTimeout: (sink) {
        if (!completer.isCompleted) {
          completer.completeError(
              TimeoutException('Timeout while streaming groups'));
          sink.addError(TimeoutException('Timeout while streaming groups'));
        }
      }).map((event) {
        if (!completer.isCompleted) {
          completer.complete();
        }
        logger.d('Received event: $event');
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          final Map<dynamic, dynamic> groupsMap =
              snapshot.value as Map<dynamic, dynamic>;
          final List<AppGroup> groups = groupsMap.entries.map((entry) {
            return AppGroup.fromJson(
                json: Map<String, dynamic>.from(entry.value), id: entry.key);
          }).toList();
          logger.i("Streamed ${groups.length} groups of type: $type");
          return groups;
        } else {
          logger.i('No groups found for type: $type');
          return [];
        }
      });
    });
  }

  Future<DatabaseReference> _resolveReference(GroupType type) async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      return dbRef
          .child(sanitizeDbPath(DbCollection.appGroups.name))
          .child(sanitizeDbPath(type.toString().split('.').last));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }
}
