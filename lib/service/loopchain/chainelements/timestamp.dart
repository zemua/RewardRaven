import 'package:logger/logger.dart';

import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();

class TimestampChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  TimestampChain() {}

  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    data.timestamp = DateTime.now();
    if (_nextHandler != null) {
      _nextHandler!.handleAppData(data);
    }
  }
}
