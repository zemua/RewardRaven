import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:reward_raven/main.dart';

import '../entity/collections.dart';
import '../entity/listed_app.dart';
import '../helper/firebase_helper.dart';

class ListedAppRepository {
  final FirebaseHelper _firebaseHelper = locator.get<FirebaseHelper>();

  final logger = Logger();

  ListedAppRepository();

  Future<void> addListedApp(ListedApp app) async {
    try {
      await _firebaseHelper.databaseReference
          .child(DbCollection.listedApps.name)
          .child(app.compositeKey)
          .set(app.toJson());
    } catch (e) {
      logger.e('Failed to add listed app: $e');
    }
  }

  Future<void> updateListedApp(ListedApp app) async {
    try {
      await _firebaseHelper.databaseReference
          .child(DbCollection.listedApps.name)
          .child(app.compositeKey)
          .update(app.toJson());
    } catch (e) {
      logger.e('Failed to update listed app: $e');
    }
  }

  Future<void> deleteListedApp(ListedApp app) async {
    try {
      await _firebaseHelper.databaseReference
          .child(DbCollection.listedApps.name)
          .child(app.compositeKey)
          .remove();
    } catch (e) {
      logger.e('Failed to delete listed app: $e');
    }
  }

  Future<ListedApp?> getListedAppById(
      String identifier, String platform) async {
    String compositeKey = '${identifier}_${platform}';
    try {
      DatabaseEvent event = await _firebaseHelper.databaseReference
          .child(DbCollection.listedApps.name)
          .child(compositeKey)
          .once();

      DataSnapshot snapshot = event.snapshot;
      if (snapshot.value != null) {
        return ListedApp.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) {
      logger.e('Failed to get listed app: $e');
    }
    return null;
  }
}
