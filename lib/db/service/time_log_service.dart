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

  Future<Duration> getTotalDuration() async {
    return await _repository.getTotalDuration();
  }

  Future<void> addToGroup(TimeLog timelog, String groupId) async {
    await _repository.addToGroup(timelog, groupId);
  }

  Future<Duration> getGroupDurationForLastDays(
      String groupId, int lastDays) async {
    Duration totaDuration = const Duration();
    DateTime now = DateTime.now();
    for (int i = 0; i <= lastDays; i++) {
      DateTime specificDay = now.subtract(Duration(days: i));
      Duration durationForDay =
          await _repository.getGroupTotalDuration(groupId, specificDay);
      totaDuration += durationForDay;
    }
    return totaDuration;
  }
}
