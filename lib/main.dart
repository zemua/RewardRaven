import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher.dart';
import 'package:reward_raven/screens/apps/fetcher/apps_fetcher_provider.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/ampty_apps_fetcher.dart';
import 'package:reward_raven/screens/apps/fetcher/impl/android_apps_fetcher.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';
import 'package:reward_raven/service/impl/platform_wrapper_impl.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'db/helper/database_helper.dart';
import 'firebase_options.dart'; // $ flutterfire configure

final GetIt locator = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // $ flutterfire configure
  );
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
  locator.registerSingleton<PlatformWrapper>(PlatformWrapperImpl());

  if (!kIsWeb) {
    // Register platform-specific implementations only if not running on the web
    locator.registerSingleton<AndroidAppsFetcher>(AndroidAppsFetcher());
  }
  locator.registerSingleton<EmptyAppsFetcher>(EmptyAppsFetcher());

  locator.registerSingleton<AppsFetcher>(AppsFetcherProvider());

  locator.registerSingleton<DatabaseHelper>(DatabaseHelper.instance);
}
