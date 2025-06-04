import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../../db/service/group_condition_service.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt _locator = GetIt.instance;

class GroupConditionsChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  GroupConditionsChain();

  @override
  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  @override
  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    if (data.appGroup?.id != null) {
      data.groupConditions = await _locator<GroupConditionService>()
          .getGroupConditions(data.appGroup!.id!);
    }

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
