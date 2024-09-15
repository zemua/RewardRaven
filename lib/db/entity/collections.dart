enum DbCollection { listedApps, appGroups }

extension DbCollectionExtension on DbCollection {
  String get name {
    switch (this) {
      case DbCollection.listedApps:
        return 'listedApps';
      case DbCollection.appGroups:
        return 'appGroups';
      default:
        return '';
    }
  }
}
