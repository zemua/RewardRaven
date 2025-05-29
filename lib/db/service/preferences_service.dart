import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void saveSharedString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getSharedString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Future.value(prefs.getString(key));
}

Future<String> getUserUUID() async {
  String userUuidProperty = "user_uuid";
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? uuid = prefs.getString(userUuidProperty);
  if (uuid == null) {
    uuid = Uuid().v1();
    await prefs.setString(userUuidProperty, uuid);
  }
  return uuid;
}
