import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/repository/listed_app_repository.dart';
import 'package:reward_raven/db/service/listed_app_service.dart';
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
      final app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.addListedApp(app);
      verify(mockRepository.saveListedApp(app)).called(1);
    });

    test('updateListedApp updates app in repository', () async {
      final app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.updateListedApp(app);
      verify(mockRepository.updateListedApp(app)).called(1);
    });

    test('deleteListedApp deletes app from repository', () async {
      final app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      await listedAppService.deleteListedApp(app);
      verify(mockRepository.deleteListedApp(app)).called(1);
    });

    test('getListedAppById returns app if found', () async {
      final app = ListedApp(
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
      final app = ListedApp(
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

    test('saveStatus adds new app if not found', () async {
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => null);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      await listedAppService.saveStatus('test', AppStatus.positive);
      verify(mockRepository.saveListedApp(any)).called(1);
    });

    test('saveStatus updates existing app if found', () async {
      final app = ListedApp(
          identifier: 'test', platform: 'android', status: AppStatus.positive);
      when(mockRepository.getListedAppById('test', 'android'))
          .thenAnswer((_) async => app);
      when(mockPlatformWrapper.platformName).thenReturn('android');
      await listedAppService.saveStatus('test', AppStatus.positive);
      verify(mockRepository.updateListedApp(app)).called(1);
    });
  });
}
