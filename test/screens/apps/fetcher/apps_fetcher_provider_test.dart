import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:installed_apps/app_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher_provider.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/ampty_apps_fetcher.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/android_apps_fetcher.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'apps_fetcher_provider_test.mocks.dart';

@GenerateMocks([PlatformWrapper, AndroidAppsFetcher])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final locator = GetIt.instance;

  setUp(() {
    locator.reset();
  });

  group('AppsFetcherProvider', () {
    test('fetchInstalledApps returns list of apps on Android', () async {
      MockPlatformWrapper mockPlatformWrapper = MockPlatformWrapper();
      MockAndroidAppsFetcher mockAndroidAppsFetcher = MockAndroidAppsFetcher();
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
      locator.registerSingleton<AndroidAppsFetcher>(mockAndroidAppsFetcher);
      when(mockPlatformWrapper.isAndroid()).thenReturn(true);
      when(mockAndroidAppsFetcher.fetchInstalledApps())
          .thenAnswer((_) async => [
                AppInfo(
                    name: 'App1',
                    icon: null,
                    packageName: '',
                    versionName: '',
                    versionCode: 1,
                    builtWith: BuiltWith.flutter,
                    installedTimestamp: DateTime.now().millisecondsSinceEpoch)
              ]);

      final provider = AppsFetcherProvider();
      final apps = await provider.fetchInstalledApps();

      expect(apps, isA<List<AppInfo>>());
      expect(apps.length, 1);
      expect(apps.first.name, 'App1');
    });

    test('fetchInstalledApps returns empty list on non-Android platforms',
        () async {
      MockPlatformWrapper mockPlatformWrapper = MockPlatformWrapper();
      MockAndroidAppsFetcher mockAndroidAppsFetcher = MockAndroidAppsFetcher();
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
      locator.registerSingleton<EmptyAppsFetcher>(EmptyAppsFetcher());
      when(mockPlatformWrapper.isAndroid()).thenReturn(false);

      final provider = AppsFetcherProvider();
      final apps = await provider.fetchInstalledApps();

      expect(apps, isA<List<AppInfo>>());
      expect(apps, isEmpty);
    });
  });
}
