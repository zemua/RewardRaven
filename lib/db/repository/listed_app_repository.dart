import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

import '../entity/collections.dart';
import '../entity/listed_app.dart';
import '../helper/firebase_helper.dart';

class ListedAppRepository {
  final FirebaseHelper _firebaseHelper;

  final logger = Logger();

  ListedAppRepository(this._firebaseHelper);

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

  Future<ListedApp?> getListedAppById(String compositeKey) async {
    try {
      DataSnapshot snapshot = await _firebaseHelper.databaseReference
          .child(DbCollection.listedApps.name)
          .child(compositeKey)
          .once();
      if (snapshot.value != null) {
        return ListedApp.fromJson(Map<String, dynamic>.from(snapshot.value));
      }
    } catch (e) {
      logger.e('Failed to get listed app: $e');
    }
    return null;
  }
}
