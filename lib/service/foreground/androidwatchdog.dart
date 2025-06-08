import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../loopchain/app_data_dto.dart';
import '../loopchain/app_data_handler.dart';
import 'localized_strings.dart';

final logger = Logger();
final GetIt locator = GetIt.instance;

final String _buildLoopData = 'buildLoopData';

const Duration watchdogPeriod = Duration(seconds: 5);

@pragma('vm:entry-point')
void startCallback() {
  logger.d('startCallback, setting task handler');
  FlutterForegroundTask.setTaskHandler(WatchdogTaskHandler());
}

class AndroidWatchdogWidget extends StatefulWidget {
  const AndroidWatchdogWidget({super.key});

  @override
  State<StatefulWidget> createState() => _AndroidWatchdogWidgetState();
}

class _AndroidWatchdogWidgetState extends State<AndroidWatchdogWidget> {
  static const _appNativeChannel = MethodChannel('mrp.dev/appinfo');

  late String _notificationTitle;
  late String _notificationText;
  late String _channelName;
  late String _channelDescription;

  final LocalizedStrings _localizedStrings = LocalizedStrings();

  @override
  Widget build(BuildContext context) {
    _notificationTitle =
        AppLocalizations.of(context)!.watchdogServiceDefaultTitle;
    _notificationText =
        AppLocalizations.of(context)!.watchdogServiceDefaultText;
    _channelName =
        AppLocalizations.of(context)!.watchdogServiceAndroidChannelName;
    _channelDescription =
        AppLocalizations.of(context)!.watchdogServiceAndroidChannelDescription;

    _localizedStrings.sleeping = AppLocalizations.of(context)!.sleeping;
    return const SizedBox.shrink();
  }

  Future<void> _onReceiveTaskData(Object data) async {
    logger.d("onReceiveTaskData: $data");
    if (data == _buildLoopData) {
      try {
        locator<AppDataHandler>().handleAppData(AppData(
          appNativeChannel: _appNativeChannel,
          localizedStrings: _localizedStrings,
        ));
      } catch (e) {
        logger.e('Failed to process loop chain: $e');
      }
    }
  }

  Future<void> _requestPermissions() async {
    final NotificationPermission notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    if (notificationPermission != NotificationPermission.granted) {
      await FlutterForegroundTask.requestNotificationPermission();
    }
  }

  void _initService() async {
    logger.d("Initializing FlutterForegroundTask service");
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'raven_monitoring_service',
        channelName: _channelName,
        channelDescription: _channelDescription,
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
          allowWakeLock: false,
          allowWifiLock: false,
          autoRunOnBoot: true,
          autoRunOnMyPackageReplaced: true,
          eventAction:
              ForegroundTaskEventAction.repeat(watchdogPeriod.inMilliseconds)),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      logger.d("Service is already running");
      FlutterForegroundTask.updateService(
        notificationTitle: _notificationTitle,
        notificationText: _notificationText,
        notificationButtons: [],
        notificationIcon: const NotificationIcon(
          metaDataName: sleepIcon,
        ),
        notificationInitialRoute: '/',
        callback: startCallback,
      );
      return FlutterForegroundTask.restartService();
    } else {
      logger.d("Starting service");
      var startServiceResult = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: _notificationTitle,
        notificationText: _notificationText,
        notificationButtons: [],
        notificationIcon: const NotificationIcon(
          metaDataName: sleepIcon,
        ),
        notificationInitialRoute: '/',
        callback: startCallback,
      );
      if (startServiceResult is ServiceRequestFailure) {
        logger.e(
            "Failed to start foreground service: ${startServiceResult.error}");
      }
      return startServiceResult;
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterForegroundTask.addTaskDataCallback(_onReceiveTaskData);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Request permissions and initialize the service.
      _requestPermissions();
      _initService();
      _startService();
    });
  }

  @override
  void dispose() {
    FlutterForegroundTask.removeTaskDataCallback(_onReceiveTaskData);
    super.dispose();
  }

  Future<ServiceRequestResult> _stopService() {
    logger.d('Stopping service');
    return FlutterForegroundTask.stopService();
  }
}

class WatchdogTaskHandler extends TaskHandler {
  // Called when the task is started.
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    logger.d('onStart(starter: ${starter.name})');
  }

  // Called based on the eventAction set in ForegroundTaskOptions.
  @override
  void onRepeatEvent(DateTime timestamp) async {
    logger.d('onRepeatEvent');
    FlutterForegroundTask.sendDataToMain(_buildLoopData);
  }

  // Called when the task is destroyed.
  @override
  Future<void> onDestroy(DateTime timestamp) async {
    logger.d('onDestroy');
  }

  // Called when data is sent using `FlutterForegroundTask.sendDataToTask`.
  @override
  void onReceiveData(Object data) {
    logger.d('onReceiveData: $data');
  }

  // Called when the notification button is pressed.
  @override
  void onNotificationButtonPressed(String id) {
    logger.d('onNotificationButtonPressed: $id');
  }

  // Called when the notification itself is pressed.
  @override
  void onNotificationPressed() {
    logger.d('onNotificationPressed');
  }

  // Called when the notification itself is dismissed.
  @override
  void onNotificationDismissed() {
    logger.d('onNotificationDismissed');
  }
}
