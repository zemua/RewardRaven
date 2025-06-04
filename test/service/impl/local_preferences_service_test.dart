import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/service/impl/local_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'local_preferences_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SharedPreferences>(),
])
void main() {
  late LocalPreferencesService service;
  late MockSharedPreferences sharedPreferences;
  const testUuid = 'test-uuid-123';

  final GetIt locator = GetIt.instance;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    locator.registerSingleton<SharedPreferences>(sharedPreferences);

    service = LocalPreferencesService();
  });

  tearDown(() {
    locator.reset();
  });

  group('getUserUUID', () {
    test('should return existing UUID when available', () async {
      // Arrange
      when(sharedPreferences.getString('device_uuid')).thenReturn(testUuid);

      // Act
      final result = await service.getUserUUID();

      // Assert
      expect(result, equals(testUuid));
      verify(sharedPreferences.getString('device_uuid')).called(1);
    });

    test('should generate and save new UUID when not available', () async {
      // Arrange
      when(sharedPreferences.getString('device_uuid')).thenReturn(null);
      when(sharedPreferences.setString('device_uuid', any))
          .thenAnswer((_) => Future.value(true));

      // Act
      final result = await service.getUserUUID();

      // Assert
      expect(result, isNotNull);
      expect(result, isA<String>());
      verify(sharedPreferences.getString('device_uuid')).called(1);
      verify(sharedPreferences.setString('device_uuid', result)).called(1);
    });
  });
}
