import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/app_group_repository.dart';
import 'package:reward_raven/db/repository/group_condition_repository.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';
import 'package:reward_raven/screens/homepage/home_page.dart';
import 'package:reward_raven/service/app/apps_fetcher.dart';
import 'package:reward_raven/service/app/apps_fetcher_provider.dart';
import 'package:reward_raven/service/app/impl/android_apps_fetcher.dart';
import 'package:reward_raven/service/app/impl/empty_apps_fetcher.dart';
import 'package:reward_raven/service/condition_checker.dart';
import 'package:reward_raven/service/impl/condition_checker_impl.dart';
import 'package:reward_raven/service/impl/platform_wrapper_impl.dart';
import 'package:reward_raven/service/loopchain/app_data_chain_master.dart';
import 'package:reward_raven/service/loopchain/app_data_handler.dart';
import 'package:reward_raven/service/platform_wrapper.dart';
import 'package:reward_raven/tools/injectable_time_picker.dart';

import 'db/repository/listed_app_repository.dart';
import 'db/service/app_group_service.dart';
import 'db/service/listed_app_service.dart';
import 'firebase_options.dart'; // $ flutterfire configure

final GetIt locator = GetIt.instance;

void main() async {
  final logger = Logger();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // $ flutterfire configure
  );

  if (kDebugMode) {
    try {
      // For Realtime Database
      FirebaseDatabase.instance.useDatabaseEmulator('10.0.2.2', 9000);
      FirebaseDatabase.instance.setPersistenceEnabled(false);
    } catch (e) {
      logger.e('Error connecting to Firebase emulator: $e');
    }
  } else {
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance
        .setPersistenceCacheSizeBytes(90000000); // cache size ~90MB
  }

  _setupLocator();

  FlutterForegroundTask.initCommunicationPort();

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

void _setupLocator() {
  locator.registerSingleton<PlatformWrapper>(PlatformWrapperImpl());
  locator.registerSingleton(InjectableTimePicker());

  if (!kIsWeb) {
    locator.registerSingleton<AndroidAppsFetcher>(AndroidAppsFetcher());
  }
  locator.registerSingleton<EmptyAppsFetcher>(EmptyAppsFetcher());

  locator.registerSingleton<FirebaseHelper>(FirebaseHelper());
  locator.registerSingleton<AppsFetcher>(AppsFetcherProvider());
  locator.registerSingleton<ListedAppRepository>(ListedAppRepository());
  locator.registerSingleton<ListedAppService>(ListedAppService());
  locator.registerSingleton<AppGroupRepository>(AppGroupRepository());
  locator.registerSingleton<AppGroupService>(AppGroupService());
  locator
      .registerSingleton<GroupConditionRepository>(GroupConditionRepository());
  locator.registerSingleton<GroupConditionService>(GroupConditionService());
  locator.registerSingleton<ConditionChecker>(ConditionCheckerImpl());
  locator.registerSingleton<AppDataHandler>(AppDataChainMaster());
}
