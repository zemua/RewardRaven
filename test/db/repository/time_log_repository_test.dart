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
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  final MockPreferencesService mockPreferencesService =
      MockPreferencesService();

  _locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  _locator.registerSingleton<PreferencesService>(mockPreferencesService);

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
    when(mockDatabaseReference.child('total')).thenReturn(mockTotalReference);
    when(mockTotalReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.once())
        .thenAnswer((_) async => mockDatabaseEvent);
    when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
    when(mockDatabaseReference.path).thenReturn('testPath');

    timeLogRepository = TimeLogRepository();
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
      final result = await timeLogRepository.getTotalSeconds();

      // Assert
      expect(result, equals(0));
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
      final result = await timeLogRepository.getTotalSeconds();

      // Assert
      expect(result, equals(3600)); // 60 minutes in seconds
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
      final result = await timeLogRepository.getTotalSeconds();

      // Assert
      expect(result,
          equals(3600)); // Should still sum the valid entries (30 + 30 minutes)
      verify(mockTotalReference.get()).called(1);
    });
  });
}
