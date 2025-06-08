import 'package:reward_raven/db/entity/listed_app.dart';

import '../../db/entity/app_group.dart';
import '../../db/entity/group_condition.dart';

// TODO make configurable
const int negativeProportion = 4;

const String sleepIcon = 'devs.mrp.SLEEP_ICON';
const String fireIcon = 'devs.mrp.FIRE_ICON';
const String neutralIcon = 'devs.mrp.NEUTRAL_ICON';
const String snowIcon = 'devs.mrp.SNOW_ICON';

class AppData {
  final String _processId;
  final String _appName;
  DateTime? _timestamp;
  String? _platform;
  ListedApp? _listedApp;
  AppGroup? _appGroup;
  List<GroupCondition>? _groupConditions;
  bool _conditionsMet = true;
  Duration _timeElapsed = Duration.zero;
  Duration _timeCounted = Duration.zero;
  Duration _remainingTime = Duration.zero;

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

  bool get conditionsMet => _conditionsMet;
  set conditionsMet(bool value) {
    _conditionsMet = value;
  }

  Duration get timeElapsed => _timeElapsed;
  set timeElapsed(Duration value) {
    _timeElapsed = value;
  }

  Duration get timeCounted => _timeCounted;
  set timeCounted(Duration value) {
    _timeCounted = value;
  }

  Duration get remainingTime => _remainingTime;
  set remainingTime(Duration value) {
    _remainingTime = value;
  }

  AppData({required String processId, required String appName})
      : _processId = processId,
        _appName = appName;

  @override
  String toString() {
    return 'AppData{processId: $_processId, appName: $_appName, timestamp: $_timestamp, platform: $_platform, listedApp: $_listedApp, appGroup: $_appGroup, groupConditions: $_groupConditions, conditionsMet: $_conditionsMet, timeElapsed: $_timeElapsed, timeCounted: $_timeCounted, remainingTime: $_remainingTime}';
  }
}
