import '../../main.dart';
import '../../screens/apps/app_list_type.dart';
import '../../service/platform_wrapper.dart';
import '../entity/listed_app.dart';
import '../repository/listed_app_repository.dart';

class ListedAppService {
  final ListedAppRepository _repository = locator<ListedAppRepository>();
  final PlatformWrapper _platformWrapper = locator<PlatformWrapper>();

  ListedAppService();

  Future<void> saveListedApp(ListedApp app) async {
    await _repository.saveListedApp(app);
  }

  Future<void> updateListedApp(ListedApp app) async {
    await _repository.updateListedApp(app);
  }

  Future<void> deleteListedApp(ListedApp app) async {
    await _repository.deleteListedApp(app);
  }

  Future<ListedApp?> getListedAppById(String identifier) async {
    return await _repository.getListedAppById(
        identifier, _platformWrapper.platformName);
  }

  Future<List<ListedApp>> fetchListedAppsByType(AppListType listType) async {
    return await _repository.getListedAppsByStatus(
        listType.appStatus, _platformWrapper.platformName);
  }

  Future<AppStatus> fetchStatus(String identifier) async {
    final listedApp = await _repository.getListedAppById(
        identifier, _platformWrapper.platformName);
    if (listedApp == null) {
      return AppStatus.unknown;
    }
    return listedApp.status;
  }
}
