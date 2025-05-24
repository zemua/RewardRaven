class AppDataHandler {
  AppDataHandler? entryHandler;

  AppDataHandler() {}

  void setNextHandler(AppDataHandler handler) {
    throw UnsupportedError("Next handler in chain master is not supported.");
  }

  void handleAppData() {
    if (entryHandler != null) {
      entryHandler!.handleAppData();
    }
  }
}
