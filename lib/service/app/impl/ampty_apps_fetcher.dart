import 'package:installed_apps/app_info.dart';

import '../apps_fetcher.dart';

class EmptyAppsFetcher implements AppsFetcher {
  @override
  Future<List<AppInfo>> fetchInstalledApps() {
    return Future.value([]);
  }

  @override
  Future<List<AppInfo>> fetchAllApps() {
    return Future.value([]);
  }

  @override
  bool hasHiddenApps() {
    return false;
  }
}
