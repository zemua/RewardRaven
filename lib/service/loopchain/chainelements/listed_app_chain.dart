import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/service/listed_app_service.dart';
import '../../platform_wrapper.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class ListedAppChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  ListedAppChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    String id;
    if (_locator<PlatformWrapper>().isAndroid()) {
      id = data.processId;
    } else {
      id = data.appName;
    }

    try {
      data.listedApp = await _locator<ListedAppService>().getListedAppById(id);
    } catch (e) {
      logger.w('Exception getting listed app for: $id');
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
