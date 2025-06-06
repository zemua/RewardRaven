import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/service/app_group_service.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class AppGroupChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  AppGroupChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    if (data.listedApp?.listId != null &&
        data.listedApp?.status?.toGroupType() != null) {
      data.appGroup = await _locator<AppGroupService>().getGroup(
          data.listedApp!.status!.toGroupType()!, data.listedApp!.listId!);
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
