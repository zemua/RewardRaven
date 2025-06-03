import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
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

  setUp(() {
    timeLogRepository = MockTimeLogRepository();
    locator.registerSingleton<TimeLogRepository>(timeLogRepository);

    timeLogService = TimeLogService();
  });

  tearDown(() {
    locator.reset();
  });

  group('TimeLogService', () {
    test('get ground seconds for last 1 days', () async {
      List<DateTime> captured = [];
      when(timeLogRepository.getGroupTotalDuration("someGroupId", any))
          .thenAnswer((invocation) {
        captured.add(invocation.positionalArguments.last);
        return Future.value(const Duration(seconds: 30));
      });

      final result =
          await timeLogService.getGroupDurationForLastDays("someGroupId", 1);

      expect(result, equals(const Duration(seconds: 60)));
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
      fail("not yet implemented");
    });
  });
}
