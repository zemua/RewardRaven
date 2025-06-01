import 'package:get_it/get_it.dart';
import 'package:reward_raven/db/repository/time_log_repository.dart';

final GetIt _locator = GetIt.instance;

class TimeLogService {
  final TimeLogRepository _repository = _locator<TimeLogRepository>();

  TimeLogService();
}
