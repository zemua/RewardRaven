import 'dart:io' show Platform;

import '../platform_wrapper.dart';

class PlatformWrapperImpl implements PlatformWrapper {
  @override
  bool isAndroid() {
    return Platform.isAndroid;
  }
}
