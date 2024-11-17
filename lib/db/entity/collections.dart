enum DbCollection { listedApps, appGroups, groupConditions }

extension DbCollectionExtension on DbCollection {
  String get name {
    switch (this) {
      case DbCollection.listedApps:
        return 'listedApps';
      case DbCollection.appGroups:
        return 'appGroups';
      case DbCollection.groupConditions:
        return 'groupConditions';
      default:
        return '';
    }
  }
}
