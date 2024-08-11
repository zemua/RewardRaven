import 'package:installed_apps/app_info.dart';

abstract class AppsFetcher {
  Future<List<AppInfo>> fetchInstalledApps();
}
