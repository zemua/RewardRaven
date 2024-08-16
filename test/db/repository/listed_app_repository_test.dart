import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:your_project/db/repository/listed_app_repository.dart';
import 'package:your_project/entity/listed_app.dart';
import 'package:your_project/helper/firebase_helper.dart';

class MockFirebaseHelper extends Mock implements FirebaseHelper {}

class MockDatabaseReference extends Mock implements DatabaseReference {}

class MockDataSnapshot extends Mock implements DataSnapshot {}

void main() {
  MockFirebaseHelper mockFirebaseHelper;
  MockDatabaseReference mockDatabaseReference;
  ListedAppRepository listedAppRepository;
  Logger logger;

  setUp(() {
    mockFirebaseHelper = MockFirebaseHelper();
    mockDatabaseReference = MockDatabaseReference();
    logger = Logger();
    when(mockFirebaseHelper.databaseReference)
        .thenReturn(mockDatabaseReference);
    listedAppRepository = ListedAppRepository(mockFirebaseHelper);
  });

  group('ListedAppRepository', () {
    final listedApp = ListedApp(compositeKey: 'testKey', name: 'Test App');

    test('addListedApp adds a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.set(any)).thenAnswer((_) async => null);

      await listedAppRepository.addListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps/testKey')).called(1);
      verify(mockDatabaseReference.set(listedApp.toJson())).called(1);
    });

    test('updateListedApp updates a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.update(any)).thenAnswer((_) async => null);

      await listedAppRepository.updateListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps/testKey')).called(1);
      verify(mockDatabaseReference.update(listedApp.toJson())).called(1);
    });

    test('deleteListedApp deletes a listed app successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.remove()).thenAnswer((_) async => null);

      await listedAppRepository.deleteListedApp(listedApp);

      verify(mockDatabaseReference.child('listedApps/testKey')).called(1);
      verify(mockDatabaseReference.remove()).called(1);
    });

    test('getListedAppById retrieves a listed app successfully', () async {
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn(listedApp.toJson());

      final result = await listedAppRepository.getListedAppById('testKey');

      expect(result, isNotNull);
      expect(result!.compositeKey, listedApp.compositeKey);
      expect(result.name, listedApp.name);
    });

    test('getListedAppById returns null if app does not exist', () async {
      final mockDataSnapshot = MockDataSnapshot();
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn(null);

      final result =
          await listedAppRepository.getListedAppById('nonExistentKey');

      expect(result, isNull);
    });
  });
}
