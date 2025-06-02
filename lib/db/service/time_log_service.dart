import 'package:get_it/get_it.dart';
import 'package:reward_raven/db/entity/time_log.dart';
import 'package:reward_raven/db/repository/time_log_repository.dart';

final GetIt _locator = GetIt.instance;

class TimeLogService {
  final TimeLogRepository _repository = _locator<TimeLogRepository>();

  TimeLogService();

  Future<void> addToTotal(TimeLog timelog) async {
    await _repository.addToTotal(timelog);
  }

  Future<int> getTotalSeconds() async {
    return await _repository.getTotalSeconds();
  }

  Future<void> addToGroup(TimeLog timelog, String groupId) async {
    await _repository.addToGroup(timelog, groupId);
  }

  Future<int> getGroupSecondsForLastDays(String groupId, int lastDays) async {
    int totalSeconds = 0;
    DateTime now = DateTime.now();
    for (int i = 0; i <= lastDays; i++) {
      DateTime specificDay = now.subtract(Duration(days: i));
      int secondsForDay =
          await _repository.getGroupTotalSeconds(groupId, specificDay);
      totalSeconds += secondsForDay;
    }
    return totalSeconds;
  }
}
