import 'package:installed_apps/app_info.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';

class EmptyAppsFetcher implements AppsFetcher {
  @override
  Future<List<AppInfo>> fetchInstalledApps() {
    return Future.value([]);
  }
}
