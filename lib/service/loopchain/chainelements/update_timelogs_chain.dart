import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/db/entity/time_log.dart';

import '../../../db/service/time_log_service.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class UpdateTimelogsChain implements AppDataHandler {
  AppDataHandler? _nextHandler;
  final TimeLogService _timeLogService = _locator<TimeLogService>();

  UpdateTimelogsChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    final timeLog = TimeLog(
        used: data.timeElapsed,
        counted: data.timeCounted,
        dateTime: data.timestamp ?? DateTime.now());
    await _timeLogService.addToTotal(timeLog);

    if (data.appGroup?.id != null) {
      await _timeLogService.addToGroup(timeLog, data.appGroup!.id!);
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
