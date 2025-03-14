import '../../main.dart';
import '../entity/app_group.dart';
import '../repository/app_group_repository.dart';

class AppGroupService {
  final AppGroupRepository _appGroupRepository = locator<AppGroupRepository>();

  Future<void> saveGroup(AppGroup group) async {
    await _appGroupRepository.saveGroup(group);
  }

  Future<void> updateGroup(String key, AppGroup group) async {
    await _appGroupRepository.updateGroup(key, group);
  }

  Future<AppGroup?> getGroup(GroupType type, String key) async {
    return await _appGroupRepository.getGroup(type, key);
  }

  Future<List<AppGroup>> getGroups(GroupType type) async {
    return await _appGroupRepository.getGroups(type);
  }

  Stream<List<AppGroup>> streamGroups(GroupType type) {
    return _appGroupRepository.streamGroups(type);
  }
}
