import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:reward_raven/db/entity/group_condition.dart';
import 'package:reward_raven/db/helper/firebase_helper.dart';
import 'package:reward_raven/db/repository/group_condition_repository.dart';
import 'package:reward_raven/main.dart';

import 'app_group_repository_test.mocks.dart';

@GenerateMocks([FirebaseHelper, DatabaseReference, DataSnapshot, DatabaseEvent])
void main() {
  final MockFirebaseHelper mockFirebaseHelper = MockFirebaseHelper();
  locator.registerSingleton<FirebaseHelper>(mockFirebaseHelper);
  late MockDatabaseReference mockDatabaseReference;
  late GroupConditionRepository groupConditionRepository;

  setUp(() {
    mockDatabaseReference = MockDatabaseReference();
    when(mockFirebaseHelper.databaseReference)
        .thenAnswer((_) async => mockDatabaseReference);
    groupConditionRepository = GroupConditionRepository();
  });

  test('saveGroupCondition saves a group condition successfully', () async {
    // Arrange
    const groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());
    when(mockDatabaseReference.path).thenReturn('testPath');

    // Act
    await groupConditionRepository.saveGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testConditionalGroupId')).called(1);
    verify(mockDatabaseReference.set(groupCondition.toJson())).called(1);
  });

  test('updateGroupCondition updates a group condition successfully', () async {
    // Arrange
    const groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

    // Act
    await groupConditionRepository.updateGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testConditionalGroupId')).called(1);
    verify(mockDatabaseReference.update(groupCondition.toJson())).called(1);
  });

  test('deleteGroupCondition deletes a group condition successfully', () async {
    // Arrange
    const groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.remove()).thenAnswer((_) => Future.value());

    // Act
    await groupConditionRepository.deleteGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testConditionalGroupId')).called(1);
    verify(mockDatabaseReference.remove()).called(1);
  });

  test('getGroupConditionByIds retrieves a group condition successfully',
      () async {
    // Arrange
    const groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    final mockDatabaseEvent = MockDatabaseEvent();
    final mockDataSnapshot = MockDataSnapshot();
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
    when(mockDatabaseReference.once())
        .thenAnswer((_) async => Future.value(mockDatabaseEvent));
    when(mockDataSnapshot.value).thenReturn(groupCondition.toJson());
    when(mockDatabaseReference.path).thenReturn('testPath');

    // Act
    final result = await groupConditionRepository.getGroupConditionByIds(
        'testConditionedGroupId', 'testConditionalGroupId');

    // Assert
    expect(result, isNotNull);
    expect(result?.conditionedGroupId, groupCondition.conditionedGroupId);
    expect(result?.conditionalGroupId, groupCondition.conditionalGroupId);
    expect(result?.usedTime, groupCondition.usedTime);
    expect(result?.duringLastDays, groupCondition.duringLastDays);

    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testConditionalGroupId')).called(1);
  });
}
