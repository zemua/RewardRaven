import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../platform_wrapper.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt locator = GetIt.instance;

class PlatformChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  PlatformChain() {}

  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');
    data.platform = locator<PlatformWrapper>().platformName;
    if (_nextHandler != null) {
      _nextHandler!.handleAppData(data);
    }
  }
}
