import 'package:flutter/services.dart';
import 'package:reward_raven/db/entity/listed_app.dart';
import 'package:reward_raven/service/foreground/localized_strings.dart';

import '../../db/entity/app_group.dart';
import '../../db/entity/group_condition.dart';

// TODO make configurable
const int negativeProportion = 4;

const String sleepIcon = 'devs.mrp.SLEEP_ICON';
const String fireIcon = 'devs.mrp.FIRE_ICON';
const String neutralIcon = 'devs.mrp.NEUTRAL_ICON';
const String snowIcon = 'devs.mrp.SNOW_ICON';

class AppData {
  final MethodChannel appNativeChannel;
  LocalizedStrings localizedStrings;
  String? processId;
  String? appName;
  DateTime? timestamp;
  String? platform;
  ListedApp? listedApp;
  AppGroup? appGroup;
  List<GroupCondition>? groupConditions;
  bool conditionsMet = true;
  Duration timeElapsed = Duration.zero;
  Duration timeCounted = Duration.zero;
  Duration remainingTime = Duration.zero;

  bool hasBeenBlocked = false;
  List<String> blockingMessages = [];

  AppData({
    required this.appNativeChannel,
    required this.localizedStrings,
  });

  @override
  String toString() {
    return 'AppData{processId: $processId, appName: $appName, timestamp: $timestamp, platform: $platform, listedApp: $listedApp, appGroup: $appGroup, groupConditions: $groupConditions, conditionsMet: $conditionsMet, timeElapsed: $timeElapsed, timeCounted: $timeCounted, remainingTime: $remainingTime}';
  }
}
