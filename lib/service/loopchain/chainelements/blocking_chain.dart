import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/service/app_blocker.dart';

import '../../../db/entity/listed_app.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class BlockingChain implements AppDataHandler {
  AppDataHandler? _nextHandler;
  AppBlocker blocker = _locator<AppBlocker>();

  BlockingChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    if (data.listedApp?.status == AppStatus.negative) {
      await handleBlockingOfNegativeApp(data);
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }

  Future<void> handleBlockingOfNegativeApp(AppData data) async {
    if (!data.conditionsMet) {
      blocker.blockApp(data.processId);
      return;
    }

    Duration resultedTime = data.remainingTime + data.timeCounted;
    if (resultedTime <= Duration.zero) {
      blocker.blockApp(data.processId);
      return;
    }
  }
}
