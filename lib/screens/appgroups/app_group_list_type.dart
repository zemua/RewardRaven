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
}
