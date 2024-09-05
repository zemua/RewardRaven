import '../../db/entity/listed_app.dart';

enum ListType { positive, negative }

extension ListTypeExtension on ListType {
  AppStatus get targetApps {
    switch (this) {
      case ListType.positive:
        return AppStatus.positive;
      case ListType.negative:
        return AppStatus.negative;
    }
  }

  List<AppStatus> get disabledApps {
    switch (this) {
      case ListType.positive:
        return [AppStatus.negative, AppStatus.depends, AppStatus.neutral];
      case ListType.negative:
        return [AppStatus.positive, AppStatus.depends, AppStatus.neutral];
    }
  }
}

AppStatus getTargetApp(ListType listType) {
  return listType.targetApps;
}

List<AppStatus> getDisabledApp(ListType listType) {
  return listType.disabledApps;
}

bool isTargetApp(ListType listType, AppStatus appStatus) {
  return getTargetApp(listType) == appStatus;
}

bool isDisabledApp(ListType listType, AppStatus appStatus) {
  return getDisabledApp(listType).contains(appStatus);
}
