import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../preferences_service.dart';

const shutdownEnabledKey = 'isShutdownEnabled';
const shutdownNegativesWillBeClosedKey = 'shutdownNegativesWillBeClosed';

class LocalPreferencesService implements PreferencesService {
  final logger = Logger();
  final GetIt _locator = GetIt.instance;

  SharedPreferences _preferences() {
    return _locator<SharedPreferences>();
  }

  @override
  void saveSharedString(String key, String value) async {
    await _preferences().setString(key, value);
  }

  @override
  Future<String?> getSharedString(String key) async {
    return _preferences().getString(key);
  }

  @override
  Future<String> getUserUUID() async {
    String deviceUuidProperty = "device_uuid";
    SharedPreferences prefs = _preferences();
    String? uuid = prefs.getString(deviceUuidProperty);
    if (uuid == null) {
      uuid = const Uuid().v1();
      logger.i("Generated device uuid: $uuid");
      await prefs.setString(deviceUuidProperty, uuid);
    }
    return uuid;
  }

  @override
  Future<bool?> getSharedBool(String key) async {
    return _preferences().getBool(key);
  }

  @override
  void saveSharedBool(String key, bool value) {
    _preferences().setBool(key, value);
  }
}
