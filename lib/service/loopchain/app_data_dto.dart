class AppData {
  final String _processId;
  final String _appName;
  DateTime? _timestamp;

  String get appId => _processId;
  String get appName => _appName;

  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? value) {
    _timestamp = value;
  }

  AppData({required String processId, required String appName})
      : _processId = processId,
        _appName = appName;

  @override
  String toString() {
    return 'AppData{processId: $_processId, appName: $_appName, timestamp: $_timestamp}';
  }
}
