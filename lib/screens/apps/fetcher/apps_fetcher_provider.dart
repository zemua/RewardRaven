import 'dart:io' show Platform;

import 'package:installed_apps/app_info.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/android_apps_fetcher.dart';

import 'apps_fetcher.dart';

class AppsFetcherProvider implements AppsFetcher {
  // TODO test
  final AppsFetcher appsFetcher;

  AppsFetcherProvider() : appsFetcher = _createAppsFetcher();

  static AppsFetcher _createAppsFetcher() {
    if (Platform.isAndroid) {
      // TODO wrap the platform in an injected object for testing
      return AndroidAppsFetcher();
    } else {
      throw UnsupportedError('This platform is not supported');
    }
  }

  @override
  Future<List<AppInfo>> fetchInstalledApps() {
    return appsFetcher.fetchInstalledApps();
  }
}
