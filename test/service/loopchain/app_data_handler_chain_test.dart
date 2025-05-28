import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/service/app_group_service.dart';
import 'package:reward_raven/db/service/group_condition_service.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/service/condition_checker.dart';
import 'package:reward_raven/service/loopchain/app_data_chain_master.dart';
import 'package:reward_raven/service/loopchain/app_data_dto.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'app_data_handler_chain_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PlatformWrapper>(),
  MockSpec<ListedAppService>(),
  MockSpec<AppGroupService>(),
  MockSpec<GroupConditionService>(),
  MockSpec<ConditionChecker>(),
])
void main() {
  late MockPlatformWrapper mockPlatformWrapper;
  late MockListedAppService mockListedAppService;
  late MockAppGroupService mockAppGroupService;
  late MockGroupConditionService mockGroupConditionService;
  late MockConditionChecker mockConditionChecker;

  final locator = GetIt.instance;

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

      mockAppGroupService = MockAppGroupService();
      locator.registerSingleton<AppGroupService>(mockAppGroupService);

      mockGroupConditionService = MockGroupConditionService();
      locator
          .registerSingleton<GroupConditionService>(mockGroupConditionService);

      mockConditionChecker = MockConditionChecker();
      locator.registerSingleton<ConditionChecker>(mockConditionChecker);

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

    test('should assign group when group exists for listed app', () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, equals(testListedApp));
      expect(testAppData.appGroup, equals(testGroup));
      verify(mockAppGroupService.getGroup(
        GroupType.positive,
        'test_list_id',
      )).called(1);
    });

    test('should not assign group when no group exists for listed app',
        () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(null));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, equals(testListedApp));
      expect(testAppData.appGroup, isNull);
      verify(mockAppGroupService.getGroup(
        GroupType.positive,
        'test_list_id',
      )).called(1);
    });

    test('should not assign group when listed app has no listId', () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: null,
      );

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, equals(testListedApp));
      expect(testAppData.appGroup, isNull);
      verifyNever(mockAppGroupService.getGroup(any, any));
    });

    test('should not assign group when listed app is null', () async {
      // Arrange
      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(null));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, isNull);
      expect(testAppData.appGroup, isNull);
      verifyNever(mockAppGroupService.getGroup(any, any));
    });

    test('should assign conditions when exists', () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      final conditions = [
        GroupCondition(
          id: 'test_id',
          conditionalGroupId: 'conditional_group_id',
          conditionedGroupId: 'test_group_id',
          usedTime: Duration(hours: 1),
          duringLastDays: 1,
        ),
      ];

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) => Future.value(conditions));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.listedApp, equals(testListedApp));
      expect(testAppData.appGroup, equals(testGroup));
      expect(testAppData.groupConditions, equals(conditions));
      verify(mockGroupConditionService.getGroupConditions(
        'test_group_id',
      )).called(1);
    });

    test('should verify conditions met', () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      final conditions = [
        GroupCondition(
          id: 'test_id',
          conditionalGroupId: 'conditional_group_id',
          conditionedGroupId: 'test_group_id',
          usedTime: Duration(hours: 1),
          duringLastDays: 1,
        ),
      ];

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) => Future.value(conditions));
      when(mockConditionChecker.isConditionMet(any))
          .thenAnswer((_) => Future.value(true));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.conditionsMet, equals(true));
      verify(mockConditionChecker.isConditionMet(any)).called(1);
    });

    test('should verify conditions NOT met', () async {
      // Arrange
      final testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      final conditions = [
        GroupCondition(
          id: 'test_id',
          conditionalGroupId: 'conditional_group_id',
          conditionedGroupId: 'test_group_id',
          usedTime: Duration(hours: 1),
          duringLastDays: 1,
        ),
      ];

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) => Future.value(conditions));
      when(mockConditionChecker.isConditionMet(any))
          .thenAnswer((_) => Future.value(false));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.conditionsMet, equals(false));
      verify(mockConditionChecker.isConditionMet(any)).called(1);
    });

    test('no positive and no negative, should not count time', () async {
      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.timeElapsed, equals(5000));
      expect(testAppData.timeCounted, equals(0));
    });

    test('negative should discount time', () async {
      var testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.negative,
        listId: 'test_list_id',
      );

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.timeElapsed, equals(5000));
      expect(testAppData.timeCounted, equals(-20000));
    });

    test('positve and conditions not met should not count time', () async {
      var testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      final conditions = [
        GroupCondition(
          id: 'test_id',
          conditionalGroupId: 'conditional_group_id',
          conditionedGroupId: 'test_group_id',
          usedTime: Duration(hours: 1),
          duringLastDays: 1,
        ),
      ];

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) => Future.value(conditions));
      when(mockConditionChecker.isConditionMet(any))
          .thenAnswer((_) => Future.value(false));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.timeElapsed, equals(5000));
      expect(testAppData.timeCounted, equals(0));
    });

    test('positve and conditions met should count time', () async {
      var testListedApp = ListedApp(
        identifier: 'test_id',
        platform: 'android',
        status: AppStatus.positive,
        listId: 'test_list_id',
      );

      final testGroup = AppGroup(
          id: 'test_group_id', name: 'Test Group', type: GroupType.positive);

      final conditions = [
        GroupCondition(
          id: 'test_id',
          conditionalGroupId: 'conditional_group_id',
          conditionedGroupId: 'test_group_id',
          usedTime: Duration(hours: 1),
          duringLastDays: 1,
        ),
      ];

      when(mockListedAppService.getListedAppById(any))
          .thenAnswer((_) => Future.value(testListedApp));
      when(mockAppGroupService.getGroup(any, any))
          .thenAnswer((_) => Future.value(testGroup));
      when(mockGroupConditionService.getGroupConditions(any))
          .thenAnswer((_) => Future.value(conditions));
      when(mockConditionChecker.isConditionMet(any))
          .thenAnswer((_) => Future.value(true));

      // Act
      await chainMaster.handleAppData(testAppData);

      // Assert
      expect(testAppData.timeElapsed, equals(5000));
      expect(testAppData.timeCounted, equals(5000));
    });
  });
}
