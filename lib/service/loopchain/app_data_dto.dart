import 'package:reward_raven/db/entity/listed_app.dart';

import '../../db/entity/app_group.dart';

class AppData {
  final String _processId;
  final String _appName;
  DateTime? _timestamp;
  String? _platform;
  ListedApp? _listedApp;
  AppGroup? _appGroup;

  String get processId => _processId;
  String get appName => _appName;

  DateTime? get timestamp => _timestamp;
  set timestamp(DateTime? value) {
    _timestamp = value;
  }

  String? get platform => _platform;
  set platform(String? value) {
    _platform = value;
  }

  ListedApp? get listedApp => _listedApp;
  set listedApp(ListedApp? value) {
    _listedApp = value;
  }

  AppGroup? get appGroup => _appGroup;
  set appGroup(AppGroup? value) {
    _appGroup = value;
  }

  AppData({required String processId, required String appName})
      : _processId = processId,
        _appName = appName;

  @override
  String toString() {
    return 'AppData{processId: $_processId, appName: $_appName, timestamp: $_timestamp, platform: $_platform, listedApp: $_listedApp, appGroup: $_appGroup}';
  }
}
