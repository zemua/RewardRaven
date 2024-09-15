import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/app_group_repository.dart';
import 'package:reward_raven/main.dart';

import 'app_group_repository_test.mocks.dart';

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  late MockDatabaseReference mockDatabaseReference;
  late AppGroupRepository appGroupRepository;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    appGroupRepository = AppGroupRepository();
  });

  group('ListedAppRepository', () {
    // TODO implement tests
    final appGroup = AppGroup(
      name: 'testName',
      type: GroupType.positive,
      preventClose: true,
    );

    test('addGroup adds a group successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());

      await appGroupRepository.addGroup(appGroup);

      verify(mockDatabaseReference.child('somepath')).called(1);
      verify(mockDatabaseReference.child('somechild')).called(1);
      verify(mockDatabaseReference.child('someid')).called(1);
      verify(mockDatabaseReference.set(appGroup.toJson())).called(1);
    });
  });
}
