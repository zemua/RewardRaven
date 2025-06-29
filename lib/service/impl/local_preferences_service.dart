import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../preferences_enums.dart';
import '../preferences_service.dart';

class LocalPreferencesService implements PreferencesService {
  final logger = Logger();
  final GetIt _locator = GetIt.instance;

  SharedPreferences _preferences() {
    return _locator<SharedPreferences>();
  }

  @override
  void saveSharedString(StringPreferencesKey key, String value) async {
    await _preferences().setString(key.name, value);
  }

  @override
  String getSharedString(StringPreferencesKey key) {
    String? value = _preferences().getString(key.name);
    return value ?? key.defaultValue;
  }

  @override
  String getUserUUID() {
    String deviceUuidProperty = "device_uuid";
    SharedPreferences prefs = _preferences();
    String? uuid = prefs.getString(deviceUuidProperty);
    if (uuid == null) {
      uuid = const Uuid().v1();
      logger.i("Generated device uuid: $uuid");
      prefs.setString(deviceUuidProperty, uuid);
    }
    return uuid;
  }

  @override
  bool getSharedBool(BoolPreferencesKey key) {
    bool? value = _preferences().getBool(key.name);
    return value ?? key.defaultValue;
  }

  @override
  void saveSharedBool(BoolPreferencesKey key, bool value) async {
    await _preferences().setBool(key.name, value);
  }
}
