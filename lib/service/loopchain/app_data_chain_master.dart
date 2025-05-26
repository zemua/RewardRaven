import 'package:logger/logger.dart';

import 'app_data_dto.dart';
import 'app_data_handler.dart';
import 'chainelements/listed_app_chain.dart';
import 'chainelements/platform_chain.dart';
import 'chainelements/timestamp_chain.dart';

final logger = Logger();

class AppDataChainMaster implements AppDataHandler {
  AppDataHandler? _entryHandler;

  AppDataChainMaster() {
    AppDataHandler listedAppHandler = ListedAppChain();

    AppDataHandler platformHandler = PlatformChain();
    platformHandler.setNextHandler(listedAppHandler);

    _entryHandler = TimestampChain();
    _entryHandler!.setNextHandler(platformHandler);
  }

  void setNextHandler(AppDataHandler handler) {
    throw UnsupportedError("Next handler in chain master is not supported.");
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    if (_entryHandler != null) {
      _entryHandler!.handleAppData(data);
    }
  }
}
