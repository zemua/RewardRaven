import 'package:firebase_database/firebase_database.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../service/preferences_service.dart';
import '../entity/collections.dart';
import '../helper/firebase_helper.dart';

final GetIt _locator = GetIt.instance;

class TimeLogRepository {
  // TODO implement tests
  final FirebaseHelper _firebaseHelper = _locator.get<FirebaseHelper>();
  final PreferencesService _sharedPreferences =
      _locator.get<PreferencesService>();
  final logger = Logger();

  TimeLogRepository();

  Future<void> addToTotal(TimeLog) async {
    final now = DateTime.now();
    final reference = _firebaseHelper.getReference(
        'timelogs/$appPackageName/${now.year}/${now.month}/${now.day}');
    await reference.runTransaction((MutableData transaction) async {
      final data = transaction.value as Map<dynamic, dynamic>?;
      if (data == null) {
        transaction.value = {'total': time};
      } else {
        final newTotal = (data['total'] as int) + time;
        transaction.value = {'total': newTotal};
      }
      return transaction;
    });
  }

  Future<int> getTotal(String appPackageName) async {
    final now = DateTime.now();
    final reference = _firebaseHelper.getReference(
        'timelogs/$appPackageName/${now.year}/${now.month}/${now.day}');
    final snapshot = await reference.get();
    final data = snapshot.value as Map<dynamic, dynamic>?;
    return data?['total'] as int? ?? 0;
  }

  Future<DatabaseReference> _resolveTotalReference() async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      return dbRef
          .child(sanitizeDbPath(DbCollection.logs.name))
          .child(sanitizeDbPath("total"))
          .child(sanitizeDbPath(await _sharedPreferences.getUserUUID()));
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }
}
