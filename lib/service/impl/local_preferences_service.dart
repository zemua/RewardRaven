import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../preferences_service.dart';

class LocalPreferencesService implements PreferencesService {
  final logger = Logger();

  @override
  void saveSharedString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getSharedString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  @override
  Future<String> getUserUUID() async {
    String deviceUuidProperty = "device_uuid";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uuid = prefs.getString(deviceUuidProperty);
    if (uuid == null) {
      uuid = Uuid().v1();
      logger.i("Generated device uuid: $uuid");
      await prefs.setString(deviceUuidProperty, uuid);
    }
    return uuid;
  }
}
