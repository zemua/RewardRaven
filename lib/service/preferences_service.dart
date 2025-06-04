abstract class PreferencesService {
  void saveSharedString(String key, String value);
  Future<String?> getSharedString(String key);
  Future<String> getUserUUID();
}
