abstract class Permissions {
  Future<bool> hasOverlayPermission();
  Future<void> requestOverlayPermission();
  Future<bool> hasNotificationPermission();
  Future<void> requestNotificationPermission();
}
