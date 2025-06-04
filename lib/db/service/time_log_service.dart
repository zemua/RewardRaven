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

  Future<TimeLog> getTotalDuration() async {
    return await _repository.getTotalDuration();
  }

  Future<void> addToGroup(TimeLog timelog, String groupId) async {
    await _repository.addToGroup(timelog, groupId);
  }

  Future<TimeLog> getGroupDurationForLastDays(
      String groupId, int lastDays) async {
    Duration totalUsed = Duration.zero;
    Duration totalCounted = Duration.zero;
    DateTime now = DateTime.now();
    for (int i = 0; i <= lastDays; i++) {
      DateTime specificDay = now.subtract(Duration(days: i));
      TimeLog durationForDay =
          await _repository.getGroupTotalDuration(groupId, specificDay);
      totalUsed += durationForDay.used;
      totalCounted += durationForDay.counted;
    }
    return TimeLog(used: totalUsed, counted: totalCounted, dateTime: now);
  }
}
