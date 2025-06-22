import 'package:logger/logger.dart';
import 'package:reward_raven/service/loopchain/chainelements/send_toast_chain.dart';
import 'package:reward_raven/service/loopchain/chainelements/update_notification_chain.dart';

import 'app_data_dto.dart';
import 'app_data_handler.dart';
import 'chainelements/app_group_chain.dart';
import 'chainelements/app_time_chain.dart';
import 'chainelements/blocking_chain.dart';
import 'chainelements/conditions_check_chain.dart';
import 'chainelements/detect_sleep_chain.dart';
import 'chainelements/fetch_foreground_app_chain.dart';
import 'chainelements/group_conditions_chain.dart';
import 'chainelements/listed_app_chain.dart';
import 'chainelements/platform_chain.dart';
import 'chainelements/remaining_time_chain.dart';
import 'chainelements/timestamp_chain.dart';
import 'chainelements/update_timelogs_chain.dart';

final logger = Logger();

class AppDataChainMaster implements AppDataHandler {
  AppDataHandler? _entryHandler;

  AppDataChainMaster() {
    List<AppDataHandler> handlers = [];
    handlers.add(DetectSleepChain());
    handlers.add(ForegroundAppChain());
    handlers.add(TimestampChain());
    handlers.add(PlatformChain());
    handlers.add(ListedAppChain());
    handlers.add(AppGroupChain());
    handlers.add(GroupConditionsChain());
    handlers.add(ConditionsCheckChain());
    handlers.add(AppTimeChain());
    handlers.add(RemainingTimeChain());
    handlers.add(BlockingChain());
    handlers.add(UpdateTimelogsChain());
    handlers.add(UpdateNotificationChain());
    handlers.add(SendToastChain());
    _setupHandlers(handlers);
  }

  void _setupHandlers(List<AppDataHandler> handlers) {
    _entryHandler = handlers[0];
    for (int i = 1; i < handlers.length; i++) {
      handlers[i - 1].setNextHandler(handlers[i]);
    }
  }

  @override
  void setNextHandler(AppDataHandler handler) {
    throw UnsupportedError("Next handler in chain master is not supported.");
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    if (_entryHandler != null) {
      await _entryHandler!.handleAppData(data);
    }
  }
}
