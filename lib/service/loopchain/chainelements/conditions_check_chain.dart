import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../condition_checker.dart';
import '../app_data_dto.dart';
import '../app_data_handler.dart';

final logger = Logger();
final GetIt locator = GetIt.instance;

class ConditionsCheckChain implements AppDataHandler {
  AppDataHandler? _nextHandler;

  ConditionsCheckChain() {}

  void setNextHandler(AppDataHandler handler) {
    _nextHandler = handler;
  }

  Future<void> handleAppData(AppData data) async {
    logger.d('handleAppData: $data');

    ConditionChecker checker = locator<ConditionChecker>();
    bool allMet = true;
    if (data.groupConditions != null && data.groupConditions!.isNotEmpty) {
      for (var condition in data.groupConditions!) {
        if (!(await checker.isConditionMet(condition))) {
          allMet = false;
          break;
        }
      }
    }
    data.conditionsMet = allMet;

    if (_nextHandler != null) {
      await _nextHandler!.handleAppData(data);
    }
  }
}
