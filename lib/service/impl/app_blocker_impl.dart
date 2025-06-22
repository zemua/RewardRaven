import 'package:flutter/services.dart';

import '../app_blocker.dart';

class AppBlockerImpl implements AppBlocker {
  @override
  Future<void> blockApp(
      MethodChannel appNativeChannel, String identifier) async {
    appNativeChannel.invokeMethod("blockingAction");
  }
}
