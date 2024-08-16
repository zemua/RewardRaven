import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class FirebaseHelper {
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  late DatabaseReference _databaseReference;
  final String _databasePath = 'your_database_path';

  final _logger = Logger();

  FirebaseHelper() {
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    try {
      _databaseReference = await _database.reference().child(_databasePath);
      _logger.i("Database loaded successfully");
    } catch (e) {
      _logger.e('Failed to load database: $e');
    }
  }

  DatabaseReference get databaseReference => _databaseReference;
}
