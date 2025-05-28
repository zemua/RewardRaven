import 'package:shared_preferences/shared_preferences.dart';

void saveSharedString(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String> getSharedString(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Future.value(prefs.getString(key));
}
