import 'package:reward_raven/screens/apps/app_list_type.dart';

import '../../db/entity/app_group.dart';

enum AppGroupListType { positive, negative }

extension AppGroupListTypeExtension on AppGroupListType {
  GroupType toGroupType() {
    switch (this) {
      case AppGroupListType.positive:
        return GroupType.positive;
      case AppGroupListType.negative:
        return GroupType.negative;
    }
  }

  AppListType toAppListType() {
    switch (this) {
      case AppGroupListType.positive:
        return AppListType.positive;
      case AppGroupListType.negative:
        return AppListType.negative;
    }
  }
}
