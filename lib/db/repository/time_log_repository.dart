import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../service/preferences_service.dart';
import '../entity/collections.dart';
import '../entity/time_log.dart';
import '../helper/firebase_helper.dart';

final GetIt _locator = GetIt.instance;

class TimeLogRepository {
  final FirebaseHelper _firebaseHelper = _locator.get<FirebaseHelper>();
  final PreferencesService _sharedPreferences =
      _locator.get<PreferencesService>();
  final logger = Logger();

  TimeLogRepository();

  Future<void> addToTotal(TimeLog timeLog) async {
    try {
      String uuid = await _sharedPreferences.getUserUUID();
      final reference = await _resolveTotalReference();
      final uuidRef = reference.child(sanitizeDbPath(uuid));
      final dbEvent = await uuidRef.once().timeout(const Duration(seconds: 10));
      final DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        final Map<String, dynamic> logMap =
            Map<String, dynamic>.from(snapshot.value as Map);
        final TimeLog retrievedLog = TimeLog.fromJson(logMap);
        logger.i("Retrieved log with uuid $uuid as $retrievedLog");
        TimeLog updatedLog = TimeLog(
            duration: timeLog.duration + retrievedLog.duration,
            dateTime: timeLog.dateTime);
        await uuidRef
            .update(updatedLog.toJson())
            .timeout(const Duration(seconds: 10));
        logger
            .i('Updated log with uuid $uuid as $updatedLog in ${uuidRef.path}');
      } else {
        logger.i(
            'No log found for uuid $uuid proceeding to create a new entry in ${uuidRef.path}');
        await uuidRef
            .set(timeLog.toJson())
            .timeout(const Duration(seconds: 10));
        logger.i('Created log with uuid $uuid as $timeLog');
      }
    } catch (e) {
      logger.e('Failed to resolve log: $e');
    }
  }

  Future<int> getTotalSeconds() async {
    final reference = await _resolveTotalReference();
    final snapshot = await reference.get().timeout(const Duration(seconds: 10));
    if (snapshot.value != null) {
      final Map<dynamic, dynamic> logMap =
          Map<dynamic, dynamic>.from(snapshot.value as Map);
      int totalDuration = 0;
      logMap.forEach((key, value) {
        if (value is Map) {
          try {
            final timeLog = TimeLog.fromJson(Map<String, dynamic>.from(value));
            totalDuration += timeLog.duration.inSeconds;
          } catch (e) {
            logger.e('Error parsing TimeLog: $e');
          }
        }
      });

      return totalDuration;
    } else {
      return 0;
    }
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
}
