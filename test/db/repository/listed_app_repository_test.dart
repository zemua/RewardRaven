import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/listed_app_repository.dart';

import 'listed_app_repository_test.mocks.dart';

final GetIt _locator = GetIt.instance;

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  _locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  late MockDatabaseReference mockDatabaseReference;
  late ListedAppRepository listedAppRepository;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    listedAppRepository = ListedAppRepository();
  });

  group('ListedAppRepository', () {
    const listedApp = ListedApp(
        identifier: 'testId',
        platform: 'testPlatform',
        listId: "3",
        status: AppStatus.positive);

    test('addListedApp adds a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());
      when(mockDatabaseReference.path).thenReturn('testPath');

      await listedAppRepository.saveListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testPlatform')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
      verify(mockDatabaseReference.set(listedApp.toJson())).called(1);
    });

    test('updateListedApp updates a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

      await listedAppRepository.updateListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testPlatform')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
      verify(mockDatabaseReference.update(listedApp.toJson())).called(1);
    });

    test('deleteListedApp deletes a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.remove()).thenAnswer((_) => Future.value());

      await listedAppRepository.deleteListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testPlatform')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
      verify(mockDatabaseReference.remove()).called(1);
    });

    test('getListedAppById retrieves a listed app successfully', () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => Future.value(mockDatabaseEvent));
      when(mockDataSnapshot.value).thenReturn(listedApp.toJson());
      when(mockDatabaseReference.path).thenReturn('testPath');

      final result =
          await listedAppRepository.getListedAppById('testId', "testPlatform");

      expect(result, isNotNull);
      expect(result?.platform, listedApp.platform);
      expect(result?.identifier, listedApp.identifier);
      expect(result?.status, listedApp.status);
      expect(result?.listId, listedApp.listId);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testPlatform')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
    });

    test('getListedAppById returns null if app does not exist', () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => Future.value(mockDatabaseEvent));
      when(mockDataSnapshot.value).thenReturn(null);

      final result = await listedAppRepository.getListedAppById(
          'nonExistingId', "nonExistingPlatform");

      expect(result, isNull);
    });

    test('fromJson should set status to UNKNOWN if null', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': "1",
        'status': null,
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.unknown);
    });

    test('fromJson should correctly deserialize status', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': "1",
        'status': 'positive',
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.positive);
    });

    test('fromJson return unknown if status is not recognized', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': "1",
        'status': 'POSITIVE',
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.unknown);
    });

    test('toJson should correctly serialize status', () {
      const app = ListedApp(
        identifier: 'app1',
        platform: 'android',
        listId: "1",
        status: AppStatus.positive,
      );

      final json = app.toJson();

      expect(json['status'], 'positive');
    });

    test('getListedAppsByStatus retrieves listed apps by status successfully',
        () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      final listedAppJson = {
        'identifier': 'testId',
        'platform': 'testPlatform',
        'listId': "3",
        'status': 'positive',
      };
      final anotherAppJson = {
        'identifier': 'anotherid',
        'platform': 'testPlatform',
        'listId': "4",
        'status': 'negative',
      };
      final listedApp = ListedApp.fromJson(listedAppJson);
      final appsMap = {
        'app1': listedAppJson,
        'app2': anotherAppJson,
      };

      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => Future.value(mockDatabaseEvent));
      when(mockDataSnapshot.value).thenReturn(appsMap);

      final result = await listedAppRepository.getListedAppsByStatus(
          AppStatus.positive, "testPlatform");

      expect(result, isNotEmpty);
      expect(result.length, 1);
      expect(result.first.platform, listedApp.platform);
      expect(result.first.identifier, listedApp.identifier);
      expect(result.first.status, listedApp.status);
      expect(result.first.listId, listedApp.listId);

      verify(mockDatabaseReference.child('listedApps')).called(1);
    });
  });
}
