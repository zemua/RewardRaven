import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/time_log.dart';
import 'package:reward_raven/db/repository/time_log_repository.dart';
import 'package:reward_raven/db/service/time_log_service.dart';
import 'package:reward_raven/tools/dates.dart';

import 'time_log_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<TimeLogRepository>(),
])
void main() {
  final locator = GetIt.instance;
  late MockTimeLogRepository timeLogRepository;
  late TimeLogService timeLogService;

  final testTimeLog = TimeLog(
    used: const Duration(minutes: 30),
    counted: const Duration(minutes: 20),
    dateTime: DateTime(2023, 1, 1, 12, 0),
  );

  setUp(() {
    timeLogRepository = MockTimeLogRepository();
    locator.registerSingleton<TimeLogRepository>(timeLogRepository);

    timeLogService = TimeLogService();
  });

  tearDown(() {
    locator.reset();
  });

  group('TimeLogService', () {
    test('get group duration seconds for last 1 days', () async {
      List<DateTime> captured = [];
      DateTime now = DateTime.now();
      when(timeLogRepository.getGroupTotalDuration("someGroupId", any))
          .thenAnswer((invocation) {
        captured.add(invocation.positionalArguments.last);
        return Future.value(TimeLog(
            used: const Duration(seconds: 60),
            counted: const Duration(seconds: 30),
            dateTime: now));
      });

      final result =
          await timeLogService.getGroupDurationForLastDays("someGroupId", 1);

      expect(result.counted, const Duration(seconds: 60));
      expect(result.used, const Duration(seconds: 120));
      expect(result.dateTime, isNotNull);
      verify(timeLogRepository.getGroupTotalDuration("someGroupId", any))
          .called(2);

      List<String> formattedDates = captured.map((dateTime) {
        return DateFormat('yyyy-MM-dd').format(dateTime);
      }).toList();

      assert(formattedDates.contains(toDateOnly(DateTime.now())));
      assert(formattedDates.contains(
          toDateOnly(DateTime.now().subtract(const Duration(days: 1)))));
    });

    test('add to total', () async {
      await timeLogService.addToTotal(testTimeLog);
      verify(timeLogRepository.addToTotal(testTimeLog)).called(1);
    });

    test('get total duration', () async {
      when(timeLogRepository.getTotalDuration()).thenAnswer((_) => Future.value(
          TimeLog(
              used: const Duration(hours: 2),
              counted: const Duration(hours: 1),
              dateTime: DateTime.now())));
      TimeLog result = await timeLogService.getTotalDuration();
      expect(result.used, equals(const Duration(hours: 2)));
      expect(result.counted, equals(const Duration(hours: 1)));
    });

    test('add to group', () async {
      await timeLogService.addToGroup(testTimeLog, "someGroupId");
      verify(timeLogRepository.addToGroup(testTimeLog, "someGroupId"))
          .called(1);
    });
  });
}
