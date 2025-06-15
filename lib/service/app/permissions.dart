abstract class Permissions {
  Future<bool> hasOverlayPermission();
  Future<void> requestOverlayPermission();
}
