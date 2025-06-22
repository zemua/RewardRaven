import 'package:flutter/services.dart';

abstract class AppBlocker {
  Future<void> blockApp(MethodChannel appNativeChannel, String identifier);
}
