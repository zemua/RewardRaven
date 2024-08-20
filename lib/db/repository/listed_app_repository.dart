import 'dart:async';

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
      final dbRef = await _firebaseHelper.databaseReference;
      await dbRef
          .child(DbCollection.listedApps.name)
          .child(sanitizeDbPath(app.compositeKey))
          .set(app.toJson());
      logger.d("Added listed app: ${app.compositeKey}");
    } catch (e) {
      logger.e('Failed to add listed app: $e');
    }
  }

  Future<void> updateListedApp(ListedApp app) async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      await dbRef
          .child(DbCollection.listedApps.name)
          .child(sanitizeDbPath(app.compositeKey))
          .update(app.toJson());
      logger.d("Updated listed app: ${app.compositeKey}");
    } catch (e) {
      logger.e('Failed to update listed app: $e');
    }
  }

  Future<void> deleteListedApp(ListedApp app) async {
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      await dbRef
          .child(DbCollection.listedApps.name)
          .child(sanitizeDbPath(app.compositeKey))
          .remove();
      logger.d("Deleted listed app: ${app.compositeKey}");
    } catch (e) {
      logger.e('Failed to delete listed app: $e');
    }
  }

  Future<ListedApp?> getListedAppById(
      String identifier, String platform) async {
    String compositeKey = '${identifier}_${platform}';
    try {
      final dbRef = await _firebaseHelper.databaseReference;
      DatabaseEvent dbEvent = await dbRef
          .child(DbCollection.listedApps.name)
          .child(sanitizeDbPath(compositeKey))
          .once()
          .timeout(const Duration(seconds: 10));
      DataSnapshot snapshot = dbEvent.snapshot;
      if (snapshot.value != null) {
        logger.d("Got listed app: $compositeKey");
        return ListedApp.fromJson(
            Map<String, dynamic>.from(snapshot.value as Map));
      } else {
        logger.d('Listed app not found: $compositeKey');
      }
    } catch (e) {
      logger.e('Failed to get listed app: $e');
      rethrow;
    }
    return null;
  }
}
