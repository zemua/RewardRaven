import 'package:reward_raven/db/entity/app_group.dart';

import '../../db/entity/listed_app.dart';

enum AppListType { positive, negative }

extension ListTypeExtension on AppListType {
  AppStatus get targetApps {
    switch (this) {
      case AppListType.positive:
        return AppStatus.positive;
      case AppListType.negative:
        return AppStatus.negative;
    }
  }

  List<AppStatus> get disabledApps {
    switch (this) {
      case AppListType.positive:
        return [AppStatus.negative, AppStatus.depends, AppStatus.neutral];
      case AppListType.negative:
        return [AppStatus.positive, AppStatus.depends, AppStatus.neutral];
    }
  }

  AppStatus get appStatus {
    switch (this) {
      case AppListType.positive:
        return AppStatus.positive;
      case AppListType.negative:
        return AppStatus.negative;
    }
  }

  GroupType get groupType {
    switch (this) {
      case AppListType.positive:
        return GroupType.positive;
      case AppListType.negative:
        return GroupType.negative;
    }
  }
}

AppStatus getTargetApp(AppListType listType) {
  return listType.targetApps;
}

List<AppStatus> getDisabledApp(AppListType listType) {
  return listType.disabledApps;
}

bool isTargetApp(AppListType listType, AppStatus appStatus) {
  return getTargetApp(listType) == appStatus;
}

bool isDisabledApp(AppListType listType, AppStatus appStatus) {
  return getDisabledApp(listType).contains(appStatus);
}
