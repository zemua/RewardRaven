abstract class PreferencesService {
  void saveSharedString(String key, String value);
  Future<String?> getSharedString(String key);
  void saveSharedBool(String key, bool value);
  Future<bool?> getSharedBool(String key);
  Future<String> getUserUUID();
}
