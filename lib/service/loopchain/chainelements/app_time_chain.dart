import 'package:logger/logger.dart';
import 'package:reward_raven/service/foreground/androidwatchdog.dart';

import '../../../db/entity/listed_app.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();

class AppTimeChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  AppTimeChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    data.timeElapsed = WATCHDOG_PERIOD;
    if (data.listedApp?.status == AppStatus.positive && data.conditionsMet) {
      data.timeCounted = data.timeElapsed;
    } else if (data.listedApp?.status == AppStatus.negative) {
      data.timeCounted =
          -4 * data.timeElapsed; // TODO make proportion configurable
    } else {
      data.timeCounted = 0;
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
