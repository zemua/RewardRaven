import 'package:logger/logger.dart';

import 'app_data_dto.dart';
import 'app_data_handler.dart';

final logger = Logger();

class AppDataChainMaster implements AppDataHandler {
  AppDataHandler? entryHandler;

  AppDataChainMaster() {}

  void setNextHandler(AppDataHandler handler) {
    throw UnsupportedError("Next handler in chain master is not supported.");
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    if (entryHandler != null) {
      entryHandler!.handleAppData(data);
    }
  }
}
