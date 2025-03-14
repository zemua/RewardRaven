import 'package:flutter_test/flutter_test.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/screens/apps/app_list_type.dart';

void main() {
  group('ListTypeConfig', () {
    test('should create a new ListTypeConfig object', () {
      const config = AppListType.positive;
      expect(config.targetApps, AppStatus.positive);
      expect(config.disabledApps,
          [AppStatus.negative, AppStatus.depends, AppStatus.neutral]);
    });
  });

  group('getTargetApp', () {
    test('should return AppStatus.POSITIVE for ListType.POSITIVE', () {
      final status = getTargetApp(AppListType.positive);
      expect(status, AppStatus.positive);
    });

    test('should return AppStatus.NEGATIVE for ListType.NEGATIVE', () {
      final status = getTargetApp(AppListType.negative);
      expect(status, AppStatus.negative);
    });

    test(
        'should return true for isTargetApp(ListType.POSITIVE, AppStatus.POSITIVE)',
        () {
      final isTarget = isTargetApp(AppListType.positive, AppStatus.positive);
      expect(isTarget, isTrue);
    });

    test(
        'should return false for isTargetApp(ListType.POSITIVE, AppStatus.NEGATIVE)',
        () {
      final isTarget = isTargetApp(AppListType.positive, AppStatus.negative);
      expect(isTarget, isFalse);
    });
  });

  group('getDisabledApp', () {
    test('should return the disabled apps for a given ListType', () {
      final apps = getDisabledApp(AppListType.positive);
      expect(apps, isNotNull);
    });

    test(
        'should return true for isDisabledApp(ListType.POSITIVE, AppStatus.NEGATIVE)',
        () {
      final isDisabled =
          isDisabledApp(AppListType.positive, AppStatus.negative);
      expect(isDisabled, isTrue);
    });

    test(
        'should return false for isDisabledApp(ListType.POSITIVE, AppStatus.POSITIVE)',
        () {
      final isDisabled =
          isDisabledApp(AppListType.positive, AppStatus.positive);
      expect(isDisabled, isFalse);
    });
  });
}
