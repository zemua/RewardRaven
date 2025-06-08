import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:logger/logger.dart';

import '../../foreground/androidwatchdog.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();

class DetectSleepChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  DetectSleepChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    if (!data.isScreenActive) {
      _updateAndroidNotification(data);
    }

    if (_nextHandler != null && data.isScreenActive) {
      await _nextHandler!.handleAppData(data);
    }
  }

  void _updateAndroidNotification(AppData data) {
    FlutterForegroundTask.updateService(
      notificationTitle: data.localizedStrings?.sleeping,
      notificationText: data.appName,
      notificationButtons: [],
      notificationIcon: const NotificationIcon(
        metaDataName: sleepIcon,
      ),
      notificationInitialRoute: '/',
      callback: startCallback,
    );
  }
}
