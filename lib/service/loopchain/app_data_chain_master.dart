import 'package:logger/logger.dart';

import 'app_data_dto.dart';
import 'app_data_handler.dart';
import 'chainelements/timestamp.dart';

final logger = Logger();

class AppDataChainMaster implements AppDataHandler {
  AppDataHandler? _entryHandler;

  AppDataChainMaster() {
    _entryHandler = TimestampChain();
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
