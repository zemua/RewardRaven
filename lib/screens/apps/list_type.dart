import '../../db/entity/listed_app.dart';

enum ListType { POSITIVE, NEGATIVE }

class ListTypeConfig {
  // TODO extend like DbCollection in collections.dart
  final AppStatus targetApps;
  final List<AppStatus> disabledApps;

  ListTypeConfig({required this.targetApps, required this.disabledApps});
}

var listTypeConfigs = {
  ListType.POSITIVE: ListTypeConfig(
      targetApps: AppStatus.POSITIVE,
      disabledApps: [AppStatus.NEGATIVE, AppStatus.DEPENDS]),
  ListType.NEGATIVE: ListTypeConfig(
      targetApps: AppStatus.NEGATIVE, disabledApps: [AppStatus.POSITIVE])
};

ListTypeConfig? getListTypeConfig(ListType listType) {
  return listTypeConfigs[listType];
}

AppStatus getTargetApp(ListType listType) {
  return getListTypeConfig(listType)!.targetApps;
}

List<AppStatus> getDisabledApp(ListType listType) {
  return getListTypeConfig(listType)!.disabledApps;
}

bool isTargetApp(ListType listType, AppStatus appStatus) {
  return getTargetApp(listType) == appStatus;
}

bool isDisabledApp(ListType listType, AppStatus appStatus) {
  return getDisabledApp(listType).contains(appStatus);
}
