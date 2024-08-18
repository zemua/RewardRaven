import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/listed_app_repository.dart';

import 'listed_app_repository_test.mocks.dart';

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  late MockFirebaseHelper mockFirebaseHelper;
  late MockDatabaseReference mockDatabaseReference;
  late ListedAppRepository listedAppRepository;

  setUp(() {
    mockFirebaseHelper = MockFirebaseHelper();
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenReturn(mockDatabaseReference);
    listedAppRepository = ListedAppRepository(mockFirebaseHelper);
  });

  group('ListedAppRepository', () {
    final listedApp = ListedApp(
        identifier: 'testId',
        platform: 'testPlatform',
        listId: 3,
        status: AppStatus.POSITIVE);

    test('addListedApp adds a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.set(any)).thenAnswer((_) async => null);

      await listedAppRepository.addListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testId_testPlatform')).called(1);
      verify(mockDatabaseReference.set(listedApp.toJson())).called(1);
    });

    test('updateListedApp updates a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.update(any)).thenAnswer((_) async => null);

      await listedAppRepository.updateListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testId_testPlatform')).called(1);
      verify(mockDatabaseReference.update(listedApp.toJson())).called(1);
    });

    test('deleteListedApp deletes a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.remove()).thenAnswer((_) async => null);

      await listedAppRepository.deleteListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps')).called(1);
      verify(mockDatabaseReference.child('testId_testPlatform')).called(1);
      verify(mockDatabaseReference.remove()).called(1);
    });

    test('getListedAppById retrieves a listed app successfully', () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDatabaseEvent);
      when(mockDataSnapshot.value).thenReturn(listedApp.toJson());

      final result = await listedAppRepository.getListedAppById('testKey');

      expect(result, isNotNull);
      expect(result!.compositeKey, listedApp.compositeKey);
      expect(result.identifier, listedApp.identifier);
    });

    test('getListedAppById returns null if app does not exist', () async {
      final mockDatabaseEvent = MockDatabaseEvent();
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDatabaseEvent);
      when(mockDataSnapshot.value).thenReturn(null);

      final result =
          await listedAppRepository.getListedAppById('nonExistentKey');

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

      expect(app.status, AppStatus.UNKNOWN);
    });

    test('fromJson should correctly deserialize status', () {
      final json = {
        'identifier': 'app1',
        'platform': 'android',
        'listId': 1,
        'status': 'POSITIVE',
      };

      final app = ListedApp.fromJson(json);

      expect(app.status, AppStatus.POSITIVE);
    });

    test('toJson should correctly serialize status', () {
      final app = ListedApp(
        identifier: 'app1',
        platform: 'android',
        listId: 1,
        status: AppStatus.POSITIVE,
      );

      final json = app.toJson();

      expect(json['status'], 'POSITIVE');
    });
  });
}
