import 'package:reward_raven/db/entity/listed_app.dart';

import '../../db/entity/app_group.dart';
import '../../db/entity/group_condition.dart';

class AppData {
  final String _processId;
  final String _appName;
  DateTime? _timestamp;
  String? _platform;
  ListedApp? _listedApp;
  AppGroup? _appGroup;
  List<GroupCondition>? _groupConditions;
  int _timeElapsed = 0;
  int _timeCounted = 0;
  bool _conditionsMet = true;
  bool _shallBlock = false;

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

  List<GroupCondition>? get groupConditions => _groupConditions;
  set groupConditions(List<GroupCondition>? value) {
    _groupConditions = value;
  }

  int get timeElapsed => _timeElapsed;
  set timeElapsed(int value) {
    _timeElapsed = value;
  }

  int get timeCounted => _timeCounted;
  set timeCounted(int value) {
    _timeCounted = value;
  }

  bool get conditionsMet => _conditionsMet;
  set conditionsMet(bool value) {
    _conditionsMet = value;
  }

  bool get shallBlock => _shallBlock;
  set shallBlock(bool value) {
    _shallBlock = value;
  }

  AppData({required String processId, required String appName})
      : _processId = processId,
        _appName = appName;

  @override
  String toString() {
    return 'AppData{processId: $_processId, appName: $_appName, timestamp: $_timestamp, platform: $_platform, listedApp: $_listedApp, appGroup: $_appGroup}';
  }
}
