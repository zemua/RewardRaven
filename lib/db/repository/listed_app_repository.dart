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

  Future<void> saveListedApp(ListedApp app) async {
    try {
      final ref = await _resolveReference(app);
      await ref?.set(app.toJson());
      logger.d("Saved listed app: ${app.platform} ${app.identifier}");
    } catch (e) {
      logger.e('Failed to save listed app: $e');
    }
  }

  Future<void> updateListedApp(ListedApp app) async {
    try {
      final ref = await _resolveReference(app);
      await ref?.update(app.toJson());
      logger.d("Updated listed app: ${app.platform} ${app.identifier}");
    } catch (e) {
      logger.e('Failed to update listed app: $e');
    }
  }

  Future<void> deleteListedApp(ListedApp app) async {
    try {
      final ref = await _resolveReference(app);
      await ref?.remove();
      logger.d("Deleted listed app: ${app.platform} ${app.identifier}");
    } catch (e) {
      logger.e('Failed to delete listed app: $e');
    }
  }

  Future<ListedApp?> getListedAppById(
      String identifier, String platform) async {
    try {
      final app = ListedApp(
        identifier: identifier,
        platform: platform,
        status: AppStatus.unknown,
      );
      final ref = await _resolveReference(app);
      final dbEvent = await ref?.once().timeout(const Duration(seconds: 10));
      final DataSnapshot? snapshot = dbEvent?.snapshot;
      if (snapshot?.value != null) {
        logger.d("Got listed app: $platform $identifier");
        return ListedApp.fromJson(
            Map<String, dynamic>.from(snapshot?.value as Map));
      } else {
        logger.d('Listed app not found: $platform $identifier');
      }
    } catch (e) {
      logger.e('Failed to get listed app: $e');
      rethrow;
    }
    return null;
  }

  Future<DatabaseReference?> _resolveReference(ListedApp app) async {
    try {
      if (app.identifier.isEmpty || app.platform.isEmpty) {
        throw Exception('Identifier and platform cannot be empty');
      }
      final dbRef = await _firebaseHelper.databaseReference;
      logger.d(
          "Procesing listed app node: platform ${app.platform} - identifier ${app.identifier}");
      return dbRef
          .child(DbCollection.listedApps.name)
          .child(app.platform)
          .child(app.identifier);
    } catch (e) {
      logger.e('Failed to resolve db reference: $e');
      rethrow;
    }
  }
}
