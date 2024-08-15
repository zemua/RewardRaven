import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';

class AndroidAppsFetcher implements AppsFetcher {
  @override
  Future<List<AppInfo>> fetchInstalledApps() async {
    List<AppInfo> apps = await InstalledApps.getInstalledApps();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentPackageName = packageInfo.packageName;

    return apps.where((app) => app.packageName != currentPackageName).toList();
  }
}
