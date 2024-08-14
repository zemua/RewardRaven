import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

import '../platform_wrapper.dart';

class PlatformWrapperImpl implements PlatformWrapper {
  @override
  bool isAndroid() {
    return !kIsWeb && Platform.isAndroid;
  }
}
