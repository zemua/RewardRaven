import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher_provider.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/android_apps_fetcher.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';
import 'package:reward_raven/service/impl/platform_wrapper_impl.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

final GetIt locator = GetIt.instance;

void main() {
  setupLocator();
  runApp(const RewardRavenApp());
}

class RewardRavenApp extends StatelessWidget {
  const RewardRavenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: "Reward Raven",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

void setupLocator() {
  locator.registerSingleton<AppsFetcher>(AppsFetcherProvider());
  locator.registerSingleton<AndroidAppsFetcher>(AndroidAppsFetcher());
  locator.registerSingleton<PlatformWrapper>(PlatformWrapperImpl());
}
