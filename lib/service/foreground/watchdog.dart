import 'package:flutter/cupertino.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:logger/logger.dart';

final logger = Logger();

@pragma('vm:entry-point')
void startCallback() {
  logger.d('startCallback, setting task handler');
  FlutterForegroundTask.setTaskHandler(WatchdogTaskHandler());
}

class WatchdogWidget extends StatefulWidget {
  const WatchdogWidget({super.key});

  @override
  State<StatefulWidget> createState() => _WatchdogWidgetState();
}

class _WatchdogWidgetState extends State<WatchdogWidget> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }

  void _onReceiveTaskData(Object data) {
    logger.d('onReceiveTaskData: $data');
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
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
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
          eventAction: ForegroundTaskEventAction.repeat(5000)),
    );
  }

  Future<ServiceRequestResult> _startService() async {
    if (await FlutterForegroundTask.isRunningService) {
      logger.d("Service is already running");
      FlutterForegroundTask.updateService(
        notificationTitle: 'Hello MyTaskHandler :)',
        notificationText: 'blablabla',
      );
      return FlutterForegroundTask.restartService();
    } else {
      logger.d("Starting service");
      var startServiceResult = await FlutterForegroundTask.startService(
        serviceId: 256,
        notificationTitle: 'Watchdog Service is running',
        notificationText: 'tap here',
        notificationIcon: null,
        notificationButtons: [
          const NotificationButton(id: 'btn_hello', text: 'hello raven'),
        ],
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
    // Add a callback to receive data sent from the TaskHandler.
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
    // Remove a callback to receive data sent from the TaskHandler.
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
  void onRepeatEvent(DateTime timestamp) {
    logger.d('onRepeatEvent');
    // Send data to main isolate.
    final Map<String, dynamic> data = {
      "timestampMillis": timestamp.millisecondsSinceEpoch,
    };
    FlutterForegroundTask.sendDataToMain(data);
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
