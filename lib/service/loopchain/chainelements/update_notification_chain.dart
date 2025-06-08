import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../foreground/androidwatchdog.dart';
import '../../platform_wrapper.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class UpdateNotificationChain implements AppDataHandler {
  AppDataHandler? _nextHandler;
  final PlatformWrapper _platformWrapper = _locator<PlatformWrapper>();

  UpdateNotificationChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    if (_platformWrapper.isAndroid()) {
      _updateAndroidNotification(data);
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }

  void _updateAndroidNotification(AppData data) {
    final String icon = _resolveIcon(data);
    FlutterForegroundTask.updateService(
      notificationTitle: _remainingTime(data),
      notificationText: data.appName,
      notificationButtons: [],
      notificationIcon: NotificationIcon(
        metaDataName: icon,
      ),
      notificationInitialRoute: '/',
      callback: startCallback,
    );
  }

  String _remainingTime(AppData data) {
    final totalDuration = Duration(
        seconds: ((data.remainingTime + data.timeCounted).inSeconds /
                negativeProportion)
            .floor());
    String hours = totalDuration.inHours.toString().padLeft(2, '0');
    String minutes = (totalDuration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (totalDuration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _resolveIcon(AppData data) {
    if (data.timeCounted > Duration.zero) {
      return fireIcon;
    } else if (data.timeCounted < Duration.zero) {
      return snowIcon;
    } else {
      return neutralIcon;
    }
  }
}
