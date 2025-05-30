import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/app_group.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/app_group_repository.dart';

import 'app_group_repository_test.mocks.dart';

final GetIt _locator = GetIt.instance;

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  _locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  late MockDatabaseReference mockDatabaseReference;
  late AppGroupRepository appGroupRepository;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    appGroupRepository = AppGroupRepository();
  });

  group('AppGroupRepository', () {
    const appGroup = AppGroup(
      name: 'testName',
      type: GroupType.positive,
      preventClose: true,
    );

    test('saveGroup adds a group successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.push()).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());
      when(mockDatabaseReference.path).thenReturn('testPath');

      await appGroupRepository.saveGroup(appGroup);

      verify(mockDatabaseReference.child('appGroups')).called(1);
      verify(mockDatabaseReference.push()).called(1);
      verify(mockDatabaseReference.set(appGroup.toJson())).called(1);
    });

    test('updateGroup updates a group successfully', () async {
      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

      await appGroupRepository.updateGroup('testId', appGroup);

      verify(mockDatabaseReference.child('appGroups')).called(1);
      verify(mockDatabaseReference.child('positive')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
      verify(mockDatabaseReference.update(appGroup.toJson())).called(1);
    });

    test(
        'getGroup returns a single AppGroup given type is "positive" and key is "testId"',
        () async {
      final mockDataSnapshot = MockDataSnapshot();
      final mockDatabaseEvent = MockDatabaseEvent();

      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.child('testId'))
          .thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDatabaseEvent);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn(appGroup.toJson());

      final group =
          await appGroupRepository.getGroup(GroupType.positive, 'testId');

      expect(group, isNotNull);
      expect(group?.name, 'testName');
      expect(group?.type, GroupType.positive);
      expect(group?.preventClose, true);

      verify(mockDatabaseReference.child('appGroups')).called(1);
      verify(mockDatabaseReference.child('positive')).called(1);
      verify(mockDatabaseReference.child('testId')).called(1);
      verify(mockDatabaseReference.once()).called(1);
    });

    test('getGroups fetches groups of a specific type', () async {
      final mockDataSnapshot = MockDataSnapshot();
      final mockDatabaseEvent = MockDatabaseEvent();

      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.once())
          .thenAnswer((_) async => mockDatabaseEvent);
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn({
        'group1': appGroup.toJson(),
      });

      final groups = await appGroupRepository.getGroups(GroupType.positive);

      expect(groups, isA<List<AppGroup>>());
      expect(groups.length, 1);
      expect(groups.first.name, 'testName');
      expect(groups.first.type, GroupType.positive);
      expect(groups.first.preventClose, true);

      verify(mockDatabaseReference.child('appGroups')).called(1);
      verify(mockDatabaseReference.child('positive')).called(1);
      verify(mockDatabaseReference.once()).called(1);
    });

    test('streamGroups fetches a stream of groups of a specific type',
        () async {
      final mockDataSnapshot = MockDataSnapshot();
      final mockDatabaseEvent = MockDatabaseEvent();

      when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
      when(mockDatabaseReference.onValue)
          .thenAnswer((_) => Stream.value(mockDatabaseEvent));
      when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
      when(mockDataSnapshot.value).thenReturn({
        'group1': appGroup.toJson(),
      });
      when(mockDatabaseReference.path).thenReturn('testPath');

      final stream = appGroupRepository.streamGroups(GroupType.positive);

      await expectLater(
        stream,
        emits(isA<List<AppGroup>>()
            .having((groups) => groups.length, 'length', 1)),
      );

      verify(mockDatabaseReference.child('appGroups')).called(1);
      verify(mockDatabaseReference.child('positive')).called(1);
      verify(mockDatabaseReference.onValue).called(1);
    });
  });
}
