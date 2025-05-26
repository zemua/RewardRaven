import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/service/loopchain/app_data_chain_master.dart';
import 'package:reward_raven/service/loopchain/app_data_dto.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'app_data_handler_chain_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlatformWrapper>()])
void main() {
  void setupLocator(PlatformWrapper platformWrapper) {
    if (GetIt.I.isRegistered<PlatformWrapper>()) {
      GetIt.I.unregister<PlatformWrapper>();
    }
    GetIt.I.registerSingleton<PlatformWrapper>(platformWrapper);
  }

  group('AppDataChainMaster', () {
    late AppDataChainMaster chainMaster;
    late AppData testAppData;

    late MockPlatformWrapper mockPlatformWrapper;

    setUp(() {
      // Create and setup mock
      mockPlatformWrapper = MockPlatformWrapper();
      when(mockPlatformWrapper.platformName).thenReturn('test_platform');
      setupLocator(mockPlatformWrapper);

      chainMaster = AppDataChainMaster();
      testAppData = AppData(
        processId: 'test_process_id',
        appName: 'test_app',
      );
    });

    test('should maintain initial AppData properties', () async {
      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.appId, equals('test_process_id'));
      expect(testAppData.appName, equals('test_app'));
    });

    test('should set timestamp when handling AppData', () async {
      // Verify initial state
      expect(testAppData.timestamp, isNull);

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.timestamp, isNotNull);
      expect(testAppData.timestamp, isA<DateTime>());

      final now = DateTime.now();
      final difference = now.difference(testAppData.timestamp!);
      expect(difference.inSeconds, lessThan(1)); // Should be very recent
    });

    test('should set platform when handling AppData', () async {
      // Verify initial state
      expect(testAppData.platform, isNull);

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.platform, isNotNull);
      expect(testAppData.platform, equals('test_platform'));
    });
  });
}
