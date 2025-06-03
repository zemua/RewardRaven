import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/collections.dart';
import 'package:reward_raven/db/entity/time_log.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/time_log_repository.dart';
import 'package:reward_raven/service/preferences_service.dart';
import 'package:reward_raven/tools/dates.dart';

import 'time_log_repository_test.mocks.dart';

final GetIt _locator = GetIt.instance;

@GenerateNiceMocks([
  MockSpec<FirebaseHelper>(),
  MockSpec<DatabaseReference>(),
  MockSpec<DataSnapshot>(),
  MockSpec<DatabaseEvent>(),
  MockSpec<PreferencesService>(),
])
void main() {
  late MockFirebaseHelper mockFirebaseHelper;
  late MockPreferencesService mockPreferencesService;
  late MockDatabaseReference mockDatabaseReference;
  late MockDatabaseReference mockTotalReference;
  late TimeLogRepository timeLogRepository;
  late MockDatabaseEvent mockDatabaseEvent;
  late MockDataSnapshot mockDataSnapshot;

  const testUuid = 'test-uuid-123';
  final testTimeLog = TimeLog(
    duration: const Duration(minutes: 30),
    dateTime: DateTime(2023, 1, 1, 12, 0),
  );

  setUp(() {
    mockFirebaseHelper = MockFirebaseHelper();
    mockPreferencesService = MockPreferencesService();

    _locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
    _locator.registerSingleton<PreferencesService>(mockPreferencesService);

    mockDatabaseReference = MockDatabaseReference();
    mockTotalReference = MockDatabaseReference();
    mockDatabaseEvent = MockDatabaseEvent();
    mockDataSnapshot = MockDataSnapshot();

    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    when(mockPreferencesService.getUserUUID())
        .thenAnswer((_) async => testUuid);
    when(mockDatabaseReference.child(DbCollection.logs.name))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child('group'))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child('groupId'))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child('test-uuid-123'))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child('2023-01-01'))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child('total')).thenReturn(mockTotalReference);
    when(mockTotalReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.once())
        .thenAnswer((_) async => mockDatabaseEvent);
    when(mockDatabaseReference.get()).thenAnswer((_) async => mockDataSnapshot);
    when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
    when(mockDatabaseReference.path).thenReturn('testPath');

    timeLogRepository = TimeLogRepository();
  });

  tearDown(() {
    _locator.reset();
  });

  group('addToTotal', () {
    test('should create new time log when no existing log exists', () async {
      // Arrange
      when(mockDataSnapshot.value).thenReturn(null);
      when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());

      // Act
      await timeLogRepository.addToTotal(testTimeLog);

      // Assert
      verify(mockDatabaseReference.set(argThat(isA<Map<String, dynamic>>())))
          .called(1);
      verify(mockPreferencesService.getUserUUID()).called(1);
    });

    test('should update existing time log when one exists', () async {
      // Arrange
      final existingLog = {
        'date_time': '2023-01-01T11:00:00.000',
        'duration': 1800, // 30 minutes
      };
      when(mockDataSnapshot.value).thenReturn(existingLog);
      when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

      // Arrange - Capture the update arguments
      Map<String, dynamic>? capturedUpdate;
      when(mockDatabaseReference.update(argThat(isA<Map<String, dynamic>>())))
          .thenAnswer((invocation) {
        capturedUpdate =
            invocation.positionalArguments.first as Map<String, dynamic>;
        return Future.value();
      });

      // Act
      await timeLogRepository.addToTotal(testTimeLog);

      // Assert
      verify(mockDatabaseReference.update(argThat(isA<Map<String, dynamic>>())))
          .called(1);

      // Inspect the captured update
      expect(capturedUpdate, isNotNull);
      expect(capturedUpdate!['date_time'], '2023-01-01T12:00:00.000');
      expect(capturedUpdate!['duration'], 3600);
    });
  });

  group('getTotalSeconds', () {
    test('should return 0 when no time logs exist', () async {
      // Arrange
      when(mockTotalReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn(null);

      // Act
      final result = await timeLogRepository.getTotalDuration();

      // Assert
      expect(result, equals(const Duration()));
      verify(mockTotalReference.get()).called(1);
    });

    test('should return sum of all time logs', () async {
      // Arrange
      when(mockTotalReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn({
        'device1': {
          'date_time': '2023-01-01T12:00:00.000',
          'duration': 1800, // 30 minutes
        },
        'device2': {
          'date_time': '2023-01-01T13:00:00.000',
          'duration': 1800, // 30 minutes
        },
      });

      // Act
      final result = await timeLogRepository.getTotalDuration();

      // Assert
      expect(result, equals(const Duration(seconds: 3600)));
      verify(mockTotalReference.get()).called(1);
    });

    test('should handle malformed time logs gracefully', () async {
      // Arrange
      when(mockTotalReference.get()).thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn({
        'device1': {
          'date_time': '2023-01-01T12:00:00.000',
          'duration': 1800, // 30 minutes
        },
        'device2': 'malformed-data',
        'device3': {
          'date_time': '2023-01-01T13:00:00.000',
          'duration': 1800, // 30 minutes
        },
      });

      // Act
      final result = await timeLogRepository.getTotalDuration();

      // Assert
      expect(result, equals(const Duration(seconds: 3600)));
      verify(mockTotalReference.get()).called(1);
    });
  });

  group('addToGroup', () {
    test('should create new group time log when no existing log exists',
        () async {
      // Arrange
      when(mockDataSnapshot.value).thenReturn(null);
      when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());

      // Act
      await timeLogRepository.addToGroup(testTimeLog, 'groupId');

      // Assert
      verify(mockDatabaseReference.set(argThat(isA<Map<String, dynamic>>())))
          .called(1);
      verify(mockPreferencesService.getUserUUID()).called(1);
    });

    test('should update existing group time log when one exists', () async {
      // Arrange
      final existingLog = {
        'date_time': '2023-01-01T11:00:00.000',
        'duration': 1800, // 30 minutes
      };
      when(mockDataSnapshot.value).thenReturn(existingLog);
      when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

      // Arrange - Capture the update arguments
      Map<String, dynamic>? capturedUpdate;
      when(mockDatabaseReference.update(argThat(isA<Map<String, dynamic>>())))
          .thenAnswer((invocation) {
        capturedUpdate =
            invocation.positionalArguments.first as Map<String, dynamic>;
        return Future.value();
      });

      // Act
      await timeLogRepository.addToGroup(testTimeLog, 'groupId');

      // Assert
      verify(mockDatabaseReference.update(argThat(isA<Map<String, dynamic>>())))
          .called(1);

      // Inspect the captured update
      expect(capturedUpdate, isNotNull);
      expect(capturedUpdate!['date_time'], '2023-01-01T12:00:00.000');
      expect(capturedUpdate!['duration'], 3600);
    });
  });

  group('countFromGroup', () {
    test('should return sum of all time logs from group', () async {
      // Arrange
      when(mockDatabaseReference.child(toDateOnly(DateTime.now())))
          .thenReturn(mockDatabaseReference);
      when(mockDataSnapshot.value).thenReturn({
        'device1': {
          'date_time': '2023-01-01T12:00:00.000',
          'duration': 1800, // 30 minutes
        },
        'device2': {
          'date_time': '2023-01-01T13:00:00.000',
          'duration': 1800, // 30 minutes
        },
      });

      // Act
      final result = await timeLogRepository.getGroupTotalDuration(
          'groupId', DateTime.now());

      // Assert
      expect(result,
          equals(const Duration(seconds: 3600))); // 60 minutes in seconds
      verify(mockDatabaseReference.get()).called(1);
    });
  });
}
