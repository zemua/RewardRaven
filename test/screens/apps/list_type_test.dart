import 'package:flutter_test/flutter_test.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/screens/apps/list_type.dart';

void main() {
  group('ListTypeConfig', () {
    test('should create a new ListTypeConfig object', () {
      final config = ListTypeConfig(
        targetApps: AppStatus.POSITIVE,
        disabledApps: [AppStatus.NEGATIVE],
      );
      expect(config.targetApps, AppStatus.POSITIVE);
      expect(config.disabledApps, [AppStatus.NEGATIVE]);
    });
  });

  group('getListTypeConfig', () {
    test('should return the ListTypeConfig for a given ListType', () {
      final config = getListTypeConfig(ListType.POSITIVE);
      expect(config, isNotNull);
    });
  });

  group('getTargetApp', () {
    test('should return AppStatus.POSITIVE for ListType.POSITIVE', () {
      final status = getTargetApp(ListType.POSITIVE);
      expect(status, AppStatus.POSITIVE);
    });

    test('should return AppStatus.NEGATIVE for ListType.NEGATIVE', () {
      final status = getTargetApp(ListType.NEGATIVE);
      expect(status, AppStatus.NEGATIVE);
    });

    test(
        'should return true for isTargetApp(ListType.POSITIVE, AppStatus.POSITIVE)',
        () {
      final isTarget = isTargetApp(ListType.POSITIVE, AppStatus.POSITIVE);
      expect(isTarget, isTrue);
    });

    test(
        'should return false for isTargetApp(ListType.POSITIVE, AppStatus.NEGATIVE)',
        () {
      final isTarget = isTargetApp(ListType.POSITIVE, AppStatus.NEGATIVE);
      expect(isTarget, isFalse);
    });
  });

  group('getDisabledApp', () {
    test('should return the disabled apps for a given ListType', () {
      final apps = getDisabledApp(ListType.POSITIVE);
      expect(apps, isNotNull);
    });

    test(
        'should return true for isDisabledApp(ListType.POSITIVE, AppStatus.NEGATIVE)',
        () {
      final isDisabled = isDisabledApp(ListType.POSITIVE, AppStatus.NEGATIVE);
      expect(isDisabled, isTrue);
    });

    test(
        'should return false for isDisabledApp(ListType.POSITIVE, AppStatus.POSITIVE)',
        () {
      final isDisabled = isDisabledApp(ListType.POSITIVE, AppStatus.POSITIVE);
      expect(isDisabled, isFalse);
    });
  });
}
