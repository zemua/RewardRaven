enum DbCollection {
  listedApps,
}

extension DbCollectionExtension on DbCollection {
  String get name {
    switch (this) {
      case DbCollection.listedApps:
        return 'listedApps';
      default:
        return '';
    }
  }
}
