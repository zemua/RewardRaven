// Mocks generated by Mockito 5.4.4 from annotations
// in reward_raven/test/service/impl/condition_checker_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:reward_raven/db/entity/app_group.dart' as _i6;
import 'package:reward_raven/db/entity/group_condition.dart' as _i4;
import 'package:reward_raven/db/service/app_group_service.dart' as _i5;
import 'package:reward_raven/db/service/group_condition_service.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [GroupConditionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGroupConditionService extends _i1.Mock
    implements _i2.GroupConditionService {
  @override
  _i3.Future<_i4.GroupCondition?> getGroupCondition({
    required String? conditionedGroupId,
    required String? conditionId,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupCondition,
          [],
          {
            #conditionedGroupId: conditionedGroupId,
            #conditionId: conditionId,
          },
        ),
        returnValue: _i3.Future<_i4.GroupCondition?>.value(),
        returnValueForMissingStub: _i3.Future<_i4.GroupCondition?>.value(),
      ) as _i3.Future<_i4.GroupCondition?>);

  @override
  _i3.Future<List<_i4.GroupCondition>> getGroupConditions(
          String? conditionedGroupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupConditions,
          [conditionedGroupId],
        ),
        returnValue:
            _i3.Future<List<_i4.GroupCondition>>.value(<_i4.GroupCondition>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i4.GroupCondition>>.value(<_i4.GroupCondition>[]),
      ) as _i3.Future<List<_i4.GroupCondition>>);

  @override
  _i3.Stream<List<_i4.GroupCondition>> streamGroupConditions(
          String? conditionedGroupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #streamGroupConditions,
          [conditionedGroupId],
        ),
        returnValue: _i3.Stream<List<_i4.GroupCondition>>.empty(),
        returnValueForMissingStub: _i3.Stream<List<_i4.GroupCondition>>.empty(),
      ) as _i3.Stream<List<_i4.GroupCondition>>);

  @override
  _i3.Future<void> saveGroupCondition(_i4.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveGroupCondition,
          [groupCondition],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> updateGroupCondition(_i4.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroupCondition,
          [groupCondition],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteGroupCondition(_i4.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteGroupCondition,
          [groupCondition],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [AppGroupService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppGroupService extends _i1.Mock implements _i5.AppGroupService {
  @override
  _i3.Future<void> saveGroup(_i6.AppGroup? group) => (super.noSuchMethod(
        Invocation.method(
          #saveGroup,
          [group],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> updateGroup(
    String? key,
    _i6.AppGroup? group,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroup,
          [
            key,
            group,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<_i6.AppGroup?> getGroup(
    _i6.GroupType? type,
    String? key,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroup,
          [
            type,
            key,
          ],
        ),
        returnValue: _i3.Future<_i6.AppGroup?>.value(),
        returnValueForMissingStub: _i3.Future<_i6.AppGroup?>.value(),
      ) as _i3.Future<_i6.AppGroup?>);

  @override
  _i3.Future<List<_i6.AppGroup>> getGroups(_i6.GroupType? type) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroups,
          [type],
        ),
        returnValue: _i3.Future<List<_i6.AppGroup>>.value(<_i6.AppGroup>[]),
        returnValueForMissingStub:
            _i3.Future<List<_i6.AppGroup>>.value(<_i6.AppGroup>[]),
      ) as _i3.Future<List<_i6.AppGroup>>);

  @override
  _i3.Stream<List<_i6.AppGroup>> streamGroups(_i6.GroupType? type) =>
      (super.noSuchMethod(
        Invocation.method(
          #streamGroups,
          [type],
        ),
        returnValue: _i3.Stream<List<_i6.AppGroup>>.empty(),
        returnValueForMissingStub: _i3.Stream<List<_i6.AppGroup>>.empty(),
      ) as _i3.Stream<List<_i6.AppGroup>>);
}
