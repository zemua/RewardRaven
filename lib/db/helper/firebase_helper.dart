import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class FirebaseHelper {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  final String _databasePath = 'rewardraven';

  final _logger = Logger();
  final Completer<void> _completer = Completer<void>();

  FirebaseHelper() {
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      _database.setPersistenceEnabled(true);
      _database.setPersistenceCacheSizeBytes(90000000); // cache size 90MB

      _databaseReference = _database.ref(_databasePath);
      await _initializeLocalDb(_databaseReference);
      _logger.i("Database ${_databaseReference.path} loaded successfully");
      _completer.complete();
    } catch (e) {
      _logger.e('Failed to load database: $e');
      _completer.completeError(e);
    }
  }

  Future<void> _initializeLocalDb(DatabaseReference dbRef) async {
    /* Firestore can't be acceded from a different thread than its own at the first write operation
       because is the time when the reference to the local db is created, keep in mind that Firestore
        runs all their operations asynchronously(they don't block the calling thread) but their callbacks
         are called on the main looper. If in any widget you get a query to the db inside an async
          thread, then you have a problem, making this first call here should fix that.*/
    try {
      dbRef.once().timeout(const Duration(seconds: 0));
    } on TimeoutException catch (e) {
      _logger.d('Db request to remote timed out: $e');
    }
    _logger.i('Local database initialized');
  }

  Future<DatabaseReference> get databaseReference async {
    await _completer.future;
    return _databaseReference;
  }
}

String sanitizeDbPath(String packageName) {
  return packageName
      .replaceAll('.', '-')
      .replaceAll('#', '-')
      .replaceAll('\$', '-')
      .replaceAll('[', '-')
      .replaceAll(']', '-')
      .replaceAll('/', '-');
}
