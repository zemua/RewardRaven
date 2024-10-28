// Mocks generated by Mockito 5.4.4 from annotations
// in reward_raven/test/screens/apps/app_list_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:installed_apps/app_info.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:reward_raven/db/entity/listed_app.dart' as _i6;
import 'package:reward_raven/db/service/listed_app_service.dart' as _i5;
import 'package:reward_raven/screens/apps/app_list_type.dart' as _i7;
import 'package:reward_raven/service/app/apps_fetcher.dart' as _i2;

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

/// A class which mocks [AppsFetcher].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppsFetcher extends _i1.Mock implements _i2.AppsFetcher {
  MockAppsFetcher() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<List<_i4.AppInfo>> fetchInstalledApps() => (super.noSuchMethod(
        Invocation.method(
          #fetchInstalledApps,
          [],
        ),
        returnValue: _i3.Future<List<_i4.AppInfo>>.value(<_i4.AppInfo>[]),
      ) as _i3.Future<List<_i4.AppInfo>>);
}

/// A class which mocks [ListedAppService].
///
/// See the documentation for Mockito's code generation for more information.
class MockListedAppService extends _i1.Mock implements _i5.ListedAppService {
  MockListedAppService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> saveListedApp(_i6.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #saveListedApp,
          [app],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> updateListedApp(_i6.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #updateListedApp,
          [app],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> deleteListedApp(_i6.ListedApp? app) => (super.noSuchMethod(
        Invocation.method(
          #deleteListedApp,
          [app],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<_i6.ListedApp?> getListedAppById(String? identifier) =>
      (super.noSuchMethod(
        Invocation.method(
          #getListedAppById,
          [identifier],
        ),
        returnValue: _i3.Future<_i6.ListedApp?>.value(),
      ) as _i3.Future<_i6.ListedApp?>);

  @override
  _i3.Future<List<_i6.ListedApp>> fetchListedAppsByType(
          _i7.AppListType? listType) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchListedAppsByType,
          [listType],
        ),
        returnValue: _i3.Future<List<_i6.ListedApp>>.value(<_i6.ListedApp>[]),
      ) as _i3.Future<List<_i6.ListedApp>>);

  @override
  _i3.Future<_i6.AppStatus> fetchStatus(String? identifier) =>
      (super.noSuchMethod(
        Invocation.method(
          #fetchStatus,
          [identifier],
        ),
        returnValue: _i3.Future<_i6.AppStatus>.value(_i6.AppStatus.positive),
      ) as _i3.Future<_i6.AppStatus>);
}
