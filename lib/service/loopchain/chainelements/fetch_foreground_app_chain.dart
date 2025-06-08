import 'package:logger/logger.dart';

import '../app_data_dto.dart';
import '../app_data_handler.dart';

final _logger = Logger();
const String _getForegroundAppData = 'getForegroundAppInfo';

class ForegroundAppChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  ForegroundAppChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    _logger.d('handleAppData: $data');

    final result =
        await data.appNativeChannel.invokeMethod<Map>(_getForegroundAppData);
    _logger.d('App info: $result');
    data.processId = result?['packageName'];
    data.appName = result?['appName'];

    if (_nextHandler != null &&
        data.processId != null &&
        data.appName != null) {
      await _nextHandler!.handleAppData(data);
    } else {
      _logger.w('Failed to get app info');
    }
  }
}
