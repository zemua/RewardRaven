import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class FirebaseHelper {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  final String _databasePath = 'reward_raven';

  final _logger = Logger();
  final Completer<void> _completer = Completer<void>();

  FirebaseHelper() {
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      _databaseReference = _database.ref().child(_databasePath);
      _logger.i("Database loaded successfully");
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
      .replaceAll('.', '_')
      .replaceAll('#', '_')
      .replaceAll('\$', '_')
      .replaceAll('[', '_')
      .replaceAll(']', '_');
}
