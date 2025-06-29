import 'preferences_enums.dart';

abstract class PreferencesService {
  void saveSharedString(StringPreferencesKey key, String value);
  String getSharedString(StringPreferencesKey key);
  void saveSharedBool(BoolPreferencesKey key, bool value);
  bool getSharedBool(BoolPreferencesKey key);
  String getUserUUID();
}
