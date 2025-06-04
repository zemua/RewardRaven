import 'package:logger/logger.dart';

import 'app_data_dto.dart';
import 'app_data_handler.dart';
import 'chainelements/app_group_chain.dart';
import 'chainelements/app_time_chain.dart';
import 'chainelements/conditions_check_chain.dart';
import 'chainelements/group_conditions_chain.dart';
import 'chainelements/listed_app_chain.dart';
import 'chainelements/platform_chain.dart';
import 'chainelements/remaining_time_chain.dart';
import 'chainelements/timestamp_chain.dart';

final logger = Logger();

class AppDataChainMaster implements AppDataHandler {
  AppDataHandler? _entryHandler;

  AppDataChainMaster() {
    AppDataHandler remainingTimeHandler = RemainingTimeChain();

    AppDataHandler appTimeHandler = AppTimeChain();
    appTimeHandler.setNextHandler(remainingTimeHandler);

    AppDataHandler conditionsCheckHandler = ConditionsCheckChain();
    conditionsCheckHandler.setNextHandler(appTimeHandler);

    AppDataHandler groupConditionsHandler = GroupConditionsChain();
    groupConditionsHandler.setNextHandler(conditionsCheckHandler);

    AppDataHandler appGroupHandler = AppGroupChain();
    appGroupHandler.setNextHandler(groupConditionsHandler);

    AppDataHandler listedAppHandler = ListedAppChain();
    listedAppHandler.setNextHandler(appGroupHandler);

    AppDataHandler platformHandler = PlatformChain();
    platformHandler.setNextHandler(listedAppHandler);

    _entryHandler = TimestampChain();
    _entryHandler!.setNextHandler(platformHandler);
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
