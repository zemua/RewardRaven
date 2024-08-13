import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';

class AndroidAppsFetcher implements AppsFetcher {
  @override
  Future<List<AppInfo>> fetchInstalledApps() {
    return InstalledApps.getInstalledApps();
  }
}
