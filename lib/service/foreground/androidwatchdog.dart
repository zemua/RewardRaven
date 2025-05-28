import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../loopchain/app_data_dto.dart';
import '../loopchain/app_data_handler.dart';

final logger = Logger();
final GetIt locator = GetIt.instance;

const int WATCHDOG_PERIOD = 5000;

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
  static const _appinfoChannel = MethodChannel('mrp.dev/appinfo');

  late String _notificationTitle;
  late String _notificationText;
  late String _channelName;
  late String _channelDescription;

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
    return const SizedBox.shrink();
  }

  Future<void> _onReceiveTaskData(Object data) async {
    if (data is String) {
      logger.d("onReceiveTaskData: $data");
      try {
        final result = await _appinfoChannel.invokeMethod<Map>(data);
        logger.d('App info: $result');
        String processId = result?['packageName'];
        String appName = result?['appName'];
        locator<AppDataHandler>()
            .handleAppData(new AppData(processId: processId, appName: appName));
      } catch (e) {
        logger.e('Failed to get app info: $e');
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
        channelId: 'foreground_service',
        channelName: _channelName,
        channelDescription: _channelDescription,
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
          eventAction: ForegroundTaskEventAction.repeat(WATCHDOG_PERIOD)),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      logger.d("Service is already running");
      FlutterForegroundTask.updateService(
        notificationTitle: _notificationTitle,
        notificationText: _notificationText,
        notificationButtons: [],
        notificationIcon: null,
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
        notificationIcon: null,
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
    FlutterForegroundTask.sendDataToMain("getForegroundAppInfo");
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
