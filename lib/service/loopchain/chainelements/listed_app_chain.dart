import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/service/listed_app_service.dart';
import '../../platform_wrapper.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt locator = GetIt.instance;

class ListedAppChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  ListedAppChain() {}

  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    String id;
    if (locator<PlatformWrapper>().isAndroid()) {
      id = data.processId;
    } else {
      id = data.appName;
    }

    data.listedApp = await locator<ListedAppService>().getListedAppById(id);

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
