class ListedApp {
  int? id;
  String identifier;
  String platform;
  String list;

  ListedApp({
    this.id,
    required this.identifier,
    required this.platform,
    required this.list,
  });

  factory ListedApp.fromMap(Map<String, dynamic> map) {
    return ListedApp(
      id: map['id'],
      identifier: map['identifier'],
      platform: map['platform'],
      list: map['list'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'identifier': identifier,
      'platform': platform,
      'list': list,
    };
  }

  static const String tableName = 'listed_apps';
  static const String columnId = 'id';
  static const String columnIdentifier = 'identifier';
  static const String columnPlatform = 'platform';
  static const String columnList = 'list';

  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnIdentifier TEXT NOT NULL,
      $columnPlatform TEXT NOT NULL,
      $columnList TEXT NOT NULL,
      UNIQUE ($columnIdentifier, $columnPlatform)
    );
  ''';
}
