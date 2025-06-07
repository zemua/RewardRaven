import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/tools/dates.dart';

import '../../service/preferences_service.dart';
import '../entity/collections.dart';
import '../entity/time_log.dart';
import '../helper/firebase_helper.dart';

final GetIt _locator = GetIt.instance;

class TimeLogRepository {
  // TODO delete old entries periodically to free db space
  final FirebaseHelper _firebaseHelper = _locator.get<FirebaseHelper>();
  final PreferencesService _sharedPreferences =
      _locator.get<PreferencesService>();
  final logger = Logger();

  TimeLogRepository();

  Future<void> addToTotal(TimeLog timeLog) async {
    try {
      final reference = await _resolveTotalReference();
      await add(timeLog, reference);
    } catch (e) {
      logger.e('Failed to resolve log: $e');
    }
  }

  Future<TimeLog> getTotalDuration() async {
    final reference = await _resolveTotalReference();
    return await _totalLog(reference);
  }

  Future<DatabaseReference> _resolveTotalReference() async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      return dbRef
          .child(sanitizeDbPath(DbCollection.logs.name))
          .child(sanitizeDbPath("total"));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }

  Future<void> addToGroup(TimeLog timeLog, String groupId) async {
    try {
      final reference = await _resolveGroupReference(groupId, timeLog.dateTime);
      await add(timeLog, reference);
    } catch (e) {
      logger.e('Failed to resolve log: $e');
    }
  }

  Future<TimeLog> getGroupTotalDuration(
      String groupId, DateTime dateTime) async {
    final reference = await _resolveGroupReference(groupId, dateTime);
    return await _totalLog(reference);
  }

  Future<DatabaseReference> _resolveGroupReference(
      String groupId, DateTime dateTime) async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      return dbRef
          .child(sanitizeDbPath(DbCollection.logs.name))
          .child(sanitizeDbPath("group"))
          .child(sanitizeDbPath(groupId))
          .child(sanitizeDbPath(toDateOnly(dateTime)));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }

  Future<void> add(TimeLog timeLog, DatabaseReference reference) async {
    String uuid = await _sharedPreferences.getUserUUID();
    final uuidRef = reference.child(sanitizeDbPath(uuid));
    final snapshot = await uuidRef.get().timeout(const Duration(seconds: 10));
    if (snapshot.value != null) {
      final Map<String, dynamic> logMap =
          Map<String, dynamic>.from(snapshot.value as Map);
      final TimeLog retrievedLog = TimeLog.fromJson(logMap);
      logger.i("Retrieved log with uuid $uuid as $retrievedLog");
      TimeLog updatedLog = TimeLog(
          used: timeLog.used + retrievedLog.used,
          counted: timeLog.counted + retrievedLog.counted,
          dateTime: timeLog.dateTime);
      await uuidRef
          .update(updatedLog.toJson())
          .timeout(const Duration(seconds: 10));
      logger.i('Updated log with uuid $uuid as $updatedLog in ${uuidRef.path}');
    } else {
      logger.i(
          'No log found for uuid $uuid proceeding to create a new entry in ${uuidRef.path}');
      await uuidRef.set(timeLog.toJson()).timeout(const Duration(seconds: 10));
      logger.i('Created log with uuid $uuid as $timeLog');
    }
  }

  Future<TimeLog> _totalLog(DatabaseReference reference) async {
    DataSnapshot? snapshot;
    try {
      snapshot = await reference.get().timeout(const Duration(seconds: 10));
    } on TimeoutException catch (e) {
      logger.w('Timeout reached while getting total log: $e');
      snapshot = null;
    }
    if (snapshot?.value != null) {
      final Map<dynamic, dynamic> logMap =
          Map<dynamic, dynamic>.from(snapshot!.value as Map);
      int totalUsed = 0;
      int totalCounted = 0;
      logMap.forEach((key, value) {
        if (value is Map) {
          try {
            final timeLog = TimeLog.fromJson(Map<String, dynamic>.from(value));
            totalUsed += timeLog.used.inSeconds;
            totalCounted += timeLog.counted.inSeconds;
          } catch (e) {
            logger.e('Error parsing TimeLog: $e');
          }
        }
      });

      return TimeLog(
          used: Duration(seconds: totalUsed),
          counted: Duration(seconds: totalCounted),
          dateTime: DateTime.now());
    } else {
      return TimeLog(
          used: Duration.zero,
          counted: Duration.zero,
          dateTime: DateTime.now());
    }
  }
}
