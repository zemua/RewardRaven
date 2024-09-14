// Mocks generated by Mockito 5.4.4 from annotations
// in reward_raven/test/db/service/listed_app_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:logger/logger.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i4;
import 'package:reward_raven/db/entity/listed_app.dart' as _i7;
import 'package:reward_raven/db/repository/listed_app_repository.dart' as _i5;
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

class _FakeLogger_0 extends _i1.SmartFake implements _i2.Logger {
  _FakeLogger_0(
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
  MockPlatformWrapper() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get platformName => (super.noSuchMethod(
        Invocation.getter(#platformName),
        returnValue: _i4.dummyValue<String>(
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
      ) as bool);
}

/// A class which mocks [ListedAppRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockListedAppRepository extends _i1.Mock
    implements _i5.ListedAppRepository {
  MockListedAppRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.Logger get logger => (super.noSuchMethod(
        Invocation.getter(#logger),
        returnValue: _FakeLogger_0(
          this,
          Invocation.getter(#logger),
        ),
      ) as _i2.Logger);

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
  _i6.Future<_i7.ListedApp?> getListedAppById(
    String? identifier,
    String? platform,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getListedAppById,
          [
            identifier,
            platform,
          ],
        ),
        returnValue: _i6.Future<_i7.ListedApp?>.value(),
      ) as _i6.Future<_i7.ListedApp?>);
}
