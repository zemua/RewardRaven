import 'app_data_dto.dart';

abstract class AppDataHandler {
  void handleAppData(AppData data);
  void setNextHandler(AppDataHandler handler);
}
