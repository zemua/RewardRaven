class AppData {
  final String appId;
  final String appName;
  final DateTime timestamp;

  AppData({
    required this.appId,
    required this.appName,
    required this.timestamp,
  });

  factory AppData.fromMap(Map<String, dynamic> map) => AppData(
        appId: map['appId'],
        appName: map['appName'],
        timestamp: DateTime.parse(map['timestamp']),
      );

  Map<String, dynamic> toMap() => {
        'appId': appId,
        'appName': appName,
        'timestamp': timestamp.toIso8601String(),
      };
}
