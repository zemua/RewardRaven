import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../apps_fetcher.dart';

class AndroidAppsFetcher implements AppsFetcher {
  final _logger = Logger();

  @override
  Future<List<AppInfo>> fetchInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(true, true);

    _logger.d(
        'Fetched ${apps.length} apps: ${apps.map((app) => app.name).toList()}');

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentPackageName = packageInfo.packageName;

    return apps.where((app) => app.packageName != currentPackageName).toList();
  }

  @override
  Future<List<AppInfo>> fetchAllApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps(false, true);

    _logger.d(
        'Fetched ${apps.length} apps: ${apps.map((app) => app.name).toList()}');

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentPackageName = packageInfo.packageName;

    return apps.where((app) => app.packageName != currentPackageName).toList();
  }

  @override
  bool hasHiddenApps() {
    return true;
  }

  @override
  Future<AppInfo?> fetchApp(String packageName) {
    return InstalledApps.getAppInfo(packageName, BuiltWith.flutter);
  }
}
