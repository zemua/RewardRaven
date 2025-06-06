// Mocks generated by Mockito 5.4.4 from annotations
// in reward_raven/test/service/loopchain/app_data_handler_chain_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:reward_raven/db/entity/app_group.dart' as _i10;
import 'package:reward_raven/db/entity/group_condition.dart' as _i12;
import 'package:reward_raven/db/entity/listed_app.dart' as _i7;
import 'package:reward_raven/db/entity/time_log.dart' as _i2;
import 'package:reward_raven/db/service/app_group_service.dart' as _i9;
import 'package:reward_raven/db/service/group_condition_service.dart' as _i11;
import 'package:reward_raven/db/service/listed_app_service.dart' as _i5;
import 'package:reward_raven/db/service/time_log_service.dart' as _i14;
import 'package:reward_raven/screens/apps/app_list_type.dart' as _i8;
import 'package:reward_raven/service/app_blocker.dart' as _i15;
import 'package:reward_raven/service/condition_checker.dart' as _i13;
import 'package:reward_raven/service/platform_wrapper.dart' as _i3;

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

class _FakeTimeLog_0 extends _i1.SmartFake implements _i2.TimeLog {
  _FakeTimeLog_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [PlatformWrapper].
///
/// See the documentation for Mockito's code generation for more information.
class MockPlatformWrapper extends _i1.Mock implements _i3.PlatformWrapper {
  @override
  String get platformName => (super.noSuchMethod(
        Invocation.getter(#platformName),
        returnValue: _i4.dummyValue<String>(
          this,
          Invocation.getter(#platformName),
        ),
        returnValueForMissingStub: _i4.dummyValue<String>(
          this,
          Invocation.getter(#platformName),
        ),
      ) as String);

  @override
  bool isAndroid() => (super.noSuchMethod(
        Invocation.method(
          #isAndroid,
          [],
        ),
        returnValue: false,
        returnValueForMissingStub: false,
      ) as bool);
}

/// A class which mocks [ListedAppService].
///
/// See the documentation for Mockito's code generation for more information.
class MockListedAppService extends _i1.Mock implements _i5.ListedAppService {
  @override
  _i6.Future<void> saveListedApp(_i7.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #saveListedApp,
          [app],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> updateListedApp(_i7.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #updateListedApp,
          [app],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteListedApp(_i7.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #deleteListedApp,
          [app],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i7.ListedApp?> getListedAppById(String? identifier) =>
      (super.noSuchMethod(
        Invocation.method(
          #getListedAppById,
          [identifier],
        ),
        returnValue: _i6.Future<_i7.ListedApp?>.value(),
        returnValueForMissingStub: _i6.Future<_i7.ListedApp?>.value(),
      ) as _i6.Future<_i7.ListedApp?>);

  @override
  _i6.Future<List<_i7.ListedApp>> fetchListedAppsByType(
          _i8.AppListType? listType) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchListedAppsByType,
          [listType],
        ),
        returnValue: _i6.Future<List<_i7.ListedApp>>.value(<_i7.ListedApp>[]),
        returnValueForMissingStub:
            _i6.Future<List<_i7.ListedApp>>.value(<_i7.ListedApp>[]),
      ) as _i6.Future<List<_i7.ListedApp>>);

  @override
  _i6.Future<_i7.AppStatus> fetchStatus(String? identifier) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchStatus,
          [identifier],
        ),
        returnValue: _i6.Future<_i7.AppStatus>.value(_i7.AppStatus.positive),
        returnValueForMissingStub:
            _i6.Future<_i7.AppStatus>.value(_i7.AppStatus.positive),
      ) as _i6.Future<_i7.AppStatus>);
}

/// A class which mocks [AppGroupService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppGroupService extends _i1.Mock implements _i9.AppGroupService {
  @override
  _i6.Future<void> saveGroup(_i10.AppGroup? group) => (super.noSuchMethod(
        Invocation.method(
          #saveGroup,
          [group],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> updateGroup(
    String? key,
    _i10.AppGroup? group,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroup,
          [
            key,
            group,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i10.AppGroup?> getGroup(
    _i10.GroupType? type,
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
        returnValue: _i6.Future<_i10.AppGroup?>.value(),
        returnValueForMissingStub: _i6.Future<_i10.AppGroup?>.value(),
      ) as _i6.Future<_i10.AppGroup?>);

  @override
  _i6.Future<List<_i10.AppGroup>> getGroups(_i10.GroupType? type) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroups,
          [type],
        ),
        returnValue: _i6.Future<List<_i10.AppGroup>>.value(<_i10.AppGroup>[]),
        returnValueForMissingStub:
            _i6.Future<List<_i10.AppGroup>>.value(<_i10.AppGroup>[]),
      ) as _i6.Future<List<_i10.AppGroup>>);

  @override
  _i6.Stream<List<_i10.AppGroup>> streamGroups(_i10.GroupType? type) =>
      (super.noSuchMethod(
        Invocation.method(
          #streamGroups,
          [type],
        ),
        returnValue: _i6.Stream<List<_i10.AppGroup>>.empty(),
        returnValueForMissingStub: _i6.Stream<List<_i10.AppGroup>>.empty(),
      ) as _i6.Stream<List<_i10.AppGroup>>);
}

/// A class which mocks [GroupConditionService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGroupConditionService extends _i1.Mock
    implements _i11.GroupConditionService {
  @override
  _i6.Future<_i12.GroupCondition?> getGroupCondition({
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
        returnValue: _i6.Future<_i12.GroupCondition?>.value(),
        returnValueForMissingStub: _i6.Future<_i12.GroupCondition?>.value(),
      ) as _i6.Future<_i12.GroupCondition?>);

  @override
  _i6.Future<List<_i12.GroupCondition>> getGroupConditions(
          String? conditionedGroupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupConditions,
          [conditionedGroupId],
        ),
        returnValue: _i6.Future<List<_i12.GroupCondition>>.value(
            <_i12.GroupCondition>[]),
        returnValueForMissingStub: _i6.Future<List<_i12.GroupCondition>>.value(
            <_i12.GroupCondition>[]),
      ) as _i6.Future<List<_i12.GroupCondition>>);

  @override
  _i6.Stream<List<_i12.GroupCondition>> streamGroupConditions(
          String? conditionedGroupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #streamGroupConditions,
          [conditionedGroupId],
        ),
        returnValue: _i6.Stream<List<_i12.GroupCondition>>.empty(),
        returnValueForMissingStub:
            _i6.Stream<List<_i12.GroupCondition>>.empty(),
      ) as _i6.Stream<List<_i12.GroupCondition>>);

  @override
  _i6.Future<void> saveGroupCondition(_i12.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveGroupCondition,
          [groupCondition],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> updateGroupCondition(_i12.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroupCondition,
          [groupCondition],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> deleteGroupCondition(_i12.GroupCondition? groupCondition) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteGroupCondition,
          [groupCondition],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [ConditionChecker].
///
/// See the documentation for Mockito's code generation for more information.
class MockConditionChecker extends _i1.Mock implements _i13.ConditionChecker {
  @override
  _i6.Future<bool> isConditionMet(_i12.GroupCondition? condition) =>
      (super.noSuchMethod(
        Invocation.method(
          #isConditionMet,
          [condition],
        ),
        returnValue: _i6.Future<bool>.value(false),
        returnValueForMissingStub: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);
}

/// A class which mocks [TimeLogService].
///
/// See the documentation for Mockito's code generation for more information.
class MockTimeLogService extends _i1.Mock implements _i14.TimeLogService {
  @override
  _i6.Future<void> addToTotal(_i2.TimeLog? timelog) => (super.noSuchMethod(
        Invocation.method(
          #addToTotal,
          [timelog],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i2.TimeLog> getTotalDuration() => (super.noSuchMethod(
        Invocation.method(
          #getTotalDuration,
          [],
        ),
        returnValue: _i6.Future<_i2.TimeLog>.value(_FakeTimeLog_0(
          this,
          Invocation.method(
            #getTotalDuration,
            [],
          ),
        )),
        returnValueForMissingStub: _i6.Future<_i2.TimeLog>.value(_FakeTimeLog_0(
          this,
          Invocation.method(
            #getTotalDuration,
            [],
          ),
        )),
      ) as _i6.Future<_i2.TimeLog>);

  @override
  _i6.Future<void> addToGroup(
    _i2.TimeLog? timelog,
    String? groupId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addToGroup,
          [
            timelog,
            groupId,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i2.TimeLog> getGroupDurationForLastDays(
    String? groupId,
    int? lastDays,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupDurationForLastDays,
          [
            groupId,
            lastDays,
          ],
        ),
        returnValue: _i6.Future<_i2.TimeLog>.value(_FakeTimeLog_0(
          this,
          Invocation.method(
            #getGroupDurationForLastDays,
            [
              groupId,
              lastDays,
            ],
          ),
        )),
        returnValueForMissingStub: _i6.Future<_i2.TimeLog>.value(_FakeTimeLog_0(
          this,
          Invocation.method(
            #getGroupDurationForLastDays,
            [
              groupId,
              lastDays,
            ],
          ),
        )),
      ) as _i6.Future<_i2.TimeLog>);
}

/// A class which mocks [AppBlocker].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppBlocker extends _i1.Mock implements _i15.AppBlocker {
  @override
  _i6.Future<void> blockApp(String? identifier) => (super.noSuchMethod(
        Invocation.method(
          #blockApp,
          [identifier],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}
