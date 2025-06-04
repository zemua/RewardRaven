enum DbCollection { listedApps, appGroups, groupConditions, logs }

extension DbCollectionExtension on DbCollection {
  String get name {
    switch (this) {
      case DbCollection.listedApps:
        return 'listedApps';
      case DbCollection.appGroups:
        return 'appGroups';
      case DbCollection.groupConditions:
        return 'groupConditions';
      case DbCollection.logs:
        return 'timeLogs';
      default:
        return '';
    }
  }
}
