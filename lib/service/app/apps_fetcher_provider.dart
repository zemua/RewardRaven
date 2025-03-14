import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'apps_fetcher.dart';
import 'impl/android_apps_fetcher.dart';
import 'impl/empty_apps_fetcher.dart';

final GetIt locator = GetIt.instance;

class AppsFetcherProvider implements AppsFetcher {
  final AppsFetcher appsFetcher;

  AppsFetcherProvider() : appsFetcher = _createAppsFetcher();

  static AppsFetcher _createAppsFetcher() {
    final platform = locator<PlatformWrapper>();
    if (platform.isAndroid()) {
      return locator<AndroidAppsFetcher>();
    } else {
      return locator<EmptyAppsFetcher>();
    }
  }

  @override
  Future<List<AppInfo>> fetchInstalledApps() {
    return appsFetcher.fetchInstalledApps();
  }

  @override
  Future<List<AppInfo>> fetchAllApps() {
    return appsFetcher.fetchAllApps();
  }

  @override
  bool hasHiddenApps() {
    return appsFetcher.hasHiddenApps();
  }

  @override
  Future<AppInfo?> fetchApp(String packageName) {
    return appsFetcher.fetchApp(packageName);
  }
}
