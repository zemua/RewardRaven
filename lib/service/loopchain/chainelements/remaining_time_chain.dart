import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/entity/time_log.dart';
import '../../../db/service/time_log_service.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class RemainingTimeChain implements AppDataHandler {
  AppDataHandler? _nextHandler;
  final TimeLogService _timeLogService = _locator.get<TimeLogService>();

  RemainingTimeChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    TimeLog totalDuration = await _timeLogService.getTotalDuration();
    data.remainingTime = totalDuration.counted;

    if (data.remainingTime + data.timeCounted <= Duration.zero) {
      data.blockingMessages
          .add(data.localizedStrings.notEnoughTime ?? "Time used up");
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
