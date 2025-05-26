import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/service/loopchain/app_data_chain_master.dart';
import 'package:reward_raven/service/loopchain/app_data_dto.dart';

void main() {
  group('AppDataChainMaster', () {
    late AppDataChainMaster chainMaster;
    late AppData testAppData;

    setUp(() {
      chainMaster = AppDataChainMaster();
      testAppData = AppData(
        processId: 'test_process_id',
        appName: 'test_app',
      );
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

    test('should maintain other AppData properties', () async {
      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.appId, equals('test_process_id'));
      expect(testAppData.appName, equals('test_app'));
      expect(testAppData.timestamp, isNotNull);
    });
  });
}
