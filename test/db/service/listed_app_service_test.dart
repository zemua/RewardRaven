import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/repository/listed_app_repository.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
import 'package:reward_raven/screens/apps/app_list_type.dart';
import 'package:reward_raven/service/platform_wrapper.dart';

import 'listed_app_service_test.mocks.dart';

@GenerateMocks([PlatformWrapper, ListedAppRepository])
void main() {
  final locator = GetIt.instance;
  late ListedAppService listedAppService;
  late MockListedAppRepository mockRepository;
  late MockPlatformWrapper mockPlatformWrapper;

  setUp(() {
    mockRepository = MockListedAppRepository();
    locator.registerSingleton<ListedAppRepository>(mockRepository);
    mockPlatformWrapper = MockPlatformWrapper();
    locator.registerSingleton<PlatformWrapper>(mockPlatformWrapper);
    listedAppService = ListedAppService();
  });

  tearDown(() {
    locator.reset();
  });

  group('ListedAppService', () {
    test('addListedApp adds app to repository', () async {
      const app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.saveListedApp(app);
      verify(mockRepository.saveListedApp(app)).called(1);
    });

    test('updateListedApp updates app in repository', () async {
      const app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.updateListedApp(app);
      verify(mockRepository.updateListedApp(app)).called(1);
    });

    test('deleteListedApp deletes app from repository', () async {
      const app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.deleteListedApp(app);
      verify(mockRepository.deleteListedApp(app)).called(1);
    });

    test('getListedAppById returns app if found', () async {
      const app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => app);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      final result = await listedAppService.getListedAppById('test');
      expect(result, app);
    });

    test('getListedAppById returns null if not found', () async {
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => null);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      final result = await listedAppService.getListedAppById('test');
      expect(result, isNull);
    });

    test('fetchStatus returns status if app found', () async {
      const app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => app);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      final result = await listedAppService.fetchStatus('test');
      expect(result, AppStatus.positive);
    });

    test('fetchStatus returns UNKNOWN if app not found', () async {
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => null);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      final result = await listedAppService.fetchStatus('test');
      expect(result, AppStatus.unknown);
    });

    test('fetchListedAppsByType returns apps of specified type', () async {
      const app1 = ListedApp(
          identifier: 'test1', platform: 'android', status: AppStatus.positive);
      const app2 = ListedApp(
          identifier: 'test2', platform: 'android', status: AppStatus.positive);
      const listType = AppListType.positive;

      when(mockRepository.getListedAppsByStatus(AppStatus.positive, 'android'))
          .thenAnswer((_) async => [app1, app2]);
      when(mockPlatformWrapper.platformName).thenReturn('android');

      final result = await listedAppService.fetchListedAppsByType(listType);
      expect(result, [app1, app2]);
    });
  });
}
