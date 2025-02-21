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
    final groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.push()).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.set(any)).thenAnswer((_) => Future.value());
    when(mockDatabaseReference.path).thenReturn('testPath');

    // Act
    await groupConditionRepository.saveGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verifyNever(mockDatabaseReference.child('testConditionalGroupId'));
    verify(mockDatabaseReference.push()).called(1);
    verify(mockDatabaseReference.set(groupCondition.toJson())).called(1);
  });

  test('updateGroupCondition updates a group condition successfully', () async {
    // Arrange
    final groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
      id: 'testId',
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.update(any)).thenAnswer((_) => Future.value());

    // Act
    await groupConditionRepository.updateGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testId')).called(1);
    verifyNever(mockDatabaseReference.child('testConditionalGroupId'));
    verifyNever(mockDatabaseReference.push());
    verify(mockDatabaseReference.update(groupCondition.toJson())).called(1);
  });

  test('deleteGroupCondition deletes a group condition successfully', () async {
    // Arrange
    final groupCondition = GroupCondition(
      conditionedGroupId: 'testConditionedGroupId',
      conditionalGroupId: 'testConditionalGroupId',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
      id: 'testId',
    );
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.remove()).thenAnswer((_) => Future.value());

    // Act
    await groupConditionRepository.deleteGroupCondition(groupCondition);

    // Assert
    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verifyNever(mockDatabaseReference.child('testConditionalGroupId'));
    verify(mockDatabaseReference.child('testId')).called(1);
    verify(mockDatabaseReference.remove()).called(1);
  });

  test('getGroupConditionByIds retrieves a group condition successfully',
      () async {
    // Arrange
    final groupCondition = GroupCondition(
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
    when(mockDataSnapshot.key).thenReturn('testId');
    when(mockDatabaseReference.path).thenReturn('testPath');

    // Act
    final result = await groupConditionRepository.getGroupConditionByIds(
        conditionedGroupId: 'testConditionedGroupId', conditionId: 'testId');

    // Assert
    expect(result, isNotNull);
    expect(result?.conditionedGroupId, groupCondition.conditionedGroupId);
    expect(result?.conditionalGroupId, groupCondition.conditionalGroupId);
    expect(result?.usedTime, groupCondition.usedTime);
    expect(result?.duringLastDays, groupCondition.duringLastDays);

    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child('testConditionedGroupId')).called(1);
    verify(mockDatabaseReference.child('testId')).called(1);
    verifyNever(mockDatabaseReference.child('testConditionalGroupId'));
  });

  test(
      'getAllGroupConditionsByConditionedGroupId retrieves all group conditions successfully',
      () async {
    // Arrange
    const conditionedGroupId = 'testConditionedGroupId';
    final groupCondition1 = GroupCondition(
      conditionedGroupId: conditionedGroupId,
      conditionalGroupId: 'testConditionalGroupId1',
      usedTime: Duration(hours: 1),
      duringLastDays: 7,
    );
    final groupCondition2 = GroupCondition(
      conditionedGroupId: conditionedGroupId,
      conditionalGroupId: 'testConditionalGroupId2',
      usedTime: Duration(hours: 2),
      duringLastDays: 8,
    );
    final conditionsMap = {
      groupCondition1.conditionalGroupId: groupCondition1.toJson(),
      groupCondition2.conditionalGroupId: groupCondition2.toJson(),
    };

    final mockDatabaseEvent = MockDatabaseEvent();
    final mockDataSnapshot = MockDataSnapshot();
    when(mockDatabaseReference.child(any)).thenReturn(mockDatabaseReference);
    when(mockDatabaseReference.child(conditionedGroupId))
        .thenReturn(mockDatabaseReference);
    when(mockDatabaseEvent.snapshot).thenReturn(mockDataSnapshot);
    when(mockDatabaseReference.once())
        .thenAnswer((_) async => Future.value(mockDatabaseEvent));
    when(mockDataSnapshot.value).thenReturn(conditionsMap);
    when(mockDatabaseReference.path).thenReturn('testPath');

    // Act
    final result =
        await groupConditionRepository.getGroupConditions(conditionedGroupId);

    // Assert
    expect(result, isNotNull);
    expect(result.length, 2);
    expect(result[0].conditionedGroupId, groupCondition1.conditionedGroupId);
    expect(result[0].conditionalGroupId, groupCondition1.conditionalGroupId);
    expect(result[0].usedTime, groupCondition1.usedTime);
    expect(result[0].duringLastDays, groupCondition1.duringLastDays);
    expect(result[1].conditionedGroupId, groupCondition2.conditionedGroupId);
    expect(result[1].conditionalGroupId, groupCondition2.conditionalGroupId);
    expect(result[1].usedTime, groupCondition2.usedTime);
    expect(result[1].duringLastDays, groupCondition2.duringLastDays);

    verify(mockDatabaseReference.child('groupConditions')).called(1);
    verify(mockDatabaseReference.child(conditionedGroupId)).called(1);
    verifyNever(
        mockDatabaseReference.child(groupCondition1.conditionalGroupId));
    verifyNever(
        mockDatabaseReference.child(groupCondition2.conditionalGroupId));
  });

  test('streamGroupConditions retrieves group conditions successfully',
      () async {
    fail("not yet implemented");
  });
}
