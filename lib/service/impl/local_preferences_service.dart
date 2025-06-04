import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../preferences_service.dart';

class LocalPreferencesService implements PreferencesService {
  final logger = Logger();
  final GetIt _locator = GetIt.instance;

  @override
  void saveSharedString(String key, String value) async {
    SharedPreferences prefs = _locator<SharedPreferences>();
    await prefs.setString(key, value);
  }

  @override
  Future<String?> getSharedString(String key) async {
    SharedPreferences prefs = _locator<SharedPreferences>();
    return prefs.getString(key);
  }

  @override
  Future<String> getUserUUID() async {
    String deviceUuidProperty = "device_uuid";
    SharedPreferences prefs = _locator<SharedPreferences>();
    String? uuid = prefs.getString(deviceUuidProperty);
    if (uuid == null) {
      uuid = Uuid().v1();
      logger.i("Generated device uuid: $uuid");
      await prefs.setString(deviceUuidProperty, uuid);
    }
    return uuid;
  }
}
