import 'app_data_dto.dart';

abstract class AppDataHandler {
  Future<void> handleAppData(AppData data);
  void setNextHandler(AppDataHandler handler);
}
