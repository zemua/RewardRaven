import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class UpdateNotificationChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  UpdateNotificationChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    // TODO: Update notification

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
