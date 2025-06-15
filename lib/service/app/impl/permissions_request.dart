import 'package:get_it/get_it.dart';

import '../app_native.dart';
import '../permissions.dart';

const String _hasOverlayPermissionFunction = "getOverlayPermission";
const String _requestOverlayPermissionFunction = "requestOverlayPermission";
const String _hasNotificationPermissionFunction = "getNotificationPermission";
const String _requestNotificationPermissionFunction =
    "requestNotificationPermission";

final GetIt locator = GetIt.instance;

class PermissionsRequest implements Permissions {
  @override
  Future<bool> hasOverlayPermission() async {
    return await appNativeChannel
            .invokeMethod<bool>(_hasOverlayPermissionFunction) ??
        true;
  }

  @override
  Future<void> requestOverlayPermission() async {
    await appNativeChannel.invokeMethod(_requestOverlayPermissionFunction);
  }

  @override
  Future<bool> hasNotificationPermission() async {
    return await appNativeChannel
            .invokeMethod<bool>(_hasNotificationPermissionFunction) ??
        true;
  }

  @override
  Future<void> requestNotificationPermission() async {
    await appNativeChannel.invokeMethod(_requestNotificationPermissionFunction);
  }
}
