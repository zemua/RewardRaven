import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class Watchdog {
  static init() {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground_service',
        channelName: 'Foreground Service Notification',
        channelDescription:
            'This notification appears when the foreground service is running.',
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
          eventAction: ForegroundTaskEventAction.repeat(5000)),
    );
  }
}
