import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/repository/app_group_repository.dart';
import 'package:reward_raven/db/service/app_group_service.dart';

import 'app_group_service_test.mocks.dart';

@GenerateMocks([AppGroupRepository])
void main() {
  final locator = GetIt.instance;
  late AppGroupService appGroupService;
  late MockAppGroupRepository mockRepository;

  group('AppGroupService Tests', () {
    setUp(() {
      mockRepository = MockAppGroupRepository();
      locator.registerSingleton<AppGroupRepository>(mockRepository);
      appGroupService = AppGroupService();
    });

    tearDown(() {
      locator.reset();
    });

    test('saveGroup adds group to repository', () async {
      final group = AppGroup(name: 'Test Group', type: GroupType.positive);
      await appGroupService.saveGroup(group);
      verify(mockRepository.saveGroup(group)).called(1);
    });

    test('updateGroup updates group in repository', () async {
      final group = AppGroup(name: 'Updated Group', type: GroupType.positive);
      const key = 'test_key';
      await appGroupService.updateGroup(key, group);
      verify(mockRepository.updateGroup(key, group)).called(1);
    });

    test('getGroups retrieves groups from repository', () async {
      const groupType = GroupType.positive;
      final groups = [
        AppGroup(name: 'Group 1', type: groupType),
        AppGroup(name: 'Group 2', type: groupType),
      ];

      when(mockRepository.getGroups(groupType)).thenAnswer((_) async => groups);

      final result = await appGroupService.getGroups(groupType);

      expect(result, equals(groups));
      verify(mockRepository.getGroups(groupType)).called(1);
    });
  });
}
