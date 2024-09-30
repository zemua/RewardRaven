import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/listed_app_repository.dart';
import 'package:reward_raven/main.dart';

import 'listed_app_repository_test.mocks.dart';

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  late MockDatabaseReference mockDatabaseReference;
  late ListedAppRepository listedAppRepository;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    listedAppRepository = ListedAppRepository();
  });

  group('ListedAppRepository', () {
    final listedApp = ListedApp(
        identifier: 'testId',
        platform: 'testPlatform',
        listId: 3,
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
        'listId': 1,
        'status': null,
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.unknown);
    });

    test('fromJson should correctly deserialize status', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': 1,
        'status': 'positive',
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.positive);
    });

    test('fromJson return unknown if status is not recognized', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': 1,
        'status': 'POSITIVE',
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.unknown);
    });

    test('toJson should correctly serialize status', () {
      final app = ListedApp(
        identifier: 'app1',
        platform: 'android',
        listId: 1,
        status: AppStatus.positive,
      );

      final json = app.toJson();

      expect(json['status'], 'positive');
    });

    test('getListedAppsByName retrieves listed apps successfully', () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      final listedAppsJson = {
        'app1': {
          'identifier': 'app1.id',
          'platform': 'testPlatform',
          'listId': 1,
          'status': 'positive',
        },
        'app2': {
          'identifier': 'app2.id',
          'platform': 'testPlatform',
          'listId': 2,
          'status': 'negative',
        },
      };

      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => Future.value(mockDatabaseEvent));
      when(mockDataSnapshot.value).thenReturn(listedAppsJson);

      final result =
          await listedAppRepository.getListedAppsByName('testPlatform');

      expect(result, isNotEmpty);
      expect(result.length, 2);
      expect(result['app1.id']?.identifier, 'app1.id');
      expect(result['app1.id']?.status, AppStatus.positive);
      expect(result['app2.id']?.identifier, 'app2.id');
      expect(result['app2.id']?.status, AppStatus.negative);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testPlatform')).called(1);
    });
  });
}
