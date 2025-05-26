import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/main.dart';
import 'package:reward_raven/service/loopchain/app_data_chain_master.dart';
import 'package:reward_raven/service/loopchain/app_data_dto.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'app_data_handler_chain_test.mocks.dart';

@GenerateNiceMocks([MockSpec<PlatformWrapper>(), MockSpec<ListedAppService>()])
void main() {
  late MockPlatformWrapper mockPlatformWrapper;
  late MockListedAppService mockListedAppService;

  group('AppDataChainMaster', () {
    late AppDataChainMaster chainMaster;
    late AppData testAppData;

    setUp(() {
      // Create and setup mock
      mockPlatformWrapper = MockPlatformWrapper();
      when(mockPlatformWrapper.platformName).thenReturn('test_platform');
      locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);

      mockListedAppService = MockListedAppService();
      locator.registerSingleton<ListedAppService>(mockListedAppService);

      chainMaster = AppDataChainMaster();
      testAppData = AppData(
        processId: 'test_process_id',
        appName: 'test_app',
      );
    });

    tearDown(() {
      locator.reset();
    });

    test('should maintain initial AppData properties', () async {
      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.processId, equals('test_process_id'));
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

    test('should add ListedApp to AppData', () async {
      // Setup a dummy ListedApp
      final listedApp = ListedApp(
          identifier: 'test_id',
          platform: 'android',
          status: AppStatus.positive,
          listId: '1');

      when(mockListedAppService.getListedAppById("test_process_id"))
          .thenAnswer((_) => Future.value(listedApp));
      when(mockPlatformWrapper.isAndroid()).thenAnswer((_) => true);

      // Verify initial state
      expect(testAppData.listedApp, isNull);

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, equals(listedApp));
    });
  });
}
