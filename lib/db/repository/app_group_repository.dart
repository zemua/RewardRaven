import 'package:reward_raven/db/entity/app_group.dart';

import '../../main.dart';
import '../helper/firebase_helper.dart';

class AppGroupRepository {
  final FirebaseHelper _firebaseHelper = locator.get<FirebaseHelper>();

  AppGroupRepository();

  Future<void> addGroup(AppGroup group) async {
    // TODO implement
  }
}
