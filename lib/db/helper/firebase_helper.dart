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
      // TODO fix for get app list
      /* Firestore can't be acceded from a different thread than it own at the first write operation
       because is the time when the reference to the local db is created, keep in mind that Firestore
        runs all their operations asynchronously(they don't block the calling thread) but their callbacks
         are called on the main looper */
      _database.setPersistenceEnabled(true);
      _database.setPersistenceCacheSizeBytes(90000000); // cache size 90MB

      _databaseReference = _database.ref(_databasePath);
      _logger.i("Database ${_databaseReference.path} loaded successfully");
      _completer.complete();
    } catch (e) {
      _logger.e('Failed to load database: $e');
      _completer.completeError(e);
    }
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
