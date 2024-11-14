import 'package:installed_apps/app_info.dart';

abstract class AppsFetcher {
  Future<List<AppInfo>> fetchInstalledApps();
  Future<List<AppInfo>> fetchAllApps();
  Future<AppInfo?> fetchApp(String packageName);
  bool hasHiddenApps();
}
