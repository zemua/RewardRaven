import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';
import 'package:reward_raven/service/app/apps_fetcher_provider.dart';
import 'package:reward_raven/service/app/impl/ampty_apps_fetcher.dart';
import 'package:reward_raven/service/app/impl/android_apps_fetcher.dart';
import 'package:reward_raven/service/impl/platform_wrapper_impl.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'db/repository/listed_app_repository.dart';
import 'db/service/listed_app_service.dart';
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
      home: const HomePage(),
    );
  }
}

void setupLocator() {
  locator.registerSingleton<PlatformWrapper>(PlatformWrapperImpl());

  if (!kIsWeb) {
    locator.registerSingleton<AndroidAppsFetcher>(AndroidAppsFetcher());
  }
  locator.registerSingleton<EmptyAppsFetcher>(EmptyAppsFetcher());

  locator.registerSingleton<FirebaseHelper>(FirebaseHelper());
  locator.registerSingleton<AppsFetcher>(AppsFetcherProvider());
  locator.registerSingleton<ListedAppRepository>(ListedAppRepository());
  locator.registerSingleton<ListedAppService>(ListedAppService());
}
