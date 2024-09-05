import '../../main.dart';
import '../../service/platform_wrapper.dart';
import '../entity/listed_app.dart';
import '../repository/listed_app_repository.dart';

class ListedAppService {
  final ListedAppRepository _repository = locator<ListedAppRepository>();
  final PlatformWrapper _platformWrapper = locator<PlatformWrapper>();

  ListedAppService();

  Future<void> addListedApp(ListedApp app) async {
    await _repository.addListedApp(app);
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

  Future<AppStatus> fetchStatus(String identifier) async {
    final listedApp = await _repository.getListedAppById(
        identifier, _platformWrapper.platformName);
    if (listedApp == null) {
      return AppStatus.unknown;
    }
    return listedApp.status;
  }

  Future<void> saveStatus(String identifier, AppStatus status) async {
    final listedApp = await _repository.getListedAppById(
        identifier, _platformWrapper.platformName);
    if (listedApp == null) {
      final newApp = ListedApp(
        identifier: identifier,
        platform: _platformWrapper.platformName,
        status: status,
      );
      await _repository.addListedApp(newApp);
    } else {
      listedApp.status = status;
      await _repository.updateListedApp(listedApp);
    }
  }
}
